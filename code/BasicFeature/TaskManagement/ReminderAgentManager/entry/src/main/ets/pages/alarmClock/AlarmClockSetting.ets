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

import AlarmClockReminder from '../../util/AlarmClockReminder'
import PreferencesDataManager from '../../util/PreferencesDataManager'

@CustomDialog
export struct AlarmClockSetting {
  @State snoozeTimes: number = 0
  @State timeInterval: number = 0
  @State selectName: string = 'Demo'
  @State days: Array<{
    name: Resource,
    value: number,
    isSelect: boolean
  }> =
    [
      { name: $r('app.string.alarm_clock_one'), value: 1, isSelect: false },
      { name: $r('app.string.alarm_clock_two'), value: 2, isSelect: false },
      { name: $r('app.string.alarm_clock_three'), value: 3, isSelect: false },
      { name: $r('app.string.alarm_clock_four'), value: 4, isSelect: false },
      { name: $r('app.string.alarm_clock_five'), value: 5, isSelect: false },
      { name: $r('app.string.alarm_clock_six'), value: 6, isSelect: false },
      { name: $r('app.string.alarm_clock_seven'), value: 7, isSelect: false }
    ]
  private selectAlarmClockIndex: number = 0
  private controller: CustomDialogController
  private musics: Array<{
    value: string
    src: string,
  }> = [{ value: 'Demo', src: '/system/etc/demo.wav' }, { value: 'Dynamic', src: '/system/etc/dynamic.wav' }]

  build() {
    Column() {
      Row() {
        Text($r('app.string.alarm_clock_remind_day'))
          .fontSize(20)
        Blank()
        ForEach(this.days, (item) => {
          Column() {
            Text(item.name)
              .margin(2)
              .fontSize(18)
            Checkbox({ name: item.name, group: 'days' })
              .select(item.isSelect)
              .selectedColor(0x39a2db)
              .onChange((value: boolean) => {
                item.isSelect = value
              })
          }
          .layoutWeight(1)
        })
      }
      .width('100%')
      .padding({ left: 8, right: 8, top: 8 })

      Row() {
        Text($r('app.string.alarm_clock_snooze'))
          .fontSize(20)
        Blank()
        Counter() {
          Text(`${JSON.stringify(this.snoozeTimes)}`)
        }
        .onInc(() => {
          this.snoozeTimes++
        })
        .onDec(() => {
          this.snoozeTimes <= 0 ? 0 : this.snoozeTimes--
        })
      }
      .width('100%')
      .margin({ top: 4, bottom: 4 })
      .padding({ left: 8, right: 8 })

      Row() {
        Text($r('app.string.alarm_clock_interval'))
          .fontSize(20)
        Blank()
        Counter() {
          Text(`${JSON.stringify(this.timeInterval)}`)
        }
        .onInc(() => {
          this.timeInterval++
        })
        .onDec(() => {
          this.timeInterval <= 0 ? 0 : this.timeInterval--
        })
      }
      .width('100%')
      .margin({ top: 4, bottom: 4 })
      .padding({ left: 8, right: 8 })

      Row() {
        Text($r('app.string.is_vibrator'))
          .fontSize(20)
        Blank()
        Toggle({
          type: ToggleType.Switch,
          isOn: AlarmClockReminder.alarmClockReminders[this.selectAlarmClockIndex].isVibrator
        })
          .margin({ left: 8 })
          .onChange((isOn: boolean) => {
            AlarmClockReminder.alarmClockReminders[this.selectAlarmClockIndex].isVibrator = isOn
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
            AlarmClockReminder.alarmClockReminders[this.selectAlarmClockIndex].audioSrc = this.musics[index].src
          })
      }
      .padding(8)
      .width('100%')

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
            let selectDays: number[] = []
            for (let i = 0; i < this.days.length; i++) {
              if (this.days[i].isSelect) {
                selectDays.push(this.days[i].value)
              }
            }
            AlarmClockReminder.alarmClockReminders[this.selectAlarmClockIndex].reminderRequestAlarm.snoozeTimes = this.snoozeTimes
            AlarmClockReminder.alarmClockReminders[this.selectAlarmClockIndex].reminderRequestAlarm.timeInterval = this.timeInterval
            AlarmClockReminder.alarmClockReminders[this.selectAlarmClockIndex].reminderRequestAlarm.daysOfWeek = selectDays
            await PreferencesDataManager.putData('alarmClock', AlarmClockReminder.alarmClockReminders)
            this.controller.close()
          })
      }
      .padding(8)
      .width('100%')
      .margin({ top: 8, bottom: 8 })
      .justifyContent(FlexAlign.Center)
    }
  }

  aboutToAppear() {
    // Read the data of the settings and display it
    this.snoozeTimes = AlarmClockReminder.alarmClockReminders[this.selectAlarmClockIndex].reminderRequestAlarm.snoozeTimes
    this.timeInterval = AlarmClockReminder.alarmClockReminders[this.selectAlarmClockIndex].reminderRequestAlarm.timeInterval
    this.selectName = AlarmClockReminder.alarmClockReminders[this.selectAlarmClockIndex].audioSrc === '/system/etc/demo.wav' ? 'Demo' : 'Dynamic'
    let selectDays = AlarmClockReminder.alarmClockReminders[this.selectAlarmClockIndex].reminderRequestAlarm.daysOfWeek
    for (let i = 0; i < this.days.length; i++) {
      for (let j = 0; j < selectDays.length; j++) {
        if (this.days[i].value === selectDays[j]) {
          this.days[i].isSelect = true
          break
        }
      }
    }
  }
}