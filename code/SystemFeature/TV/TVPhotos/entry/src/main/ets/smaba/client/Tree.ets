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
  Smb2Request,
  Smb2Response,
  smbUtil,
  structureUtil
} from 'smbProtocol';
import EventEmitter from './EventEmitter';
import { util } from '@kit.ArkTS';
import { isImage } from './utils/FileFilterUtil';

const TAG = 'SMB_tree'

interface RpcBindResponseBody {
  arkResult: number;
}

interface NetShareEnumAllResponseBody {
  buffer: buffer.Buffer;
}

interface TreeCreateResponseBody {
  fileId?: string | buffer.Buffer;
}

interface TreeBufferResponseBody {
  buffer?: buffer.Buffer;
}

interface RpcBindRequestBody {
  fragLength: number;
  contextItems: number;
  buffer: buffer.Buffer;
}

interface NetShareEnumAllRequestBody {
  fragLength: number;
  allocHintLength: number;
  contextId: number;
  buffer: buffer.Buffer;
}

class TreeHeaderOptions implements Smb2Header {
  public protocolId?: string;
  public structureSize?: number;
  public creditCharge?: number;
  public status?: number;
  public type?: Smb2PacketType;
  public credit?: number;
  public flags?: number;
  public nextCommand?: number;
  public messageId?: bigint;
  public clientId?: string;
  public treeId?: number;
  public sessionId?: string;
  public signature?: number;
}

class TreeRequestBody {
}

class TreePacketBody extends TreeRequestBody {
  public requestedOplockLevel?: number;
  public desiredAccess?: number;
  public shareAccess?: number;
  public createOptions?: number;
  public createDisposition?: number;
  public fileAttributes?: number;
  public nameOffset?: number;
  public createContextsOffset?: number;
  public fileId?: string;
  public buffer?: buffer.Buffer;
  public contextBuffer?: buffer.Buffer;
}

class Tree extends EventEmitter {
  public session: Session;
  public _id: number = 0;
  public connected: boolean = false;
  public connecting: boolean = false;
  public openFiles: File[] = [];
  public openDirectories: Directory[] = [];

  constructor(session: Session) {
    super()
    this.session = session
  }

  async listShareEnum(host: string): Promise<ShareEnum[]> {
    const createSrvsvcBody = new TreePacketBody()
    createSrvsvcBody.buffer = buffer.from('\srvsvc', 'ucs2')
    createSrvsvcBody.createOptions = 0x00000000
    createSrvsvcBody.fileAttributes = 0x00000000
    createSrvsvcBody.nameOffset = 0x0078
    createSrvsvcBody.createContextsOffset = 0x0080
    let createResponse = await this.request({ type: Smb2PacketType.Create }, createSrvsvcBody)
    const createResponseBody = createResponse.body as TreeCreateResponseBody;
    const createFileId = createResponseBody.fileId;
    if (typeof createFileId !== 'string') {
      throw new Error('create_response_file_id_not_found');
    }
    let fileId: string = createFileId
    console.info(TAG, 'create response fileId = ' + fileId)
    //rpc bind
    let contextBufs = buffer.alloc(44 * RpcBind.rpcBindContexts.length)
    let offset = 0
    RpcBind.rpcBindContexts.forEach((context) => {
      const contextBuf = RpcBind.createRpcBindContext(context)
      contextBuf.copy(contextBufs, offset)
      offset += contextBuf.length
    })

    const rpcBindRequestBody: RpcBindRequestBody = {
      fragLength: contextBufs.length + 28,
      contextItems: 3,
      buffer: contextBufs
    }
    const writeBody = new TreePacketBody()
    writeBody.fileId = fileId
    writeBody.buffer = structureUtil.serializeStructure(RpcBind.requestStructure, rpcBindRequestBody)
    await this.request({ type: Smb2PacketType.Write }, writeBody)
    const readBody = new TreePacketBody()
    readBody.fileId = fileId
    let bindAckResponse = await this.request({ type: Smb2PacketType.Read }, readBody)
    const bindAckResponseBody = bindAckResponse.body as TreeBufferResponseBody;
    const bindAckBuffer = bindAckResponseBody.buffer;
    if (bindAckBuffer === undefined) {
      throw new Error('bind_ack_buffer_not_found');
    }
    const bindAck = structureUtil.parseStructure(
      bindAckBuffer,
      RpcBind.responseStructure
    ) as RpcBindResponseBody
    console.info(TAG, `bindAck = ${JSON.stringify(bindAck, smbUtil.bigIntReplacer)}`)
    //share enum
    const serverNameBuf = NetShareEnumAll.createServerNameBuffer('\\\\' + host)
    const infoCtrlBuf = NetShareEnumAll.createInfoCtrlBuffer()
    const enumAllBuf = buffer.concat([serverNameBuf, infoCtrlBuf])
    const netShareEnumAllRequestBody: NetShareEnumAllRequestBody = {
      fragLength: enumAllBuf.length + 32,
      allocHintLength: enumAllBuf.length + 8,
      contextId: bindAck.arkResult,
      buffer: enumAllBuf
    }
    const inputOutputControlBody = new TreePacketBody()
    inputOutputControlBody.fileId = fileId
    inputOutputControlBody.buffer = structureUtil.serializeStructure(
      NetShareEnumAll.requestStructure,
      netShareEnumAllRequestBody
    )
    let shareEnumResponse = await this.request({ type: Smb2PacketType.InputOutputControl }, inputOutputControlBody)
    console.info(TAG, ` shareEnumResponse = ${JSON.stringify(shareEnumResponse, smbUtil.bigIntReplacer)}`)
    const shareEnumResponseBody = shareEnumResponse.body as TreeBufferResponseBody;
    const shareEnumBuffer = shareEnumResponseBody.buffer;
    if (shareEnumBuffer === undefined) {
      throw new Error('share_enum_buffer_not_found');
    }
    const shareEnumData = structureUtil.parseStructure(
      shareEnumBuffer,
      NetShareEnumAll.responseStructure
    ) as NetShareEnumAllResponseBody
    const shareEnums = NetShareEnumAll.getShareEnums(shareEnumData.buffer)
    console.info(TAG, `shareEnums = ${JSON.stringify(shareEnums, smbUtil.bigIntReplacer)}`)
    const closeBody = new TreePacketBody()
    closeBody.fileId = fileId
    await this.request({ type: Smb2PacketType.Close }, closeBody)
    return shareEnums;
  }

  async listAllImage(shareEnum: ShareEnum, createGuid: string): Promise<DirectoryEntry[]> {
    try {
      let filterFiles: DirectoryEntry[] = []
      await this.findFiles('', '', filterFiles, createGuid)
      return filterFiles
    } catch (e) {
      console.warn(TAG, `connect tree ${shareEnum.name} fail ${JSON.stringify(e)}`)
      return []
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
      const queryDirectoryBody = new TreePacketBody()
      queryDirectoryBody.fileId = fileId
      queryDirectoryBody.buffer = buffer.from('*', 'ucs2')
      let queryResponse = await this.request({ type: Smb2PacketType.QueryDirectory }, queryDirectoryBody)
      const closeBody = new TreePacketBody()
      closeBody.fileId = fileId
      await this.request({ type: Smb2PacketType.Close }, closeBody)

      let entries: DirectoryEntry[] = [];
      let imageEntries: DirectoryEntry[] = [];
      let dirEntries: DirectoryEntry[] = [];
      if (queryResponse.data) {
        const queryEntries = queryResponse.data as DirectoryEntry[];
        entries = queryEntries.filter((entry: DirectoryEntry): boolean => entry.filename !== '.' && entry.filename !== '..')
        imageEntries = entries.filter((entry: DirectoryEntry): boolean => entry.type === 'File' && isImage(entry.filename))
        dirEntries = entries.filter((entry: DirectoryEntry): boolean => entry.type === 'Directory')
      }
      console.error(TAG, `query dir data = ${JSON.stringify(entries, smbUtil.bigIntReplacer)}`)
      imageEntries.forEach((entry: DirectoryEntry): void => {
        entry.absoluteDir = dirPath
        filterFiles.push(entry)
      })
      for (let i = 0; i < dirEntries.length; i++) {
        await this.findFiles(dirPath, dirEntries[i].filename, filterFiles, createGuid)
      }
    } catch (e) {
      console.error(TAG, `findFiles dir =${dirPath}  error = ${JSON.stringify(e)}`)
    }
  }

  private async getFileId(dirPath: string, createGuid: string): Promise<string> {
    let fileId: string = ''
    console.info(TAG, 'create uuid = ' + createGuid)
    const contextBuf = buffer.concat([Smb2Create.createDH2QContext(createGuid), Smb2Create.createQFidContext(),
      Smb2Create.createRqLsContext(util.generateRandomUUID())])
    const dirBuffer = buffer.from(dirPath, 'ucs2')
    console.info(TAG, 'create dirBuffer = ' + JSON.stringify(dirBuffer))
    const createFileIdBody = new TreePacketBody()
    createFileIdBody.requestedOplockLevel = 0xff
    createFileIdBody.desiredAccess = Smb2FilePipePrinterAccess.ReadData |
      Smb2FilePipePrinterAccess.ReadAttributes |
      Smb2FilePipePrinterAccess.Synchronize
    createFileIdBody.createOptions = Smb2CreateOptions.Directory | Smb2CreateOptions.Nonalert
    createFileIdBody.createDisposition = Smb2CreateDispositionType.Open
    createFileIdBody.fileAttributes = 0x00000000
    createFileIdBody.nameOffset = 0x0078
    createFileIdBody.createContextsOffset = 0x007c + dirBuffer.length
    createFileIdBody.buffer = dirBuffer
    createFileIdBody.contextBuffer = contextBuf
    let createResponse = await this.request({ type: Smb2PacketType.Create }, createFileIdBody)
    const createResponseBody = createResponse.body as TreeCreateResponseBody;
    const responseFileId = createResponseBody.fileId;
    if (typeof responseFileId !== 'string') {
      throw new Error('file_id_not_found');
    }
    fileId = responseFileId
    if (fileId === '') {
      throw new Error('file id get fail')
    } else {
      return fileId
    }
  }

  async connect(path: string): Promise<void> {
    if (this.connected || this.connecting) {
      return;
    }
    this.connecting = true;
    const buf = buffer.from(smbUtil.toWindowsPath(`\\\\${this.session.client.host}\\${path}`), 'ucs2');
    const treeConnectBody = new TreePacketBody()
    treeConnectBody.buffer = buf
    const response = await this.request({ type: Smb2PacketType.TreeConnect }, treeConnectBody);
    this._id = response.header.treeId ?? 0;
    this.connecting = false;
    this.connected = true;
    this.emit('connect', this);
  }

  async disconnect() {
    if (!this.connected) {
      return;
    }
    this.connected = false;
    const closePromises: Promise<void>[] = [];
    this.openFiles.forEach((file: File): void => {
      closePromises.push(file.close())
    });
    this.openDirectories.forEach((directory: Directory): void => {
      closePromises.push(directory.close())
    });
    await Promise.all(closePromises);
    await this.request({ type: Smb2PacketType.TreeDisconnect });
    this.emit('disconnect', this);
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

  async watch(onChange?: (response: Smb2Response) => void, recursive?: boolean): Promise<() => Promise<void>> {
    if (!onChange) {
      return async (): Promise<void> => {
      };
    }
    return await this.watchDirectory('', onChange, recursive);
  }

  async watchDirectory(path: string = '/', onChange: (response: Smb2Response) => void, recursive?: boolean): Promise<() => Promise<void>> {
    const directory = new Directory(this);
    this.registerDirectory(directory);
    await directory.open(path);
    await directory.watch(recursive);
    directory.on('change', onChange);
    return async (): Promise<void> => {
      directory.off('change', onChange);
      await directory.unwatch();
    };
  }

  async readDirectory(path: string = '\\', options: OpenOptions = {}) {
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
    if (typeof content !== 'undefined') {
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

  private registerFile(file: File): void {
    file.once('open', (): void => {
      this.openFiles.push(file)
    })
    file.once('close', (): void => {
      this.openFiles.splice(this.openFiles.indexOf(file), 1)
    });
  }

  private registerDirectory(directory: Directory): void {
    directory.once('open', (): void => {
      this.openDirectories.push(directory)
    })
    directory.once('close', (): void => {
      this.openDirectories.splice(this.openDirectories.indexOf(directory), 1)
    });
  }

  createRequest(header?: Smb2Header, body: Object = new TreeRequestBody()): Smb2Request {
    return this.session.createRequest(this.createHeader(header), body);
  }

  request(header?: Smb2Header, body: Object = new TreeRequestBody()): Promise<Smb2Response> {
    return this.session.request(this.createHeader(header), body);
  }

  private createHeader(header?: Smb2Header): Smb2Header {
    const requestHeader = new TreeHeaderOptions()
    requestHeader.treeId = this._id
    if (header) {
      requestHeader.protocolId = header.protocolId
      requestHeader.structureSize = header.structureSize
      requestHeader.creditCharge = header.creditCharge
      requestHeader.status = header.status
      requestHeader.type = header.type
      requestHeader.credit = header.credit
      requestHeader.flags = header.flags
      requestHeader.nextCommand = header.nextCommand
      requestHeader.messageId = header.messageId
      requestHeader.clientId = header.clientId
      requestHeader.treeId = header.treeId ?? this._id
      requestHeader.sessionId = header.sessionId
      requestHeader.signature = header.signature
    }
    return requestHeader
  }
}

export default Tree;
