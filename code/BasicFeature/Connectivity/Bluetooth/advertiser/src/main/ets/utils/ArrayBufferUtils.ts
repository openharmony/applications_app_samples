/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

export default class ArrayBufferUtils {

  /**
   * byte array to ArrayBuffer
   * @param byteArr
   */
  public static byteArray2ArrayBuffer(byteArr: Array<number>): ArrayBufferLike {
    let ret: ArrayBufferLike = new Uint8Array(byteArr).buffer;
    return ret;
  }

  /**
   * ArrayBuffer to byte array
   * @param arrayBuffer
   */
  public static arrayBuffer2ByteArray(arrayBuffer: ArrayBuffer): Array<number> {
    let ret: Array<number> = Array.prototype.slice.call(new Uint8Array(arrayBuffer));
    return ret;
  }
}