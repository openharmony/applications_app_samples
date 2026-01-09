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
  @State message: string = 'MessageDigestComputationCppTest';

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.single_time'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestSha256Md();
          if (ret == 0) {
            this.message = 'SHA256 SingleTime C++ Success';
          } else {
            this.message = 'SHA256 SingleTime C++ Fail';
          }
        })
      Button($r('app.string.segmentation'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doLoopSha256Md();
          if (ret == 0) {
            this.message = 'SHA256 Segmentation C++ Success';
          } else {
            this.message = 'SHA256 Segmentation C++ Fail';
          }
        })
      Button($r('app.string.sha3_single_time'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestSha3Md();
          if (ret == 0) {
            this.message = 'SHA3 SingleTime C++ Success';
          } else {
            this.message = 'SHA3 SingleTime C++ Fail';
          }
        })
      Button($r('app.string.sha3_segmentation'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doLoopSha3Md();
          if (ret == 0) {
            this.message = 'SHA3 Segmentation C++ Success';
          } else {
            this.message = 'SHA3 Segmentation C++ Fail';
          }
        })
      Button($r('app.string.md5_single_time'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestMd5Md();
          if (ret == 0) {
            this.message = 'MD5 SingleTime C++ Success';
          } else {
            this.message = 'MD5 SingleTime C++ Fail';
          }
        })
      Button($r('app.string.md5_segmentation'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doLoopMd5Md();
          if (ret == 0) {
            this.message = 'MD5 Segmentation C++ Success';
          } else {
            this.message = 'MD5 Segmentation C++ Fail';
          }
        })
    }
    .width('100%')
    .height('100%')
  }
}
