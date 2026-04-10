/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
import File from './File';
import Session from './Session';
import buffer from '@ohos.buffer';
import Directory, { OpenOptions } from './Directory';
import {
  DirectoryEntry,
  NetShareEnumAll,
  RpcBind,
  ShareEnum,
  Smb2Create,
  Smb2CreateDispositionType,
  Smb2CreateOptions,
  Smb2DirectoryAccess,
  Smb2FilePipePrinterAccess,
  Smb2Header,
  Smb2PacketType,
  Smb2Response,
  smbUtil,
  structureUtil
} from 'smbProtocol';
import EventEmitter from './EventEmitter';
import { util } from '@kit.ArkTS';
import { isImage } from './utils/FileFilterUtil';

const TAG = 'SMB_tree'

interface Tree {
  on(event: "connect" | "disconnect", callback: (tree: Tree) => void): this;

  once(event: "connect" | "disconnect", callback: (tree: Tree) => void): this;
}

class Tree extends EventEmitter {
  _id: number;
  connected: boolean = false;
  connecting: boolean = false;
  openFiles: File[] = [];
  openDirectories: Directory[] = [];

  constructor(public session: Session) {
    super()
  }

  async listShareEnum(host: string) {
    let createResponse = await this.request({ type: Smb2PacketType.Create }, {
      buffer: buffer.from('\srvsvc', 'ucs2'),
      createOptions: 0x00000000,
      fileAttributes: 0x00000000,
      nameOffset: 0x0078,
      createContextsOffset: 0x0080
    })
    let fileId: string = createResponse.body.fileId
    console.info(TAG, 'create response fileId = ' + fileId)
    //rpc bind
    let contextBufs = buffer.alloc(44 * RpcBind.rpcBindContexts.length)
    let offset = 0
    RpcBind.rpcBindContexts.forEach((context) => {
      const contextBuf = RpcBind.createRpcBindContext(context)
      contextBuf.copy(contextBufs, offset)
      offset += contextBuf.length
    })

    await this.request({ type: Smb2PacketType.Write }, {
      fileId: fileId,
      buffer: structureUtil.serializeStructure(RpcBind.requestStructure, {
        fragLength: contextBufs.length + 28,
        contextItems: 3,
        buffer: contextBufs
      })
    })
    let bindAckResponse = await this.request({ type: Smb2PacketType.Read }, {
      fileId: fileId
    })
    const bindAck = structureUtil.parseStructure(bindAckResponse.body.buffer, RpcBind.responseStructure)
    console.info(TAG, `bindAck = ${JSON.stringify(bindAck, smbUtil.bigIntReplacer)}`)
    //share enum
    const serverNameBuf = NetShareEnumAll.createServerNameBuffer('\\\\' + host)
    const infoCtrlBuf = NetShareEnumAll.createInfoCtrlBuffer()
    const enumAllBuf = buffer.concat([serverNameBuf, infoCtrlBuf])
    let shareEnumResponse = await this.request({ type: Smb2PacketType.InputOutputControl }, {
      fileId: fileId,
      buffer: structureUtil.serializeStructure(NetShareEnumAll.requestStructure, {
        fragLength: enumAllBuf.length + 32,
        allocHintLength: enumAllBuf.length + 8,
        contextId: bindAck.arkResult,
        buffer: enumAllBuf
      })
    })
    console.info(TAG, ` shareEnumResponse = ${JSON.stringify(shareEnumResponse, smbUtil.bigIntReplacer)}`)
    const shareEnumData = structureUtil.parseStructure(shareEnumResponse.body.buffer, NetShareEnumAll.responseStructure)
    const shareEnums = NetShareEnumAll.getShareEnums(shareEnumData.buffer)
    console.info(TAG, `shareEnums = ${JSON.stringify(shareEnums, smbUtil.bigIntReplacer)}`)
    await this.request({ type: Smb2PacketType.Close }, {
      fileId: fileId
    })
    return shareEnums;
  }

  async listAllImage(shareEnum: ShareEnum, createGuid: string) {
    try {
      let filterFiles: DirectoryEntry[] = []
      await this.findFiles('', '', filterFiles, createGuid)
      return filterFiles
    } catch (e) {
      console.warn(TAG, `connect tree ${shareEnum.name} fail ${JSON.stringify(e)}`)
    }
  }

  //递归读取文件
  private async findFiles(parentPath: string, dirName: string, filterFiles: DirectoryEntry[],
    createGuid: string): Promise<void> {
    const dirPath = parentPath.length === 0 ? dirName : `${parentPath}/${dirName}`
    try {
      const fileId = await this.getFileId(dirPath, createGuid)
      console.info(TAG, `findFiles create dirPath = ${dirPath} , fileId = ${fileId} success`)
      //query
      let queryResponse = await this.request({ type: Smb2PacketType.QueryDirectory }, {
        fileId: fileId,
        buffer: buffer.from('*', 'ucs2')
      })
      await this.request({ type: Smb2PacketType.Close }, {
        fileId: fileId
      })

      let entries: DirectoryEntry[] = [];
      let imageEntries: DirectoryEntry[] = [];
      let dirEntries: DirectoryEntry[] = [];
      if (queryResponse.data) {
        entries = queryResponse.data.filter(x => x.filename !== "." && x.filename !== "..")
        imageEntries = entries.filter(x => x.type === 'File' && isImage(x.filename))
        dirEntries = entries.filter(x => x.type === 'Directory')
      }
      console.error(TAG, `query dir data = ${JSON.stringify(entries, smbUtil.bigIntReplacer)}`)
      imageEntries.forEach((entries) => {
        entries.absoluteDir = dirPath
        filterFiles.push(entries)
      })
      for (let i = 0; i < dirEntries.length; i++) {
        await this.findFiles(dirPath, dirEntries[i].filename, filterFiles, createGuid)
      }
    } catch (e) {
      console.error(TAG, `findFiles dir =${dirPath}  error = ${JSON.stringify(e)}`)
    }
  }

  private async getFileId(dirPath: string, createGuid: string) {
    let fileId: string = ''
    console.info(TAG, 'create uuid = ' + createGuid)
    const contextBuf = buffer.concat([Smb2Create.createDH2QContext(createGuid), Smb2Create.createQFidContext(),
      Smb2Create.createRqLsContext(util.generateRandomUUID())])
    const dirBuffer = buffer.from(dirPath, 'ucs2')
    console.info(TAG, 'create dirBuffer = ' + JSON.stringify(dirBuffer))
    let createResponse = await this.request({ type: Smb2PacketType.Create }, {
      requestedOplockLevel: 0xff,
      desiredAccess: Smb2FilePipePrinterAccess.ReadData | Smb2FilePipePrinterAccess.ReadAttributes |
      Smb2FilePipePrinterAccess.Synchronize,
      createOptions: Smb2CreateOptions.Directory | Smb2CreateOptions.Nonalert,
      createDisposition: Smb2CreateDispositionType.Open,
      fileAttributes: 0x00000000,
      nameOffset: 0x0078,
      createContextsOffset: 0x007c + dirBuffer.length,
      buffer: dirBuffer,
      contextBuffer: contextBuf
    })
    fileId = createResponse.body.fileId
    if (fileId === '') {
      throw new Error('file id get fail')
    } else {
      return fileId
    }
  }

  async connect(path: string) {
    if (this.connected || this.connecting) {
      return;
    }
    this.connecting = true;
    const buf = buffer.from(smbUtil.toWindowsPath(`\\\\${this.session.client.host}\\${path}`), "ucs2");
    const response = await this.request({ type: Smb2PacketType.TreeConnect }, { buffer: buf });
    this._id = response.header.treeId;
    this.connecting = false;
    this.connected = true;
    this.emit("connect", this);
  }

  async disconnect() {
    if (!this.connected) {
      return;
    }
    this.connected = false;
    await Promise.all([...this.openFiles.map(x => x.close()), ...this.openDirectories.map(x => x.close())]);
    await this.request({ type: Smb2PacketType.TreeDisconnect });
    this.emit("disconnect", this);
  }

  async createDirectory(path: string) {
    const directory = new Directory(this);
    this.registerDirectory(directory);
    await directory.create(path);
    await directory.close();
  }

  async removeDirectory(path: string) {
    const directory = new Directory(this);
    this.registerDirectory(directory);
    await directory.open(path, { desiredAccess: Smb2DirectoryAccess.Delete });
    await directory.remove();
    await directory.close();
  }

  async renameDirectory(path: string, newPath: string) {
    const directory = new Directory(this);
    this.registerDirectory(directory);
    await directory.open(path, { desiredAccess: Smb2DirectoryAccess.MaximumAllowed });
    await directory.rename(newPath);
    await directory.close();
  }

  async watch(onChange?: (response: Smb2Response) => void, recursive?: boolean) {
    return await this.watchDirectory("", onChange, recursive);
  }

  async watchDirectory(path: string = "/", onChange: (response: Smb2Response) => void, recursive?: boolean) {
    const directory = new Directory(this);
    this.registerDirectory(directory);
    await directory.open(path);
    await directory.watch(recursive);
    directory.on("change", onChange);
    return async () => {
      directory.off("change", onChange);
      await directory.unwatch();
    };
  }

  async readDirectory(path: string = "\\", options: OpenOptions = {}) {
    const directory = new Directory(this);
    this.registerDirectory(directory);
    await directory.open(path);
    const entries = await directory.read();
    await directory.close();
    return entries;
  }

  async exists(path: string) {
    const file = new File(this);
    this.registerFile(file);
    const exists = await file.exists(path);
    await file.close();
    return exists;
  }

  async createFile(path: string, content?: buffer.Buffer | string) {
    const file = new File(this);
    this.registerFile(file);
    await file.create(path);
    if (typeof content !== "undefined") {
      await file.setSize(BigInt(content.length));
      await file.write(content);
    }
    await file.close();
  }

  async removeFile(path: string) {
    const file = new File(this);
    this.registerFile(file);
    await file.open(path, { desiredAccess: Smb2FilePipePrinterAccess.Delete });
    await file.remove();
    await file.close();
  }

  async renameFile(path: string, newPath: string) {
    const file = new File(this);
    this.registerFile(file);
    await file.open(path, { desiredAccess: Smb2FilePipePrinterAccess.MaximumAllowed });
    await file.rename(newPath);
    await file.close();
  }

  async readFile(path: string) {
    const file = new File(this);
    this.registerFile(file);
    await file.open(path);
    const buffer = await file.read();
    await file.close();
    return buffer;
  }

  private registerFile(file: File) {
    file.once("open", () => this.openFiles.push(file))
    file.once("close", () => this.openFiles.splice(this.openFiles.indexOf(file), 1));
  }

  private registerDirectory(directory: Directory) {
    directory.once("open", () => this.openDirectories.push(directory))
    directory.once("close", () => this.openDirectories.splice(this.openDirectories.indexOf(directory), 1));
  }

  createRequest(header: Smb2Header = {}, body: any = {}) {
    return this.session.createRequest({ treeId: this._id, ...header }, body);
  }

  request(header: Smb2Header = {}, body: any = {}) {
    return this.session.request({ treeId: this._id, ...header }, body);
  }
}

export default Tree;