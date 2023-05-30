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
      Divider().width('85%').margin({ right: $r('app.float.request_bar_ic_margin') })
      Row() {
        Image($r('app.media.ic_public_gps'))
          .width($r('app.float.request_bar_ic_width'))
          .height($r('app.float.request_bar_ic_width'))
          .margin({ left: $r('app.float.request_bar_ic_left_margin') })
        Text($r('app.string.gps'))
          .fontSize($r('app.float.request_bar_font_size'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.request_bar_font'))
          .margin({ left: $r('app.float.request_bar_text_left_margin') })
        Blank()
        Image($r('app.media.ic_public_arrow_right'))
          .width($r('app.float.request_bar_ic_width'))
          .height($r('app.float.request_bar_ic_width'))
          .margin({ right: $r('app.float.request_bar_ic_margin') })
      }
      .width('90%')
      .height($r('app.float.request_bar_row_height'))
      .margin({ right: $r('app.float.request_bar_text_left_margin') })
      .onClick(() => {
        prompt.showDialog({ message: $r('app.string.user_tip') })
      })

      Divider().width('85%').margin({ right: $r('app.float.request_bar_ic_margin') })
      Row() {
        Image($r('app.media.ic_public_contacts'))
          .width($r('app.float.request_bar_ic_width'))
          .height($r('app.float.request_bar_ic_width'))
          .margin({ left: $r('app.float.request_bar_ic_left_margin') })
        Text($r('app.string.anyone'))
          .fontSize($r('app.float.request_bar_font_size'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.request_bar_font'))
          .margin({ left: $r('app.float.request_bar_text_left_margin') })
        Blank()
        Text($r('app.string.open'))
          .fontSize($r('app.float.request_bar_font_size'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.font_b2b2b2'))
        Image($r('app.media.ic_public_arrow_right'))
          .width($r('app.float.request_bar_ic_width'))
          .height($r('app.float.request_bar_ic_width'))
          .margin({ right: $r('app.float.request_bar_ic_margin') })
      }
      .width('90%')
      .height($r('app.float.request_bar_row_height'))
      .margin({ right: $r('app.float.request_bar_text_left_margin') })
      .onClick(() => {
        prompt.showDialog({ message: $r('app.string.user_tip') })
      })

      Divider().width('85%').margin({ right: $r('app.float.request_bar_ic_margin') })
    }
    .width('100%')
    .height('30%')
    .margin($r('app.float.request_bar_margin'))
  }
}