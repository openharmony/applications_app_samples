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

import testNapi from 'libentry.so';

@Entry
@Component
struct Index {
  @State message: string = 'EncryptionDecryptionGuidanceAes';

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.call_aes_gcm'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.testAesGcm();
          this.message = 'AES_GCMSuccess Result:' + ret.toString();
        })
      Button($r('app.string.call_aes_ccm'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.testAesCcm();
          this.message = 'AES_CCMSuccess Result:' + ret.toString();
        })
      Button($r('app.string.call_aes_cbc'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.testAesCbc();
          this.message = 'AES_CBCSuccess Result:' + ret.toString();
        })
      Button($r('app.string.call_aes_ecb'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.testAesEcb();
          this.message = 'AES_ECBSuccess Result:' + ret.toString();
        })
      Button($r('app.string.call_aes_gcm_segment'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.testAesEcb();
          this.message = 'AES_GCM_SegmentSuccess Result:' + ret.toString();
        })
    }
    .width('100%')
    .height('100%')
  }
}
