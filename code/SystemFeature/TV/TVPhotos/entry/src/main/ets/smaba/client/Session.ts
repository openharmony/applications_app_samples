/**
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import Tree from './Tree';
import Client from './Client';
import {
  DirectoryEntry,
  ntlm,
  ShareAccessType,
  ShareEnum,
  Smb2Create,
  Smb2CreateDispositionType,
  Smb2CreateOptions,
  Smb2Dialect,
  Smb2FilePipePrinterAccess,
  Smb2Header,
  Smb2PacketType
} from 'smbProtocol';
import buffer from '@ohos.buffer';
import EventEmitter from './EventEmitter';
import { util } from '@kit.ArkTS';
import File from './File';

const TAG = 'SMB_session'

export interface AuthenticateOptions {
  domain: string;
  username: string;
  password: string;
  workStation: string;
}

interface Session extends EventEmitter {
  on(event: "authenticate" | "logoff", callback: (session: Session) => void): this;

  once(event: "authenticate" | "logoff", callback: (session: Session) => void): this;
}

class Session extends EventEmitter {
  _id: string;
  connectedTrees: Tree[] = [];
  authenticated: boolean = false;
  shareEnums: ShareEnum[] = []
  shareEnumTrees: Map<string, Tree> = new Map();
  createGuid = util.generateRandomUUID()
  allImages: DirectoryEntry[] = []
  maxReadSize: number = 65536

  // rootTree?:Tree
  constructor(public client: Client) {
    super()
  }

  async connectTree(path: string) {
    const tree = new Tree(this);
    this.registerTree(tree);
    await tree.connect(path);
    return tree;
  }

  async connectRootTree() {
    const tree = new Tree(this);
    this.registerTree(tree);
    await tree.connect('IPC$');
    this.shareEnums = await tree.listShareEnum(this.client.host)
  }

  async deleteFile(file: DirectoryEntry) {
    let tree = this.shareEnumTrees.get(file.shareEnum)
    if (!tree) {
      tree = new Tree(this);
      await tree.connect(file.shareEnum);
      this.shareEnumTrees.set(file.shareEnum, tree)
    }

    const filePathBuffer = buffer.from(file.absoluteDir + '/' + file.filename, 'ucs2')
    console.info(TAG, 'create uuid = ' + this.createGuid)
    const sambaFile = new File(tree)
    const contextBuf = buffer.concat([Smb2Create.createDH2QContext(this.createGuid), Smb2Create.createQFidContext(),
      Smb2Create.createRqLsContext(util.generateRandomUUID())])
    await sambaFile.openByBody({
      requestedOplockLevel: 0xff,
      desiredAccess: Smb2FilePipePrinterAccess.ReadAttributes | Smb2FilePipePrinterAccess.Delete,
      shareAccess: ShareAccessType.Delete,
      createOptions: Smb2CreateOptions.NonDirectory | Smb2CreateOptions.DeleteOnClose,
      createDisposition: Smb2CreateDispositionType.Open,
      fileAttributes: 0x00000000,
      nameOffset: 0x0078,
      createContextsOffset: 0x007c + filePathBuffer.length,
      buffer: filePathBuffer,
      contextBuffer: contextBuf
    })
    await sambaFile.close()
  }

  async readFile(file: DirectoryEntry) {
    let tree = this.shareEnumTrees.get(file.shareEnum)
    if (!tree) {
      tree = new Tree(this);
      await tree.connect(file.shareEnum);
      this.shareEnumTrees.set(file.shareEnum, tree)
    }

    const filePathBuffer = buffer.from(file.absoluteDir + '/' + file.filename, 'ucs2')
    console.info(TAG, 'create uuid = ' + this.createGuid)
    const sambaFile = new File(tree)
    const contextBuf = buffer.concat([Smb2Create.createDH2QContext(this.createGuid), Smb2Create.createQFidContext(),
      Smb2Create.createRqLsContext(util.generateRandomUUID())])
    await sambaFile.openByBody({
      requestedOplockLevel: 0xff,
      desiredAccess: Smb2FilePipePrinterAccess.ReadData | Smb2FilePipePrinterAccess.ReadEa |
      Smb2FilePipePrinterAccess.ReadAttributes | Smb2FilePipePrinterAccess.ReadControl |
      Smb2FilePipePrinterAccess.Synchronize,
      shareAccess: ShareAccessType.Read | ShareAccessType.Delete,
      createOptions: Smb2CreateOptions.Nonalert | Smb2CreateOptions.NonDirectory,
      createDisposition: Smb2CreateDispositionType.Open,
      fileAttributes: 0x00000000,
      nameOffset: 0x0078,
      createContextsOffset: 0x007c + filePathBuffer.length,
      buffer: filePathBuffer,
      contextBuffer: contextBuf
    })
    let imageBuf = await sambaFile.read()
    console.info(TAG, `read buffer  ${file.absoluteDir}/${file.filename} success`)
    return imageBuf
  }

  async listAllImage() {
    const images: DirectoryEntry[] = []
    for (let i = this.shareEnums.length - 1; i < this.shareEnums.length; i++) {
      const shareEnum = this.shareEnums[i];
      if (shareEnum.type === 0) {
        const tree = new Tree(this);
        //connect
        await tree.connect(shareEnum.name);
        let files = await tree.listAllImage(shareEnum, this.createGuid)
        if (files && files.length > 0) {
          files.forEach((v) => v.shareEnum = shareEnum.name)
          this.shareEnumTrees.set(shareEnum.name, tree)
          images.push(...files)
        } else {
          tree.disconnect()
        }
      }
    }
    images.sort((a, b) => {
      if (a.creationTime > b.creationTime) {
        return -1;
      } else {
        return 1;
      }
    })
    this.allImages = images
  }

  createRequest(header: Smb2Header = {}, body: any = {}) {
    return this.client.createRequest({ sessionId: this._id, ...header }, body);
  }

  async request(header: Smb2Header = {}, body: any = {}) {
    return await this.client.request({ sessionId: this._id, ...header }, body);
  }

  async authenticate(options: AuthenticateOptions) {
    console.info(TAG, `do auth options = ${JSON.stringify(options)} authenticated = ${this.authenticated}`)
    if (this.authenticated) {
      return;
    }
    const negotiateResponse = await this.request({ type: Smb2PacketType.Negotiate }, {
      dialects: [Smb2Dialect.Smb300, Smb2Dialect.Smb210]
    });
    this.maxReadSize = negotiateResponse.body.maxReadSize
    const sessionSetupResponse = await this.request({ type: Smb2PacketType.SessionSetup },
      { buffer: ntlm.createType1Message(options.workStation, options.domain) });
    this._id = sessionSetupResponse.header.sessionId;
    const type2Message = ntlm.decodeType2Message(sessionSetupResponse.body.buffer as buffer.Buffer)
    await this.request({ type: Smb2PacketType.SessionSetup }, {
      buffer: ntlm.createType3Message(type2Message, options.username, options.password, options.workStation)
    });
    this.authenticated = true;
    this.emit("authenticate", this);
  }

  private registerTree(tree: Tree) {
    tree.once("connect", () => this.connectedTrees.push(tree))
    tree.once("disconnect", () => this.connectedTrees.splice(this.connectedTrees.indexOf(tree), 1));
  }

  async logoff() {
    if (!this.authenticated) {
      return;
    }
    this.authenticated = false;
    await Promise.all(this.connectedTrees.map(x => x.disconnect()));
    await this.request({ type: Smb2PacketType.LogOff });
    delete this._id;
    this.emit("logoff", this);
  }
}

export default Session;