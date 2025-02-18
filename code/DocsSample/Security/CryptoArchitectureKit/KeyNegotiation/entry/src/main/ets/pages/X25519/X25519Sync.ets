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

function x25519Await() {
  // 假设此公私钥对数据为外部传入
  let pubKeyArray =
    new Uint8Array([48, 42, 48, 5, 6, 3, 43, 101, 110, 3, 33, 0, 36, 98, 216, 106, 74, 99, 179, 203, 81, 145, 147, 101,
      139, 57, 74, 225, 119, 196, 207, 0, 50, 232, 93, 147, 188, 21, 225, 228, 54, 251, 230, 52]);
  let priKeyArray =
    new Uint8Array([48, 46, 2, 1, 0, 48, 5, 6, 3, 43, 101, 110, 4, 34, 4, 32, 112, 65, 156, 73, 65, 89, 183, 39, 119,
      229, 110, 12, 192, 237, 186, 153, 21, 122, 28, 176, 248, 108, 22, 242, 239, 179, 106, 175, 85, 65, 214, 90]);
  let keyGen = cryptoFramework.createAsyKeyGenerator('X25519');
  // 外部传入的公私钥对A
  let keyPairA = keyGen.convertKeySync({ data: pubKeyArray }, { data: priKeyArray });
  // 内部生成的公私钥对B
  let keyPairB = keyGen.generateKeyPairSync();
  let keyAgreement = cryptoFramework.createKeyAgreement('X25519');
  // 使用A的公钥和B的私钥进行密钥协商
  let secret1 = keyAgreement.generateSecretSync(keyPairB.priKey, keyPairA.pubKey);
  // 使用A的私钥和B的公钥进行密钥协商
  let secret2 = keyAgreement.generateSecretSync(keyPairA.priKey, keyPairB.pubKey);
  // 两种协商的结果应当一致
  if (secret1.data.toString() === secret2.data.toString()) {
    console.info('x25519 success');
    console.info('x25519 output is ' + secret1.data);
  } else {
    console.error('x25519 result is not equal');
  }
}

@Entry
@Component
struct Index {
  @State message: string = 'X25519 Sync';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_x25519_sync'))
        .width('70%')
        .onClick(() => {
          try {
            x25519Await();
            this.message = 'X25519 Sync Success';
          } catch {
            this.message = 'X25519 Sync Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}