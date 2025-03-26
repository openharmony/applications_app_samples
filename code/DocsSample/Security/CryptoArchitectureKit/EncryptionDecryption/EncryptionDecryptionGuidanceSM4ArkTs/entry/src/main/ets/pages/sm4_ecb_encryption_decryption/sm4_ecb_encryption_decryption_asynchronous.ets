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
async function encryptMessagePromise(symKey: cryptoFramework.SymKey, plainText: cryptoFramework.DataBlob) {
  let cipher = cryptoFramework.createCipher('SM4_128|ECB|PKCS7');
  await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, null);
  let encryptData = await cipher.doFinal(plainText);
  return encryptData;
}

// 解密消息
async function decryptMessagePromise(symKey: cryptoFramework.SymKey, cipherText: cryptoFramework.DataBlob) {
  let decoder = cryptoFramework.createCipher('SM4_128|ECB|PKCS7');
  await decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, null);
  let decryptData = await decoder.doFinal(cipherText);
  return decryptData;
}

async function genSymKeyByData(symKeyData: Uint8Array) {
  let symKeyBlob: cryptoFramework.DataBlob = { data: symKeyData };
  let symGenerator = cryptoFramework.createSymKeyGenerator('SM4_128');
  let symKey = await symGenerator.convertKey(symKeyBlob);
  console.info('convertKey success');
  return symKey;
}

async function main() {
  let keyData = new Uint8Array([7, 154, 52, 176, 4, 236, 150, 43, 237, 9, 145, 166, 141, 174, 224, 131]);
  let symKey = await genSymKeyByData(keyData);
  let message = 'This is a test';
  let plainText: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from(message, 'utf-8').buffer) };
  let encryptText = await encryptMessagePromise(symKey, plainText);
  let decryptText = await decryptMessagePromise(symKey, encryptText);
  if (plainText.data.toString() === decryptText.data.toString()) {
    console.info('decrypt ok');
    console.info('decrypt plainText: ' + buffer.from(decryptText.data).toString('utf-8'));
  } else {
    console.error('decrypt failed');
  }
}

@Entry
@Component
struct Index {
  @State message: string = 'Encryption Decryption Guidance SM4 ArkTs';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_sm4_ecb_asynchronous'))
        .width('70%')
        .onClick(async () => {
          try {
            await main();
            this.message = 'SM4_ECBSuccess';
          } catch {
            this.message = 'SM4_ECBFail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}