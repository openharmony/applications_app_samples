/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import { TitleBar } from '../../../../common/TitleBar';

@Extend(Row) function rowStyle() {
  .padding(8)
  .borderRadius(24)
  .width('100%')
  .backgroundColor(Color.White)
  .margin({ left: 12, right: 12 })
}

@Entry
@Component
struct LocationSample {
  build() {
    Column() {
      TitleBar({ title: $r('app.string.location_settings') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.location_settings_align') })
          Row() {
            Column() {
              Stack() {
                Text($r('app.string.location_settings_bottom_end'))
                  .height('65%')
                  .backgroundColor(0xD2B48C)
                  .align(Alignment.BottomEnd)
              }
              .width('90%')
              .height(50)
              .margin({ top: 5 })
              .backgroundColor(0xFFE4C4)

              Stack() {
                Text($r('app.string.location_settings_top_start'))
              }
              .width('90%')
              .height(50)
              .margin({ top: 5 })
              .backgroundColor(0xFFE4C4)
              .align(Alignment.TopStart)

              Stack() {
                Text($r('app.string.location_settings_center'))
              }
              .width('90%')
              .height(50)
              .margin({ top: 5 })
              .backgroundColor(0xFFE4C4)
              .align(Alignment.Center)
            }
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.location_settings_direction') })
          Row() {
            Column() {
              Row() {
                Text($r('app.string.text_picker_text_banana'))
                  .height(50)
                  .width('25%')
                  .fontSize(16)
                  .backgroundColor(0xF5DEB3)
                Text($r('app.string.text_picker_text_orange'))
                  .height(50)
                  .width('25%')
                  .fontSize(16)
                  .backgroundColor(0xD2B48C)
                Text($r('app.string.text_picker_text_peach'))
                  .height(50)
                  .width('25%')
                  .fontSize(16)
                  .backgroundColor(0xF5DEB3)
                Text($r('app.string.text_picker_text_apple'))
                  .height(50)
                  .width('25%')
                  .fontSize(16)
                  .backgroundColor(0xD2B48C)
              }
              .width('90%')
              .direction(Direction.Ltr)
              // 父容器设置direction为Direction.Rtl，子元素从右到左排列
              Row() {
                Text($r('app.string.text_picker_text_banana'))
                  .height(50)
                  .width('25%')
                  .fontSize(16)
                  .backgroundColor(0xF5DEB3)
                  .textAlign(TextAlign.End)
                Text($r('app.string.text_picker_text_orange'))
                  .height(50)
                  .width('25%')
                  .fontSize(16)
                  .backgroundColor(0xD2B48C)
                  .textAlign(TextAlign.End)
                Text($r('app.string.text_picker_text_peach'))
                  .height(50)
                  .width('25%')
                  .fontSize(16)
                  .backgroundColor(0xF5DEB3)
                  .textAlign(TextAlign.End)
                Text($r('app.string.text_picker_text_apple'))
                  .height(50)
                  .width('25%')
                  .fontSize(16)
                  .backgroundColor(0xD2B48C)
                  .textAlign(TextAlign.End)
              }
              .width('90%')
              .direction(Direction.Rtl)
            }
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.location_settings_position') })
          Row() {
            Column() {
              Text($r('app.string.location_settings_position_text'))
                .size({ width: '60%', height: '30' })
                .backgroundColor(0xbbb2cb)
                .border({ width: 1 })
                .fontSize(16)
                .align(Alignment.Start)
                .position({ x: 30, y: 10 })
            }
            .height(100)
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.location_settings_markAnchor') })
          Row() {
            Stack({ alignContent: Alignment.TopStart }) {
              Row()
                .size({ width: '100', height: '100' })
                .backgroundColor(0xdeb887)
              Text($r('app.string.text_picker_text_banana'))
                .fontSize('30px')
                .textAlign(TextAlign.Center)
                .size({ width: 25, height: 25 })
                .backgroundColor(Color.Green)
                .markAnchor({ x: 25, y: 25 })
              Text($r('app.string.text_picker_text_banana'))
                .fontSize('30px')
                .textAlign(TextAlign.Center)
                .size({ width: 25, height: 25 })
                .backgroundColor(Color.Green)
                .markAnchor({ x: -100, y: -25 })
              Text($r('app.string.text_picker_text_banana'))
                .fontSize('30px')
                .textAlign(TextAlign.Center)
                .size({ width: 25, height: 25 })
                .backgroundColor(Color.Green)
                .markAnchor({ x: 25, y: -25 })
            }
            .margin({ top: 25, left: 50 })
            .border({ width: 1, style: BorderStyle.Dashed })
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.location_settings_offset') })
          Row() {
            Text($r('app.string.text_picker_text_banana'))
              .size({ width: '15%', height: '50' })
              .backgroundColor(0xdeb887)
              .border({ width: 1 })
              .fontSize(16)
              .textAlign(TextAlign.Center)
            Text($r('app.string.location_settings_position_offSet_text'))
              .size({ width: 120, height: '50' })
              .backgroundColor(0xbbb2cb)
              .border({ width: 1 })
              .fontSize(16)
              .align(Alignment.Start)
              .offset({ x: 15, y: 30 })
            Text($r('app.string.text_picker_text_banana'))
              .size({ width: '15%', height: '50' })
              .backgroundColor(0xdeb887)
              .border({ width: 1 })
              .fontSize(16)
              .textAlign(TextAlign.Center)
          }
          .height(200)
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.location_settings_alignRules') })
          Row() {
            RelativeContainer() {
              Row()
                .width(100)
                .height(100)
                .backgroundColor(Color.Pink)
                .alignRules({
                  top: { anchor: "__container__", align: VerticalAlign.Top },
                  left: { anchor: "__container__", align: HorizontalAlign.Start }
                })
                .id("row1")

              Row()
                .width(100)
                .height(100)
                .backgroundColor(Color.Green)
                .alignRules({
                  top: { anchor: "__container__", align: VerticalAlign.Top },
                  right: { anchor: "__container__", align: HorizontalAlign.End }
                })
                .id("row2")

              Row().height(100)
                .backgroundColor(Color.Blue)
                .alignRules({
                  top: { anchor: "row1", align: VerticalAlign.Bottom },
                  left: { anchor: "row1", align: HorizontalAlign.End },
                  right: { anchor: "row2", align: HorizontalAlign.Start }
                })
                .id("row3")

              Row()
                .backgroundColor(Color.Orange)
                .alignRules({
                  top: { anchor: "row3", align: VerticalAlign.Bottom },
                  bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
                  left: { anchor: "__container__", align: HorizontalAlign.Start },
                  right: { anchor: "row1", align: HorizontalAlign.End }
                })
                .id("row4")

              Row()
                .backgroundColor(Color.Red)
                .alignRules({
                  top: { anchor: "row3", align: VerticalAlign.Bottom },
                  bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
                  left: { anchor: "row2", align: HorizontalAlign.Start },
                  right: { anchor: "__container__", align: HorizontalAlign.End }
                })
                .id("row5")
            }
            .width(300)
            .height(300)
          }
          .rowStyle()
        }
        .constraintSize({ minHeight: '100%' })
      }
      .margin({ bottom: 70 })
    }
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}