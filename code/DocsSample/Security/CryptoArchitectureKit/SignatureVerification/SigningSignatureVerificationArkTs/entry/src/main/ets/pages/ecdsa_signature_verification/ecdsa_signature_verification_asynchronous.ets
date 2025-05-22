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

// [Start signature_verification_with_ecdsa_key_pair_ark_async]

import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';

// 完整的明文被拆分为input1和input2
let input1: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from('This is Sign test plan1', 'utf-8').buffer) };
let input2: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from('This is Sign test plan2', 'utf-8').buffer) };

async function signMessagePromise(priKey: cryptoFramework.PriKey) {
  let signAlg = 'ECC256|SHA256';
  let signer = cryptoFramework.createSign(signAlg);
  await signer.init(priKey);
  await signer.update(input1); // 如果明文较短，可以直接调用sign接口一次性传入
  let signData = await signer.sign(input2);
  return signData;
}

async function verifyMessagePromise(signMessageBlob: cryptoFramework.DataBlob, pubKey: cryptoFramework.PubKey) {
  let verifyAlg = 'ECC256|SHA256';
  let verifier = cryptoFramework.createVerify(verifyAlg);
  await verifier.init(pubKey);
  await verifier.update(input1); // 如果明文较短，可以直接调用verify接口一次性传入
  let res = await verifier.verify(input2, signMessageBlob);
  console.info('verify result is ' + res);
  return res;
}

async function main() {
  let keyGenAlg = 'ECC256';
  let generator = cryptoFramework.createAsyKeyGenerator(keyGenAlg);
  let keyPair = await generator.generateKeyPair();
  let signData = await signMessagePromise(keyPair.priKey);
  let verifyResult = await verifyMessagePromise(signData, keyPair.pubKey);
  if (verifyResult === true) {
    console.info('verify success');
  } else {
    console.error('verify failed');
  }
}

// [End signature_verification_with_ecdsa_key_pair_ark_async]
@Entry
@Component
struct Index {
  @State message: string = 'Signing Signature Verification';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(25).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_ecdsasignature_asynchronous'))
        .width('70%')
        .onClick(async () => {
          try {
            await main();
            this.message = 'ECDSASignatureSuccess';
          } catch {
            this.message = 'ECDSASignatureFail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}