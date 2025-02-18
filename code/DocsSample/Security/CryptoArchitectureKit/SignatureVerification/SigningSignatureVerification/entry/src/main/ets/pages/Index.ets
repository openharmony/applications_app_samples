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
  @State message: string = 'Signing Signature Verification';

  build() {
    Column({ space: 5 }) {
      Text(this.message).fontSize(25).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_signature_seg'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.signatureSeg();
          this.message = 'SignatureSegSuccess Result:' + ret.toString();
        })
      Button($r('app.string.call_signature'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.signature();
          this.message = 'SignatureSuccess Result:' + ret.toString();
        })
      Button($r('app.string.call_signature_recover'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.signatureRecover();
          this.message = 'SignatureRecoverSuccess Result:' + ret.toString();
        })
      Button($r('app.string.call_psssignature_seg'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.pssSignatureSeg();
          this.message = 'PSSSignatureSegSuccess Result:' + ret.toString();
        })
      Button($r('app.string.call_ecdsasignature'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.ecdsaSignature();
          this.message = 'ECDSASignatureSuccess Result:' + ret.toString();
        })
      Button($r('app.string.call_sm2signature'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.sm2Signature();
          this.message = 'SM2SignatureSuccess Result:' + ret.toString();
        })
    }
    .height('100%')
    .width('100%')
  }
}
