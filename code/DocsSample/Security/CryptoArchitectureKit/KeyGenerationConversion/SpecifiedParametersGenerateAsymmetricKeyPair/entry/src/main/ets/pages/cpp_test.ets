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
  @State message: string = 'SpecifiedParametersGenerateAsymmetricKeyPairCppTest';

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.call_rsa_gen_key_pair_by_spec_cpp'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestRsaGenKeyPairBySpec();
          if (ret == 0) {
            this.message = 'RSA Gen Key Pair By Spec C++ Success';
          } else {
            this.message = 'RSA Gen Key Pair By Spec C++ Fail';
          }
        })
      Button($r('app.string.call_ecc_gen_key_pair_by_spec_cpp'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestEccGenKeyPairBySpec();
          if (ret == 0) {
            this.message = 'ECC Gen Key Pair By Spec C++ Success';
          } else {
            this.message = 'ECC Gen Key Pair By Spec C++ Fail';
          }
        })
      Button($r('app.string.call_sm2_gen_key_pair_by_spec_cpp'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestSm2GenKeyPairBySpec();
          if (ret == 0) {
            this.message = 'SM2 Gen Key Pair By Spec C++ Success';
          } else {
            this.message = 'SM2 Gen Key Pair By Spec C++ Fail';
          }
        })
    }
    .width('100%')
    .height('100%')
  }
}
