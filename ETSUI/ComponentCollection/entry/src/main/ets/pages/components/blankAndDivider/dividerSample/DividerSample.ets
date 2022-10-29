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

import { ChangePanel } from './ChangePanel'
import { IntroductionTitle } from '../../../../common/IntroductionTitle'
import { TitleBar } from '../../../../common/TitleBar'

@Entry
@Component
struct DividerSample {
  @State strokeWidth: number = 8
  @State lineColor: ResourceColor = $r('app.color.background_blue')
  @State lineCapStyle: LineCapStyle = LineCapStyle.Butt

  @Styles backgroundStyle() {
    .width('100%')
    .padding(16)
    .borderRadius(24)
    .backgroundColor(Color.White)
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.divider_title') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.divider_horizontal') })
          // horizontal divider
          Column() {
            this.Block()
            Divider()
            this.Block()
          }
          .height(150)
          .backgroundStyle()

          IntroductionTitle({ introduction: $r('app.string.divider_vertical') })
          // vertical divider
          Row() {
            Text($r('app.string.beijing'))
            Divider()
              .vertical(true) // if true, divider is vertical
              .height(26)
            Text($r('app.string.shanghai'))
            Divider()
              .vertical(true)
              .height(26)
            Text($r('app.string.guangzhou'))
          }
          .height(60)
          .backgroundStyle()
          .justifyContent(FlexAlign.SpaceEvenly)

          IntroductionTitle({ introduction: $r('app.string.divider_attribute') })
          Column() {
            this.Block()
            Divider()
              .color(this.lineColor) // divider color
              .strokeWidth(this.strokeWidth) // divider stroke width
              .lineCap(this.lineCapStyle) // divider line cap style
            this.Block()

            ChangePanel({
              strokeWidth: $strokeWidth,
              lineCapStyle: $lineCapStyle,
              lineColor: $lineColor
            })
          }
          .height(280)
          .margin({ bottom: 80 })
          .backgroundStyle()
        }
        .constraintSize({ minHeight: '100%' }) // Let the minHeight of the component cover screen
      }
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor($r('app.color.background'))
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