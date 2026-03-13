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

// [Start encrypt_decrypt_rc4_asynchronous]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';


// 加密消息
async function encryptMessagePromise(symKey: cryptoFramework.SymKey, plainText: cryptoFramework.DataBlob) {
  let cipher = cryptoFramework.createCipher('RC4');
  await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, null);
  let cipherData = await cipher.doFinal(plainText);
  return cipherData;
}

// 解密消息
async function decryptMessagePromise(symKey: cryptoFramework.SymKey, cipherText: cryptoFramework.DataBlob) {
  let decoder = cryptoFramework.createCipher('RC4');
  await decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, null);
  let decryptData = await decoder.doFinal(cipherText);
  return decryptData;
}

async function genSymKeyByData(symKeyData: Uint8Array) {
  let symKeyBlob: cryptoFramework.DataBlob = { data: symKeyData };
  let rc4Generator = cryptoFramework.createSymKeyGenerator('RC4');
  let symKey = await rc4Generator.convertKey(symKeyBlob);
  console.info('convertKey result: success.');
  return symKey;
}

async function rc4EncryptionDecryption() {
  let keyData = new Uint8Array([83, 217, 231, 76, 28, 113, 23, 219, 250, 71, 209, 210, 205, 97, 32, 159]);
  let symKey = await genSymKeyByData(keyData);
  let message = 'This is a test';
  let plainText: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from(message, 'utf-8').buffer) };
  let encryptText = await encryptMessagePromise(symKey, plainText);
  let decryptText = await decryptMessagePromise(symKey, encryptText);
  if (plainText.data.toString() === decryptText.data.toString()) {
    console.info('decrypt ok.');
    console.info('decrypt plainText: ' + buffer.from(decryptText.data).toString('utf-8'));
  } else {
    console.error('decrypt failed.');
  }
}
// [End encrypt_decrypt_rc4_asynchronous]

@Entry
@Component
struct Index {
  @State message: string = 'Encryption Decryption Guidance RC4 ArkTs';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_rc4_encryption_decryption_asynchronous'))
        .width('70%')
        .onClick(() => {
          try {
            rc4EncryptionDecryption();
            this.message = 'RC4_EncryptionDecryptionAsynchronousSuccess';
          } catch {
            this.message = 'RC4_EncryptionDecryptionAsynchronousFail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}