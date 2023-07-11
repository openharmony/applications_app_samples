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
  .height(100)
  .borderRadius(24)
  .backgroundColor(Color.White)
  .margin({ left: 12, right: 12 })
}

@Extend(Text) function textStyle(marginValue: number) {
  .height(80)
  .fontSize(18)
  .layoutWeight(1)
  .textAlign(TextAlign.Center)
  .margin({ left: marginValue, right: marginValue })
}

@Entry
@Component
struct Border {
  build() {
    Column() {
      TitleBar({ title: $r('app.string.prop_border') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.border_type') })
          Row() {
            Text($r('app.string.border_type_dashed'))
              .textStyle(20)
              .borderWidth(1)
              .borderStyle(BorderStyle.Dashed)
            Text($r('app.string.border_type_dotted'))
              .textStyle(20)
              .borderWidth(1)
              .borderStyle(BorderStyle.Dotted)
            Text($r('app.string.border_type_solid'))
              .textStyle(20)
              .borderWidth(1)
              .borderStyle(BorderStyle.Solid)
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.border_border_style') })
          Row() {
            Text($r('app.string.border_border_width'))
              .textStyle(20)
              .borderWidth(10)
            Text($r('app.string.border_border_color'))
              .textStyle(20)
              .borderWidth(1)
              .borderColor($r('app.color.background_blue'))
            Text($r('app.string.border_border_radius'))
              .textStyle(20)
              .borderWidth(1)
              .borderRadius(20)
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.border_edge_style') })
          Row() {
            Text($r('app.string.border_style_top'))
              .textStyle(12)
              .border({
                width: { top: 2 },
                color: { top: $r('app.color.background_blue') },
                style: { top: BorderStyle.Solid }
              })
            Text($r('app.string.border_style_left'))
              .textStyle(12)
              .border({ width: { left: 2 }, style: { left: BorderStyle.Dashed } })
            Text($r('app.string.border_style_bottom'))
              .textStyle(12)
              .border({ width: { bottom: 10 } })
            Text($r('app.string.border_style_right'))
              .textStyle(12)
              .border({ width: { right: 2 }, radius: 20 })
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.border_radius') })
          Row() {
            Text($r('app.string.border_radius_left_top'))
              .textStyle(4)
              .border({ width: 2, radius: { topLeft: 20 } })
            Text($r('app.string.border_radius_left_bottom'))
              .textStyle(4)
              .border({ width: 2, radius: { bottomLeft: 20 } })
            Text($r('app.string.border_radius_right_top'))
              .textStyle(4)
              .border({ width: 2, radius: { topRight: 20 } })
            Text($r('app.string.border_radius_right_bottom'))
              .textStyle(4)
              .border({ width: 2, radius: { bottomRight: 20 } })
          }
          .rowStyle()
        }
        .constraintSize({ minHeight: '100%' })
      }
    }
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}