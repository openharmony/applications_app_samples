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

import { IntroductionTitle } from '../../../../common/IntroductionTitle'
import ShowToast from '../../../../util/ShowToast'
import { TitleBar } from '../../../../common/TitleBar'
import { getStringData } from '../../../../data/ResourceDataHandle'

@Extend(Text) function textStyle() {
  .height(40)
  .padding(8)
  .fontSize(20)
  .borderRadius(20)
  .fontColor($r('app.color.background_blue'))
  .backgroundColor($r('app.color.background_grey'))
}

@Extend(Row) function rowStyle() {
  .height(50)
  .padding(12)
  .width('100%')
  .borderRadius(24)
  .margin({ top: 12, bottom: 12 })
}

@Entry
@Component
struct TimeDialogSample {
  @State fullTime: string = getStringData($r('app.string.time_picker_dialog_timeone'))
  @State halfTime: string = getStringData($r('app.string.time_picker_dialog_timeone'))
  private context: any = getContext(this)
  private selectTime: Date = new Date(getStringData($r('app.string.time_picker_dialog_timetwo')))

  build() {
    Column() {
      TitleBar({ title: $r('app.string.time_picker_dialog') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.time_picker_dialog_time') })
          Row({ space: 16 }) {
            Text($r('app.string.time_picker_dialog_24_hour'))
              .fontSize(20)
            Text(this.fullTime)
              .textStyle()
              .onClick(() => {
                TimePickerDialog.show({
                  selected: this.selectTime,
                  useMilitaryTime: true,
                  onAccept: (value: TimePickerResult) => {
                    this.setTime(true, value)
                  },
                  onCancel: () => {
                    ShowToast.shortToast($r('app.string.time_picker_dialog_cancel'))
                  },
                  onChange: (value: TimePickerResult) => {
                    this.ShowToastTime(value)
                  }
                })
              })
          }
          .rowStyle()

          Row({ space: 16 }) {
            Text($r('app.string.time_picker_dialog_12_hour'))
              .fontSize(20)
            Text(this.halfTime)
              .textStyle()
              .onClick(() => {
                TimePickerDialog.show({
                  selected: this.selectTime,
                  useMilitaryTime: false,
                  onAccept: (value: TimePickerResult) => {
                    this.setTime(false, value)
                  },
                  onCancel: () => {
                    ShowToast.shortToast($r('app.string.time_picker_dialog_cancel'))
                  },
                  onChange: (value: TimePickerResult) => {
                    this.ShowToastTime(value)
                  }
                })
              })
          }
          .rowStyle()
        }
        .constraintSize({ minHeight: '100%' })
      }
    }
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }

  setTime(isUseMilitaryTime: boolean, value: TimePickerResult) {
    this.selectTime.setHours(value.hour, value.minute)
    let hour: string = `${value.hour}`
    let minute: string = `${value.minute}`
    if (value.hour < 10) {
      hour = `0${value.hour}`
    }
    if (value.minute < 10) {
      minute = `0${value.minute}`
    }
    if (isUseMilitaryTime) {
      this.fullTime = `${hour}:${minute}`
    } else {
      this.halfTime = `${hour}:${minute}`
    }
  }

  ShowToastTime(value: TimePickerResult) {
    let hour: string = `${value.hour}`
    let minute: string = `${value.minute}`
    if (value.hour < 10) {
      hour = `0${value.hour}`
    }
    if (value.minute < 10) {
      minute = `0${value.minute}`
    }
    ShowToast.shortToast(`${this.context.resourceManager.getStringSync($r('app.string.time_picker_toast_time')
      .id)}${hour}:${minute}`)
  }
}