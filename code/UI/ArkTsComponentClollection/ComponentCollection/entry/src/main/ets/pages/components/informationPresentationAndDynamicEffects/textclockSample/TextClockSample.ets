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
import { getStringData } from '../../../../data/ResourceDataHandle'

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
struct TextClockSample {
  @State format: string = 'HH:mm:ss'
  @State accumulateTime: number = 0
  controller: TextClockController = new TextClockController()

  build() {
    Column() {
      TitleBar({ title: $r('app.string.text_clock') })
      Text($r('app.string.normal_display'))
        .leftTitleStyle()
      Column() {
        TextClock({ timeZoneOffset: -8, controller: this.controller })
          .format(this.format)
          .margin(20)
          .fontSize(30)
        Row() {
          Button($r('app.string.text_clock_start')).onClick(() => {
            this.controller.start()
          })
          Blank()
          Button($r('app.string.text_clock_stop')).onClick(() => {
            this.controller.stop()
          })
        }.width('100%')
      }
      .cardStyle()
      .width('100%')

      Text($r('app.string.textclock_timeformat'))
        .leftTitleStyle()
      Column() {
        Row() {
          Text($r('app.string.text_clock_timeformatone'))
            .leftTitleStyle()
            .width('50%')
          Blank()
          Radio({
            value: getStringData($r('app.string.text_clock_timeformatone')),
            group: getStringData($r('app.string.text_clock_groupformat'))
          })
            .checked(this.format === getStringData($r('app.string.text_clock_timeformatone')))
            .onChange((isChecked: boolean) => {
              if (isChecked)
                this.format = getStringData($r('app.string.text_clock_timeformatone'))
            })
        }.width('100%')
        .height(50)

        Row() {
          Text($r('app.string.text_clock_timeformattwo'))
            .leftTitleStyle()
            .width('50%')
          Blank()
          Radio({
            value: getStringData($r('app.string.text_clock_timeformattwo')),
            group: getStringData($r('app.string.text_clock_groupformat'))
          })
            .checked(this.format === getStringData($r('app.string.text_clock_timeformattwo')))
            .onChange((isChecked: boolean) => {
              if (isChecked)
                this.format = getStringData($r('app.string.text_clock_timeformattwo'))
            })
        }.width('100%')
        .height(50)

        Row() {
          Text($r('app.string.text_clock_timeformatthree'))
            .leftTitleStyle()
            .width('50%')
          Blank()
          Radio({
            value: getStringData($r('app.string.text_clock_timeformatthree')),
            group: getStringData($r('app.string.text_clock_groupformat'))
          })
            .checked(this.format === getStringData($r('app.string.text_clock_timeformatthree')))
            .onChange((isChecked: boolean) => {
              if (isChecked)
                this.format = getStringData($r('app.string.text_clock_timeformatthree'))
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
