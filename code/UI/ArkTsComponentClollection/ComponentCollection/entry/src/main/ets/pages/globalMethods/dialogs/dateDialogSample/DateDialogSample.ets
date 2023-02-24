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
struct DataDialogSample {
  @State lunarDate: string = getStringData($r('app.string.date_picker_dialog_datetimeone'))
  @State gregorianDate: string = getStringData($r('app.string.date_picker_dialog_datetimeone'))
  private context = getContext(this)
  private selectedDate: Date = new Date(getStringData($r('app.string.date_picker_dialog_datetimeone')))

  build() {
    Column() {
      TitleBar({ title: $r('app.string.date_picker_dialog') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.date_picker_dialog_date') })
          Row({ space: 16 }) {
            Text($r('app.string.date_picker_dialog_date_lunar'))
              .fontSize(20)
            Text(this.lunarDate)
              .textStyle()
              .onClick(() => {
                DatePickerDialog.show({
                  start: new Date(getStringData($r('app.string.date_picker_dialog_datetimetwo'))),
                  end: new Date(getStringData($r('app.string.date_picker_dialog_datetimethree'))),
                  selected: this.selectedDate,
                  lunar: true,
                  onAccept: (value: DatePickerResult) => {
                    this.setDate(true, value)
                  },
                  onCancel: () => {
                    ShowToast.shortToast($r('app.string.date_picker_dialog_cancel'))
                  },
                  onChange: (value: DatePickerResult) => {
                    this.ShowToastDate(value)
                  }
                })
              })
          }
          .rowStyle()

          Row({ space: 16 }) {
            Text($r('app.string.date_picker_dialog_date_gregorian'))
              .fontSize(20)
            Text(this.gregorianDate)
              .textStyle()
              .onClick(() => {
                DatePickerDialog.show({
                  start: new Date(getStringData($r('app.string.date_picker_dialog_datetimetwo'))),
                  end: new Date(getStringData($r('app.string.date_picker_dialog_datetimethree'))),
                  selected: this.selectedDate,
                  lunar: false,
                  onAccept: (value: DatePickerResult) => {
                    this.setDate(false, value)
                  },
                  onCancel: () => {
                    ShowToast.shortToast($r('app.string.date_picker_dialog_cancel'))
                  },
                  onChange: (value: DatePickerResult) => {
                    this.ShowToastDate(value)
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

  setDate(isLunar: boolean, value: DatePickerResult) {
    this.selectedDate.setFullYear(value.year, value.month, value.day)
    let month: string = `${value.month + 1}`
    let day: string = `${value.day}`
    if (value.month < 9) {
      month = `0${value.month + 1}`
    }
    if (value.day < 10) {
      day = `0${value.day}`
    }
    if (isLunar) {
      this.lunarDate = `${value.year}-${month}-${day}`
    } else {
      this.gregorianDate = `${value.year}-${month}-${day}`
    }
  }

  ShowToastDate(value: DatePickerResult) {
    let month: string = `${value.month + 1}`
    let day: string = `${value.day}`
    if (value.month < 9) {
      month = `0${value.month + 1}`
    }
    if (value.day < 10) {
      day = `0${value.day}`
    }
    ShowToast.shortToast(`${this.context.resourceManager.getStringSync($r('app.string.date_picker_toast_date')
      .id)}${value.year}-${month}-${day}`)
  }
}