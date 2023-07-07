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
  .padding(12)
  .borderRadius(24)
  .backgroundColor(Color.White)
  .margin({ left: 12, right: 12 })
  .justifyContent(FlexAlign.SpaceBetween)
}

@Entry
@Component
struct Size {
  build() {
    Column() {
      TitleBar({ title: $r('app.string.prop_size') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.size_width') })
          Row() {
            Row() {
              Text($r('app.string.size_width_fixed_100vp'))
                .fontSize(18)
                .fontColor(Color.White)
            }
            .width(100)
            .height(100)
            .borderRadius(5)
            .justifyContent(FlexAlign.Center)
            .backgroundColor($r('app.color.background_green'))

            Row() {
              Text($r('app.string.size_width_percent'))
                .fontSize(18)
                .width('60%')
                .height('100%')
                .fontColor(Color.White)
                .textAlign(TextAlign.Center)
                .backgroundColor($r('app.color.background_green'))
            }
            .height(100)
            .layoutWeight(1)
            .borderRadius(5)
            .margin({ left: 20 })
            .justifyContent(FlexAlign.Start)
            .backgroundColor($r('app.color.background_blue'))
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.size_height') })
          Row() {
            Row() {
              Text($r('app.string.size_height_fixed_100vp'))
                .fontSize(18)
                .fontColor(Color.White)
            }
            .height(100)
            .borderRadius(5)
            .justifyContent(FlexAlign.Center)
            .backgroundColor($r('app.color.background_blue'))

            Row() {
              Text($r('app.string.size_height_percent'))
                .fontSize(18)
                .width('100%')
                .height('60%')
                .fontColor(Color.White)
                .textAlign(TextAlign.Center)
                .backgroundColor($r('app.color.background_green'))
            }
            .height(100)
            .layoutWeight(1)
            .borderRadius(5)
            .margin({ left: 20 })
            .alignItems(VerticalAlign.Top)
            .backgroundColor($r('app.color.background_blue'))
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