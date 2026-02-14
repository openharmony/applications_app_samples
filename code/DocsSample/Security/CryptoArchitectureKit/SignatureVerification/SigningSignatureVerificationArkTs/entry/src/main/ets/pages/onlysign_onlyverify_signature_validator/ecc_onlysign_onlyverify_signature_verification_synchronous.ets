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

// [Start ecc_onlysign_onlyverify_signature_verification_synchronous]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';

function signMessagePromise(priKey: cryptoFramework.PriKey, digestBlob: cryptoFramework.DataBlob) {
  let signAlg = 'ECC|SHA1|OnlySign';
  let signer = cryptoFramework.createSign(signAlg);
  signer.initSync(priKey);
  let signData = signer.signSync(digestBlob);
  return signData;
}

function verifyMessagePromise(digestBlob: cryptoFramework.DataBlob, signMessageBlob: cryptoFramework.DataBlob,
  pubKey: cryptoFramework.PubKey) {
  let verifyAlg = 'ECC|SHA1|OnlyVerify';
  let verifier = cryptoFramework.createVerify(verifyAlg);
  verifier.initSync(pubKey);
  let res = verifier.verifySync(digestBlob, signMessageBlob);
  console.info('verify result: ' + res);
  return res;
}

function main() {
  let messageData: cryptoFramework.DataBlob =
    { data: new Uint8Array(buffer.from('This is ecc onlySign test', 'utf-8').buffer) };
  let md = cryptoFramework.createMd('SHA1');
  md.updateSync(messageData);
  let digestBlob = md.digestSync();
  let keyGenAlg = 'ECC224';
  let generator = cryptoFramework.createAsyKeyGenerator(keyGenAlg);
  let keyPair = generator.generateKeyPairSync();
  let signData = signMessagePromise(keyPair.priKey, digestBlob);
  let verifyResult = verifyMessagePromise(digestBlob, signData, keyPair.pubKey);
  if (verifyResult === true) {
    console.info('verify result: success.');
  } else {
    console.error('verify result: failed.');
  }
}

// [End ecc_onlysign_onlyverify_signature_verification_synchronous]

@Entry
@Component
struct Index {
  @State message: string = 'Ecc OnlySign OnlyVerify Signature Verification Synchronous';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(25).fontWeight(FontWeight.Bold)
      Button($r('app.string.ecc_onlysign_onlyverify_signature_verification_synchronous'))
        .width('70%')
        .onClick(() => {
          try {
            main();
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