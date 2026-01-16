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
  @State message: string = 'MessageAuthenticationCodeCppTest';

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.call_cmac_single_time_cpp'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestCmacOnce();
          if (ret == 0) {
            this.message = 'CMAC SingleTime C++ Success';
          } else {
            this.message = 'CMAC SingleTime C++ Fail';
          }
        })
      Button($r('app.string.call_cmac_segmentation_cpp'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestCmacBySegments();
          if (ret == 0) {
            this.message = 'CMAC Segmentation C++ Success';
          } else {
            this.message = 'CMAC Segmentation C++ Fail';
          }
        })
      Button($r('app.string.call_hmac_single_time_cpp'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestHmacOnce();
          if (ret == 0) {
            this.message = 'HMAC SingleTime C++ Success';
          } else {
            this.message = 'HMAC SingleTime C++ Fail';
          }
        })
      Button($r('app.string.call_hmac_segmentation_cpp'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestHmacBySegments();
          if (ret == 0) {
            this.message = 'HMAC Segmentation C++ Success';
          } else {
            this.message = 'HMAC Segmentation C++ Fail';
          }
        })
    }
    .width('100%')
    .height('100%')
  }
}
