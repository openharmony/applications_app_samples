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
import CryptoJS from '@ohos/crypto-js';

export default class HMACT64 {
  private static readonly BLOCK_LENGTH: number = 64;
  private static readonly IPAD: number = 0x36;
  private static readonly OPAD: number = 0x5c;

  private ipad: CryptoJS.lib.WordArray;
  private opad: CryptoJS.lib.WordArray;

  constructor(key: CryptoJS.lib.WordArray) {
    // Truncate the key to BLOCK_LENGTH if necessary
    const truncatedKey = key.clone();
    truncatedKey.sigBytes = Math.min(truncatedKey.sigBytes, HMACT64.BLOCK_LENGTH);

    // Create IPAD and OPAD
    this.ipad = CryptoJS.lib.WordArray.create();
    this.opad = CryptoJS.lib.WordArray.create();

    for (let i = 0; i < HMACT64.BLOCK_LENGTH; i++) {
      // Get the byte at position i from the truncated key
      const keyByte =
        i < truncatedKey.sigBytes ? truncatedKey.words[Math.floor(i / 4)] >>> (24 - (i % 4) * 8) & 0xff : 0;

      // XOR the key byte with IPAD and OPAD
      this.ipad.words[Math.floor(i / 4)] |= (keyByte ^ HMACT64.IPAD) << (24 - (i % 4) * 8);
      this.opad.words[Math.floor(i / 4)] |= (keyByte ^ HMACT64.OPAD) << (24 - (i % 4) * 8);
    }
    this.ipad.sigBytes = HMACT64.BLOCK_LENGTH;
    this.opad.sigBytes = HMACT64.BLOCK_LENGTH;
  }

  public update(data: CryptoJS.lib.WordArray): void {
    this.ipad.concat(data);
  }

  public digest(): CryptoJS.lib.WordArray {
    // Inner hash: MD5(ipad || data)
    const innerHash = CryptoJS.MD5(this.ipad);

    // Outer hash: MD5(opad || innerHash)
    const outerHash = CryptoJS.MD5(this.opad.clone().concat(innerHash));

    return outerHash;
  }

  public clone(): HMACT64 {
    const cloned = new HMACT64(CryptoJS.lib.WordArray.create());
    cloned.ipad = this.ipad.clone();
    cloned.opad = this.opad.clone();
    return cloned;
  }
}