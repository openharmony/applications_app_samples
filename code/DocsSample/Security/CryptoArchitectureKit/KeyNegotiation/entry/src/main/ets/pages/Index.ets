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
  @State message: string = 'KeyNegotiation';

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
      Button($r('app.string.ecdh_async'))
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/ECDH/EDCHAsync')
        })
      Button($r('app.string.ecdh_sync'))
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/ECDH/EDCHSync')
        })
      Button($r('app.string.x25519_async'))
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/X25519/X25519Async')
        })
      Button($r('app.string.x25519_sync'))
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/X25519/X25519Sync')
        })
      Button($r('app.string.dh_async'))
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/DH/DHAsync')
        })
      Button($r('app.string.dh_sync'))
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/DH/DHSync')
        })
    }
    .height('100%')
    .width('100%')
  }
}