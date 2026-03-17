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
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  @State message: string = 'onlysign_onlyverify_signature_validator';

  goToSample(url: string): void {
    this.getUIContext().getRouter().pushUrl({
      url: url,
    }).then(() => {
      console.info('pushUrl success');
    }).catch((err: BusinessError) => {
      console.error(`pushUrl failed, code is ${err.code}, message is ${err.message}`);
    });
  }

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
      Button('rsa_pkcs1_onlysign_onlyverify_signature_validator_asynchronous')
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/onlysign_onlyverify_signature_validator/rsa_pkcs1_onlysign_onlyverify_signature_validator_asynchronous');
        })
      Button('rsa_pkcs1_onlysign_onlyverify_signature_validator_synchronous')
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/onlysign_onlyverify_signature_validator/rsa_pkcs1_onlysign_onlyverify_signature_validator_synchronous');
        })
      Button('rsa_pss_onlysign_onlyverify_signature_verification_asynchronous')
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/onlysign_onlyverify_signature_validator/rsa_pss_onlysign_onlyverify_signature_verification_asynchronous');
        })
      Button('rsa_pss_onlysign_onlyverify_signature_verification_synchronous')
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/onlysign_onlyverify_signature_validator/rsa_pss_onlysign_onlyverify_signature_verification_synchronous');
        })
      Button('ecc_onlysign_onlyverify_signature_verification_asynchronous')
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/onlysign_onlyverify_signature_validator/ecc_onlysign_onlyverify_signature_verification_asynchronous');
        })
      Button('ecc_onlysign_onlyverify_signature_verification_synchronous')
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/onlysign_onlyverify_signature_validator/ecc_onlysign_onlyverify_signature_verification_synchronous');
        })
    }
    .height('100%')
    .width('100%')
  }
}