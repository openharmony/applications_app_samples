/*
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

// [Start get_license]
import { http } from '@kit.NetworkKit';

export class GetLicense {
  // 获取DRM许可证, 仅做参考，需要结合实际资源和服务地址进行获取。
  async getLicense(drmUrl: string, requestData: Uint8Array): Promise<Uint8Array | undefined> {
    let licenseRequestStr: string = this.byteToString(requestData);
    let licenseResponseStr: string = 'defaultStr';
    let httpRequest = http.createHttp();
    try {
      let response: http.HttpResponse = await httpRequest.request(drmUrl, {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json',
          'Accept-Encoding': 'gzip, deflate',
        },
        extraData: licenseRequestStr,
        expectDataType: http.HttpDataType.STRING,
      });
      if (response?.responseCode == http.ResponseCode.OK) {
        if (typeof response.result == 'string') {
          licenseResponseStr = response.result;
        }
      }
      httpRequest.destroy();
    } catch (error) {
      console.error(`Failed to request Http. Error: ${error}`);
      return undefined;
    }
    return this.stringToByte(licenseResponseStr);
  }

  /**
   * Uint8Array to string
   * @param arr Uint8Array
   * @returns string
   */
  byteToString(arr: Uint8Array): string {
    let str: string = ''
    let _arr: Uint8Array = arr

    for (let i = 0; i < _arr.length; i++) {
      // 将数值转为二进制字符串
      let binaryStr: string = _arr[i].toString(2)
      let matchArray = binaryStr.match(new RegExp('/^1+?(?=0)/'))
      if (matchArray && binaryStr.length == 8) {
        let bytesLength: number = matchArray[0].length
        let store: string = _arr[i].toString(2).slice(7 - bytesLength)

        for (let j = 1; j < bytesLength; j++) {
          store += _arr[j + i].toString(2).slice(2)
        }
        str += String.fromCharCode(Number.parseInt(store, 2))
        i += bytesLength - 1
      } else {
        str += String.fromCharCode(_arr[i])
      }
    }
    return str
  }

  /**
   * string 转 Uint8Array
   * @param str string
   * @returns Uint8Array
   */
  stringToByte(str: string): Uint8Array {
    let bytes: number[] = []
    let unicode: number

    for (let i = 0; i < str.length; i++) {
      unicode = str.charCodeAt(i)
      if (unicode >= 0x010000 && unicode <= 0x10FFFF) {
        bytes.push(((unicode >> 18) & 0x07) | 0xf0)
        bytes.push(((unicode >> 12) & 0x3F) | 0x80)
        bytes.push(((unicode >> 6) & 0x3F) | 0x80)
        bytes.push((unicode & 0x3F) | 0x80)
      } else if (unicode >= 0x000800 && unicode <= 0x00FFF) {
        bytes.push(((unicode >> 12) & 0x07) | 0xf0)
        bytes.push(((unicode >> 6) & 0x3F) | 0x80)
        bytes.push((unicode & 0x3F) | 0x80)
      } else if (unicode >= 0x000800 && unicode <= 0x0007FF) {
        bytes.push(((unicode >> 6) & 0x3F) | 0x80)
        bytes.push((unicode & 0x3F) | 0x80)
      } else {
        bytes.push(unicode & 0xFF)
      }
    }
    return new Uint8Array(bytes);
  }
}
// [End get_license]