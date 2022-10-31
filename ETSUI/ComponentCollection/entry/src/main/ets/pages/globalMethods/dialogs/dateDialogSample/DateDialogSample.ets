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
import ShowToast from '../../../../util/ShowToast'
import { TitleBar } from '../../../../common/TitleBar'

@Extend(Text) function textStyle () {
  .height(40)
  .padding(8)
  .fontSize(20)
  .borderRadius(20)
  .fontColor($r('app.color.background_blue'))
  .backgroundColor($r('app.color.background_grey'))
}

@Extend(Row) function rowStyle () {
  .height(50)
  .padding(12)
  .width('100%')
  .borderRadius(24)
  .margin({ top: 12, bottom: 12 })
}

@Entry
@Component
struct DataPopupSample {
  @State fullTime: string = `12:00:00`
  @State halfTime: string = `12:00:00`
  @State lunarDate: string = '2022-10-01'
  @State gregorianDate: string = '2022-10-01'
  private selectedDate: Date = new Date('2022-10-01')
  private selectTime: Date = new Date('10/01/2022 12:00:00')

  build() {
    Column() {
      TitleBar({ title: $r('app.string.date_picker_dialog') })
      IntroductionTitle({ introduction: $r('app.string.date_picker_dialog_date') })
      Row({ space: 16 }) {
        Text($r('app.string.date_picker_dialog_date_lunar'))
          .fontSize(20)
        Text(this.lunarDate)
          .textStyle()
          .onClick(() => {
            DatePickerDialog.show({
              start: new Date('1970-1-1'),
              end: new Date('2100-12-31'),
              selected: this.selectedDate,
              lunar: true,
              onAccept: (value: DatePickerResult) => {
                this.setDate(true, value)
              },
              onCancel: () => {
                ShowToast.showToast($r('app.string.date_picker_dialog_cancel'), 300)
              },
              onChange: (value: DatePickerResult) => {
                ShowToast.showToast(JSON.stringify(value), 300)
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
              start: new Date('1970-1-1'),
              end: new Date('2100-12-31'),
              selected: this.selectedDate,
              lunar: false,
              onAccept: (value: DatePickerResult) => {
                this.setDate(false, value)
              },
              onCancel: () => {
                ShowToast.showToast($r('app.string.date_picker_dialog_cancel'), 300)
              },
              onChange: (value: DatePickerResult) => {
                ShowToast.showToast(JSON.stringify(value), 300)
              }
            })
          })
      }
      .rowStyle()

      IntroductionTitle({ introduction: $r('app.string.date_picker_dialog_time') })
      Row({ space: 16 }) {
        Text($r('app.string.date_picker_dialog_24_hour'))
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
                ShowToast.showToast($r('app.string.date_picker_dialog_cancel'), 300)
              },
              onChange: (value: TimePickerResult) => {
                ShowToast.showToast(JSON.stringify(value), 300)
              }
            })
          })
      }
      .rowStyle()

      Row({ space: 16 }) {
        Text($r('app.string.date_picker_dialog_12_hour'))
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
                ShowToast.showToast($r('app.string.date_picker_dialog_cancel'), 300)
              },
              onChange: (value: TimePickerResult) => {
                ShowToast.showToast(JSON.stringify(value), 300)
              }
            })
          })
      }
      .rowStyle()
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }

  setDate(isLunar: boolean, value: DatePickerResult) {
    this.selectedDate.setFullYear(value.year, value.month, value.day)
    if (isLunar) {
      this.lunarDate = `${value.year}-${value.month + 1}-${value.day}`
    } else {
      this.gregorianDate = `${value.year}-${value.month + 1}-${value.day}`
    }
  }

  setTime(isUseMilitaryTime: boolean, value: TimePickerResult) {
    this.selectTime.setHours(value.hour, value.minute)
    if (isUseMilitaryTime) {
      this.fullTime = `${value.hour}:${value.minute}:00`
    } else {
      this.halfTime = `${value.hour}:${value.minute}:00`
    }
  }
}