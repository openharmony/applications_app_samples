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

// [Start bin_convert_rsa_keypair]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';

function convertAsyKey() {
  let rsaGenerator = cryptoFramework.createAsyKeyGenerator('RSA1024');
  let pkVal =
    new Uint8Array([48, 129, 159, 48, 13, 6, 9, 42, 134, 72, 134, 247, 13, 1, 1, 1, 5, 0, 3, 129, 141, 0, 48, 129, 137,
      2, 129, 129, 0, 174, 203, 113, 83, 113, 3, 143, 213, 194, 79, 91, 9, 51, 142, 87, 45, 97, 65, 136, 24, 166, 35, 5,
      179, 42, 47, 212, 79, 111, 74, 134, 120, 73, 67, 21, 19, 235, 80, 46, 152, 209, 133, 232, 87, 192, 140, 18, 206,
      27, 106, 106, 169, 106, 46, 135, 111, 118, 32, 129, 27, 89, 255, 183, 116, 247, 38, 12, 7, 238, 77, 151, 167, 6,
      102, 153, 126, 66, 28, 253, 253, 216, 64, 20, 138, 117, 72, 15, 216, 178, 37, 208, 179, 63, 204, 39, 94, 244, 170,
      48, 190, 21, 11, 73, 169, 156, 104, 193, 3, 17, 100, 28, 60, 50, 92, 235, 218, 57, 73, 119, 19, 101, 164, 192,
      161, 197, 106, 105, 73, 2, 3, 1, 0, 1]);
  let pkBlob: cryptoFramework.DataBlob = { data: pkVal };
  rsaGenerator.convertKey(pkBlob, null, (err, keyPair) => {
    if (err) {
      console.error(`convertKey failed, ${err.code}, ${err.message}`);
      return;
    }
    console.info('convertKey success');
  });
}
// [End bin_convert_rsa_keypair]

@Entry
@Component
struct Index {
  @State message: string = 'RSA Callback';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_rsa_callback'))
        .width('70%')
        .onClick(() => {
          try {
            convertAsyKey();
            this.message = 'RSA Callback Success';
          } catch {
            this.message = 'RSA Callback Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}