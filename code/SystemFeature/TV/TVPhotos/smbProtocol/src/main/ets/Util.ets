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
import CryptoJS from '@ohos/crypto-js';

export const toWindowsFilePath = (value: string): string => {
  if (value[0] === '.') {
    value = value.substring(1);
  }
  if (value[0] === '/') {
    value = value.substring(1);
  }
  value = toWindowsPath(value);
  return value;
};

export const toUnixFilePath = (value: string): string => {
  value = toUnixPath(value);
  if (value[0] !== '/' && value[0] !== '.') {
    value = `./${value}`;
  }
  if (value[0] === '/') {
    value = `.${value}`;
  }
  return value;
};

export const toWindowsPath = (value: string): string => {
  value = value.replace(/\//g, '\\');
  return value;
};

export const toUnixPath = (value: string): string => {
  value = value.replace(/\\/g, '/');
  return value;
};

export const getRandomInt = (min: number, max: number): number => {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min + 1)) + min;
};

export const generateGuid = (): buffer.Buffer => {
  const timeLow = getRandomInt(0, Math.pow(2, 32) - 1);
  const timeMiddle = getRandomInt(0, Math.pow(2, 16) - 1);
  const timeHighAndVersion = 0x4000 | getRandomInt(0, Math.pow(2, 12) - 1);
  const clockSequenceHighAndReserved = 0x80 | getRandomInt(0, Math.pow(2, 6) - 1);
  const clockSequenceLow = getRandomInt(0, Math.pow(2, 8) - 1);
  const node = CryptoJS.lib.WordArray.random(6).words;
  const buf = buffer.alloc(16);
  let offset = 0;
  buf.writeUInt32LE(timeLow, offset);
  offset += 4;
  buf.writeUInt16LE(timeMiddle, offset);
  offset += 2;
  buf.writeUInt16LE(timeHighAndVersion, offset);
  offset += 2;
  buf.writeUInt8(clockSequenceHighAndReserved, offset);
  offset += 1;
  buf.writeUInt8(clockSequenceLow, offset);
  offset += 1;
  buffer.from(node).copy(buf, offset);
  return buf;
};

export const bufferAlign = (buf: buffer.Buffer, alignSize: 2 | 4 | 8): buffer.Buffer => {
  const pad = buf.length % alignSize
  //补齐4位
  if (pad === 0) {
    return buf
  } else {
    let b = buffer.alloc(buf.length + alignSize - pad)
    buf.copy(b)
    return b
  }
}

export const bufferAppendTerminator = (buf: buffer.Buffer, terminatorSize: number = 2): buffer.Buffer => {
  let b = buffer.alloc(buf.length + terminatorSize)
  buf.copy(b)
  return b
}

export const convertUuidToBuffer = (uuid: string): buffer.Buffer => {
  const parts = uuid.split('-')
  if (parts.length !== 5) {
    throw new Error(`Invalid UUID: ${uuid}`);
  }
  const buf = buffer.alloc(16)
  let offset = 0
  for (let index = 0; index < parts.length; index++) {
    const partBuf = buffer.from(parts[index], 'hex');
    if (index <= 2) {
      if (partBuf.length == 2) {
        buf.writeUInt16LE(partBuf.readUInt16BE(), offset)
        offset += 2
      } else if (partBuf.length == 4) {
        buf.writeUInt32LE(partBuf.readUInt32BE(), offset)
        offset += 4
      } else {
        throw new Error(`Invalid UUID: ${uuid}`);
      }
    } else {
      partBuf.copy(buf, offset)
      offset += partBuf.length
    }
  }
  return buf
}

export function bigIntReplacer(key: string, value: Object): Object {
  if (typeof value === 'bigint') {
    return value.toString();
  }
  return value;
}

export function byteReplacer(key: string, value: Object): Object {
  if (typeof value === 'number') {
    return value.toString(16).padStart(2, '0')
  }
  return value;
}

export function generateClientId(): string {
  return CryptoJS.lib.WordArray.random(4).toString(CryptoJS.enc.Hex);
}
