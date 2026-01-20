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

// [Start encrypt_decrypt_aes_wrap_sync]

import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';

function generateRandom(len: number) {
  let rand = cryptoFramework.createRandom();
  let generateRandSync = rand.generateRandomSync(len);
  return generateRandSync;
}

function genIvParamsSpec() {
  let ivBlob = generateRandom(8);
  let ivParamsSpec: cryptoFramework.IvParamsSpec = {
    algName: 'IvParamsSpec',
    iv: ivBlob
  };
  return ivParamsSpec;
}
let iv = genIvParamsSpec();
// 加密消息。
function encryptMessage(symKey: cryptoFramework.SymKey, plainText: cryptoFramework.DataBlob) {
  let cipher = cryptoFramework.createCipher('AES128-WRAP');
  cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, iv);
  let cipherData = cipher.doFinalSync(plainText);
  return cipherData;
}
// 解密消息。
function decryptMessage(symKey: cryptoFramework.SymKey, cipherText: cryptoFramework.DataBlob) {
  let decoder = cryptoFramework.createCipher('AES128-WRAP');
  decoder.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, iv);
  let decryptData = decoder.doFinalSync(cipherText);
  return decryptData;
}

function genSymKeyByData(symKeyData: Uint8Array) {
  let symKeyBlob: cryptoFramework.DataBlob = { data: symKeyData };
  let aesGenerator = cryptoFramework.createSymKeyGenerator('AES128');
  let symKey = aesGenerator.convertKeySync(symKeyBlob);
  console.info('convertKeySync result: success.');
  return symKey;
}

function main() {
  try {
    let keyData = new Uint8Array([83, 217, 231, 76, 28, 113, 23, 219, 250, 71, 209, 210, 205, 97, 32, 159]);
    let symKey = genSymKeyByData(keyData);
    let plainText: cryptoFramework.DataBlob = { data: new Uint8Array(keyData)};
    let encryptText = encryptMessage(symKey, plainText);
    let decryptText = decryptMessage(symKey, encryptText);
    if (plainText.data.toString() === decryptText.data.toString()) {
      console.info('decrypt ok.');
      console.info('decrypt plainText: ' + buffer.from(decryptText.data).toString('utf-8'));
    } else {
      console.error('decrypt failed.');
    }
  } catch (error) {
    console.error(`AES Wrap failed: errCode: ${error.code}, message: ${error.message}`);
  }
}

// [End encrypt_decrypt_aes_wrap_sync]

@Entry
@Component
struct Index {
  @State message: string = 'AesWrap Sync';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_aes_wrap_synchronous'))
        .width('70%')
        .onClick(() => {
          try {
            main();
            this.message = 'AesWrap Sync Success';
          } catch {
            this.message = 'AesWrap Sync Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}