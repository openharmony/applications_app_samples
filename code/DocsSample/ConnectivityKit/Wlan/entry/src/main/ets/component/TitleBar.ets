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

import router from '@ohos.router'

@Component
export struct TitleBar {
  build() {
    Row() {
      Text($r('app.string.EntryAbility_label'))
        .fontColor(Color.White)
        .fontSize(25)
        .layoutWeight(1)

      Button() {
        Image($r('app.media.about'))
          .size({ width: 60, height: '95%' })
          .objectFit(ImageFit.Contain)
      }
      .id('about')
      .type(ButtonType.Normal)
      .height('90%')
      .backgroundColor($r('app.color.button_color'))
    }
    .width('100%')
    .height('8%')
    .constraintSize({ minHeight: 50 })
    .padding({ left: 15 })
    .backgroundColor($r('app.color.button_color'))
  }
}