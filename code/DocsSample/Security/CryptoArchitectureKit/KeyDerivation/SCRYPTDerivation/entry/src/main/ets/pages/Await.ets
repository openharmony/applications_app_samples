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

// [Start use_scrypt_for_key_derivation_await]

import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { buffer } from '@kit.ArkTS';

async function scryptAwait() {
  try {
    let spec: cryptoFramework.ScryptSpec = {
      algName: 'SCRYPT',
      salt: new Uint8Array(16),
      passphrase: 'password',
      n:1024,
      p:16,
      r:8,
      maxMemory:1024 * 16 * 8 * 10, //n * p * r * 10
      keySize: 64
    };
    let kdf = cryptoFramework.createKdf('SCRYPT');
    let secret = await kdf.generateSecret(spec);
    console.info('key derivation output is ' + secret.data);
  } catch(error) {
    let e: BusinessError = error as BusinessError;
    console.error('key derivation failed, errCode: ' + e.code + ', errMsg: ' + e.message);
  }
}
// [End use_scrypt_for_key_derivation_await]
@Entry
@Component
struct Index {
  @State message: string = 'Await';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_await'))
        .width('70%')
        .onClick(async () => {
          try {
            await scryptAwait();
            this.message = 'Await Success';
          } catch {
            this.message = 'Await Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}