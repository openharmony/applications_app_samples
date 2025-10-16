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

import { bundleManager } from '@kit.AbilityKit';

@Component
export struct TestTsInterface {
  @State tokenId: number = -1
  @State data: string = ''

  queryTokenId() {
    try {
      let flags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION |
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_EXTENSION_ABILITY;
      bundleManager.getBundleInfoForSelf(flags).then(data => {
        this.tokenId = data.appInfo.accessTokenId;
      })

    } catch (err) {
      console.info('getBundleInfoForSelf failed')
    }
  }

  build() {
    Row() {
      Column() {
        Button('获取当前应用TokenId')
          .onClick(() => {
            this.queryTokenId()
          })
        Text(`${this.tokenId}`)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}