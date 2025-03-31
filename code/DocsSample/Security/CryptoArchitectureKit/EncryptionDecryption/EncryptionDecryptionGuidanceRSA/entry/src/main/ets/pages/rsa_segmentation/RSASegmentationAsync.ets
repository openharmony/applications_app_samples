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

// 分段加密消息
async function rsaEncryptBySegment(pubKey: cryptoFramework.PubKey, plainText: cryptoFramework.DataBlob) {
  let cipher = cryptoFramework.createCipher('RSA1024|PKCS1');
  await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, pubKey, null);
  let plainTextSplitLen = 64;
  let cipherText = new Uint8Array();
  for (let i = 0; i < plainText.data.length; i += plainTextSplitLen) {
    let updateMessage = plainText.data.subarray(i, i + plainTextSplitLen);
    let updateMessageBlob: cryptoFramework.DataBlob = { data: updateMessage };
    // 将原文按64字符进行拆分，循环调用doFinal进行加密，使用1024bit密钥时，每次加密生成128字节长度的密文
    let updateOutput = await cipher.doFinal(updateMessageBlob);
    let mergeText = new Uint8Array(cipherText.length + updateOutput.data.length);
    mergeText.set(cipherText);
    mergeText.set(updateOutput.data, cipherText.length);
    cipherText = mergeText;
  }
  let cipherBlob: cryptoFramework.DataBlob = { data: cipherText };
  return cipherBlob;
}

// 分段解密消息
async function rsaDecryptBySegment(priKey: cryptoFramework.PriKey, cipherText: cryptoFramework.DataBlob) {
  let decoder = cryptoFramework.createCipher('RSA1024|PKCS1');
  await decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, priKey, null);
  let cipherTextSplitLen = 128; // RSA密钥每次加密生成的密文字节长度计算方式：密钥位数/8
  let decryptText = new Uint8Array();
  for (let i = 0; i < cipherText.data.length; i += cipherTextSplitLen) {
    let updateMessage = cipherText.data.subarray(i, i + cipherTextSplitLen);
    let updateMessageBlob: cryptoFramework.DataBlob = { data: updateMessage };
    // 将密文按128字节进行拆分解密，得到原文后进行拼接
    let updateOutput = await decoder.doFinal(updateMessageBlob);
    let mergeText = new Uint8Array(decryptText.length + updateOutput.data.length);
    mergeText.set(decryptText);
    mergeText.set(updateOutput.data, decryptText.length);
    decryptText = mergeText;
  }
  let decryptBlob: cryptoFramework.DataBlob = { data: decryptText };
  return decryptBlob;
}

async function rsaEncryptLongMessage() {
  let message = 'This is a long plainTest! This is a long plainTest! This is a long plainTest!' +
    'This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!' +
    'This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!' +
    'This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!' +
    'This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!' +
    'This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!' +
    'This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!' +
    'This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!';
  let asyKeyGenerator = cryptoFramework.createAsyKeyGenerator('RSA1024'); // 创建非对称密钥生成器对象
  let keyPair = await asyKeyGenerator.generateKeyPair(); // 随机生成RSA密钥
  let plainText: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from(message, 'utf-8').buffer) };
  let encryptText = await rsaEncryptBySegment(keyPair.pubKey, plainText);
  let decryptText = await rsaDecryptBySegment(keyPair.priKey, encryptText);
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
  @State message: string = 'RSA Segmentation Async';

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.call_rsa_segmentation_async'))
        .onClick(async () => {
          try {
            await rsaEncryptLongMessage();
            this.message = 'RSA Segmentation Async Success';
          } catch (error) {
            console.error(error);
            this.message = 'RSA Segmentation Async Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}