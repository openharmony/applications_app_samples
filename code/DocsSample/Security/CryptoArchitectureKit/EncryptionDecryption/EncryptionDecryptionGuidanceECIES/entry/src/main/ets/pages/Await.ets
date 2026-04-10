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

// [Start use_sample_await_test]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';

namespace ECIES {
  function generateGcmParamsSpec(ivData: Uint8Array): cryptoFramework.GcmParamsSpec {
    let ivBlob: cryptoFramework.DataBlob = {
      data: ivData,
    };
    let rand: cryptoFramework.Random = cryptoFramework.createRandom();
    let aadBlob: cryptoFramework.DataBlob = rand.generateRandomSync(8);
    let tagBlob: cryptoFramework.DataBlob = rand.generateRandomSync(16);
    // GCM的authTag在加密时从doFinal结果中获取，在解密时填入init函数的params参数中
    let gcmParams: cryptoFramework.GcmParamsSpec = {
      iv: ivBlob,
      aad: aadBlob,
      authTag: tagBlob,
      algName: 'GcmParamsSpec',
    };
    return gcmParams;
  }

  async function generateSecret(priKey: cryptoFramework.PriKey, pubKey: cryptoFramework.PubKey):
    Promise<cryptoFramework.DataBlob> {
    // EC密钥协商
    let agreement: cryptoFramework.KeyAgreement = cryptoFramework.createKeyAgreement('ECC256');
    let keyData: cryptoFramework.DataBlob = await agreement.generateSecret(priKey, pubKey);

    let infoData: Uint8Array = new Uint8Array(buffer.from('infostring', 'utf-8').buffer);
    let spec: cryptoFramework.X963KdfSpec = {
      algName: 'X963KDF',
      key: keyData.data,
      info: infoData,
      keySize: 32, // 前16字节作为AES128的IV，后16字节作为的密钥
    };

    // 使用X963KDF进行密钥派生
    let kdf = cryptoFramework.createKdf('X963KDF|SHA256');
    let secret = await kdf.generateSecret(spec);
    return secret;
  }

  async function generateSymKey(secret: cryptoFramework.DataBlob): Promise<cryptoFramework.SymKey> {
    let symKeyGenerator = cryptoFramework.createSymKeyGenerator('AES128');
    let keyData: cryptoFramework.DataBlob = {
      data: secret.data.slice(16),
    };
    let symKey: cryptoFramework.SymKey = await symKeyGenerator.convertKey(keyData);
    return symKey;
  }

  async function encrypt(symKey: cryptoFramework.SymKey, gcmParams: cryptoFramework.GcmParamsSpec,
    plainText: cryptoFramework.DataBlob): Promise<cryptoFramework.DataBlob> {
    // AES-GCM对称加密
    let cipher: cryptoFramework.Cipher = cryptoFramework.createCipher('AES128|GCM');
    await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, gcmParams);
    let cipherText: cryptoFramework.DataBlob = await cipher.update(plainText);
    gcmParams.authTag = await cipher.doFinal(null);
    return cipherText;
  }

  async function decrypt(symKey: cryptoFramework.SymKey, gcmParams: cryptoFramework.GcmParamsSpec,
    cipherText: cryptoFramework.DataBlob): Promise<cryptoFramework.DataBlob> {
    // AES-GCM对称解密
    let cipher: cryptoFramework.Cipher = cryptoFramework.createCipher('AES128|GCM');
    await cipher.init(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, gcmParams);
    let plainText: cryptoFramework.DataBlob = await cipher.doFinal(cipherText);
    return plainText;
  }

  export async function doEciesTest(): Promise<string> {
    try {
      // 生成A端和B端的EC密钥对
      let asyKeyGenerator = cryptoFramework.createAsyKeyGenerator('ECC256');
      let keyPairA: cryptoFramework.KeyPair = asyKeyGenerator.generateKeyPairSync();
      let keyPairB: cryptoFramework.KeyPair = asyKeyGenerator.generateKeyPairSync();

      // A端加密：A端的私钥 + B端的公钥
      let secretA: cryptoFramework.DataBlob = await generateSecret(keyPairA.priKey, keyPairB.pubKey);
      let symKeyA: cryptoFramework.SymKey = await generateSymKey(secretA);
      let ivData: Uint8Array = secretA.data.slice(0, 16);
      let gcmParams: cryptoFramework.GcmParamsSpec = generateGcmParamsSpec(ivData);

      let message: string = 'This is a test message!!!';
      let plainText: cryptoFramework.DataBlob = {
        data: new Uint8Array(buffer.from(message, 'utf-8').buffer),
      };
      let cipherData: cryptoFramework.DataBlob = await encrypt(symKeyA, gcmParams, plainText);

      // B端解密：B端的私钥 + A端的公钥
      let secretB: cryptoFramework.DataBlob = await generateSecret(keyPairB.priKey, keyPairA.pubKey);
      let symKeyB: cryptoFramework.SymKey = await generateSymKey(secretB);
      let plainData: cryptoFramework.DataBlob = await decrypt(symKeyB, gcmParams, cipherData);
      console.info('doEciesTest success, message: ' + buffer.from(plainData.data).toString('utf-8'));
      return 'Success';
    } catch (error) {
      console.error(`doEciesTest failed, error: + ${JSON.stringify(error)}`);
      return 'Failed';
    }
  }
}

// [End use_sample_await_test]
@Entry
@Component
struct Index {
  @State message: string = 'Test Await';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_await'))
        .width('70%')
        .onClick(async () => {
          let result: string = await ECIES.doEciesTest();
          this.message = 'Call Await ' + result;
        })
    }
    .height('100%')
    .width('100%')
  }
}
