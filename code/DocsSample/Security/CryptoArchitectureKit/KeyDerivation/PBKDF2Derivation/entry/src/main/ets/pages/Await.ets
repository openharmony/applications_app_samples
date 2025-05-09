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
// [Start use_pbkdf2_for_key_derivation_await]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';

async function kdfAwait() {
  let spec: cryptoFramework.PBKDF2Spec = {
    algName: 'PBKDF2',
    password: '123456',
    salt: new Uint8Array(16),
    iterations: 10000,
    keySize: 32
  };
  let kdf = cryptoFramework.createKdf('PBKDF2|SHA256');
  let secret = await kdf.generateSecret(spec);
  console.info('key derivation output is ' + secret.data);
}

// [End use_pbkdf2_for_key_derivation_await]

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
            await kdfAwait();
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