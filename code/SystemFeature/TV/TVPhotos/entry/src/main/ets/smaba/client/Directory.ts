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

interface Directory {
  on(event: "open" | "close", callback: (directory: Directory) => void): this;

  on(event: "change", callback: (response: Smb2Response) => void): this;

  once(event: "open" | "close", callback: (directory: Directory) => void): this;

  once(event: "change", callback: (response: Smb2Response) => void): this;
}

const TAG = 'SMB_Directory'

class Directory extends EventEmitter {
  public _id: string;
  public isOpen: boolean = false;
  public watching: boolean = false;
  private watchingMessageIds: bigint[] = [];
  private watchRecursive: boolean;

  constructor(private tree: Tree) {
    super()
  }

  async open(path: string, options: OpenOptions = {}) {
    if (this.isOpen) {
      return;
    }
    const buf = buffer.from(smbUtil.toWindowsFilePath(path), "ucs2");
    const response = await this.tree.request({ type: Smb2PacketType.Create }, {
      buffer: buf,
      desiredAccess: typeof options.desiredAccess === "number" ? options.desiredAccess :
        (Smb2DirectoryAccess.ListDirectory | Smb2DirectoryAccess.ReadAttributes | Smb2DirectoryAccess.Synchronize),
      fileAttributes: typeof options.fileAttributes === "number" ? options.fileAttributes : Smb2FileAttribute.Directory,
      shareAccess: ShareAccessType.Read | ShareAccessType.Write | ShareAccessType.Delete,
      createDisposition: typeof options.createDisposition === "number" ? options.createDisposition :
      Smb2CreateDispositionType.Open,
      createOptions: typeof options.createOptions === "number" ? options.createOptions : Smb2CreateOptions.Directory,
      nameOffset: 0x0078,
      createContextsOffset: 0x007a + buf.length
    });
    this._id = response.body.fileId as string;
    this.isOpen = true;
    this.emit("open", this);
  }

  async create(path: string) {
    await this.open(path, {
      createDisposition: Smb2CreateDispositionType.Create,
      createOptions: Smb2CreateOptions.Directory
    });
  }

  async watch(recursive: boolean = true) {
    if (this.watching) {
      return;
    }
    this.watching = true;
    this.watchRecursive = recursive;
    await this.requestWatch();
    this.tree.session.client.on("changeNotify", this.onChangeNotify);
  }

  async unwatch() {
    if (!this.watching) {
      return;
    }
    this.watching = false;
    this.tree.session.client.off("changeNotify", this.onChangeNotify);
    await this.close();
  }

  private onChangeNotify = async (response: Smb2Response) => {
    const messageId = response.header.messageId;
    const messageIdIndex = this.watchingMessageIds.indexOf(messageId);
    if (messageIdIndex !== -1) {
      this.watchingMessageIds.splice(messageIdIndex, 1);
      this.emit("change", response);
      await this.requestWatch();
    }
  };

  private async requestWatch() {
    const request = this.tree.createRequest({ type: Smb2PacketType.ChangeNotify }, {
      flags: this.watchRecursive ? Smb2Flags.WatchTreeRecursively : Smb2Flags.None,
      fileId: this._id
    });
    this.watchingMessageIds.push(request.header.messageId);
    const response = await this.tree.session.client.send(request);
    if (response.header.status !== Smb2StatusCode.Success && response.header.status !==
    Smb2StatusCode.Pending) {
      throw new Error(`ChangeNotify: ${structureUtil.parseEnumValue(Smb2StatusCode,
        response.header.status)} (${response.header.status})`);
    }
    return response;
  }

  async flush() {
    await this.tree.request({ type: Smb2PacketType.Flush }, { fileId: this._id });
  }

  async read() {
    const response = await this.tree.request({ type: Smb2PacketType.QueryDirectory }, {
      fileId: this._id,
      buffer: buffer.from("*", "ucs2")
    });
    let entries: DirectoryEntry[] = [];
    if (response.data) {
      entries = response.data.filter(x => x.filename !== "." && x.filename !== "..")
    } else {
      console.warn("response without data", response);
    }
    return entries;
  }

  async exists(path: string) {
    try {
      await this.open(path);
    } catch (err) {
      if (err.header.status === Smb2StatusCode.FileNameNotFound ||
        err.header.status === Smb2StatusCode.FilePathNotFound) {
        return false;
      }
      throw err;
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

  async setInfo(fileInfoClass: number, buf: buffer.Buffer) {
    await this.tree.request({ type: Smb2PacketType.SetInfo }, {
      infoType: Smb2InfoType.File,
      fileId: this._id,
      fileInfoClass,
      buf
    });
  }

  async close() {
    if (this.watching) {
      return await this.unwatch();
    }
    if (!this.isOpen) {
      return;
    }
    this.isOpen = false;
    await this.tree.request({ type: Smb2PacketType.Close }, { fileId: this._id });
    this.emit("close", this);
  }
}

export default Directory;