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


// [Start use_dh_for_key_negotiation_sync]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';

function dhAwait() {
  let keyGen = cryptoFramework.createAsyKeyGenerator('DH_modp1536');
  // 随机生成公私钥对A
  let keyPairA = keyGen.generateKeyPairSync();
  // 随机生成规格一致的公私钥对B
  let keyPairB = keyGen.generateKeyPairSync();
  let keyAgreement = cryptoFramework.createKeyAgreement('DH_modp1536');
  // 使用A的公钥和B的私钥进行密钥协商
  let secret1 = keyAgreement.generateSecretSync(keyPairB.priKey, keyPairA.pubKey);
  // 使用A的私钥和B的公钥进行密钥协商
  let secret2 = keyAgreement.generateSecretSync(keyPairA.priKey, keyPairB.pubKey);
  // 两种协商的结果应当一致
  if (secret1.data.toString() === secret2.data.toString()) {
    console.info('DH success');
    console.info('DH output is ' + secret1.data);
  } else {
    console.error('DH result is not equal');
  }
}
// [End use_dh_for_key_negotiation_sync]
@Entry
@Component
struct Index {
  @State message: string = 'DH Sync';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_dh_sync'))
        .width('70%')
        .onClick(() => {
          try {
            dhAwait();
            this.message = 'DH Sync Success';
          } catch {
            this.message = 'DH Async Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}