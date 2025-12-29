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
  @State message: string = 'EncryptionDecryptionGuidanceCpp';

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.call_sm2_encrypt_decrypt'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestSm2EncMessage();
          if (ret == 0) {
            this.message = 'SM2 Encrypt Decrypt Success';
          } else {
            this.message = 'SM2 Encrypt Decrypt Fail';
          }
        })
      Button($r('app.string.call_create_asn1_cipher_text'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestGenCipherTextBySpec();
          if (ret == 0) {
            this.message = 'SM2 Gen Cipher Text Success';
          } else {
            this.message = 'SM2 Gen Cipher Text Fail';
          }
        })
      Button($r('app.string.call_obtain_cipher_text'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestGetCipherTextSpec();
          if (ret == 0) {
            this.message = 'SM2 Get Cipher Text Success';
          } else {
            this.message = 'SM2 Get Cipher Text Fail';
          }
        })
      Button($r('app.string.call_pkcs1_rsa'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestRsaEncDec();
          if (ret == 0) {
            this.message = 'RSA Encrypt Decrypt Success';
          } else {
            this.message = 'RSA Encrypt Decrypt Fail';
          }
        })
      Button($r('app.string.call_rsa_encrypt'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestRsaEncLongMessage();
          if (ret == 0) {
            this.message = 'RSA Encrypt Long Message Success';
          } else {
            this.message = 'RSA Encrypt Long Message Fail';
          }
        })
    }
    .width('100%')
    .height('100%')
  }
}
