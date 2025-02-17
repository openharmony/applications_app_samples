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

@Entry
@Component
struct Index {
  @State message: string = 'EncryptionDecryptionGuidanceRSA';

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
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.rsa_pkcs1_async'))
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/rsa_pkcs1/RSAPKCS1Async')
        })
      Button($r('app.string.rsa_pkcs1_sync'))
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/rsa_pkcs1/RSAPKCS1Sync')
        })
      Button($r('app.string.rsa_segmentation_async'))
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/rsa_segmentation/RSASegmentationAsync')
        })
      Button($r('app.string.rsa_segmentation_sync'))
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/rsa_segmentation/RSASegmentationSync')
        })
      Button($r('app.string.rsa_pkcs1_oaep_async'))
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/rsa_pkcs1_oaep/RSAPKCS1OAEPAsync')
        })
      Button($r('app.string.rsa_pkcs1_oaep_sync'))
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/rsa_pkcs1_oaep/RSAPKCS1OAEPSync')
        })
    }
    .height('100%')
    .width('100%')
  }
}