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

import router from '@ohos.router';

@Entry
@Component
struct BitmapExample {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private img: ImageBitmap = new ImageBitmap("/common/images/test1.jpg")

  build() {
    Column() {
      Canvas(this.context)
        .width('100%')
        .height(500)
        .backgroundColor(Color.Pink)
        .onReady(() => {
          this.context.imageSmoothingEnabled = false
          this.context.drawImage(this.img, 60, 50, 200, 200)
        })
        .padding({ left: 12, right: 12 })
      Button('back')
        .width(130)
        .height(45)
        .key('back')
        .backgroundColor(Color.Orange)
        .onClick(() => {
          router.back()
        })
        .margin({ top: 10 })
    }.width('100%').height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}