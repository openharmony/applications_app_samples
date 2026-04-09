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
import Structure from '../Structure';
import * as packets from './packets';
import HeaderFlag from './HeaderFlag';
import PacketType from './PacketType';
import * as structureUtil from '../structureUtil';
import Header, { headerSize, headerStructure } from './Header';

const TAG = 'SMB_Packet'

export default class Packet {
  static getPacketTypeName(packetType: PacketType) {
    return structureUtil.parseEnumValue(PacketType, packetType);
  }

  static getPacketByPacketType(packetType: PacketType) {
    const typeName = structureUtil.parseEnumValue(PacketType, packetType);
    return Packet.getPacket(typeName);
  }

  static getPacket(typeName: string) {
    const packet = packets[typeName];
    if (!packet) {
      throw new Error(`packet_not_found: ${typeName}`);
    }
    return packet;
  }

  static getStructure(header: Header) {
    const packet = Packet.getPacketByPacketType(header.type);
    const isResponse = (header.flags & HeaderFlag.Response) === 1;
    const structure = packet[`${isResponse ? "response" : "request"}Structure`] as Structure;
    return structure;
  }

  static serialize(header: Header, body: any) {
    const structure = Packet.getStructure(header);
    const headerBuffer = Packet.serializeHeader(header);
    console.info(TAG, 'headerBuffer size =' + headerBuffer.length + ' ' + JSON.stringify(headerBuffer, byteReplacer))
    const bodyBuffer = structureUtil.serializeStructure(structure, body);
    console.info(TAG, 'bodyBuffer size =' + bodyBuffer.length + ' ' + JSON.stringify(bodyBuffer, byteReplacer))
    const buf = buffer.concat([headerBuffer, bodyBuffer]);
    const prefixedBuffer = buffer.alloc(buf.length + 4);
    prefixedBuffer.writeUInt8(0x00, 0);
    prefixedBuffer.writeUInt8((0xff0000 & buf.length) >> 16, 1);
    prefixedBuffer.writeUInt16BE(0xffff & buf.length, 2);
    buf.copy(prefixedBuffer, 4, 0, buf.length);
    return prefixedBuffer;
  }

  static parse(buf: buffer.Buffer) {
    const { header, bodyBuffer } = Packet.parseHeader(buf);
    const structure = Packet.getStructure(header);
    const body = structureUtil.parseStructure(bodyBuffer, structure);
    return {
      header, body
    };
  }

  static parseHeader(buf: buffer.Buffer) {
    const header = structureUtil.parseStructure(buf, headerStructure) as Header;
    const bodyBuffer = buf.subarray(headerSize);
    return {
      header, bodyBuffer
    };
  }

  static serializeHeader(header: Header) {
    return structureUtil.serializeStructure(headerStructure, header);
  }
}

export function byteReplacer(key: string, value: any): any {
  if (typeof value === 'number') {
    return value.toString(16).padStart(2, '0') // 将 BigInt 类型转换为字符串
  }
  return value;
}