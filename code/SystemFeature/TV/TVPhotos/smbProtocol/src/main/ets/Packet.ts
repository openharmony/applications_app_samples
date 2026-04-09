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
import * as protocolIds from './protocolIds';
import StructureField from './StructureField';
import * as structureUtil from './structureUtil';

export const protocolIdStructureField: StructureField = {
  type: String,
  encoding: "hex",
  size: 4,
  defaultValue: protocolIds.smb2
};

export default class Packet {
  static parseProtocolId(buf: buffer.Buffer) {
    return structureUtil.parseValue(buf, protocolIdStructureField) as string;
  }

  static getChunks(buf: buffer.Buffer) {
    const chunks: buffer.Buffer[] = [];
    while (buf.length > 4) {
      const netBiosType = buf.readUInt8(0);
      if (netBiosType !== 0x00) {
        throw new Error("no_net_bios_message");
      }
      const packetLength = buf.readUInt32BE(0);
      if (packetLength > buf.length - 4) {
        break;
      }
      buf = buf.subarray(4);
      chunks.push(buf.subarray(0, packetLength));
      buf = buf.subarray(packetLength);
    }
    return {
      chunks, restChunk: buf
    };
  }
}