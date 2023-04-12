/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import router from '@ohos.router'
import { Logger, FileManager } from '@ohos/feature-file-manager'

@Entry
@Component
struct ImagePreview {
  @State imagePixelMap: PixelMap = undefined
  fileName: string = router.getParams()['imageFileName']

  async aboutToAppear() {
    this.fileName = router.getParams()['imageFileName']
    Logger.debug('fileName: ' + this.fileName)
    let file = await FileManager.getFileAssetsByName(getContext(this), this.fileName)
    this.imagePixelMap = await FileManager.getPixelMapByFileAsset(file)
    Logger.debug('pixel size: ' + this.imagePixelMap.getPixelBytesNumber())
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.back'))
          .width(36)
          .height(36)
          .objectFit(ImageFit.Fill)
          .alignSelf(ItemAlign.Start)

        Text(this.fileName)
          .fontSize(24)
          .margin({ left: 10 })
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.black'))
      }
      .width('100%')
      .margin({ top: 10 })
      .onClick(() => {
        router.back()
      })

      Image(this.imagePixelMap)
        .objectFit(ImageFit.Fill)
        .alignSelf(ItemAlign.Start)
        .scale({ x: 0.9, y: 0.9 })
    }
    .height('100%')
    .backgroundColor($r('app.color.white'))
    .padding(20)
  }
}