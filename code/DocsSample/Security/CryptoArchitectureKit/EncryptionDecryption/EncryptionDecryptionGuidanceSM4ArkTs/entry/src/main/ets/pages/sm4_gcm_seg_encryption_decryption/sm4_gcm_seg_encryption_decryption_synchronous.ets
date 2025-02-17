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

function generateRandom(len: number) {
  let rand = cryptoFramework.createRandom();
  let generateRandSync = rand.generateRandomSync(len);
  return generateRandSync;
}

function genGcmParamsSpec() {
  let ivBlob = generateRandom(12); // 12 bytes
  let arr = [1, 2, 3, 4, 5, 6, 7, 8]; // 8 bytes
  let dataAad = new Uint8Array(arr);
  let aadBlob: cryptoFramework.DataBlob = { data: dataAad };
  arr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; // 16 bytes
  let dataTag = new Uint8Array(arr);
  let tagBlob: cryptoFramework.DataBlob = {
    data: dataTag
  }; // The GCM authTag is obtained by doFinal() in encryption and passed in params of init() in decryption.
  let gcmParamsSpec: cryptoFramework.GcmParamsSpec = {
    iv: ivBlob,
    aad: aadBlob,
    authTag: tagBlob,
    algName: 'GcmParamsSpec'
  };
  return gcmParamsSpec;
}

let gcmParams = genGcmParamsSpec();

// 分段加密消息
function encryptMessageUpdateBySegment(symKey: cryptoFramework.SymKey, plainText: cryptoFramework.DataBlob) {
  let cipher = cryptoFramework.createCipher('SM4_128|GCM|PKCS7');
  cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, gcmParams);
  let updateLength = 20; // 假设以20字节为单位进行分段update，实际并无要求
  let cipherText = new Uint8Array();
  for (let i = 0; i < plainText.data.length; i += updateLength) {
    let updateMessage = plainText.data.subarray(i, i + updateLength);
    let updateMessageBlob: cryptoFramework.DataBlob = { data: updateMessage };
    // 分段update
    let updateOutput = cipher.updateSync(updateMessageBlob);
    // 把update的结果拼接起来，得到密文（有些情况下还需拼接doFinal的结果，这取决于分组模式
    // 和填充模式，本例中GCM模式的doFinal结果只包含authTag而不含密文，所以不需要拼接）
    let mergeText = new Uint8Array(cipherText.length + updateOutput.data.length);
    mergeText.set(cipherText);
    mergeText.set(updateOutput.data, cipherText.length);
    cipherText = mergeText;
  }
  gcmParams.authTag = cipher.doFinalSync(null);
  let cipherBlob: cryptoFramework.DataBlob = { data: cipherText };
  return cipherBlob;
}

// 分段解密消息
function decryptMessage(symKey: cryptoFramework.SymKey, cipherText: cryptoFramework.DataBlob) {
  let decoder = cryptoFramework.createCipher('SM4_128|GCM|PKCS7');
  decoder.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, gcmParams);
  let updateLength = 20; // 假设以20字节为单位进行分段update，实际并无要求
  let decryptText = new Uint8Array();
  for (let i = 0; i < cipherText.data.length; i += updateLength) {
    let updateMessage = cipherText.data.subarray(i, i + updateLength);
    let updateMessageBlob: cryptoFramework.DataBlob = { data: updateMessage };
    // 分段update
    let updateOutput = decoder.updateSync(updateMessageBlob);
    // 把update的结果拼接起来，得到明文
    let mergeText = new Uint8Array(decryptText.length + updateOutput.data.length);
    mergeText.set(decryptText);
    mergeText.set(updateOutput.data, decryptText.length);
    decryptText = mergeText;
  }
  let decryptData = decoder.doFinalSync(null);
  if (decryptData == null) {
    console.info('GCM decrypt success, decryptData is null');
  }
  let decryptBlob: cryptoFramework.DataBlob = { data: decryptText };
  return decryptBlob;
}

function genSymKeyByData(symKeyData: Uint8Array) {
  let symKeyBlob: cryptoFramework.DataBlob = { data: symKeyData };
  let sm4Generator = cryptoFramework.createSymKeyGenerator('SM4_128');
  let symKey = sm4Generator.convertKeySync(symKeyBlob);
  console.info('convertKeySync success');
  return symKey;
}

function main() {
  let keyData = new Uint8Array([83, 217, 231, 76, 28, 113, 23, 219, 250, 71, 209, 210, 205, 97, 32, 159]);
  let symKey = genSymKeyByData(keyData);
  let message = 'aaaaa.....bbbbb.....ccccc.....ddddd.....eee'; // 假设信息总共43字节，根据utf-8解码后，也是43字节
  let plainText: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from(message, 'utf-8').buffer) };
  let encryptText = encryptMessageUpdateBySegment(symKey, plainText);
  let decryptText = decryptMessage(symKey, encryptText);
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
      Button($r('app.string.call_sm4_gcm_segmentation_synchronous'))
        .width('70%')
        .onClick(() => {
          try {
            main();
            this.message = 'SM4_GCMSegmentationSuccess';
          } catch {
            this.message = 'SM4_GCMSegmentationFail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}