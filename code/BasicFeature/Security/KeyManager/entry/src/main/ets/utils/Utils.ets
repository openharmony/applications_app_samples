/*
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

import { buffer, util } from '@kit.ArkTS';
import { emitter } from '@kit.BasicServicesKit';

export const TAG: string = "KeyManager";

export enum MessagePosition {
  Left, Right
}

export class Message {
  message: string = "";
  position: MessagePosition = MessagePosition.Right;
}

export const messageEvent: emitter.InnerEvent = {
  eventId: 1
}

export function sendProcessMessage(message: string, position: MessagePosition) {
  emitter.emit(messageEvent, {
    data: {
      message: message,
      position: position
    }
  })
}

// 字节流以16进制字符串输出
export function uint8ArrayToShowStr(uint8Array: Uint8Array): string {
  let hexString: string = '';
  for (let i = 0; i < uint8Array.length; i++) {
    let char = ('00' + uint8Array[i].toString(16)).slice(-2);
    hexString += char;
  }
  return hexString;
}

// 16进制字符串转字节流
export function fromHexString(hexString: string): Uint8Array {
  return new Uint8Array(buffer.from(hexString, 'hex').buffer);
}


// 字节流转字符串
export function arrayBufferToString(uint8Array: Uint8Array): string {
  let textDecoderOptions: util.TextDecoderOptions = {
    fatal: false,
    ignoreBOM: true
  }
  let decodeToStringOptions: util.DecodeToStringOptions = {
    stream: false
  }
  let textDecoder = util.TextDecoder.create('utf-8', textDecoderOptions);
  let retStr = textDecoder.decodeToString(new Uint8Array(uint8Array), decodeToStringOptions);
  console.info('字节流转成可理解的字符串：' + retStr);
  return retStr;
}

// 可理解的字符串转成字节流
export function stringToUint8Array(str: string): Uint8Array {
  console.info('字符串转成字节流:' + new Uint8Array(buffer.from(str, 'utf-8').buffer));
  return new Uint8Array(buffer.from(str, 'utf-8').buffer);
}

