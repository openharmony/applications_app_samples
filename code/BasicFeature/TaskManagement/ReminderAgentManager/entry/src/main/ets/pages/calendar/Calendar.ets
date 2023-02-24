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

import { CalendarSetting } from './CalendarSetting'
import CalendarReminder from '../../util/CalendarReminder'
import PreferencesDataManager from '../../util/PreferencesDataManager'

@Component
export struct ReminderCalendar {
  @State isEdit: boolean = false
  @State selectCalendar: number = 0
  @State calendarNames: string[] = []
  private title: string
  private calendarSetting: CustomDialogController = new CustomDialogController({
    builder: CalendarSetting({ selectIndex: this.selectCalendar })
  })

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize(24)
          .margin({ left: 8 })
        Blank()
        Image($r('app.media.ic_public_add'))
          .width(24)
          .height(24)
          .margin({ right: 8 })
          .onClick(() => {
            DatePickerDialog.show({
              start: new Date(),
              end: new Date('2100-12-31'),
              onAccept: async (value: DatePickerResult) => {
                await CalendarReminder.setCalendar(value)
                if (CalendarReminder.calendarReminders.length !== 0) {
                  for (let i = 0; i < CalendarReminder.calendarReminders.length; i++) {
                    this.calendarNames[i] = CalendarReminder.calendarReminders[i].reminderName
                  }
                } else {
                  this.calendarNames = []
                }
              }
            })
          })
      }
      .height(56)
      .padding(8)
      .width('100%')

      List({ space: 8 }) {
        ForEach(this.calendarNames, (item, index) => {
          ListItem() {
            Row() {
              Text(item)
                .fontSize(24)
              Blank()
              Toggle({ type: ToggleType.Switch, isOn: CalendarReminder.calendarReminders[index].isStart })
                .margin({ left: 8 })
                .onChange(async (isOn: boolean) => {
                  await CalendarReminder.setToggle(isOn, index)
                })
            }
            .width('100%')
            .borderRadius(24)
            .backgroundColor(Color.White)
            .padding({ left: 12, right: 12, top: 8, bottom: 8 })
          }
          .editable(this.isEdit)
          .padding({ left: 12, right: 12 })
          .gesture(
          SwipeGesture({ direction: SwipeDirection.Horizontal })
            .onAction((event: GestureEvent) => {
              this.isEdit = !this.isEdit
              this.deleteItem(index)
            })
          )
          .onClick(async () => {
            this.selectCalendar = index
            CalendarReminder.calendarReminders[index].isStart = false
            await CalendarReminder.openDialog(this.calendarSetting, index)
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
  }

  deleteItem(index: number): boolean {
    CalendarReminder.deleteCalendar(index).then(() => {
      this.calendarNames = []
      if (CalendarReminder.calendarReminders.length !== 0) {
        for (let i = 0; i < CalendarReminder.calendarReminders.length; i++) {
          this.calendarNames[i] = CalendarReminder.calendarReminders[i].reminderName
        }
      }
      this.isEdit = false
    })
    return true
  }

  aboutToAppear() {
    PreferencesDataManager.getData('Calendar').then((result) => {
      if (result !== undefined) {
        CalendarReminder.calendarReminders = result
        for (let i = 0; i < CalendarReminder.calendarReminders.length; i++) {
          this.calendarNames[i] = CalendarReminder.calendarReminders[i].reminderName
        }
      }
    })
  }
}