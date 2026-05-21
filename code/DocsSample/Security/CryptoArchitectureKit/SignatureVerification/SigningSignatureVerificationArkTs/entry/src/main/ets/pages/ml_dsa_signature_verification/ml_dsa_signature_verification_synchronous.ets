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

// [Start signature_verification_with_ml_dsa_key_pair_ark_sync]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';

let input: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from('This is Sign test plan', 'utf-8').buffer) };
let context: Uint8Array = new Uint8Array(buffer.from('test', 'utf-8').buffer);

function signMessageSync(priKey: cryptoFramework.PriKey) {
  let signer = cryptoFramework.createSign('ML-DSA');
  signer.setSignSpec(cryptoFramework.SignSpecItem.ML_DSA_DETERMINISTIC_BOOL, true);
  signer.setSignSpec(cryptoFramework.SignSpecItem.ML_DSA_CONTEXT_UINT8ARR, context);
  signer.initSync(priKey);
  let signData = signer.signSync(input);
  return signData;
}

function verifyMessageSync(signMessageBlob: cryptoFramework.DataBlob, pubKey: cryptoFramework.PubKey) {
  let verifier = cryptoFramework.createVerify('ML-DSA');
  verifier.setVerifySpec(cryptoFramework.SignSpecItem.ML_DSA_CONTEXT_UINT8ARR, context);
  verifier.initSync(pubKey);
  let res = verifier.verifySync(input, signMessageBlob);
  console.info('verify result: ' + res);
  return res;
}

function main() {
  try {
    let generator = cryptoFramework.createAsyKeyGenerator('ML-DSA-87');
    let keyPair = generator.generateKeyPairSync();
    let signData = signMessageSync(keyPair.priKey);
    let verifyResult = verifyMessageSync(signData, keyPair.pubKey);
    if (verifyResult === true) {
      console.info('verify result: success.');
      return 'Success';
    } else {
      console.error('verify result: failed.');
      return 'Fail';
    }
  } catch (error) {
    console.error(`verify failed, error: ${JSON.stringify(error)}`);
    return 'Fail';
  }
}

// [End signature_verification_with_ml_dsa_key_pair_ark_sync]
@Entry
@Component
struct Index {
  @State message: string = 'Signing Signature Verification';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(25).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_ml_dsasignature_synchronous'))
        .width('70%')
        .onClick(() => {
          let result: string = main();
          this.message = 'ML-DSASignature' + result;
        })
    }
    .height('100%')
    .width('100%')
  }
}