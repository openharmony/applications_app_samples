/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import prompt from '@ohos.promptAction'

@Component
export struct RequestBar {
  build() {
    Column() {
      Divider().width('85%').margin({ right: 30 })
      Row() {
        Image($r('app.media.ic_public_gps'))
          .width(24)
          .height(24)
          .margin({ left: 8 })
        Text($r('app.string.gps'))
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#191919')
          .margin({ left: 10 })
        Blank()
        Image($r('app.media.ic_public_arrow_right'))
          .width(24)
          .height(24)
          .margin({ right: 30 })
      }
      .width('90%')
      .height(80)
      .margin({ right: 10 })
      .onClick(() => {
        prompt.showDialog({ message: $r('app.string.user_tip') })
      })

      Divider().width('85%').margin({ right: 30 })
      Row() {
        Image($r('app.media.ic_public_contacts'))
          .width(24)
          .height(24)
          .margin({ left: 8 })
        Text($r('app.string.anyone'))
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#191919')
          .margin({ left: 10 })
        Blank()
        Text($r('app.string.open'))
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#B2B2B2')
        Image($r('app.media.ic_public_arrow_right'))
          .width(24)
          .height(24)
          .margin({ right: 30 })
      }
      .width('90%')
      .height(80)
      .margin({ right: 10 })
      .onClick(() => {
        prompt.showDialog({ message: $r('app.string.user_tip') })
      })

      Divider().width('85%').margin({ right: 30 })
    }
    .width('100%')
    .height('30%')
    .margin(20)
  }
}