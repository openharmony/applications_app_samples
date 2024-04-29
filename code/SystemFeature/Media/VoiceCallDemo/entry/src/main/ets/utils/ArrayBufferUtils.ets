/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

const BYTE_FOR_EACH_CHAR = 2; // 2 bytes for each char

export default class ArrayBufferUtils {
  static byte2ArrayBuffer(data: Array<number>): ArrayBuffer {
    let view = new Uint8Array(data);
    return view.buffer;
  }

  static arrayBuffer2Byte(buf: ArrayBuffer): Array<number> {
    let arr = new Uint8Array(buf);
    let result: Array<number> = [];

    for (let i = 0; i < arr.length; i++) {
      result.push(arr[i]);
    }
    return result;
  }


  static arrayBuffer2str(buf: ArrayBuffer): string {
    let result: string = String.fromCharCode.apply(null, new Uint16Array(buf));
    return result;
  }

  static str2ArrayBuffer(str): ArrayBuffer {
    let buf = new ArrayBuffer(str.length * BYTE_FOR_EACH_CHAR); // 2 bytes for each char
    let bufView = new Uint16Array(buf);
    for (let i = 0, strLen = str.length; i < strLen; i++) {
      bufView[i] = str.charCodeAt(i);
    }
    return buf;
  }
}