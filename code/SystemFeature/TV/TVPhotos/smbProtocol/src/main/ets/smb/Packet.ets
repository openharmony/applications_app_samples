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
import * as structureUtil from '../structureUtil';
import Header, { headerSize, headerStructure } from './Header';

export default class Packet {
  static parse(buf: buffer.Buffer) {
    const { header, bodyBuffer } = Packet.parseHeader(buf);
    let offset = 0;
    const wordCount = bodyBuffer.readInt8(offset);
    offset += 1;
    const dataCount = bodyBuffer.readUInt16LE(offset);
    offset += 2;
    const dataBuffer = bodyBuffer.subarray(offset);
    const dialects = Packet.parseList(dataBuffer) as string[]; // TODO: export into Negotiate packet
    const body: any = { dialects };
    return { header, body };
  }

  static parseHeader(buf: buffer.Buffer) {
    const header = structureUtil.parseStructure(buf, headerStructure) as Header;
    const bodyBuffer = buf.subarray(headerSize);
    return { header, bodyBuffer };
  }

  static parseList(buf: buffer.Buffer) {
    let offset = 0;
    let currentBytes: number[] = [];
    let terminated = true;
    let format = 0;
    const list = [];
    while (offset < buf.length) {
      const byte = buf.readInt8(offset);
      if (terminated) {
        format = byte;
        offset++;
        terminated = false;
        continue;
      }
      if (byte === 0) {
        if (format === 2) {
          const text = buffer.from(currentBytes).toString('ascii');
          list.push(text);
        }
        currentBytes = [];
        terminated = true;
      } else
        currentBytes.push(byte);
      offset++;
    }
    return list;
  }
}
