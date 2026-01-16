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
// [Start prikey_encoding]

import { cryptoFramework } from '@kit.CryptoArchitectureKit';

function prikeyEncoding() {
  let rsaGenerator = cryptoFramework.createAsyKeyGenerator('RSA1024');
  let keyPair = rsaGenerator.generateKeyPairSync();
  let options : cryptoFramework.KeyEncodingConfig = {
      password: '123456',
      cipherName: 'AES-128-CBC'
  }
  let priPemKey = keyPair.priKey;
  let priString = priPemKey.getEncodedPem('PKCS1', options);
  console.info('[sync]TestPriKeyPkcs1Encoded priString output is ' + priString);
}
// [End prikey_encoding]

@Entry
@Component
struct Index {
  @State message: string = 'Prikey Encoding';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_prikey_encoding'))
        .width('70%')
        .onClick(async () => {
          try {
            await prikeyEncoding();
            this.message = 'Prikey Encoding Success';
          } catch {
            this.message = 'Prikey Encoding Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}