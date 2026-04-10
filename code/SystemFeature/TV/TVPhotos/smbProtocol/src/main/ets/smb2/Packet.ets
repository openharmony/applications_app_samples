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
import Structure from '../Structure';
import * as packets from './packets';
import HeaderFlag from './HeaderFlag';
import PacketType from './PacketType';
import * as structureUtil from '../structureUtil';
import Header, { headerSize, headerStructure } from './Header';

const TAG = 'SMB_Packet'

type PacketBody = Object;
type JsonReplacerValue = number | string | boolean | Object | null;

class ParsedPacketData {
  header: Header;
  body: PacketBody;

  constructor(header: Header, body: PacketBody) {
    this.header = header;
    this.body = body;
  }
}

class ParsedHeaderData {
  header: Header;
  bodyBuffer: buffer.Buffer;

  constructor(header: Header, bodyBuffer: buffer.Buffer) {
    this.header = header;
    this.bodyBuffer = bodyBuffer;
  }
}

export interface PacketDefinition {
  requestStructure: Structure;
  responseStructure: Structure;
  parseRequestBuffer?: (buf: buffer.Buffer) => Object;
  parseResponseBuffer?: (buf: buffer.Buffer) => Object;
}

export default class Packet {
  static getPacketTypeName(packetType: PacketType): string {
    const typeName = structureUtil.parseEnumValue(PacketType, packetType);
    if (typeName === undefined) {
      throw new Error(`packet_type_not_found: ${packetType}`);
    }
    return typeName;
  }

  static getPacketByPacketType(packetType: PacketType): PacketDefinition {
    const typeName = Packet.getPacketTypeName(packetType);
    return Packet.getPacket(typeName);
  }

  static getPacket(typeName: string): PacketDefinition {
    switch (typeName) {
      case 'Read':
        return packets.Read as PacketDefinition;
      case 'Echo':
        return packets.Echo as PacketDefinition;
      case 'Write':
        return packets.Write as PacketDefinition;
      case 'Close':
        return packets.Close as PacketDefinition;
      case 'Flush':
        return packets.Flush as PacketDefinition;
      case 'Create':
        return packets.Create as PacketDefinition;
      case 'LogOff':
        return packets.LogOff as PacketDefinition;
      case 'SetInfo':
        return packets.SetInfo as PacketDefinition;
      case 'Negotiate':
        return packets.Negotiate as PacketDefinition;
      case 'TreeConnect':
        return packets.TreeConnect as PacketDefinition;
      case 'SessionSetup':
        return packets.SessionSetup as PacketDefinition;
      case 'ChangeNotify':
        return packets.ChangeNotify as PacketDefinition;
      case 'TreeDisconnect':
        return packets.TreeDisconnect as PacketDefinition;
      case 'QueryDirectory':
        return packets.QueryDirectory as PacketDefinition;
      case 'InputOutputControl':
        return packets.InputOutputControl as PacketDefinition;
      case 'QueryInfo':
        return packets.QueryInfo as PacketDefinition;
      case 'RpcBind':
        return packets.RpcBind as PacketDefinition;
      case 'NetShareEnumAll':
        return packets.NetShareEnumAll as PacketDefinition;
      default:
        throw new Error(`packet_not_found: ${typeName}`);
    }
  }

  static getStructure(header: Header): Structure {
    const packetType = header.type;
    if (packetType === undefined) {
      throw new Error('header_packet_type_not_found');
    }
    const packet = Packet.getPacketByPacketType(packetType);
    const flags = header.flags ?? 0;
    const isResponse = (flags & HeaderFlag.Response) === HeaderFlag.Response;
    const structure = isResponse ? packet.responseStructure : packet.requestStructure;
    return structure;
  }

  static serialize(header: Header, body: PacketBody): buffer.Buffer {
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

  static parse(buf: buffer.Buffer): ParsedPacketData {
    const parsedHeader = Packet.parseHeader(buf);
    const header = parsedHeader.header;
    const bodyBuffer = parsedHeader.bodyBuffer;
    const structure = Packet.getStructure(header);
    const body = structureUtil.parseStructure(bodyBuffer, structure);
    const parsedPacket = new ParsedPacketData(header, body);
    return parsedPacket;
  }

  static parseHeader(buf: buffer.Buffer): ParsedHeaderData {
    const header = structureUtil.parseStructure(buf, headerStructure) as Header;
    const bodyBuffer = buf.subarray(headerSize);
    const parsedHeader = new ParsedHeaderData(header, bodyBuffer);
    return parsedHeader;
  }

  static serializeHeader(header: Header): buffer.Buffer {
    return structureUtil.serializeStructure(headerStructure, header);
  }
}

export function byteReplacer(key: string, value: JsonReplacerValue): JsonReplacerValue {
  if (typeof value === 'number') {
    return value.toString(16).padStart(2, '0');
  }
  return value;
}
