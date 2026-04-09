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
import buffer from '@ohos.buffer';
import Structure from '../../Structure';
import ShareAccessType from '../ShareAccessType';
import CreateDispositionType from '../CreateDispositionType';
import { bufferAlign, bufferAppendTerminator, convertUuidToBuffer } from '../../util';

export enum CreateOptions {
  None = 0,
  Directory = 1 << 0,
  WriteData = 1 << 1,
  SequentialOnly = 1 << 2,
  Intermediate = 1 << 3,
  Alert = 1 << 4,
  Nonalert = 1 << 5,
  NonDirectory = 1 << 6,
  CreateTress = 1 << 7,
  Complete = 1 << 8,
  NoEA = 1 << 16,
  ONLY = 1 << 17,
  RandomAccess = 1 << 18,
  DeleteOnClose = 1 << 19,
  OpenByFileId = 1 << 20,
  Backup = 1 << 24,
  NoCompression = 1 << 25,
  Reserve = 1 << 28,
  OpenReparse = 1 << 29,
  OpenNoRecall = 1 << 30,
  OpenForFree = 1 << 31
}

const requestStructure: Structure = {
  structureSize: {
    type: Number,
    size: 2,
    defaultValue: 57
  },
  securityFlags: {
    type: Number,
    size: 1
  },
  requestedOplockLevel: {
    type: Number,
    size: 1
  },
  impersonationLevel: {
    type: Number,
    size: 4,
    defaultValue: 0x00000002
  },
  smbCreateFlags: {
    type: Number,
    size: 8
  },
  reserved: {
    type: Number,
    size: 8
  },
  desiredAccess: {
    type: Number,
    size: 4,
    defaultValue: 0x0012019f
  },
  fileAttributes: {
    type: Number,
    size: 4,
    defaultValue: 0x00000080
  },
  shareAccess: {
    type: Number,
    size: 4,
    defaultValue:
    ShareAccessType.Read |
    ShareAccessType.Write |
    ShareAccessType.Delete
  },
  createDisposition: {
    type: Number,
    size: 4,
    defaultValue: CreateDispositionType.Open
  },
  createOptions: {
    type: Number,
    size: 4,
    defaultValue: CreateOptions.None
  },
  nameOffset: {
    type: Number,
    size: 2,
    defaultValue: 0x78
  },
  nameLength: {
    type: Number,
    size: 2
  },
  createContextsOffset: {
    type: Number,
    size: 4,
    defaultValue: 0x80
  },
  createContextsLength: {
    type: Number,
    size: 4
  },
  'buffer': {
    type: buffer.Buffer,
    sizeFieldName: "nameLength"
  },
  reserved2: {
    type: Number,
    size: 4,
  },
  'contextBuffer': {
    type: buffer.Buffer,
    sizeFieldName: "createContextsLength"
  },
  // reserved2: {
  //   type: Number,
  //   size: 2,
  //   defaultValue: 0x0000
  // },
  // createContexts: {
  //   type: Number,
  //   sizeFieldName: "createContextsLength",
  //   defaultValue: 0
  // }
};

const responseStructure: Structure = {
  structureSize: {
    type: Number,
    size: 2
  },
  oplockLevel: {
    type: Number,
    size: 1
  },
  flags: {
    type: Number,
    size: 1
  },
  createAction: {
    type: Number,
    size: 4
  },
  creationTime: {
    type: Number,
    size: 8
  },
  lastAccessTime: {
    type: Number,
    size: 8
  },
  lastWriteTime: {
    type: Number,
    size: 8
  },
  changeTime: {
    type: Number,
    size: 8
  },
  allocationSize: {
    type: Number,
    size: 8
  },
  endOfFile: {
    type: Number,
    size: 8
  },
  fileAttributes: {
    type: Number,
    size: 4
  },
  reserved2: {
    type: Number,
    size: 4
  },
  fileId: {
    type: String,
    encoding: "hex",
    size: 16
  },
  createContextsOffset: {
    type: Number,
    size: 4
  },
  createContextsLength: {
    type: Number,
    size: 4
  },
  'buffer': {
    type: buffer.Buffer,
    sizeFieldName: "createContextsLength"
  }
};

const createDH2QContext = (createGuid: string): buffer.Buffer => {
  const buf = buffer.alloc(56)
  let offset = 0
  buf.writeUInt32LE(buf.length, offset)
  offset += 4;
  buf.writeUInt16LE(0x0010, offset) //tag offset
  offset += 2;
  buf.writeUInt32LE(4, offset) // tag length
  offset += 4
  buf.writeUInt16LE(0x0018, offset) //data offset
  offset += 2;
  buf.writeUInt32LE(32, offset) // data length
  offset += 4

  buf.write('DH2Q', offset)
  offset += 4
  buf.writeUInt32LE(0, offset) // reserve
  offset += 4

  buf.writeUInt32LE(0, offset) // timeout
  offset += 4
  buf.writeUInt32LE(0, offset) // flags
  offset += 4
  buf.writeUInt32LE(0, offset) // reserve
  buf.writeUInt32LE(0, offset)
  offset += 8
  convertUuidToBuffer(createGuid).copy(buf, offset)
  return buf

}
const createQFidContext = (): buffer.Buffer => {
  const buf = buffer.alloc(24)
  let offset = 0
  buf.writeUInt32LE(buf.length, offset)
  offset += 4;
  buf.writeUInt16LE(0x0010, offset) //tag offset
  offset += 2;
  buf.writeUInt32LE(4, offset) // tag length
  offset += 4
  buf.writeUInt16LE(0x0018, offset) //data offset
  offset += 2;
  buf.writeUInt32LE(0, offset) // data length
  offset += 4

  buf.write('QFid', offset)
  offset += 4
  return buf
}
const createRqLsContext = (leaseKey: string): buffer.Buffer => {
  const buf = buffer.alloc(76)
  let offset = 0
  buf.writeUInt32LE(0, offset)
  offset += 4;
  buf.writeUInt16LE(0x0010, offset) //tag offset
  offset += 2;
  buf.writeUInt32LE(4, offset) // tag length
  offset += 4
  buf.writeUInt16LE(0x0018, offset) //data offset
  offset += 2;
  buf.writeUInt32LE(52, offset) // data length
  offset += 4

  buf.write('RqLs', offset)
  offset += 4
  buf.writeUInt32LE(0, offset) // reserve
  offset += 4

  convertUuidToBuffer(leaseKey).copy(buf, offset)
  offset += 16
  buf.writeUInt32LE(0x00000007, offset) // lease state
  offset += 4
  buf.writeUInt32LE(0, offset) // lease flags
  offset += 4
  buf.writeUInt32LE(0, offset) // duration
  buf.writeUInt32LE(0, offset)
  offset += 8

  buf.writeUInt32LE(0, offset) // parent lease key
  buf.writeUInt32LE(0, offset)
  buf.writeUInt32LE(0, offset)
  buf.writeUInt32LE(0, offset)
  offset += 16
  buf.writeUInt16LE(0, offset) //lease epoch
  offset += 2
  buf.writeUInt16LE(0, offset) //lease reserved
  offset += 2
  return buf
}
const getFileNameBuffer = (fileName: string): { size: number, buf: buffer.Buffer } => {
  if (fileName.length === 0) {
    return { size: 0, buf: buffer.alloc(8) }
  } else {
    const nameBuf = buffer.from(fileName, 'ucs2')
    return { size: nameBuf.length, buf: bufferAlign(bufferAppendTerminator(nameBuf, 2), 4) }
  }
}

export default {
  requestStructure,
  responseStructure,
  createDH2QContext,
  createQFidContext,
  createRqLsContext
};