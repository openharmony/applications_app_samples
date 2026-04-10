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

const TAG = 'SMB_file'

interface FileErrorHeader {
  status: number;
}

interface FileResponseError {
  header: FileErrorHeader;
}

interface FileCreateResponseBody {
  fileId?: buffer.Buffer;
  endOfFile?: bigint;
}

interface FileReadResponseBody {
  buffer?: buffer.Buffer;
}

class FileRequestBody {
  public buffer?: buffer.Buffer;
  public buf?: buffer.Buffer;
  public desiredAccess?: number;
  public fileAttributes?: number;
  public shareAccess?: number;
  public createDisposition?: number;
  public createOptions?: number;
  public nameOffset?: number;
  public createContextsOffset?: number;
  public infoType?: number;
  public fileId?: buffer.Buffer | string;
  public fileInfoClass?: number;
  public offset?: buffer.Buffer;
  public length?: buffer.Buffer;
  public contextBuffer?: buffer.Buffer;
  public requestedOplockLevel?: number;
}

class FileOpenOptionsModel implements OpenOptions {
  public desiredAccess?: Smb2FilePipePrinterAccess;
  public createDisposition?: Smb2CreateDispositionType;
  public createOptions?: Smb2CreateOptions;
}

class File extends EventEmitter {
  private tree: Tree;
  public _id: buffer.Buffer = buffer.alloc(0);
  public isOpen: boolean = false;
  public fileSize: bigint = BigInt(0);

  constructor(tree: Tree) {
    super()
    this.tree = tree
  }

  async open(path: string, options: OpenOptions = {}): Promise<void> {
    if (this.isOpen) {
      return;
    }
    const buf = buffer.from(smbUtil.toWindowsFilePath(path), 'ucs2');
    const openBody = new FileRequestBody()
    openBody.buf = buf
    openBody.desiredAccess = typeof options.desiredAccess === 'number' ?
      options.desiredAccess : Smb2FilePipePrinterAccess.ReadData
    openBody.fileAttributes = Smb2FileAttribute.Normal
    openBody.shareAccess = ShareAccessType.Read | ShareAccessType.Write | ShareAccessType.Delete
    openBody.createDisposition = typeof options.createDisposition === 'number' ?
      options.createDisposition : Smb2CreateDispositionType.Open
    openBody.createOptions = typeof options.createOptions === 'number' ?
      options.createOptions : Smb2CreateOptions.None
    openBody.nameOffset = 0x0078
    openBody.createContextsOffset = 0x007a + buf.length
    const response = await this.tree.request({ type: Smb2PacketType.Create }, openBody);
    const responseBody = response.body as FileCreateResponseBody;
    const responseFileId = responseBody.fileId;
    if (responseFileId === undefined || !buffer.isBuffer(responseFileId)) {
      throw new Error('create_response_file_id_not_found');
    }
    if (typeof responseBody.endOfFile !== 'bigint') {
      throw new Error('create_response_end_of_file_not_found');
    }
    this._id = responseFileId;
    this.fileSize = responseBody.endOfFile;
    this.isOpen = true;
    this.emit('open', this);
  }

  async openByBody(body: Object = new FileRequestBody()): Promise<void> {
    if (this.isOpen) {
      return;
    }
    const response = await this.tree.request({ type: Smb2PacketType.Create }, body);
    const responseBody = response.body as FileCreateResponseBody;
    const responseFileId = responseBody.fileId;
    if (responseFileId === undefined || !buffer.isBuffer(responseFileId)) {
      throw new Error('create_response_file_id_not_found');
    }
    if (typeof responseBody.endOfFile !== 'bigint') {
      throw new Error('create_response_end_of_file_not_found');
    }
    this._id = responseFileId;
    this.fileSize = responseBody.endOfFile;
    this.isOpen = true;
    this.emit('open', this);
  }

  async create(path: string): Promise<void> {
    const openOptions = new FileOpenOptionsModel()
    openOptions.desiredAccess = Smb2FilePipePrinterAccess.WriteData
    openOptions.createDisposition = Smb2CreateDispositionType.Create
    await this.open(path, openOptions);
  }

  async remove() {
    const buf = buffer.alloc(1);
    buf.writeUInt8(1, 0);
    await this.setInfo(Smb2FileInfoClass.DispositionInformation, buf);
  }

  async rename(newPath: string) {
    const newPathUCS2 = buffer.from(newPath, 'ucs2');
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

  async setInfo(fileInfoClass: number, buf: buffer.Buffer): Promise<void> {
    const setInfoBody = new FileRequestBody()
    setInfoBody.infoType = Smb2InfoType.File
    setInfoBody.fileId = this._id
    setInfoBody.fileInfoClass = fileInfoClass
    setInfoBody.buf = buf
    await this.tree.request({ type: Smb2PacketType.SetInfo }, setInfoBody);
  }

  async write(content: buffer.Buffer | string): Promise<void> {
    const buf = buffer.isBuffer(content) ? content as buffer.Buffer : buffer.from(content as string, 'utf8');
    const chunkCount = Math.ceil(buf.length / maxWriteChunkLength);
    for (let index = 0; index < chunkCount; index++) {
      const offset = index * maxWriteChunkLength;
      const nextOffset = (index + 1) * maxWriteChunkLength;
      const length = nextOffset > buf.length ? buf.length - offset : nextOffset - offset;
      const chunk = buf.subarray(offset, offset + length);
      const offsetBuffer = buffer.alloc(8);
      offsetBuffer.writeBigUInt64LE(BigInt(offset));
      const writeBody = new FileRequestBody()
      writeBody.fileId = this._id
      writeBody.buffer = chunk
      writeBody.offset = offsetBuffer
      await this.tree.request({ type: Smb2PacketType.Write }, writeBody);
    }
  }

  async read2(readSizeMax: number = 65536): Promise<buffer.Buffer> {
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
      const readBody = new FileRequestBody()
      readBody.fileId = this._id
      readBody.length = lengthBuffer
      readBody.offset = offsetBuffer
      const response = await this.tree.request({ type: Smb2PacketType.Read }, readBody);
      const responseBody = response.body as FileReadResponseBody;
      if (responseBody.buffer === undefined) {
        throw new Error('read_response_buffer_not_found');
      }
      responseBody.buffer.copy(buf, offset);
      let newOffset = offset + length
      length = Math.min(newOffset, fileSize - newOffset, readSizeMax)
      offset = newOffset
    }
    return buf;
  }

  async read(): Promise<buffer.Buffer> {
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
      const readBody = new FileRequestBody()
      readBody.fileId = this._id
      readBody.length = lengthBuffer
      readBody.offset = offsetBuffer
      const response = await this.tree.request({ type: Smb2PacketType.Read }, readBody);
      const responseBody = response.body as FileReadResponseBody;
      if (responseBody.buffer === undefined) {
        throw new Error('read_response_buffer_not_found');
      }
      responseBody.buffer.copy(buf, offset);
      console.error(TAG, `read request response `)
    }
    return buf;
  }

  async exists(path: string): Promise<boolean> {
    try {
      await this.open(path);
    } catch (err) {
      const responseError = err as FileResponseError
      if (responseError.header.status === Smb2StatusCode.FileNameNotFound ||
        responseError.header.status === Smb2StatusCode.FilePathNotFound) {
        return false;
      }
      throw err instanceof Error ? err : new Error(JSON.stringify(err));
    }
    return true;
  }

  async close(): Promise<void> {
    if (!this.isOpen) {
      return;
    }
    this.isOpen = false;
    const closeBody = new FileRequestBody()
    closeBody.fileId = this._id
    await this.tree.request({ type: Smb2PacketType.Close }, closeBody);
    this.emit('close', this);
  }
}

export default File;
