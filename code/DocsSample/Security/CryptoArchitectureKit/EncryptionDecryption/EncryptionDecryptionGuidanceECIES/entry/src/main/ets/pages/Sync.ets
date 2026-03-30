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

// [Start use_sample_sync_test]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';

namespace ECIES {
  export function genGcmParamsSpec() {
    let ivBlob: cryptoFramework.DataBlob = {
      data: new Uint8Array([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B]), // 12 bytes
    }
    let aadBlob: cryptoFramework.DataBlob = {
      data: new Uint8Array([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]),
    }
    let tagBlob: cryptoFramework.DataBlob = {
      data: new Uint8Array([
        0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F
      ]), // 16 bytes
    }
    // GCM的authTag在加密时从doFinal结果中获取，在解密时填入init函数的params参数中
    let gcmParams: cryptoFramework.GcmParamsSpec = {
      iv: ivBlob,
      aad: aadBlob,
      authTag: tagBlob,
      algName: 'GcmParamsSpec',
    }
    return gcmParams;
  }

  export function genSymKey() {
    // 生成EC密钥
    let asyKeyGenerator = cryptoFramework.createAsyKeyGenerator('ECC256');
    let keyPair: cryptoFramework.KeyPair = asyKeyGenerator.generateKeyPairSync();
    // EC密钥协商
    let agreement: cryptoFramework.KeyAgreement = cryptoFramework.createKeyAgreement('ECC256');
    let keyData: cryptoFramework.DataBlob = agreement.generateSecretSync(keyPair.priKey, keyPair.pubKey);

    let infoData: Uint8Array = new Uint8Array(buffer.from('infostring', 'utf-8').buffer);
    let spec: cryptoFramework.X963KdfSpec = {
      algName: 'X963KDF',
      key: keyData.data,
      info: infoData,
      keySize: 16
    }

    // 使用X963KDF进行密钥派生
    let kdf = cryptoFramework.createKdf('X963KDF|SHA256');
    let secret = kdf.generateSecretSync(spec);
    let symKeyGenerator = cryptoFramework.createSymKeyGenerator('AES128');
    let symKey: cryptoFramework.SymKey = symKeyGenerator.convertKeySync(secret);
    return symKey;
  }

  export function encrypt(symKey: cryptoFramework.SymKey, gcmParams: cryptoFramework.GcmParamsSpec,
    plainText: cryptoFramework.DataBlob) {
    // AES-GCM对称加密
    let cipher: cryptoFramework.Cipher = cryptoFramework.createCipher('AES128|GCM');
    cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, gcmParams);
    let cipherText: cryptoFramework.DataBlob = cipher.updateSync(plainText);
    gcmParams.authTag = cipher.doFinalSync(null);
    return cipherText;
  }

  export function decrypt(symKey: cryptoFramework.SymKey, gcmParams: cryptoFramework.GcmParamsSpec,
    cipherText: cryptoFramework.DataBlob) {
    // AES-GCM对称解密
    let cipher: cryptoFramework.Cipher = cryptoFramework.createCipher('AES128|GCM');
    cipher.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, gcmParams);
    let plainText: cryptoFramework.DataBlob = cipher.updateSync(cipherText);
    return plainText;
  }
}

function testEciesEncryptDecrypt() {
  let symKey: cryptoFramework.SymKey = ECIES.genSymKey();
  let gcmParams: cryptoFramework.GcmParamsSpec = ECIES.genGcmParamsSpec();
  let message: string = 'This is a test message!!!';
  let plainText: cryptoFramework.DataBlob = {
    data: new Uint8Array(buffer.from(message, 'utf-8').buffer),
  }
  let cipherData: cryptoFramework.DataBlob = ECIES.encrypt(symKey, gcmParams, plainText);
  let plainData: cryptoFramework.DataBlob = ECIES.decrypt(symKey, gcmParams, cipherData);
  console.info('message: ' + buffer.from(plainData.data).toString('utf-8'));
}

// [End use_sample_sync_test]
@Entry
@Component
struct Index {
  @State message: string = 'Test Sync';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_sync'))
        .width('70%')
        .onClick(() => {
          try {
            testEciesEncryptDecrypt();
            this.message = 'Call Sync Success';
          } catch {
            this.message = 'Call Sync Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}
