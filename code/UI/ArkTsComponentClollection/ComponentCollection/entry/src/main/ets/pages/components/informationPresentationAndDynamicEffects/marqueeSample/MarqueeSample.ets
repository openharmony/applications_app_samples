/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import Logger from '../../../../util/Logger'
import { getStringData } from '../../../../data//ResourceDataHandle'

@Extend(Text) function leftTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontSize(14)
  .height(22)
  .alignSelf(ItemAlign.Start)
  .margin({ left: 12, top: 12 })
}

@Extend(Column) function cardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(24)
  .width('100%')
  .padding(15)
}

@Extend(Circle) function colorPicker(color: Color | string, callback: () => void) {
  .fill(color)
  .height(20)
  .width(20)
  .onClick(() => {
    callback()
  })
}

@Styles function pressedStyle() {
  .opacity(0.7)
  .borderWidth(1)
  .borderRadius(20)
}

@Entry
@Component
struct MarqueeSample {
  @State start: boolean = false
  @State fromStart: boolean = true
  @State step: number = 50
  @State loop: number = 3
  @State marqueeSrc: string = getStringData($r('app.string.marquee_src'))
  @State mColor: Color = Color.Gray

  build() {
    Column() {
      TitleBar({ title: $r('app.string.marquee_name') })
      Text($r('app.string.normal_display'))
        .leftTitleStyle()
      Column() {
        Marquee({
          start: this.start,
          step: this.step,
          loop: this.loop,
          fromStart: this.fromStart,
          src: this.marqueeSrc
        })
          .width(600)
          .fontColor(Color.White)
          .fontSize(30)
          .allowScale(false)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Gray)
          .margin({ bottom: 40 })
          .onStart(() => {
            Logger.info('Marquee animation complete onStart')
          })
          .onBounce(() => {
            Logger.info('Marquee animation complete onBounce')
          })
          .onFinish(() => {
            Logger.info('Marquee animation complete onFinish')
          })
        Button(this.start ? 'stop' : 'start')
          .onClick(() => {
            this.start = !this.start
          })
          .width(200)
          .height(60)
          .margin({ bottom: 20 })
      }
      .cardStyle()
      .width('100%')

      Text($r('app.string.normal_options'))
        .leftTitleStyle()
      Column() {
        Row() {
          Text($r('app.string.marquee_fromstart'))
            .leftTitleStyle()
            .width('50%')
          Blank()
          Toggle({ type: ToggleType.Switch, isOn: this.fromStart })
            .onChange((isOn) => {
              this.fromStart = isOn
            })
        }.width('100%')
        .height(50)

        Row() {
          Text($r('app.string.marquee_step'))
            .leftTitleStyle()
            .width('50%')
          Blank()
          Counter() {
            Text(this.step.toString())
          }
          .onInc(() => {
            this.step++
          })
          .onDec(() => {
            if (this.step > 0) {
              this.step--
            }
          })
        }.width('100%')
        .height(50)

        Row() {
          Text($r('app.string.marquee_loop'))
            .leftTitleStyle()
            .width('50%')
          Blank()
          Counter() {
            Text(this.loop.toString())
          }
          .onInc(() => {
            this.loop++
          })
          .onDec(() => {
            if (this.loop > 0) {
              this.loop--
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
    .padding({ left: 20, right: 20 })
  }
}
