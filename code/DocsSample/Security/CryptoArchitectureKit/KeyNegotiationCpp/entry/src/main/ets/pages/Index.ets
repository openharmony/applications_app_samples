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

import testNapi from 'libentry.so';

@Entry
@Component
struct Index {
  @State message: string = 'KeyNegotiationCpp';

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.call_dh_key_agreement'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestDHKeyAgreement();
          if (ret == 0) {
            this.message = 'DH Key Agreement Success';
          } else {
            this.message = 'DH Key Agreement Fail';
          }
        })
      Button($r('app.string.call_ecdh_key_agreement'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestEcdhKeyAgreement();
          if (ret == 0) {
            this.message = 'ECDH Key Agreement Success';
          } else {
            this.message = 'ECDH Key Agreement Fail';
          }
        })
      Button($r('app.string.call_x25519_key_agreement'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestX25519KeyAgreement();
          if (ret == 0) {
            this.message = 'X25519 Key Agreement Success';
          } else {
            this.message = 'X25519 Key Agreement Fail';
          }
        })
    }
    .width('100%')
    .height('100%')
  }
}
