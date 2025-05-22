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

// [Start bin_convert_sm2_keypair]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';

function convertSM2AsyKey() {
  let pubKeyArray =
    new Uint8Array([48, 89, 48, 19, 6, 7, 42, 134, 72, 206, 61, 2, 1, 6, 8, 42, 129, 28, 207, 85, 1, 130, 45, 3, 66, 0,
      4, 90, 3, 58, 157, 190, 248, 76, 7, 132, 200, 151, 208, 112, 230, 96, 140, 90, 238, 211, 155, 128, 109, 248, 40,
      83, 214, 78, 42, 104, 106, 55, 148, 249, 35, 61, 32, 221, 135, 143, 100, 45, 97, 194, 176, 52, 73, 136, 174, 40,
      70, 70, 34, 103, 103, 161, 99, 27, 187, 13, 187, 109, 244, 13, 7]);
  let priKeyArray =
    new Uint8Array([48, 49, 2, 1, 1, 4, 32, 54, 41, 239, 240, 63, 188, 134, 113, 31, 102, 149, 203, 245, 89, 15, 15, 47,
      202, 170, 60, 38, 154, 28, 169, 189, 100, 251, 76, 112, 223, 156, 159, 160, 10, 6, 8, 42, 129, 28, 207, 85, 1,
      130, 45]);
  let pubKeyBlob: cryptoFramework.DataBlob = { data: pubKeyArray };
  let priKeyBlob: cryptoFramework.DataBlob = { data: priKeyArray };
  let generator = cryptoFramework.createAsyKeyGenerator('SM2_256');
  generator.convertKey(pubKeyBlob, priKeyBlob, (error, data) => {
    if (error) {
      console.error(`convertKey failed, ${error.code}, ${error.message}`);
      return;
    }
    console.info('convertKey success');
  });
}
// [End bin_convert_sm2_keypair]

@Entry
@Component
struct Index {
  @State message: string = 'SM2 Callback';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_sm2_callback'))
        .width('70%')
        .onClick(() => {
          try {
            convertSM2AsyKey();
            this.message = 'SM2 Callback Success';
          } catch {
            this.message = 'SM2 Callback Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}