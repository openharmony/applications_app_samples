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
  .height(80)
  .width('100%')
  .borderRadius(24)
  .backgroundColor(Color.White)
  .margin({ left: 12, right: 12 })
  .justifyContent(FlexAlign.SpaceAround)
  .padding({ left: 20, right: 20, top: 24, bottom: 24 })
}

@Entry
@Component
struct Font {
  build() {
    Column() {
      TitleBar({ title: $r('app.string.prop_font') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.font_color') })
          Row() {
            Text('#409EFF')
              .fontSize(20)
              .fontColor($r('app.color.background_blue'))
            Text('#E6A23C')
              .fontSize(20)
              .fontColor($r('app.color.background_orange'))
            Text('#F56C6C')
              .fontSize(20)
              .fontColor($r('app.color.background_pink'))
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.font_size') })
          Row() {
            Text('14vp')
              .fontSize(14)
            Text('18vp')
              .fontSize(18)
            Text('26vp')
              .fontSize(26)
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.font_thickness') })
          Row() {
            Text('300')
              .fontSize(18)
              .fontWeight(300)
            Text('500')
              .fontSize(18)
              .fontWeight(500)
            Text('800')
              .fontSize(18)
              .fontWeight(800)
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.font_style') })
          Row() {
            Text('normal')
              .fontSize(20)
              .fontStyle(FontStyle.Normal)
            Text('italic')
              .fontSize(20)
              .fontStyle(FontStyle.Italic)
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.prop_size') })
          Row() {
            Text('sans-serif')
              .fontSize(20)
              .fontFamily('sans-serif')
            Text('HYQiHei-65S')
              .fontSize(20)
              .fontFamily('HYQiHei-65S')
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