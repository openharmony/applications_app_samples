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
import { buffer } from '@kit.ArkTS';
import Structure from '../../Structure';
import StructureField from '../../StructureField';
import { bufferAlign, bufferAppendTerminator } from '../../util';

export class ShareEnum {
  namePointer: number = 0
  name: string = ''
  type: number = 0
  commentPointer: number = 0
  comment: string = ''
}

const requestStructure = new Structure()
  .addField('version', new StructureField(Number).setSize(1).setDefaultValue(0x05))
  .addField('versionMinor', new StructureField(Number).setSize(1).setDefaultValue(0x00))
  .addField('packageType', new StructureField(Number).setSize(1).setDefaultValue(0x00))
  .addField('packageFlags', new StructureField(Number).setSize(1).setDefaultValue(0x03))
  .addField('representation', new StructureField(Number).setSize(4).setDefaultValue(0x00000010))
  .addField('fragLength', new StructureField(Number).setSize(2))
  .addField('authLength', new StructureField(Number).setSize(2))
  .addField('callId', new StructureField(Number).setSize(4).setDefaultValue(2))
  .addField('allocHintLength', new StructureField(Number).setSize(4))
  .addField('contextId', new StructureField(Number).setSize(2))
  .addField('opNum', new StructureField(Number).setSize(2).setDefaultValue(0x00F))
  .addField('buffer', new StructureField(buffer.Buffer))
  .addField('maxBuffer', new StructureField(Number).setSize(4).setDefaultValue(0xFFFFFFFF))
  .addField('reserved', new StructureField(Number).setSize(4));

const responseStructure = new Structure()
  .addField('version', new StructureField(Number).setSize(1))
  .addField('versionMinor', new StructureField(Number).setSize(1))
  .addField('packageType', new StructureField(Number).setSize(1))
  .addField('packageFlags', new StructureField(Number).setSize(1))
  .addField('representation', new StructureField(Number).setSize(4))
  .addField('fragLength', new StructureField(Number).setSize(2))
  .addField('authLength', new StructureField(Number).setSize(2))
  .addField('callId', new StructureField(Number).setSize(4))
  .addField('allocHintLength', new StructureField(Number).setSize(4))
  .addField('contextId', new StructureField(Number).setSize(2))
  .addField('cancelCount', new StructureField(Number).setSize(1))
  .addField('reserved', new StructureField(Number).setSize(1))
  .addField('buffer', new StructureField(buffer.Buffer).setSizeFieldName('allocHintLength'));

const getShareEnums = (buf: buffer.Buffer): ShareEnum[] => {
  let offset = 0;
  const infoLevel = buf.readUInt32LE(offset);
  offset += 4;
  const ctr = buf.readUInt32LE(offset);
  offset += 4
  const referentId = buf.readUInt32LE(offset)
  offset += 4;
  const shareCount = buf.readUInt32LE(offset);
  offset += 4;

  offset += 8
  // 解析共享信息列表
  const shares: ShareEnum[] = [];
  for (let i = 0; i < shareCount; i++) {
    const shareEnum = new ShareEnum()
    shareEnum.namePointer = buf.readUInt32LE(offset)
    offset += 4
    shareEnum.type = buf.readUInt32LE(offset)
    offset += 4
    shareEnum.commentPointer = buf.readUInt32LE(offset)
    offset += 4
    shares.push(shareEnum)
  }

  for (let i = 0; i < shareCount; i++) {
    offset += 12
    let tempOffset = 0
    while (true) {
      const charCode = buf.readUInt16LE(offset + tempOffset)
      if (charCode === 0) {
        // shares[i].name = buf.toString('utf8',offset,offset+tempOffset)
        shares[i].name = utf16LeToString(buf.subarray(offset, offset + tempOffset))
        offset += tempOffset
        offset += 4
        break;
      } else {
        tempOffset += 2
      }
    }

    offset += 12
    tempOffset = 0
    while (true) {
      const charCode = buf.readUInt16LE(offset + tempOffset)
      if (charCode === 0) {
        shares[i].comment = utf16LeToString(buf.subarray(offset, offset + tempOffset))
        offset += tempOffset
        offset += 4
        break;
      } else {
        tempOffset += 2
      }
    }
  }
  return shares;
}

function utf16LeToString(buf: buffer.Buffer): string {
  let str = '';
  for (let i = 0; i < buf.length; i += 2) {
    const charCode = buf.readUInt16LE(i); // true 表示小端序
    str += String.fromCharCode(charCode);
  }
  return str;
}

const createServerNameBuffer = (serverName: string): buffer.Buffer => {
  let serverNameBuf = bufferAppendTerminator(buffer.from(serverName, 'ucs2'));
  let serverNameLen = serverNameBuf.length ;
  serverNameBuf = bufferAlign(serverNameBuf,4)

  const buf = buffer.alloc(16 + serverNameBuf.length);
  let offset = 0
  buf.writeUInt32LE(0x00020000, offset);
  offset += 4; // 引用ID
  buf.writeUInt32LE(serverNameLen / 2, offset);
  offset += 4; // 最大长度
  buf.writeUInt32LE(0, offset);
  offset += 4; // offset
  buf.writeUInt32LE(serverNameLen / 2, offset);
  offset += 4; // actual count
  serverNameBuf.copy(buf, offset)
  return buf
}

const createInfoCtrlBuffer = (level: number = 1, ctrl: number = 1): buffer.Buffer => {
  const buf = buffer.alloc(20);
  let offset = 0
  buf.writeUInt32LE(level, offset);
  offset += 4; //
  buf.writeUInt32LE(ctrl, offset);
  offset += 4; //
  buf.writeUInt32LE(0x00020004, offset);
  offset += 4; //
  buf.writeUInt32LE(0, offset);
  offset += 4; //
  buf.writeUInt32LE(0, offset);
  offset += 4; //
  return buf
}


class NetShareEnumAllPacket {
  requestStructure: Structure = requestStructure;
  responseStructure: Structure = responseStructure;
  createServerNameBuffer = createServerNameBuffer;
  createInfoCtrlBuffer = createInfoCtrlBuffer;
  getShareEnums = getShareEnums;
}

export default new NetShareEnumAllPacket();
