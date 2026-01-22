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
// [Start sm2_sign_data_rs_to_der]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { BusinessError } from '@kit.BasicServicesKit';

function testSm2SignDataRsToDer() {
  try {
    let spec: cryptoFramework.EccSignatureSpec = {
      r: BigInt('97726608965854271693043443511967021777934035174185659091642456228829830775155'),
      s: BigInt('23084224202834231287427338597254751764391338275617140205467537273296855150376'),
    };

    let data = cryptoFramework.SignatureUtils.genEccSignature(spec);
    console.info('genEccSignature result: success.');
    console.info('data = ' + data);
  } catch (err) {
    let e: BusinessError = err as BusinessError;
    console.error(`ecc failed: errCode: ${e.code}, message: ${e.message}`);
  }
}
// [End sm2_sign_data_rs_to_der]
@Entry
@Component
struct Index {
  @State message: string = 'SM2 Sign Data RS to DER';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(25).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_sm2_sign_data_rs_to_der'))
        .width('70%')
        .onClick(async() => {
          try {
            await testSm2SignDataRsToDer();
            this.message = 'SM2SignDataRsToDERSuccess';
          } catch {
            this.message = 'SM2SignDataRsToDERFail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}