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


export default class ArrayBufferUtil {
  /**
   * 十六进制字符串，转为十进制数字
   * @param hexString
   * @returns
   */
  static getIntFromHex(hexString: string): number {
    if (!ArrayBufferUtil.isValidHexString(hexString)) {
      throw Error('error hex string');
    }
    return parseInt(hexString, 16);
  }

  /**
   * 在指定offset偏移量处，设置一个hex字符串的数据
   * @param view
   * @param offset 单位，字节
   * @param hexString 可以任意位数十六进制，会自动赋值到对应offset
   */
  static setUint8FromHex(view: DataView, offset: number, hexString: string) {
    const arr: string[] = ArrayBufferUtil.getHexStrArr(hexString);
    for (let i = 0; i < arr.length; i++) {
      view.setUint8(offset + i, ArrayBufferUtil.getIntFromHex(arr[i]));
    }
  }


  /**
   * 在指定offset偏移量处，写入一个hexArr表示的数据
   * @param view
   * @param offset 单位，字节
   * @param hexArr
   */
  static setUnit8FromHexArray(view: DataView, offset: number, hexArr: Array<string>) {
    let lastOffset: number = offset;
    let lastDataLength: number = 0;
    for (let i = 0; i < hexArr.length; i++) {
      let hex: string = hexArr[i];
      hex = ArrayBufferUtil.formatHex(hex);
      //当前偏移量
      lastOffset = lastOffset + lastDataLength;
      //计算本次长度
      lastDataLength = hex.length / 2;
      ArrayBufferUtil.setUint8FromHex(view, lastOffset, hex);
    }
  }

  /**
   * 把一个hex字符串，去掉开始的0x字符，转换成偶数位hex字符串，左边不够补0，转为小写
   * @returns
   */
  static formatHex(hexString: string): string {
    if (hexString.startsWith('0x')) {
      hexString = hexString.substring(2);
    }
    //补位
    if (hexString.length % 2 != 0) {
      hexString = '0' + hexString;
    }
    return hexString.toLowerCase();
  }

  /**
   * hex字符串，转为hex数组，每个元素为2位十六进制，一位的左边补零，
   * 比如 0xca1b => [0x0c,0xca,0x1b]
   * @param hexString
   * @returns
   */
  static getHexStrArr(hexString: string): Array<string> {
    if (!ArrayBufferUtil.isValidHexString(hexString)) {
      throw Error('error hex string');
    }
    hexString = ArrayBufferUtil.formatHex(hexString);
    const length = hexString.length / 2;
    const arr: string[] = new Array(length);
    for (let i = 0; i < length; i++) {
      arr[i] = '0x' + hexString.substring(i * 2, i * 2 + 2);
    }
    return arr;
  }

  static getHexArr(hexString: string): Array<number> {
    if (!ArrayBufferUtil.isValidHexString(hexString)) {
      throw Error('error hex string');
    }
    if (hexString.startsWith('0x')) {
      hexString = hexString.substring(2);
    }
    //补位
    if (hexString.length % 2 != 0) {
      hexString = '0' + hexString;
    }
    const length = hexString.length / 2;
    const arr: number[] = new Array(length);
    for (let i = 0; i < length; i++) {
      arr[i] = parseInt(hexString.substring(i * 2, i * 2 + 2), 16);
    }
    return arr;
  }

  /**
   * 判断是否是一个合法的十六进制字符串
   * @param str
   * @returns
   */
  static isValidHexString(str: string): boolean {
    // 使用正则表达式检查字符串格式
    const hexRegex = /^(0x)?[0-9a-fA-F]+$/;
    return hexRegex.test(str);
  }

  /**
   * arrayBuffer转化成十六进制的字符串，一个字节会转为2个hex字符
   * @param buffer
   */
  static getHexStringFromArrayBuffer(buffer: ArrayBuffer): string {
    const view = new DataView(buffer);
    let sb: string = '0x';
    for (let i = 0; i < view.byteLength; i++) {
      const n: number = view.getUint8(i);
      let hexStr: string = n.toString(16);
      if (hexStr.length == 1) {
        hexStr = '0' + hexStr;
      }
      sb += hexStr;
    }
    return sb;
  }

  /**
   * 根据十六进制字符串，转为对应的arrayBuffer值
   * 比如'aabbccff0011'
   * 转为对应的arraybuffer
   * @param hexStr
   * @returns
   */
  static getArrayBufferFromHexStr(hexStr: string): ArrayBuffer {
    if (!ArrayBufferUtil.isValidHexString(hexStr)) {
      throw Error('error hex string');
    }
    hexStr = ArrayBufferUtil.formatHex(hexStr);
    let u8a: Uint8Array = new Uint8Array(hexStr.length / 2);
    for (let i = 0; i < hexStr.length / 2; i++) {
      const hex: number = parseInt(hexStr.substring(i * 2, i * 2 + 2), 16);
      u8a[i] = hex;
    }
    return u8a.buffer;
  }
}