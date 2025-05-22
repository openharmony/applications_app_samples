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
/// [Start use_ecdh_for_key_negotiation_async]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';

async function ecdhAwait() {
  // 假设此公私钥对数据为外部传入
  let pubKeyArray =
    new Uint8Array([48, 89, 48, 19, 6, 7, 42, 134, 72, 206, 61, 2, 1, 6, 8, 42, 134, 72, 206, 61, 3, 1, 7, 3, 66, 0, 4,
      83, 96, 142, 9, 86, 214, 126, 106, 247, 233, 92, 125, 4, 128, 138, 105, 246, 162, 215, 71, 81, 58, 202, 121, 26,
      105, 211, 55, 130, 45, 236, 143, 55, 16, 248, 75, 167, 160, 167, 106, 2, 152, 243, 44, 68, 66, 0, 167, 99, 92,
      235, 215, 159, 239, 28, 106, 124, 171, 34, 145, 124, 174, 57, 92]);
  let priKeyArray =
    new Uint8Array([48, 49, 2, 1, 1, 4, 32, 115, 56, 137, 35, 207, 0, 60, 191, 90, 61, 136, 105, 210, 16, 27, 4, 171,
      57, 10, 61, 123, 40, 189, 28, 34, 207, 236, 22, 45, 223, 10, 189, 160, 10, 6, 8, 42, 134, 72, 206, 61, 3, 1, 7]);
  let eccGen = cryptoFramework.createAsyKeyGenerator('ECC256');
  // 外部传入的公私钥对A
  let keyPairA = await eccGen.convertKey({ data: pubKeyArray }, { data: priKeyArray });
  // 内部生成的公私钥对B
  let keyPairB = await eccGen.generateKeyPair();
  let eccKeyAgreement = cryptoFramework.createKeyAgreement('ECC256');
  // 使用A的公钥和B的私钥进行密钥协商
  let secret1 = await eccKeyAgreement.generateSecret(keyPairB.priKey, keyPairA.pubKey);
  // 使用A的私钥和B的公钥进行密钥协商
  let secret2 = await eccKeyAgreement.generateSecret(keyPairA.priKey, keyPairB.pubKey);
  // 两种协商的结果应当一致
  if (secret1.data.toString() === secret2.data.toString()) {
    console.info('ecdh success');
    console.info('ecdh output is ' + secret1.data);
  } else {
    console.error('ecdh result is not equal');
  }
}

// [End use_ecdh_for_key_negotiation_async]
@Entry
@Component
struct Index {
  @State message: string = 'EDCH Async';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_edch_async'))
        .width('70%')
        .onClick(async () => {
          try {
            await ecdhAwait();
            this.message = 'EDCH Async Success';
          } catch {
            this.message = 'EDCH Async Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}