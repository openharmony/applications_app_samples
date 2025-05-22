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
// [Start use_the_sm2_key_pair_to_sign_and_verify_sync]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';

// 完整的明文被拆分为input1和input2
let input1: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from('This is Sign test plan1', 'utf-8').buffer) };
let input2: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from('This is Sign test plan2', 'utf-8').buffer) };

function signMessagePromise(priKey: cryptoFramework.PriKey) {
  let signAlg = 'SM2_256|SM3';
  let signer = cryptoFramework.createSign(signAlg);
  signer.initSync(priKey);
  signer.updateSync(input1); // 如果明文较短，可以直接调用sign接口一次性传入
  let signData = signer.signSync(input2);
  return signData;
}

function verifyMessagePromise(signMessageBlob: cryptoFramework.DataBlob, pubKey: cryptoFramework.PubKey) {
  let verifyAlg = 'SM2_256|SM3';
  let verifier = cryptoFramework.createVerify(verifyAlg);
  verifier.initSync(pubKey);
  verifier.updateSync(input1); // 如果明文较短，可以直接调用verify接口一次性传入
  let res = verifier.verifySync(input2, signMessageBlob);
  console.info('verify result is ' + res);
  return res;
}

function main() {
  let keyGenAlg = 'SM2_256';
  let generator = cryptoFramework.createAsyKeyGenerator(keyGenAlg);
  let keyPair = generator.generateKeyPairSync();
  let signData = signMessagePromise(keyPair.priKey);
  let verifyResult = verifyMessagePromise(signData, keyPair.pubKey);
  if (verifyResult === true) {
    console.info('verify success');
  } else {
    console.error('verify failed');
  }
}

// [End use_the_sm2_key_pair_to_sign_and_verify_sync]

@Entry
@Component
struct Index {
  @State message: string = 'Signing Signature Verification';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(25).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_sm2_signature_synchronous'))
        .width('70%')
        .onClick(() => {
          try {
            main();
            this.message = 'SM2SignatureSuccess';
          } catch {
            this.message = 'SM2SignatureFail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}