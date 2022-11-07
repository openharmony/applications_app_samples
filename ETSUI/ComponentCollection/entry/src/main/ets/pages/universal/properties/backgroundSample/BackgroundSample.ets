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

import { IntroductionTitle } from '../../../../common/IntroductionTitle'
import { TitleBar } from '../../../../common/TitleBar'

@Extend(Row) function rowStyle () {
  .padding(8)
  .height(120)
  .borderRadius(24)
  .backgroundColor(Color.White)
  .margin({ left: 12, right: 12 })
}

@Extend(Text) function textStyle (marginValue: number) {
  .height(80)
  .fontSize(18)
  .layoutWeight(1)
  .fontColor(Color.White)
  .textAlign(TextAlign.Center)
  .margin({ left: marginValue, right: marginValue })
}

@Extend(Text) function titleText () {
  .fontSize(18)
  .margin({ bottom: 4 })
  .textAlign(TextAlign.Center)
  .fontColor($r('app.color.font_color_shallow'))
}

@Extend(Text) function textBorder () {
  .width('100%')
  .textStyle(12)
  .borderWidth(1)
  .borderRadius(8)
  .borderColor(Color.Black)
}

@Entry
@Component
struct Background {
  build() {
    Column() {
      TitleBar({ title: $r('app.string.prop_background') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.background_color') })
          Row() {
            Text('Brand')
              .textStyle(20)
              .backgroundColor($r('app.color.background_blue'))
            Text('Warning')
              .textStyle(20)
              .backgroundColor($r('app.color.background_orange'))
            Text('Danger')
              .textStyle(20)
              .backgroundColor($r('app.color.background_pink'))
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.background_gradient') })
          Row() {
            Text($r('app.string.background_gradient_linear'))
              .textStyle(20)
              .linearGradient({
                angle: 180,
                direction: GradientDirection.Bottom,
                colors: [[$r('app.color.background_blue'), 0.3], [$r('app.color.background_green'), 1]],
                repeating: false
              })
            Text($r('app.string.background_gradient_sweep'))
              .textStyle(20)
              .sweepGradient({
                center: [50, 50],
                start: 0,
                end: 359,
                rotation: 45,
                repeating: false,
                colors: [[$r('app.color.background_blue'), 0.3], [$r('app.color.background_green'), 1]]
              })
            Text($r('app.string.background_gradient_radial'))
              .textStyle(20)
              .radialGradient({
                center: [50, 50],
                radius: 50,
                repeating: true,
                colors: [[$r('app.color.background_blue'), 0.3], [$r('app.color.background_green'), 0.6]]
              })
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.background_image') })
          Grid() {
            GridItem() {
              Column() {
                Text($r('app.string.background_image_default'))
                  .titleText()
                Text()
                  .textBorder()
                  .backgroundImageSize(ImageSize.Cover)
                  .backgroundImage($r('app.media.ic_scenery1'))
              }
            }

            GridItem() {
              Column() {
                Text($r('app.string.background_image_repeat'))
                  .titleText()
                Text()
                  .textBorder()
                  .backgroundImageSize({ width: 100, height: 100 })
                  .backgroundImage($r('app.media.ic_scenery1'), ImageRepeat.XY)
              }
            }

            GridItem() {
              Column() {
                Text($r('app.string.background_image_size'))
                  .titleText()
                Text()
                  .textBorder()
                  .backgroundImage($r('app.media.ic_scenery1'))
                  .backgroundImageSize({ width: '50%', height: '100%' })
              }
            }

            GridItem() {
              Column() {
                Text($r('app.string.background_image_offset'))
                  .titleText()
                Text()
                  .textBorder()
                  .backgroundImageSize(ImageSize.Cover)
                  .backgroundImagePosition({ x: 20, y: 20 })
                  .backgroundImage($r('app.media.ic_scenery1'))
              }
            }
          }
          .rowsGap(8)
          .padding(8)
          .height(250)
          .columnsGap(8)
          .borderRadius(24)
          .rowsTemplate('1fr 1fr')
          .columnsTemplate('1fr 1fr')
          .backgroundColor(Color.White)
          .margin({ left: 12, right: 12 })
        }
        .constraintSize({ minHeight: '100%' })
      }
    }
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}