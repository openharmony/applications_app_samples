/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import { describe, it, expect } from '@ohos/hypium';
import util from '@ohos.util';
import Logger from '../common/Logger';

const INDEX: number = 2;
const SLEEP_TIME: number = 10;
const RADIX: number = 16;

export function strToUtf8Bytes(content: string): Array<number> {
  const code = encodeURIComponent(content);
  let bytes: Array<number> = [];
  for (let i = 0; i < code.length; i++) {
    const char: string = code.charAt(i);
    if (char === '%') {
      const hex: string = code.charAt(i + 1) + code.charAt(i + INDEX);
      const hexValue: number = Math.floor(Number(hex));
      // const hexValue: number = parseInt(hex, RADIX);
      bytes.push(hexValue);
      i += INDEX;
    } else {
      bytes.push(char.charCodeAt(0));
    }
  }
  return bytes;
}

export function strToArrayBuffer(text: string): ArrayBuffer {
  const bytes: number[] = strToUtf8Bytes(text);
  const buffer: ArrayBuffer = new ArrayBuffer(bytes.length);
  const bufView: DataView = new DataView(buffer);
  for (let i: number = 0; i < bytes.length; i++) {
    bufView.setUint8(i, bytes[i]);
  }
  return buffer;
}

export async function sleep(times: number): Promise<void> {
  if (!times) {
    times = SLEEP_TIME;
  }
  await new Promise<Object>((res) => setTimeout(res, times));
}

export function randomString(num: number, chars: string): string {
  let len = num;
  let maxPos = chars.length;
  let pwd = '';
  for (let i = 0; i < len; i++) {
    pwd += chars.charAt(Math.floor(Math.random() * maxPos));
  }
  return pwd;
}

export function bufferToString(buffer: ArrayBuffer): string {
  let textDecoder = new util.TextDecoder('utf-8', {
    ignoreBOM: true
  });
  let resultPut = textDecoder.decodeWithStream(new Uint8Array(buffer), {
    stream: true
  });
  return resultPut;
}

export function stringToBuffer(content: string): Uint8Array {
  let textEncoder = new util.TextEncoder('utf-8');
  let resultBuf = textEncoder.encodeInto(content);
  return resultBuf;
}

export {
  describe, it, expect, Logger
};