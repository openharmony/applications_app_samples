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
import buffer from '@ohos.buffer';
import {
  DirectoryEntry,
  ShareAccessType,
  Smb2CreateDispositionType,
  Smb2CreateOptions,
  Smb2DirectoryAccess,
  Smb2FileAttribute,
  Smb2FileInfoClass,
  Smb2Flags,
  Smb2InfoType,
  Smb2PacketType,
  Smb2Response,
  Smb2StatusCode,
  smbUtil,
  structureUtil
} from 'smbProtocol';
import EventEmitter from './EventEmitter';

export interface OpenOptions {
  desiredAccess?: Smb2DirectoryAccess;
  fileAttributes?: Smb2FileAttribute;
  createDisposition?: Smb2CreateDispositionType;
  createOptions?: Smb2CreateOptions;
}

const TAG = 'SMB_Directory'

interface ResponseStatusHeader {
  status: number;
}

interface ResponseStatusError {
  header: ResponseStatusHeader;
}

interface DirectoryCreateResponseBody {
  fileId?: string | buffer.Buffer;
}

class DirectoryRequestBody {
  buffer?: buffer.Buffer;
  desiredAccess?: number;
  fileAttributes?: number;
  shareAccess?: number;
  createDisposition?: number;
  createOptions?: number;
  nameOffset?: number;
  createContextsOffset?: number;
  flags?: number;
  fileId?: string;
  infoType?: number;
  fileInfoClass?: number;
  buf?: buffer.Buffer;
}

class DirectoryOpenOptionsModel implements OpenOptions {
  desiredAccess?: Smb2DirectoryAccess;
  fileAttributes?: Smb2FileAttribute;
  createDisposition?: Smb2CreateDispositionType;
  createOptions?: Smb2CreateOptions;
}

class Directory extends EventEmitter {
  private tree: Tree;
  public _id: string = '';
  public isOpen: boolean = false;
  public watching: boolean = false;
  private watchingMessageIds: bigint[] = [];
  private watchRecursive: boolean = true;

  constructor(tree: Tree) {
    super()
    this.tree = tree
  }

  async open(path: string, options: OpenOptions = {}): Promise<void> {
    if (this.isOpen) {
      return;
    }
    const buf = buffer.from(smbUtil.toWindowsFilePath(path), "ucs2");
    const createBody = new DirectoryRequestBody()
    createBody.buffer = buf
    createBody.desiredAccess = typeof options.desiredAccess === "number" ? options.desiredAccess :
      (Smb2DirectoryAccess.ListDirectory | Smb2DirectoryAccess.ReadAttributes | Smb2DirectoryAccess.Synchronize)
    createBody.fileAttributes = typeof options.fileAttributes === "number" ? options.fileAttributes : Smb2FileAttribute.Directory
    createBody.shareAccess = ShareAccessType.Read | ShareAccessType.Write | ShareAccessType.Delete
    createBody.createDisposition = typeof options.createDisposition === "number" ? options.createDisposition :
      Smb2CreateDispositionType.Open
    createBody.createOptions = typeof options.createOptions === "number" ? options.createOptions : Smb2CreateOptions.Directory
    createBody.nameOffset = 0x0078
    createBody.createContextsOffset = 0x007a + buf.length
    const response = await this.tree.request({ type: Smb2PacketType.Create }, createBody);
    const responseBody = response.body as DirectoryCreateResponseBody;
    if (typeof responseBody.fileId !== 'string') {
      throw new Error('create_response_file_id_not_found');
    }
    this._id = responseBody.fileId;
    this.isOpen = true;
    this.emit("open", this);
  }

  async create(path: string): Promise<void> {
    const openOptions = new DirectoryOpenOptionsModel()
    openOptions.createDisposition = Smb2CreateDispositionType.Create
    openOptions.createOptions = Smb2CreateOptions.Directory
    await this.open(path, openOptions);
  }

  async watch(recursive: boolean = true): Promise<void> {
    if (this.watching) {
      return;
    }
    this.watching = true;
    this.watchRecursive = recursive;
    await this.requestWatch();
    this.tree.session.client.on("changeNotify", this.onChangeNotify);
  }

  async unwatch(): Promise<void> {
    if (!this.watching) {
      return;
    }
    this.watching = false;
    this.tree.session.client.off("changeNotify", this.onChangeNotify);
    await this.close();
  }

  private onChangeNotify = async (response: Smb2Response) => {
    const messageId = response.header.messageId;
    if (messageId === undefined) {
      return;
    }
    const messageIdIndex = this.watchingMessageIds.indexOf(messageId);
    if (messageIdIndex !== -1) {
      this.watchingMessageIds.splice(messageIdIndex, 1);
      this.emit("change", response);
      await this.requestWatch();
    }
  };

  private async requestWatch(): Promise<Smb2Response> {
    const watchBody = new DirectoryRequestBody()
    watchBody.flags = this.watchRecursive ? Smb2Flags.WatchTreeRecursively : Smb2Flags.None
    watchBody.fileId = this._id
    const request = this.tree.createRequest({ type: Smb2PacketType.ChangeNotify }, watchBody);
    const messageId = request.header.messageId
    if (messageId === undefined) {
      throw new Error("change_notify_message_id_not_found");
    }
    this.watchingMessageIds.push(messageId);
    const response = await this.tree.session.client.send(request);
    const status = response.header.status
    if (status === undefined) {
      throw new Error("change_notify_status_not_found");
    }
    if (status !== Smb2StatusCode.Success && status !== Smb2StatusCode.Pending) {
      throw new Error(`ChangeNotify: ${structureUtil.parseEnumValue(Smb2StatusCode,
        status)} (${status})`);
    }
    return response;
  }

  async flush(): Promise<void> {
    const flushBody = new DirectoryRequestBody()
    flushBody.fileId = this._id
    await this.tree.request({ type: Smb2PacketType.Flush }, flushBody);
  }

  async read(): Promise<DirectoryEntry[]> {
    const queryDirectoryBody = new DirectoryRequestBody()
    queryDirectoryBody.fileId = this._id
    queryDirectoryBody.buffer = buffer.from("*", "ucs2")
    const response = await this.tree.request({ type: Smb2PacketType.QueryDirectory }, queryDirectoryBody);
    let entries: DirectoryEntry[] = [];
    if (response.data) {
      const directoryEntries = response.data as DirectoryEntry[];
      entries = directoryEntries.filter((entry: DirectoryEntry): boolean => entry.filename !== "." && entry.filename !== "..")
    } else {
      console.warn("response without data", response);
    }
    return entries;
  }

  async exists(path: string): Promise<boolean> {
    try {
      await this.open(path);
    } catch (err) {
      const responseError = err as ResponseStatusError
      if (responseError.header.status === Smb2StatusCode.FileNameNotFound ||
        responseError.header.status === Smb2StatusCode.FilePathNotFound) {
        return false;
      }
      throw err instanceof Error ? err : new Error(JSON.stringify(err));
    }
    return true;
  }

  async remove() {
    const buf = buffer.alloc(1);
    buf.writeUInt8(1, 0);
    await this.setInfo(Smb2FileInfoClass.DispositionInformation, buf);
  }

  async rename(newPath: string) {
    const newPathUCS2 = buffer.from(newPath, "ucs2");
    const buf = buffer.alloc(20 + newPathUCS2.length);
    buf.fill(0x00);
    buf.writeUInt8(1, 0);
    buf.writeUInt32LE(newPathUCS2.length, 16);
    buf.fill(newPathUCS2, 20);
    await this.setInfo(Smb2FileInfoClass.RenameInformation, buf);
  }

  async setInfo(fileInfoClass: number, buf: buffer.Buffer): Promise<void> {
    const setInfoBody = new DirectoryRequestBody()
    setInfoBody.infoType = Smb2InfoType.File
    setInfoBody.fileId = this._id
    setInfoBody.fileInfoClass = fileInfoClass
    setInfoBody.buf = buf
    await this.tree.request({ type: Smb2PacketType.SetInfo }, setInfoBody);
  }

  async close(): Promise<void> {
    if (this.watching) {
      return await this.unwatch();
    }
    if (!this.isOpen) {
      return;
    }
    this.isOpen = false;
    const closeBody = new DirectoryRequestBody()
    closeBody.fileId = this._id
    await this.tree.request({ type: Smb2PacketType.Close }, closeBody);
    this.emit("close", this);
  }
}

export default Directory;
