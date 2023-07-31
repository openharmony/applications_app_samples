/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { IntroductionTitle } from '../../../../common/IntroductionTitle'
import { TitleBar } from '../../../../common/TitleBar'

@Extend(Row) function rowStyle() {
  .padding(8)
  .height(120)
  .borderRadius(24)
  .backgroundColor(Color.White)
  .margin({ bottom: 12 })
}

@Extend(Text) function textStyle(marginValue: number) {
  .height(80)
  .fontSize(18)
  .layoutWeight(1)
  .fontColor(Color.White)
  .textAlign(TextAlign.Center)
  .margin({ left: marginValue, right: marginValue })
}

@Entry
@Component
struct foreground {

  build() {
    Column() {
      TitleBar({ title: $r('app.string.prop_foreground') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.foreground_color') })
          Row() {
            Text('Brand')
              .textStyle(20)
              .backgroundColor($r('app.color.scrollbar_background_color'))
              .foregroundColor($r('app.color.background_blue'))
            Text('Warning')
              .textStyle(20)
              .backgroundColor($r('app.color.scrollbar_background_color'))
              .foregroundColor($r('app.color.background_orange'))
            Text('Danger')
              .textStyle(20)
              .backgroundColor($r('app.color.scrollbar_background_color'))
              .foregroundColor($r('app.color.background_pink'))
          }
          .rowStyle()
        }
        .padding({ left: 12, right: 12 })
        .margin({ bottom: 80 })
        .constraintSize({ minHeight: '100%' })
      }
    }
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}