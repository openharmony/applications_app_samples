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

import { ChangePanel } from './ChangePanel'
import { IntroductionTitle } from '../../../../common/IntroductionTitle'
import { TitleBar } from '../../../../common/TitleBar'

@Extend(Row) function rowStyle() {
  .width('100%')
  .padding(16)
  .borderRadius(24)
  .backgroundColor(Color.White)
}

@Extend(Column) function columnStyle() {
  .width('100%')
  .padding(16)
  .borderRadius(24)
  .backgroundColor(Color.White)
}

@Entry
@Component
struct DividerSample {
  @State strokeWidth: number = 8
  @State lineColor: Resource = $r('app.color.background_blue')
  @State lineCapStyle: LineCapStyle = LineCapStyle.Butt

  build() {
    Column() {
      TitleBar({ title: $r('app.string.divider_title') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.divider_horizontal') })
          // Horizontal divider
          Column() {
            this.Block()
            Divider()
            this.Block()
          }
          .height(150)
          .columnStyle()

          IntroductionTitle({ introduction: $r('app.string.divider_vertical') })
          // Vertical divider
          Row() {
            Text($r('app.string.radio_beijing'))
            Divider()
              .vertical(true) // If true, divider is vertical
              .height(26)
            Text($r('app.string.radio_shanghai'))
            Divider()
              .vertical(true)
              .height(26)
            Text($r('app.string.radio_guangzhou'))
          }
          .height(60)
          .rowStyle()
          .justifyContent(FlexAlign.SpaceEvenly)

          IntroductionTitle({ introduction: $r('app.string.divider_attribute') })
          Column() {
            this.Block()
            Divider()
              .color(this.lineColor) // Divider color
              .strokeWidth(this.strokeWidth) // Divider stroke width
              .lineCap(this.lineCapStyle) // Divider line cap style
            this.Block()

            ChangePanel({
              strokeWidth: $strokeWidth,
              lineCapStyle: $lineCapStyle,
              lineColor: $lineColor
            })
          }
          .height(280)
          .columnStyle()
          .margin({ bottom: 80 })
        }
        .constraintSize({ minHeight: '100%' }) // Let the minHeight of the component cover screen
      }
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor($r('app.color.background_shallow_grey'))
  }

  @Builder Block() {
    Row()
      .width('100%')
      .layoutWeight(1)
      .margin(8)
      .borderRadius(12)
      .backgroundColor($r('app.color.divider_block_color'))
  }
}