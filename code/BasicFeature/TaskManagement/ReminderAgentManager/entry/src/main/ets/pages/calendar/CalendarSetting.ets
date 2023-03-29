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

import CalendarsReminder from '../../util/CalendarReminder'
import PreferencesDataManager from '../../util/PreferencesDataManager'

@CustomDialog
export struct CalendarSetting {
  @State selectName: string = 'Demo'
  @State calendarTime: string = '0:0'
  private selectIndex: number
  private controller: CustomDialogController
  private musics: Array<{
    value: string
    src: string,
  }> = [{ value: 'Demo', src: '/system/etc/demo.wav' }, { value: 'Dynamic', src: '/system/etc/dynamic.wav' }]

  build() {
    Column() {
      Row() {
        Text($r('app.string.calendar_time'))
          .fontSize(20)
        Blank()
        Text(this.calendarTime)
          .fontSize(20)
          .fontColor($r('app.color.button_color'))
          .onClick(() => {
            TimePickerDialog.show({
              selected: new Date,
              useMilitaryTime: true,
              onAccept: (value: TimePickerResult) => {
                CalendarsReminder.calendarReminders[this.selectIndex].reminderRequestCalendar.dateTime.hour = value.hour
                CalendarsReminder.calendarReminders[this.selectIndex].reminderRequestCalendar.dateTime.minute = value.minute
                let hour = value.hour < 10 ? `0${value.hour}` : value.hour
                let minute = value.minute < 10 ? `0${value.minute}` : value.minute
                this.calendarTime = `${hour}:${minute}`
              }
            })
          })
      }
      .width('100%')
      .margin({ top: 8, bottom: 8 })
      .padding({ left: 8, right: 8 })

      Row() {
        Text($r('app.string.is_vibrator'))
          .fontSize(20)
        Blank()
        Toggle({ type: ToggleType.Switch, isOn: CalendarsReminder.calendarReminders[this.selectIndex].isVibrator })
          .margin({ left: 8 })
          .onChange((isOn: boolean) => {
            CalendarsReminder.calendarReminders[this.selectIndex].isVibrator = isOn
          })
      }
      .width('100%')
      .padding({ left: 8, right: 8 })

      Row() {
        Text($r('app.string.setting_ringtone'))
          .fontSize(20)
        Blank()
        Select(this.musics)
          .selected(0)
          .value(this.selectName)
          .padding({ left: 20, right: 20 })
          .font({ size: 20 })
          .optionFont({ size: 20 })
          .selectedOptionFont({ size: 20 })
          .onSelect((index: number, value: string) => {
            this.selectName = value
            CalendarsReminder.calendarReminders[this.selectIndex].audioSrc = this.musics[index].src
          })
      }
      .width('100%')
      .margin({ top: 4, bottom: 4 })
      .padding({ left: 8, right: 8 })

      Row() {
        Button($r('app.string.cancel'))
          .fontSize(24)
          .margin({ right: 12 })
          .onClick(() => {
            this.controller.close()
          })
        Button($r('app.string.confirm'))
          .fontSize(24)
          .margin({ left: 12 })
          .onClick(async () => {
            CalendarsReminder.setToggle(CalendarsReminder.calendarReminders[this.selectIndex].isStart,this.selectIndex);
            await PreferencesDataManager.putData('Calendar', CalendarsReminder.calendarReminders);
            this.controller.close();
          })
      }
      .width('100%')
      .margin({ top: 8, bottom: 8 })
      .padding({ left: 8, right: 8 })
      .justifyContent(FlexAlign.Center)
    }
    .padding({ top: 12 })
  }

  aboutToAppear() {
    // Read the data of the settings and display it
    let hour = CalendarsReminder.calendarReminders[this.selectIndex].reminderRequestCalendar.dateTime.hour;
    let minute = CalendarsReminder.calendarReminders[this.selectIndex].reminderRequestCalendar.dateTime.minute;
    let dataTimeHour = hour < 10 ? `0${hour}` : hour;
    let dateTimeMinute = minute < 10 ? `0${minute}` : minute;
    this.calendarTime = `${dataTimeHour}:${dateTimeMinute}`;
    this.selectName = CalendarsReminder.calendarReminders[this.selectIndex].audioSrc === '/system/etc/demo.wav' ? 'Demo' : 'Dynamic';
  }
}