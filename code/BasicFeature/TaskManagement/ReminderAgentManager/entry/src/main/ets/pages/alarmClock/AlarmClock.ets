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
import { AlarmClockSetting } from './AlarmClockSetting'
import { DrawClock } from './DrawClock'
import PreferencesDataManager from '../../util/PreferencesDataManager'

@Component
export struct AlarmClock {
  @State isEdit: boolean = false
  @State canvasWidth: number = 0
  @State canvasRadius: number = 0
  @State alarmClockName: string[] = []
  @State selectAlarmClockIndex: number = 0
  private title: Resource
  private alarmClockSetting: CustomDialogController = new CustomDialogController({
    builder: AlarmClockSetting({ selectAlarmClockIndex: this.selectAlarmClockIndex })
  })

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize(24)
          .margin({ left: 8 })
        Blank()
        Image($r('app.media.ic_public_add'))
          .width(30)
          .height(30)
          .margin({ right: 8 })
          .onClick(() => {
            TimePickerDialog.show({
              selected: new Date,
              useMilitaryTime: true,
              onAccept: async (value: TimePickerResult) => {
                await AlarmClockReminder.setAlarmReminder(value)
                if (AlarmClockReminder.alarmClockReminders.length !== 0) {
                  for (let i = 0; i < AlarmClockReminder.alarmClockReminders.length; i++) {
                    this.alarmClockName[i] = AlarmClockReminder.alarmClockReminders[i].reminderName
                  }
                } else {
                  this.alarmClockName = []
                }
              }
            })
          })
      }
      .height(56)
      .padding(8)
      .width('100%')

      Row() {
        DrawClock({ canvasWidth: $canvasWidth, radius: $canvasRadius })
          .margin(8)
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')

      List({ space: 8 }) {
        ForEach(this.alarmClockName, (item, index) => {
          ListItem() {
            Row() {
              Text(item)
                .fontSize(24)
              Blank()
              Toggle({ type: ToggleType.Switch, isOn: AlarmClockReminder.alarmClockReminders[index].isStart })
                .margin({ left: 8 })
                .onChange(async (isOn: boolean) => {
                  await AlarmClockReminder.setToggle(isOn, index)
                })
            }
            .width('100%')
            .borderRadius(24)
            .backgroundColor(Color.White)
            .padding({ left: 12, right: 12, top: 8, bottom: 8 })
          }
          .padding({ left: 12, right: 12 })
          .gesture(
          SwipeGesture({ direction: SwipeDirection.Horizontal })
            .onAction((event: GestureEvent) => {
              this.isEdit = !this.isEdit
              this.deleteItem(index)
            })
          )
          .onClick(async () => {
            this.selectAlarmClockIndex = index
            AlarmClockReminder.alarmClockReminders[index].isStart = false
            await AlarmClockReminder.openDialog(this.alarmClockSetting, index)
          })
        })
      }
      .layoutWeight(1)

      Blank()
      Divider()
        .height(0.75)
        .width('100%')
        .alignSelf(ItemAlign.Baseline)
        .color($r('app.color.tab_bar_divider'))
    }
    .width('100%')
    .height('100%')
    .onAreaChange((oldValue: Area, newValue: Area) => {
      let size = newValue.width < newValue.height ? newValue.width : Number(newValue.height) * 0.8
      this.canvasWidth = Number(size) * 0.5
      this.canvasRadius = this.canvasWidth / 2
    })
  }

  deleteItem(index: number): boolean {
    AlarmClockReminder.deleteAlarmReminder(index)
      .then(() => {
        this.alarmClockName = []
        if (AlarmClockReminder.alarmClockReminders.length !== 0) {
          for (let i = 0;
               i < AlarmClockReminder.alarmClockReminders.length;
               i++) {
            this.alarmClockName[i] = AlarmClockReminder.alarmClockReminders[i].reminderName
          }
        }
        this.isEdit = false
      }
      )
    return true
  }

  aboutToAppear() {
    PreferencesDataManager.getData('alarmClock').then((result) => {
      if (result !== undefined) {
        AlarmClockReminder.alarmClockReminders = result
        for (let i = 0; i < AlarmClockReminder.alarmClockReminders.length; i++) {
          this.alarmClockName[i] = AlarmClockReminder.alarmClockReminders[i].reminderName
        }
      }
    })
  }
}