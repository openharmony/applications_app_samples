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

import { router } from '@kit.ArkUI';
import testNapi from 'libentry.so';

@Entry
@Component
struct Index {
  @State message: string = 'ECCCompressPublicKeyFormatConversion';

  goToSample(url: string): void {
    router.pushUrl({
      url: url,
    }, router.RouterMode.Single, (err) => {
      if (err) {
        console.error(`pushUrl failed, code is ${err.code}, message is ${err.message}`);
        return;
      }
      console.info('pushUrl success');
    })
  }

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.specifyUncompressedPublicKeyCpp'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestEccDataCovert();
          if (ret == 0) {
            this.message = 'doTestEccDataCovert Success';
          } else {
            this.message = 'doTestEccDataCovert Fail';
          }
        })
      Button($r('app.string.compressedPointDataCpp'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestEccPointUncompressedToCompressed();
          if (ret == 0) {
            this.message = 'doTestEccPointUncompressedToCompressed Success';
          } else {
            this.message = 'doTestEccPointUncompressedToCompressed Fail';
          }
        })
      Button($r('app.string.getKeyObjectCpp'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestEccPointCompressedToPoint();
          if (ret == 0) {
            this.message = 'doTestEccPointCompressedToPoint Success';
          } else {
            this.message = 'doTestEccPointCompressedToPoint Fail';
          }
        })
      Button($r('app.string.SpecifyUncompressedPublicKeyArkTS'))
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/SpecifyUncompressedPublicKey')
        })
      Button($r('app.string.CompressedPointData'))
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/CompressedPointData')
        })
      Button($r('app.string.GetKeyObject'))
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/GetKeyObject')
        })
    }
    .width('100%')
    .height('100%')
  }
}
