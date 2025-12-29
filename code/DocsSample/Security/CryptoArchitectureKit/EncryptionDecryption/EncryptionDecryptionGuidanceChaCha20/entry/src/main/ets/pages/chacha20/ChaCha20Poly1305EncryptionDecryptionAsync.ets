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

// [Start encrypt_decrypt_chacha20_poly1305_async]

import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';

function generateRandom(len: number) {
  let rand = cryptoFramework.createRandom();
  let generateRandSync = rand.generateRandomSync(len);
  return generateRandSync;
}

function genPoly1305ParamsSpec() {
  let ivBlob = generateRandom(12); // 12 bytes
  let arr = [1, 2, 3, 4, 5, 6, 7, 8]; // 8 bytes
  let dataAad = new Uint8Array(arr);
  let aadBlob: cryptoFramework.DataBlob = { data: dataAad };
  arr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; // 16 bytes
  let dataTag = new Uint8Array(arr);
  let tagBlob: cryptoFramework.DataBlob = {
    data: dataTag
  };
  // Poly1305的authTag在加密时从doFinal结果中获取，在解密时填入init函数的params参数中。
  let poly1305ParamsSpec: cryptoFramework.Poly1305ParamsSpec = {
    iv: ivBlob,
    aad: aadBlob,
    authTag: tagBlob,
    algName: 'Poly1305ParamsSpec'
  };
  return poly1305ParamsSpec;
}

let poly1305Params = genPoly1305ParamsSpec();

// 加密消息。
async function encryptMessagePromise(symKey: cryptoFramework.SymKey, plainText: cryptoFramework.DataBlob) {
  let cipher = cryptoFramework.createCipher('ChaCha20|Poly1305');
  await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, poly1305Params);
  let encryptUpdate = await cipher.update(plainText);
  // poly1305模式加密doFinal时传入空，获得tag数据，并更新至poly1305Params对象中。
  poly1305Params.authTag = await cipher.doFinal(null);
  return encryptUpdate;
}
// 解密消息。
async function decryptMessagePromise(symKey: cryptoFramework.SymKey, cipherText: cryptoFramework.DataBlob) {
  let decoder = cryptoFramework.createCipher('ChaCha20|Poly1305');
  await decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, poly1305Params);
  let decryptUpdata = await decoder.update(cipherText);
  // poly1305模式解密doFinal时传入空，验证init时传入的tag数据，如果验证失败会抛出异常。
  let decryptData = await decoder.doFinal(null);
  if (decryptData === null) {
    console.info('poly1305 decrypt success, decryptData is null');
  }
  return decryptUpdata;
}
async function genSymKeyByData(symKeyData: Uint8Array) {
  let symKeyBlob: cryptoFramework.DataBlob = { data: symKeyData };
  let chacha20Generator = cryptoFramework.createSymKeyGenerator('ChaCha20');
  let symKey = await chacha20Generator.convertKey(symKeyBlob);
  console.info('convertKey success');
  return symKey;
}
async function main() {
  try {
    let keyData = new Uint8Array([83, 217, 231, 76, 28, 113, 23, 219, 250, 71, 209, 210, 205, 97, 32, 159,
      83, 217, 231, 76, 28, 113, 23, 219, 250, 71, 209, 210, 205, 97, 32, 159]);
    let symKey = await genSymKeyByData(keyData);
    let message = 'This is a test';
    let plainText: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from(message, 'utf-8').buffer) };
    let encryptText = await encryptMessagePromise(symKey, plainText);
    let decryptText = await decryptMessagePromise(symKey, encryptText);
    if (plainText.data.toString() === decryptText.data.toString()) {
      console.info('decrypt ok');
      console.info('decrypt plainText: ' + buffer.from(decryptText.data).toString('utf-8'));
    } else {
      console.error('decrypt failed.');
    }
  } catch (error) {
    console.error(`decrypt failed, error info is ${error}, error code: ${error.code}`);
  }
}

// [End encrypt_decrypt_chacha20_poly1305_async]

@Entry
@Component
struct Index {
  @State message: string = 'ChaCha20 Poly1305 Async';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_chacha20_poly1305_async'))
        .width('70%')
        .onClick(() => {
          try {
            main();
            this.message = 'ChaCha20 Poly1305 Async Success';
          } catch {
            this.message = 'ChaCha20 Poly1305 ASync Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}