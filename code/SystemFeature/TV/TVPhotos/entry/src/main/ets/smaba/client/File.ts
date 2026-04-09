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
import buffer from '@ohos.buffer';
import {
  ShareAccessType,
  Smb2CreateDispositionType,
  Smb2CreateOptions,
  Smb2FileAttribute,
  Smb2FileInfoClass,
  Smb2FilePipePrinterAccess,
  Smb2InfoType,
  Smb2PacketType,
  Smb2StatusCode,
  smbUtil
} from 'smbProtocol';
import EventEmitter from './EventEmitter';

const maxReadChunkLength = 0x00010000;
const maxWriteChunkLength = 0x00010000 - 0x71;

interface OpenOptions {
  desiredAccess?: Smb2FilePipePrinterAccess;
  createDisposition?: Smb2CreateDispositionType;
  createOptions?: Smb2CreateOptions;
}

interface File extends EventEmitter {
  on(event: "open" | "close", callback: (file: File) => void): this;

  once(event: "open" | "close", callback: (file: File) => void): this;
}

const TAG = 'SMB_file'

class File extends EventEmitter {
  _id: buffer.Buffer;
  isOpen: boolean;
  fileSize: bigint;

  constructor(private tree: Tree) {
    super()
  }

  async open(path: string, options: OpenOptions = {}) {
    if (this.isOpen) {
      return;
    }
    const buf = buffer.from(smbUtil.toWindowsFilePath(path), "ucs2");
    const response = await this.tree.request({ type: Smb2PacketType.Create }, {
      buf,
      desiredAccess: typeof options.desiredAccess === "number" ?
      options.desiredAccess : Smb2FilePipePrinterAccess.ReadData,
      fileAttributes: Smb2FileAttribute.Normal,
      shareAccess: ShareAccessType.Read | ShareAccessType.Write | ShareAccessType.Delete,
      createDisposition: typeof options.createDisposition === "number" ?
      options.createDisposition : Smb2CreateDispositionType.Open,
      createOptions: typeof options.createDisposition === "number" ?
      options.createDisposition : Smb2CreateOptions.None,
      nameOffset: 0x0078,
      createContextsOffset: 0x007a + buf.length
    });

    this._id = response.body.fileId as buffer.Buffer;
    this.fileSize = response.body.endOfFile as bigint;
    this.isOpen = true;
    this.emit("open", this);
  }

  async openByBody(body?: any) {
    if (this.isOpen) {
      return;
    }
    const response = await this.tree.request({ type: Smb2PacketType.Create }, body);
    this._id = response.body.fileId as buffer.Buffer;
    this.fileSize = response.body.endOfFile as bigint;
    this.isOpen = true;
    this.emit("open", this);
  }

  async create(path: string) {
    await this.open(path, {
      desiredAccess: Smb2FilePipePrinterAccess.WriteData,
      createDisposition: Smb2CreateDispositionType.Create
    });
  }

  async remove() {
    const buf = buffer.alloc(1);
    buf.writeUInt8(1, 0);
    await this.setInfo(Smb2FileInfoClass.DispositionInformation, buf);
  }

  async rename(newPath: string) {
    const newPathUCS2 = buffer.from(newPath, "ucs2");
    const buf = buffer.alloc(1 + 7 + 8 + 4 + newPathUCS2.length);
    buf.fill(0x00);
    buf.writeUInt8(1, 0);
    buf.writeUInt32LE(newPathUCS2.length, 16);
    buf.fill(newPathUCS2, 20);
    await this.setInfo(Smb2FileInfoClass.RenameInformation, buf);
  }

  async setSize(size: bigint) {
    const buf = buffer.alloc(8);
    buf.writeBigInt64LE(size);
    await this.setInfo(Smb2FileInfoClass.EndOfFileInformation, buf);
  }

  async setInfo(fileInfoClass: number, buf: buffer.Buffer) {
    await this.tree.request({ type: Smb2PacketType.SetInfo }, {
      infoType: Smb2InfoType.File,
      fileId: this._id,
      fileInfoClass,
      buf
    });
  }

  async write(content: buffer.Buffer | string) {
    const buf = buffer.isBuffer(content) ? content as buffer.Buffer : buffer.from(content as string, "utf8");
    const chunkCount = Math.ceil(buf.length / maxWriteChunkLength);
    for (let index = 0; index < chunkCount; index++) {
      const offset = index * maxWriteChunkLength;
      const nextOffset = (index + 1) * maxWriteChunkLength;
      const length = nextOffset > buf.length ? buf.length - offset : nextOffset - offset;
      const chunk = buf.subarray(offset, offset + length);
      const offsetBuffer = buffer.alloc(8);
      offsetBuffer.writeBigUInt64LE(BigInt(offset));
      await this.tree.request({ type: Smb2PacketType.Write }, {
        fileId: this._id,
        buffer: chunk,
        offset: offsetBuffer
      });
    }
  }

  async read2(readSizeMax: number = 65536) {
    const fileSize = Number(this.fileSize);
    let offset = 0
    let length = Math.min(maxReadChunkLength, fileSize)
    const buf = buffer.alloc(fileSize);
    while (offset + length <= fileSize) {
      const lengthBuffer = buffer.alloc(4);
      lengthBuffer.writeInt32LE(length, 0);
      const offsetBuffer = buffer.alloc(8);
      offsetBuffer.writeBigUInt64LE(BigInt(offset));
      console.error(TAG,
        `read request length = ${length} offset=${offset}  fileSize = ${fileSize} readSizeMax = ${readSizeMax}`)
      const response = await this.tree.request({ type: Smb2PacketType.Read }, {
        fileId: this._id,
        length: lengthBuffer,
        offset: offsetBuffer
      });
      (response.body.buffer as buffer.Buffer).copy(buf, offset);
      let newOffset = offset + length
      length = Math.min(newOffset, fileSize - newOffset, readSizeMax)
      offset = newOffset
    }
    return buf;
  }

  async read() {
    const fileSize = Number(this.fileSize);
    const chunkCount = Math.ceil(fileSize / maxReadChunkLength);
    console.error(TAG, `read size  ${this.fileSize} chunkCount = ${chunkCount}`)
    const buf = buffer.alloc(fileSize);
    for (let index = 0; index < chunkCount; index++) {
      const offset = index * maxReadChunkLength;
      const nextOffset = (index + 1) * maxReadChunkLength;
      const length = nextOffset > fileSize ? fileSize - offset : nextOffset - offset;
      const lengthBuffer = buffer.alloc(4);
      lengthBuffer.writeInt32LE(length, 0);
      const offsetBuffer = buffer.alloc(8);
      offsetBuffer.writeBigUInt64LE(BigInt(offset));
      console.error(TAG, `read request index = ${index}`)
      const response = await this.tree.request({ type: Smb2PacketType.Read }, {
        fileId: this._id,
        length: lengthBuffer,
        offset: offsetBuffer
      });
      (response.body.buffer as buffer.Buffer).copy(buf, offset);
      console.error(TAG, `read request response `)
    }
    return buf;
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

  async close() {
    if (!this.isOpen) {
      return;
    }
    this.isOpen = false;
    await this.tree.request({ type: Smb2PacketType.Close }, { fileId: this._id });
    this.emit("close", this);
  }
}

export default File;