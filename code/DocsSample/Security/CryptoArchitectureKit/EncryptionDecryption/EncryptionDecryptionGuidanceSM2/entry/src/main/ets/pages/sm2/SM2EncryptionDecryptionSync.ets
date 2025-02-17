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

import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';

// 加密消息
function encryptMessage(publicKey: cryptoFramework.PubKey, plainText: cryptoFramework.DataBlob) {
  let cipher = cryptoFramework.createCipher('SM2_256|SM3');
  cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, publicKey, null);
  let encryptData = cipher.doFinalSync(plainText);
  return encryptData;
}

// 解密消息
function decryptMessage(privateKey: cryptoFramework.PriKey, cipherText: cryptoFramework.DataBlob) {
  let decoder = cryptoFramework.createCipher('SM2_256|SM3');
  decoder.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE, privateKey, null);
  let decryptData = decoder.doFinalSync(cipherText);
  return decryptData;
}

// 生成SM2密钥对
function genKeyPairByData(pubKeyData: Uint8Array, priKeyData: Uint8Array) {
  let pubKeyBlob: cryptoFramework.DataBlob = { data: pubKeyData };
  let priKeyBlob: cryptoFramework.DataBlob = { data: priKeyData };
  let sm2Generator = cryptoFramework.createAsyKeyGenerator('SM2_256');
  let keyPair = sm2Generator.convertKeySync(pubKeyBlob, priKeyBlob);
  console.info('convertKeySync success');
  return keyPair;
}

function main() {
  let pkData =
    new Uint8Array([48, 89, 48, 19, 6, 7, 42, 134, 72, 206, 61, 2, 1, 6, 8, 42, 129, 28, 207, 85, 1, 130, 45, 3, 66, 0,
      4, 90, 3, 58, 157, 190, 248, 76, 7, 132, 200, 151, 208, 112, 230, 96, 140, 90, 238, 211, 155, 128, 109, 248, 40,
      83, 214, 78, 42, 104, 106, 55, 148, 249, 35, 61, 32, 221, 135, 143, 100, 45, 97, 194, 176, 52, 73, 136, 174, 40,
      70, 70, 34, 103, 103, 161, 99, 27, 187, 13, 187, 109, 244, 13, 7]);
  let skData =
    new Uint8Array([48, 49, 2, 1, 1, 4, 32, 54, 41, 239, 240, 63, 188, 134, 113, 31, 102, 149, 203, 245, 89, 15, 15, 47,
      202, 170, 60, 38, 154, 28, 169, 189, 100, 251, 76, 112, 223, 156, 159, 160, 10, 6, 8, 42, 129, 28, 207, 85, 1,
      130, 45]);
  let keyPair = genKeyPairByData(pkData, skData);
  let pubKey = keyPair.pubKey;
  let priKey = keyPair.priKey;
  let message = 'This is a test';
  // 把字符串按utf-8解码为Uint8Array
  let plainText: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from(message, 'utf-8').buffer) };
  let encryptText = encryptMessage(pubKey, plainText);
  let decryptText = decryptMessage(priKey, encryptText);
  if (plainText.data.toString() === decryptText.data.toString()) {
    console.info('decrypt ok');
    // 把Uint8Array按utf-8编码为字符串
    let messageDecrypted = buffer.from(decryptText.data).toString('utf-8');
    console.info('decrypted result string:' + messageDecrypted);
  } else {
    console.error('decrypt failed');
  }
}

@Entry
@Component
struct Index {
  @State message: string = 'SM2 Sync';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_sm2_sync'))
        .width('70%')
        .onClick(() => {
          try {
            main();
            this.message = 'SM2 Sync Success';
          } catch {
            this.message = 'SM2 Sync Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}