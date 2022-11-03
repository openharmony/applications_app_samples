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

import { TitleBar } from '../../../../common/TitleBar'

@Extend(Text)
function leftTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontSize(14)
  .height(22)
  .alignSelf(ItemAlign.Start)
  .margin({left: 12, top: 12})
}

@Extend(Column)
function cardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(24)
  .width('100%')
  .padding(15)
}

@Extend(Circle)
function colorPicker(color: Color | string, callback: ()=>void) {
  .fill(color)
  .height(20)
  .width(20)
  .onClick(() => {
    callback()
  })
}

@Styles
function pressedStyle() {
  .opacity(0.7)
  .borderWidth(1)
  .borderRadius(20)
}

@Entry
@Component
struct GaugeSample {
  @State start: boolean = false
  @State fromStart: boolean = true
  @State step: number = 50
  @State loop: number = 3
  @State mColor: Color = Color.Gray

  @State value: number = 0
  @State startAngle: number = 210
  @State endAngle: number = 150
  @State mWidth: number = 10

  build() {
    Column() {
      TitleBar({title: $r('app.string.gauge_name')})
      Text($r('app.string.normal_display'))
        .leftTitleStyle()
      Column() {
        Gauge({ value: this.value })
          .width(200).height(200)
          .colors([[0x317AF7, 1], [0x5BA854, 1], [0xE08C3A, 1], [0x9C554B, 1]])
          .startAngle(this.startAngle)
          .endAngle(this.endAngle)
          .strokeWidth(this.mWidth)
      }
      .cardStyle()
      .width('100%')

      Text($r('app.string.normal_options'))
        .leftTitleStyle()
      Column() {
        Row() {
          Text('value')
            .leftTitleStyle()
          Row({ space: 10 }) {
            Slider({
              value: this.value,
              min: 0,
              max: 100,
              style: SliderStyle.OutSet
            })
              .onChange((value: number) => {
                this.value = value
              })
          }.layoutWeight(1)
        }.width('100%')
        .height(50)
        Row() {
          Text('strokeWidth')
            .leftTitleStyle()
          Row({ space: 10 }) {
            Slider({
              value: this.mWidth,
              min: 0,
              max: 100,
              style: SliderStyle.OutSet
            })
              .onChange((value: number) => {
                this.mWidth = value
              })
          }.layoutWeight(1)
        }.width('100%')
        .height(50)
        Row() {
          Text('startAngle')
            .leftTitleStyle()
            .width('50%')
          Blank()
          Counter() {
            Text(this.startAngle.toString())
          }
          .onInc(() => {
            this.startAngle++
          })
          .onDec(() => {
            if (this.startAngle > 0) {
              this.startAngle--
            }
          })
        }.width('100%')
        .height(50)
        Row() {
          Text('endAngle')
            .leftTitleStyle()
            .width('50%')
          Blank()
          Counter() {
            Text(this.endAngle.toString())
          }
          .onInc(() => {
            this.endAngle++
          })
          .onDec(() => {
            if (this.endAngle > 0) {
              this.endAngle--
            }
          })
        }.width('100%')
        .height(50)
      }
      .cardStyle()
      .width('100%')

    }.height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_light_gray'))
    .padding({left: 20, right: 20})
  }
}