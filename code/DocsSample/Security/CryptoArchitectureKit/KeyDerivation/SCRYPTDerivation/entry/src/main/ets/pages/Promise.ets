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

// [Start use_scrypt_for_key_derivation_promise]

import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { buffer } from '@kit.ArkTS';

function scryptPromise() {
  let spec: cryptoFramework.ScryptSpec = {
    algName: 'SCRYPT',
    passphrase: '123456',
    salt: new Uint8Array(16),
    n:1024,
    p:16,
    r:8,
    maxMemory:1024 * 16 * 8 * 10, //n * p * r * 10
    keySize: 64
  };
  let kdf = cryptoFramework.createKdf('SCRYPT');
  let kdfPromise = kdf.generateSecret(spec);
  kdfPromise.then((secret) => {
    console.info('key derivation output: ' + secret.data);
  }).catch((error: BusinessError) => {
    console.error(`key derivation failed: errCode: ${error.code}, message: ${error.message}`);
  });
}

// [End use_scrypt_for_key_derivation_promise]
@Entry
@Component
struct Index {
  @State message: string = 'Promise';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_promise'))
        .width('70%')
        .onClick(() => {
          try {
            scryptPromise();
            this.message = 'Promise Success';
          } catch {
            this.message = 'Promise Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}