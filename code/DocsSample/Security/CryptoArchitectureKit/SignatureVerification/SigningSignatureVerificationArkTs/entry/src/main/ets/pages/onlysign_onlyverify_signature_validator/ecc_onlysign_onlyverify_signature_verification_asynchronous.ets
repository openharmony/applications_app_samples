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

// [Start ecc_onlysign_onlyverify_signature_verification_asynchronous]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';

async function signMessagePromise(priKey: cryptoFramework.PriKey, digestBlob: cryptoFramework.DataBlob) {
  let signAlg = 'ECC|SHA1|OnlySign';
  let signer = cryptoFramework.createSign(signAlg);
  await signer.init(priKey);
  let signData = await signer.sign(digestBlob);
  return signData;
}

async function verifyMessagePromise(digestBlob: cryptoFramework.DataBlob, signMessageBlob: cryptoFramework.DataBlob,
  pubKey: cryptoFramework.PubKey) {
  let verifyAlg = 'ECC|SHA1|OnlyVerify';
  let verifier = cryptoFramework.createVerify(verifyAlg);
  await verifier.init(pubKey);
  let res = await verifier.verify(digestBlob, signMessageBlob);
  console.info('verify result: ' + res);
  return res;
}

async function main() {
  let messageData: cryptoFramework.DataBlob =
    { data: new Uint8Array(buffer.from('This is ecc onlySign test', 'utf-8').buffer) };
  // 先使用 Md 计算 SHA256 摘要（32字节）
  let md = cryptoFramework.createMd('SHA1');
  await md.update(messageData);
  let digestBlob = await md.digest();
  let keyGenAlg = 'ECC224';
  let generator = cryptoFramework.createAsyKeyGenerator(keyGenAlg);
  let keyPair = await generator.generateKeyPair();
  let signData = await signMessagePromise(keyPair.priKey, digestBlob);
  let verifyResult = await verifyMessagePromise(digestBlob, signData, keyPair.pubKey);
  if (verifyResult === true) {
    console.info('verify result: success.');
  } else {
    console.error('verify result: failed.');
  }
}

// [End ecc_onlysign_onlyverify_signature_verification_asynchronous]

@Entry
@Component
struct Index {
  @State message: string = 'Ecc OnlySign OnlyVerify Signature Verification asynchronous';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(25).fontWeight(FontWeight.Bold)
      Button($r('app.string.ecc_onlysign_onlyverify_signature_verification_asynchronous'))
        .width('70%')
        .onClick(async () => {
          try {
            await main();
            this.message = 'SignatureVerifySuccess';
          } catch {
            this.message = 'SignatureVerifyFail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}