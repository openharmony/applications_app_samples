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
  Smb2Request,
  Smb2PacketType,
  Smb2Response,
} from 'smbProtocol';
import buffer from '@ohos.buffer';
import EventEmitter from './EventEmitter';
import { util } from '@kit.ArkTS';
import File from './File';

const TAG = 'SMB_session';

export interface AuthenticateOptions {
  domain: string;
  username: string;
  password: string;
  workStation: string;
}

interface SessionNegotiateResponseBody {
  maxReadSize?: number;
}

interface SessionSetupResponseBody {
  buffer?: buffer.Buffer;
}

class SessionHeaderOptions implements Smb2Header {
  protocolId?: string;
  structureSize?: number;
  creditCharge?: number;
  status?: number;
  type?: Smb2PacketType;
  credit?: number;
  flags?: number;
  nextCommand?: number;
  messageId?: bigint;
  clientId?: string;
  treeId?: number;
  sessionId?: string;
  signature?: number;
}

class SessionRequestBody {
}

class SessionNegotiateRequestBody extends SessionRequestBody {
  dialects: Smb2Dialect[] = [];
}

class SessionSetupRequestBody extends SessionRequestBody {
  buffer: buffer.Buffer = buffer.alloc(0);
}

class SessionFileOpenRequestBody extends SessionRequestBody {
  requestedOplockLevel?: number;
  desiredAccess?: number;
  shareAccess?: number;
  createOptions?: number;
  createDisposition?: number;
  fileAttributes?: number;
  nameOffset?: number;
  createContextsOffset?: number;
  buffer?: buffer.Buffer;
  contextBuffer?: buffer.Buffer;
}

class Session extends EventEmitter {
  client: Client;
  _id: string = '';
  connectedTrees: Tree[] = [];
  authenticated: boolean = false;
  shareEnums: ShareEnum[] = []
  shareEnumTrees: Map<string, Tree> = new Map();
  createGuid = util.generateRandomUUID()
  allImages: DirectoryEntry[] = []
  maxReadSize: number = 65536

  // rootTree?:Tree
  constructor(client: Client) {
    super()
    this.client = client
  }

  async connectTree(path: string): Promise<Tree> {
    const tree = new Tree(this);
    this.registerTree(tree);
    await tree.connect(path);
    return tree;
  }

  async connectRootTree(): Promise<void> {
    const tree = new Tree(this);
    this.registerTree(tree);
    await tree.connect('IPC$');
    this.shareEnums = await tree.listShareEnum(this.client.host)
  }

  async deleteFile(file: DirectoryEntry): Promise<void> {
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
    const deleteFileRequestBody = new SessionFileOpenRequestBody()
    deleteFileRequestBody.requestedOplockLevel = 0xff
    deleteFileRequestBody.desiredAccess = Smb2FilePipePrinterAccess.ReadAttributes | Smb2FilePipePrinterAccess.Delete
    deleteFileRequestBody.shareAccess = ShareAccessType.Delete
    deleteFileRequestBody.createOptions = Smb2CreateOptions.NonDirectory | Smb2CreateOptions.DeleteOnClose
    deleteFileRequestBody.createDisposition = Smb2CreateDispositionType.Open
    deleteFileRequestBody.fileAttributes = 0x00000000
    deleteFileRequestBody.nameOffset = 0x0078
    deleteFileRequestBody.createContextsOffset = 0x007c + filePathBuffer.length
    deleteFileRequestBody.buffer = filePathBuffer
    deleteFileRequestBody.contextBuffer = contextBuf
    await sambaFile.openByBody(deleteFileRequestBody)
    await sambaFile.close()
  }

  async readFile(file: DirectoryEntry): Promise<buffer.Buffer> {
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
    const readFileRequestBody = new SessionFileOpenRequestBody()
    readFileRequestBody.requestedOplockLevel = 0xff
    readFileRequestBody.desiredAccess = Smb2FilePipePrinterAccess.ReadData | Smb2FilePipePrinterAccess.ReadEa |
      Smb2FilePipePrinterAccess.ReadAttributes | Smb2FilePipePrinterAccess.ReadControl |
      Smb2FilePipePrinterAccess.Synchronize
    readFileRequestBody.shareAccess = ShareAccessType.Read | ShareAccessType.Delete
    readFileRequestBody.createOptions = Smb2CreateOptions.Nonalert | Smb2CreateOptions.NonDirectory
    readFileRequestBody.createDisposition = Smb2CreateDispositionType.Open
    readFileRequestBody.fileAttributes = 0x00000000
    readFileRequestBody.nameOffset = 0x0078
    readFileRequestBody.createContextsOffset = 0x007c + filePathBuffer.length
    readFileRequestBody.buffer = filePathBuffer
    readFileRequestBody.contextBuffer = contextBuf
    await sambaFile.openByBody(readFileRequestBody)
    let imageBuf = await sambaFile.read()
    console.info(TAG, `read buffer  ${file.absoluteDir}/${file.filename} success`)
    return imageBuf
  }

  async listAllImage(): Promise<void> {
    const images: DirectoryEntry[] = []
    for (let i = this.shareEnums.length - 1; i < this.shareEnums.length; i++) {
      const shareEnum = this.shareEnums[i];
      if (shareEnum.type === 0) {
        const tree = new Tree(this);
        //connect
        await tree.connect(shareEnum.name);
        let files = await tree.listAllImage(shareEnum, this.createGuid)
        if (files && files.length > 0) {
          files.forEach((entry: DirectoryEntry): void => {
            entry.shareEnum = shareEnum.name
          })
          this.shareEnumTrees.set(shareEnum.name, tree)
          files.forEach((entry: DirectoryEntry): void => {
            images.push(entry)
          })
        } else {
          tree.disconnect()
        }
      }
    }
    images.sort((a: DirectoryEntry, b: DirectoryEntry): number => {
      if (a.creationTime > b.creationTime) {
        return -1;
      } else {
        return 1;
      }
    })
    this.allImages = images
  }

  createRequest(header?: Smb2Header, body: Object = new SessionRequestBody()): Smb2Request {
    return this.client.createRequest(this.createHeader(header), body);
  }

  async request(header?: Smb2Header, body: Object = new SessionRequestBody()): Promise<Smb2Response> {
    return await this.client.request(this.createHeader(header), body);
  }

  async authenticate(options: AuthenticateOptions) {
    console.info(TAG, `do auth options = ${JSON.stringify(options)} authenticated = ${this.authenticated}`)
    if (this.authenticated) {
      return;
    }
    const negotiateRequestBody = new SessionNegotiateRequestBody()
    negotiateRequestBody.dialects = [Smb2Dialect.Smb300, Smb2Dialect.Smb210]
    const negotiateResponse = await this.request({ type: Smb2PacketType.Negotiate }, negotiateRequestBody);
    const maxReadSize = (negotiateResponse.body as SessionNegotiateResponseBody).maxReadSize;
    this.maxReadSize = maxReadSize === undefined ? 65536 : maxReadSize;
    const sessionSetupRequestBody = new SessionSetupRequestBody()
    sessionSetupRequestBody.buffer = ntlm.createType1Message(options.workStation, options.domain)
    const sessionSetupResponse = await this.request(
      { type: Smb2PacketType.SessionSetup },
      sessionSetupRequestBody
    );
    const sessionId = sessionSetupResponse.header.sessionId;
    if (!sessionId) {
      throw new Error('session_id_not_found');
    }
    this._id = sessionId;
    const sessionSetupResponseBody = sessionSetupResponse.body as SessionSetupResponseBody;
    if (sessionSetupResponseBody.buffer === undefined) {
      throw new Error('session_setup_response_buffer_not_found');
    }
    const type2Message = ntlm.decodeType2Message(sessionSetupResponseBody.buffer)
    const sessionSetupAuthRequestBody = new SessionSetupRequestBody()
    sessionSetupAuthRequestBody.buffer = ntlm.createType3Message(
      type2Message,
      options.username,
      options.password,
      options.workStation
    )
    await this.request({ type: Smb2PacketType.SessionSetup }, sessionSetupAuthRequestBody);
    this.authenticated = true;
    this.emit("authenticate", this);
  }

  private registerTree(tree: Tree): void {
    tree.once("connect", (): void => {
      this.connectedTrees.push(tree)
    })
    tree.once("disconnect", (): void => {
      this.connectedTrees.splice(this.connectedTrees.indexOf(tree), 1)
    });
  }

  async logoff() {
    if (!this.authenticated) {
      return;
    }
    this.authenticated = false;
    await Promise.all(this.connectedTrees.map((tree: Tree): Promise<void> => tree.disconnect()));
    await this.request({ type: Smb2PacketType.LogOff });
    this._id = '';
    this.emit("logoff", this);
  }

  private createHeader(header?: Smb2Header): Smb2Header {
    const requestHeader = new SessionHeaderOptions()
    requestHeader.sessionId = this._id
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
      requestHeader.treeId = header.treeId
      requestHeader.sessionId = header.sessionId ?? this._id
      requestHeader.signature = header.signature
    }
    return requestHeader
  }
}

export default Session;
