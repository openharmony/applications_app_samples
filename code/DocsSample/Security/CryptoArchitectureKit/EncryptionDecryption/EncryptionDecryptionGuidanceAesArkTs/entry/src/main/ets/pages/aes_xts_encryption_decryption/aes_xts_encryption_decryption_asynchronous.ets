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

// [Start xts_encrypt_decrypt_aes_symkey_asynchronous]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';

function generateRandom(len: number) {
  let rand = cryptoFramework.createRandom();
  let generateRandSync = rand.generateRandomSync(len);
  return generateRandSync;
}

function genIvParamsSpec() {
  let ivBlob = generateRandom(16);
  let ivParamsSpec: cryptoFramework.IvParamsSpec = {
    algName: 'IvParamsSpec',
    iv: ivBlob
  };
  return ivParamsSpec;
}

let iv = genIvParamsSpec();

// 加密消息
async function encryptMessagePromise(symKey: cryptoFramework.SymKey, plainText: cryptoFramework.DataBlob) {
  let cipher = cryptoFramework.createCipher('AES128|XTS');
  await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, iv);
  let cipherData = await cipher.doFinal(plainText);
  return cipherData;
}

// 解密消息
async function decryptMessagePromise(symKey: cryptoFramework.SymKey, cipherText: cryptoFramework.DataBlob) {
  let decoder = cryptoFramework.createCipher('AES128|XTS');
  await decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, iv);
  let decryptData = await decoder.doFinal(cipherText);
  return decryptData;
}

export async function aesXTS() : Promise<string> {
  try {
    let symGenerator = cryptoFramework.createSymKeyGenerator('AES256')
    let symKey = await symGenerator.generateSymKey()
    let message = 'This is a xts encrypt decrypt test';
    let plainText: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from(message, 'utf-8').buffer) };
    let encryptText = await encryptMessagePromise(symKey, plainText);
    let decryptText = await decryptMessagePromise(symKey, encryptText);
    if (plainText.data.toString() === decryptText.data.toString()) {
      console.info('decrypt ok');
      console.info('decrypt plainText: ' + buffer.from(decryptText.data).toString('utf-8'));
    } else {
      console.error('decrypt failed');
    }
    return 'success';
  } catch (error) {
    console.error('xts decrypt failed. error: ' + error);
    return 'fail';
  }
}
// [End xts_encrypt_decrypt_aes_symkey_asynchronous]

@Entry
@Component
struct Index {
  @State message: string = 'Encryption Decryption Guidance Aes ArkTs';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_aes_xts_asynchronous'))
        .width('70%')
        .onClick(async () => {
          let result = await aesXTS();
          if (result === 'success') {
            this.message = 'AES_XTSSuccess';
          } else {
            this.message = 'AES_XTSFail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}