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
// [Start sm2_sign_data_der_to_rs]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { BusinessError } from '@kit.BasicServicesKit';

function testSm2SignDataDerToRs() {
  try {
    let data =
      new Uint8Array([48, 69, 2, 33, 0, 216, 15, 76, 238, 158, 165, 108, 76, 72, 63, 115, 52, 255, 51, 149, 54, 224,
        179, 49, 225, 70, 36, 117, 88, 154, 154, 27, 194, 161, 3, 1, 115, 2, 32, 51, 9, 53, 55, 248, 82, 7, 159, 179,
        144, 57, 151, 195, 17, 31, 106, 123, 32, 139, 219, 6, 253, 62, 240, 181, 134, 214, 107, 27, 230, 175, 40]);
    let spec: cryptoFramework.EccSignatureSpec = cryptoFramework.SignatureUtils.genEccSignatureSpec(data);
    console.info('genEccSignatureSpec success');
  } catch (err) {
    let e: BusinessError = err as BusinessError;
    console.error(`ecc error, ${e.code}, ${e.message}`);
  }
}
// [End sm2_sign_data_der_to_rs]
@Entry
@Component
struct Index {
  @State message: string = 'SM2 Sign Data DER to RS';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(25).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_sm2_sign_data_der_to_rs'))
        .width('70%')
        .onClick(async() => {
          try {
            await testSm2SignDataDerToRs();
            this.message = 'SM2SignDataDerToRSSuccess';
          } catch {
            this.message = 'SM2SignDataDerToRSFail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}