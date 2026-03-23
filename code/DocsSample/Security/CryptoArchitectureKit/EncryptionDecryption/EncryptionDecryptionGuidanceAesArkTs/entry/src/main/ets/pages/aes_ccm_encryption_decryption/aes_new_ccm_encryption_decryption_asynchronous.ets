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

// [Start new_ccm_encrypt_decrypt_aes_symkey_async]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';

function genCcmAeadParamsSpec() {
  let nonce = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]; // 12 bytes
  let nonceValue = new Uint8Array(nonce);
  let aad = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]; // 12 bytes
  let aadValue = new Uint8Array(aad);
  let aeadParamsSpec: cryptoFramework.AeadParamsSpec = {
      nonce: nonceValue,
      authenticatedData: aadValue,
      algName: 'AeadParamsSpec'
  };
  return aeadParamsSpec;
}

  let aeadParams = genCcmAeadParamsSpec();

// 加密消息
async function encryptMessagePromise(symKey: cryptoFramework.SymKey, plainText: cryptoFramework.DataBlob) {
  let cipher = cryptoFramework.createCipher('AES128|CCM');
  await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, aeadParams);
  let encryptUpdate = await cipher.doFinal(plainText);
  return encryptUpdate;
}

// 解密消息
async function decryptMessagePromise(symKey: cryptoFramework.SymKey, cipherText: cryptoFramework.DataBlob) {
  let decoder = cryptoFramework.createCipher('AES128|CCM');
  await decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, aeadParams);
  let decryptUpdate = await decoder.doFinal(cipherText);
  return decryptUpdate;
}

async function genSymKeyByData(symKeyData: Uint8Array) {
  let symKeyBlob: cryptoFramework.DataBlob = { data: symKeyData };
  let aesGenerator = cryptoFramework.createSymKeyGenerator('AES128');
  let symKey = await aesGenerator.convertKey(symKeyBlob);
  console.info('convertKey result: success.');
  return symKey;
}

export async function main() : Promise<string> {
  try {
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
    return 'success';
  } catch (error) {
    console.error('decrypt failed. error: ' + error);
    return 'fail';
  }
}
// [End new_ccm_encrypt_decrypt_aes_symkey_async]

@Entry
@Component
struct Index {
  @State message: string = 'Encryption Decryption Guidance Aes ArkTs';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_aes_new_ccm_asynchronous'))
        .width('70%')
        .onClick(async () => {
            let result = await main();
            if (result === 'success') {
              this.message = 'AES_NewCCMAsynchronousSuccess';
            } else {
              this.message = 'AES_NewCCMAsynchronousFail';
            }
        })
    }
    .height('100%')
    .width('100%')
  }
}