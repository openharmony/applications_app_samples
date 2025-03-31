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
function rsaEncryptBySegment(pubKey: cryptoFramework.PubKey, plainText: cryptoFramework.DataBlob) {
  let cipher = cryptoFramework.createCipher('RSA1024|PKCS1');
  cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, pubKey, null);
  let plainTextSplitLen = 64;
  let cipherText = new Uint8Array();
  for (let i = 0; i < plainText.data.length; i += plainTextSplitLen) {
    let updateMessage = plainText.data.subarray(i, i + plainTextSplitLen);
    let updateMessageBlob: cryptoFramework.DataBlob = { data: updateMessage };
    // 将原文按64字符进行拆分，循环调用doFinal进行加密，使用1024bit密钥时，每次加密生成128字节长度的密文
    let updateOutput = cipher.doFinalSync(updateMessageBlob);
    let mergeText = new Uint8Array(cipherText.length + updateOutput.data.length);
    mergeText.set(cipherText);
    mergeText.set(updateOutput.data, cipherText.length);
    cipherText = mergeText;
  }
  let cipherBlob: cryptoFramework.DataBlob = { data: cipherText };
  return cipherBlob;
}

// 分段解密消息
function rsaDecryptBySegment(priKey: cryptoFramework.PriKey, cipherText: cryptoFramework.DataBlob) {
  let decoder = cryptoFramework.createCipher('RSA1024|PKCS1');
  decoder.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE, priKey, null);
  let cipherTextSplitLen = 128; // RSA密钥每次加密生成的密文字节长度计算方式：密钥位数/8
  let decryptText = new Uint8Array();
  for (let i = 0; i < cipherText.data.length; i += cipherTextSplitLen) {
    let updateMessage = cipherText.data.subarray(i, i + cipherTextSplitLen);
    let updateMessageBlob: cryptoFramework.DataBlob = { data: updateMessage };
    // 将密文按128字节进行拆分解密，得到原文后进行拼接
    let updateOutput = decoder.doFinalSync(updateMessageBlob);
    let mergeText = new Uint8Array(decryptText.length + updateOutput.data.length);
    mergeText.set(decryptText);
    mergeText.set(updateOutput.data, decryptText.length);
    decryptText = mergeText;
  }
  let decryptBlob: cryptoFramework.DataBlob = { data: decryptText };
  return decryptBlob;
}

function main() {
  let message = 'This is a long plainTest! This is a long plainTest! This is a long plainTest!' +
    'This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!' +
    'This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!' +
    'This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!' +
    'This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!' +
    'This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!' +
    'This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!' +
    'This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!';
  let asyKeyGenerator = cryptoFramework.createAsyKeyGenerator('RSA1024'); // 创建非对称密钥生成器对象
  let keyPair = asyKeyGenerator.generateKeyPairSync(); // 随机生成RSA密钥
  let plainText: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from(message, 'utf-8').buffer) };
  let encryptText = rsaEncryptBySegment(keyPair.pubKey, plainText);
  let decryptText = rsaDecryptBySegment(keyPair.priKey, encryptText);
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
  @State message: string = 'RSA Segmentation Sync';

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.call_rsa_segmentation_sync'))
        .onClick(() => {
          try {
            main();
            this.message = 'RSA Segmentation Sync Success';
          } catch (error) {
            console.error(error);
            this.message = 'RSA Segmentation Sync Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}