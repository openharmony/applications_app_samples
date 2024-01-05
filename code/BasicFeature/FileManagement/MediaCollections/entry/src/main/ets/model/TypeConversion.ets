/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

/**
 * 类型转换
 */
export default class TypeConversionUtil {
  /**
   * Uint8Array 转 string
   * @param arr Uint8Array
   * @returns string
   */
  static byteToString(arr: Uint8Array): string {
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
  static stringToByte(str: string): Uint8Array {
    let bytes: number[] = new Array()
    let unicode: number

    for (let i = 0; i < str.length; i++) {
      unicode = str.charCodeAt(i)
      if (unicode >= 0x010000 && unicode <= 0x10FFFF) {
        bytes.push(((unicode >> 18) & 0x07) | 0xf0)
        bytes.push(((unicode >> 12) & 0x3F) | 0x80)
        bytes.push(((unicode >> 6) & 0x3f) | 0x80)
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
    return new Uint8Array(bytes)
  }

  /**
   * uuid 转换
   * 1.字母大写
   * 2.去除符号：-
   */
  static uuidChange(uuid: string): string {
    let oldArr: string[] = uuid.split('')
    let newArr: string[] = []
    for (let i = 0; i < oldArr.length; i++) {
      if (oldArr[i] === '-') {
        continue
      }
      if (oldArr[i] >= 'a' && oldArr[i] <= 'z') {
        oldArr[i] = oldArr[i].toUpperCase()
      }
      newArr.push(oldArr[i])
    }
    return newArr.join('')
  }
}
