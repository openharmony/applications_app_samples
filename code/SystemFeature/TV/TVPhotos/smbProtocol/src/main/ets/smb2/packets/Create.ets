/**
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
import buffer from '@ohos.buffer';
import Structure from '../../Structure';
import StructureField from '../../StructureField';
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

const requestStructure = new Structure()
  .addField('structureSize', new StructureField(Number).setSize(2).setDefaultValue(57))
  .addField('securityFlags', new StructureField(Number).setSize(1))
  .addField('requestedOplockLevel', new StructureField(Number).setSize(1))
  .addField('impersonationLevel', new StructureField(Number).setSize(4).setDefaultValue(0x00000002))
  .addField('smbCreateFlags', new StructureField(Number).setSize(8))
  .addField('reserved', new StructureField(Number).setSize(8))
  .addField('desiredAccess', new StructureField(Number).setSize(4).setDefaultValue(0x0012019f))
  .addField('fileAttributes', new StructureField(Number).setSize(4).setDefaultValue(0x00000080))
  .addField('shareAccess', new StructureField(Number).setSize(4).setDefaultValue(
    ShareAccessType.Read |
    ShareAccessType.Write |
    ShareAccessType.Delete
  ))
  .addField('createDisposition', new StructureField(Number).setSize(4).setDefaultValue(CreateDispositionType.Open))
  .addField('createOptions', new StructureField(Number).setSize(4).setDefaultValue(CreateOptions.None))
  .addField('nameOffset', new StructureField(Number).setSize(2).setDefaultValue(0x78))
  .addField('nameLength', new StructureField(Number).setSize(2))
  .addField('createContextsOffset', new StructureField(Number).setSize(4).setDefaultValue(0x80))
  .addField('createContextsLength', new StructureField(Number).setSize(4))
  .addField('buffer', new StructureField(buffer.Buffer).setSizeFieldName("nameLength"))
  .addField('reserved2', new StructureField(Number).setSize(4))
  .addField('contextBuffer', new StructureField(buffer.Buffer).setSizeFieldName("createContextsLength"));

const responseStructure = new Structure()
  .addField('structureSize', new StructureField(Number).setSize(2))
  .addField('oplockLevel', new StructureField(Number).setSize(1))
  .addField('flags', new StructureField(Number).setSize(1))
  .addField('createAction', new StructureField(Number).setSize(4))
  .addField('creationTime', new StructureField(Number).setSize(8))
  .addField('lastAccessTime', new StructureField(Number).setSize(8))
  .addField('lastWriteTime', new StructureField(Number).setSize(8))
  .addField('changeTime', new StructureField(Number).setSize(8))
  .addField('allocationSize', new StructureField(Number).setSize(8))
  .addField('endOfFile', new StructureField(Number).setSize(8))
  .addField('fileAttributes', new StructureField(Number).setSize(4))
  .addField('reserved2', new StructureField(Number).setSize(4))
  .addField('fileId', new StructureField(String).setEncoding("hex").setSize(16))
  .addField('createContextsOffset', new StructureField(Number).setSize(4))
  .addField('createContextsLength', new StructureField(Number).setSize(4))
  .addField('buffer', new StructureField(buffer.Buffer).setSizeFieldName("createContextsLength"));

class FileNameBuffer {
  size: number;
  buf: buffer.Buffer;

  constructor(size: number, buf: buffer.Buffer) {
    this.size = size;
    this.buf = buf;
  }
}

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
const getFileNameBuffer = (fileName: string): FileNameBuffer => {
  if (fileName.length === 0) {
    return new FileNameBuffer(0, buffer.alloc(8))
  } else {
    const nameBuf = buffer.from(fileName, 'ucs2')
    return new FileNameBuffer(nameBuf.length, bufferAlign(bufferAppendTerminator(nameBuf, 2), 4))
  }
}

class CreatePacket {
  requestStructure: Structure = requestStructure;
  responseStructure: Structure = responseStructure;
  createDH2QContext = createDH2QContext;
  createQFidContext = createQFidContext;
  createRqLsContext = createRqLsContext;
  getFileNameBuffer = getFileNameBuffer;
}

export default new CreatePacket();
