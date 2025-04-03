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
  @State message: string = 'BinaryDataConvertAsymmetricKeyPair';

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.call_rsa'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestDataCovertAsymKey();
          this.message = 'Call RSA Success Result:' + ret.toString();
        })
      Button($r('app.string.call_ecc'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doAsymEccCovert();
          this.message = 'Call ECC Success Result:' + ret.toString();
        })
      Button($r('app.string.call_sm2'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doAsymSm2Covert();
          this.message = 'Call SM2 Success Result:' + ret.toString();
        })
    }
    .width('100%')
    .height('100%')
  }
}
