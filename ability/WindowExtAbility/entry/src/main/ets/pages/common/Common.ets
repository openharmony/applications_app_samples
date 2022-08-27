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

@Component
export struct TitleBar {
  build() {
    Row() {
      Image($r('app.media.back'))
        .width(28)
        .height(28)
        .margin({ right: 4 })
        .objectFit(ImageFit.Contain)

      Text($r('app.string.back'))
        .fontSize(24)
        .fontColor('#182431')

      Blank()
    }
    .width('100%')
    .padding({ left: 24 })
    .margin({ top: 24 })
    .onClick(() => {
      router.back()
    })
  }
}

@Component
export struct Title {
  private title: Resource = undefined

  build() {
    Row() {
      Text(this.title)
        .fontSize(24)
        .fontColor('#182431')
        .fontWeight(FontWeight.Medium)

      Blank()
        .width('90%')
    }
    .height(48)
    .margin({ left: 24, bottom: 8, top: 24 })
  }
}

@Component
export struct Taggle {
  private info: Resource = undefined

  build() {
    Row() {
      Text(this.info)
        .fontSize(16)
        .fontColor('#182431')
        .layoutWeight(1)

      Blank()

      Toggle({ type: ToggleType.Switch, isOn: false })
        .width(36)
        .height(20)
        .enabled(false)
        .selectedColor('#0D9FFB')
        .switchPointColor(0xe5ffffff)
    }
    .width('95%')
    .height(56)
    .borderRadius(24)
    .padding({ top: 4, bottom: 4, left: 24, right: 24 })
    .backgroundColor(Color.White)
  }
}

@Component
export struct Show {
  private info: Resource = undefined

  build() {
    Row() {
      Text(this.info)
        .fontSize(14)
        .fontColor('#182431')

      Blank()
        .width('90%')
    }
    .opacity(0.6)
    .height(48)
    .alignItems(VerticalAlign.Bottom)
    .margin({ bottom: 8 })
  }
}