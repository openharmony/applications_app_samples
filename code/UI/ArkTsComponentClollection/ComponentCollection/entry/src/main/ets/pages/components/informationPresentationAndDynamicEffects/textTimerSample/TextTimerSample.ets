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
struct TextTimerSample {
  textTimerController: TextTimerController = new TextTimerController()
  @State format: string = 'mm:ss.SS'
  @State isCountDown: boolean = true

  build() {
    Column() {
      TitleBar({ title: $r('app.string.text_timer') })
      Text($r('app.string.normal_display'))
        .leftTitleStyle()
      Column() {
        TextTimer({ controller: this.textTimerController, isCountDown: this.isCountDown, count: 30000 })
          .format(this.format)
          .fontColor(Color.Black)
          .fontSize(50)
          .onTimer((utc: number, elapsedTime: number) => {
            Logger.info(`textTimer notCountDown utc is：${utc}, elapsedTime: ${elapsedTime}`)
          })
        Row() {
          Button($r('app.string.text_timer_start')).onClick(() => {
            this.textTimerController.start()
          })
          Blank()
          Button($r('app.string.text_timer_pause')).onClick(() => {
            this.textTimerController.pause()
          })
          Blank()
          Button($r('app.string.text_timer_reset')).onClick(() => {
            this.textTimerController.reset()
          })
        }.width('100%')
      }
      .cardStyle()
      .width('100%')

      Text($r('app.string.normal_options'))
        .leftTitleStyle()
      Column() {
        Row() {
          Text($r('app.string.text_timer_iscountdown'))
            .leftTitleStyle()
            .width('50%')
          Blank()
          Toggle({ type: ToggleType.Switch, isOn: this.isCountDown })
            .onChange((isOn) => {
              this.isCountDown = isOn
            })
        }.width('100%')
        .height(50)
      }.cardStyle()

      Text($r('app.string.textclock_timeformat'))
        .leftTitleStyle()
      Column() {
        Row() {
          Text($r('app.string.text_timer_timeformatone'))
            .leftTitleStyle()
            .width('50%')
          Blank()
          Radio({
            value: getStringData($r('app.string.text_timer_timeformatone')),
            group: getStringData($r('app.string.text_timer_groupformat'))
          })
            .checked(this.format === getStringData($r('app.string.text_timer_timeformatone')))
            .onChange((isChecked: boolean) => {
              if (isChecked)
                this.format = getStringData($r('app.string.text_timer_timeformatone'))
            })
        }.width('100%')
        .height(50)

        Row() {
          Text($r('app.string.text_timer_timeformattwo'))
            .leftTitleStyle()
            .width('50%')
          Blank()
          Radio({
            value: getStringData($r('app.string.text_timer_timeformattwo')),
            group: getStringData($r('app.string.text_timer_groupformat'))
          })
            .checked(this.format === getStringData($r('app.string.text_timer_timeformattwo')))
            .onChange((isChecked: boolean) => {
              if (isChecked)
                this.format = getStringData($r('app.string.text_timer_timeformattwo'))
            })
        }.width('100%')
        .height(50)

        Row() {
          Text($r('app.string.text_timer_timeformatthree'))
            .leftTitleStyle()
            .width('50%')
          Blank()
          Radio({
            value: getStringData($r('app.string.text_timer_timeformatthree')),
            group: getStringData($r('app.string.text_timer_groupformat'))
          })
            .checked(this.format === getStringData($r('app.string.text_timer_timeformatthree')))
            .onChange((isChecked: boolean) => {
              if (isChecked)
                this.format = getStringData($r('app.string.text_timer_timeformatthree'))
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