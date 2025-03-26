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

function convertECCAsyKeySync() {
  let pubKeyArray =
    new Uint8Array([48, 89, 48, 19, 6, 7, 42, 134, 72, 206, 61, 2, 1, 6, 8, 42, 134, 72, 206, 61, 3, 1, 7, 3, 66, 0, 4,
      83, 96, 142, 9, 86, 214, 126, 106, 247, 233, 92, 125, 4, 128, 138, 105, 246, 162, 215, 71, 81, 58, 202, 121, 26,
      105, 211, 55, 130, 45, 236, 143, 55, 16, 248, 75, 167, 160, 167, 106, 2, 152, 243, 44, 68, 66, 0, 167, 99, 92,
      235, 215, 159, 239, 28, 106, 124, 171, 34, 145, 124, 174, 57, 92]);
  let priKeyArray =
    new Uint8Array([48, 49, 2, 1, 1, 4, 32, 115, 56, 137, 35, 207, 0, 60, 191, 90, 61, 136, 105, 210, 16, 27, 4, 171,
      57, 10, 61, 123, 40, 189, 28, 34, 207, 236, 22, 45, 223, 10, 189, 160, 10, 6, 8, 42, 134, 72, 206, 61, 3, 1, 7]);
  let pubKeyBlob: cryptoFramework.DataBlob = { data: pubKeyArray };
  let priKeyBlob: cryptoFramework.DataBlob = { data: priKeyArray };
  let generator = cryptoFramework.createAsyKeyGenerator('ECC256');
  try {
    let keyPair = generator.convertKeySync(pubKeyBlob, priKeyBlob);
    if (keyPair != null) {
      console.info('convertKeySync success');
    }
  } catch (e) {
    console.error(`get key pair failed, ${e.code}, ${e.message}`);
  }
}

@Entry
@Component
struct Index {
  @State message: string = 'ECC Sync';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_ecc_sync'))
        .width('70%')
        .onClick(() => {
          try {
            convertECCAsyKeySync();
            this.message = 'ECC Sync Success';
          } catch {
            this.message = 'ECC Sync Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}