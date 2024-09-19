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

import StorageModel from '../model/StorageModel';
import reminderAgentManager from '@ohos.reminderAgentManager';
import Logger from '../model/Logger';
import { calendarManager } from '@kit.CalendarKit';
import { calendarMgr } from '../entryability/EntryAbility';
import { BusinessError } from '@kit.BasicServicesKit';

interface DateTime {
  hour: string,
  minute: string,
  reminderId: number,
}

@CustomDialog
export struct CustomDatePicker {
  @State year: number = 0;
  @State month: number = 0;
  @State day: number = 0;
  @State hour: number = 0;
  @State minute: number = 0;
  @State seconds: number = 0;
  @State reminderId: number = 0;
  @State hourTest: string = '';
  @State minuteTest: string = '';
  @State secondTest: string = '';
  private total: number = 0;
  private selectedTime: Date = new Date();
  private controller: CustomDialogController;
  private countChange: (result: number) => void = () => {};
  private calendar : calendarManager.Calendar | undefined = undefined;
  @Link isDefault: boolean;

  aboutToAppear() {
    this.year = this.selectedTime.getFullYear();
    this.month = this.selectedTime.getMonth() + 1;
    this.day = this.selectedTime.getDate();
    this.hour = this.selectedTime.getHours();
    this.minute = this.selectedTime.getMinutes();
    this.seconds = this.selectedTime.getSeconds();
    this.hourTest = (this.hour > 9 ? '' : '0') + this.hour;
    this.minuteTest = (this.minute > 9 ? '' : '0') + this.minute;
    this.secondTest = (this.seconds > 9 ? '' : '0') + this.seconds;
    if (this.isDefault === false) {
      this.setCalendarReminder();
    }
  }

  setCalendarReminder(){
    let config: calendarManager.CalendarConfig = {
      enableReminder: true,
      color: '#aabbcc',
    };
    calendarMgr?.getCalendar(async (err: BusinessError, data:calendarManager.Calendar) => {
      if (err) {
        Logger.error(`Failed to get calendar. Code: {err.code}, message: {err.code}, message: {err.message}`);
      } else {
        Logger.info(`Succeeded in getting calendar, data ->` + JSON.stringify(data));
        this.calendar = data;
        await this.calendar.setConfig(config).then(() => {
          Logger.info(`Succeeded in setting config, config -> ` + JSON.stringify(config));
        }).catch((err: BusinessError) => {
          Logger.error(`Failed to set config. Code: {err.code}, message: {err.message}`);
        });
      }
    });
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.hour'))
          .fontSize(20)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Text($r('app.string.minute'))
          .fontSize(20)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .margin({ top: 20, bottom: 10 })

      Column() {
        TimePicker({
          selected: this.selectedTime,
        })
          .id('timePicker')
          .useMilitaryTime(true)
          .onChange((date) => {
            this.hour = date.hour;
            this.minute = date.minute;
            this.hourTest = (date.hour > 9 ? '' : '0') + date.hour;
            this.minuteTest = (date.minute > 9 ? '' : '0') + date.minute;
          })
      }
      .height('30%')

      Row() {
        Button($r('app.string.yes'))
          .id('yes')
          .fontSize(20)
          .fontColor(Color.Blue)
          .layoutWeight(1)
          .backgroundColor(Color.White)
          .onClick(async () => {
            if (this.isDefault === true) {
              let reminderRequest: reminderAgentManager.ReminderRequestAlarm = {
                reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_ALARM,
                hour: this.hour,
                minute: this.minute,
                title: getContext(this).resourceManager.getStringSync($r('app.string.alarmClock')),
                maxScreenWantAgent: {
                  pkgName: 'ohos.samples.flipclock',
                  abilityName: 'ohos.samples.flipclock.EntryAbility'
                },
                ringDuration: 5
              }
              this.reminderId = await reminderAgentManager.publishReminder(reminderRequest);
            } else {
              let selectDate = this.year + '-' + this.month + '-' + this.day + ' ' + this.hourTest + ':' + this.minuteTest + ':' + this.secondTest;
              Logger.info(`selectDate: ${selectDate}`);
              let event: calendarManager.Event = {
                type: calendarManager.EventType.NORMAL,
                startTime: Date.parse(selectDate),
                endTime: Date.parse(selectDate) + 60 * 60 * 1000,
                reminderTime: [0],
                title: getContext(this).resourceManager.getStringSync($r('app.string.alarmClock'))
              };
              await this.calendar!.addEvent(event).then((data: number) => {
                Logger.info(`Succeeded in adding event, id -> {data}`);
                this.reminderId = data;
                Logger.info(`this.reminderId is` + JSON.stringify(this.reminderId));
              }).catch((err: BusinessError) => {
                Logger.error(`Failed to add event. Code: {err.code}, message: {err.code}, message: {err.message}` + JSON.stringify(err));
              });
            }
            let dateTime: DateTime = { hour: this.hourTest, minute: this.minuteTest, reminderId: this.reminderId };
            Logger.info(`dateTime: ` + dateTime);
            StorageModel.getInstance().putStorageValue(`alarmClock${this.total}`, dateTime);
            this.total += 1;
            StorageModel.getInstance().putTotalStorageValue('amount', this.total);
            this.controller.close();
            this.countChange(this.total);
          })

        Button($r('app.string.no'))
          .fontSize(20)
          .fontColor(Color.Red)
          .backgroundColor(Color.White)
          .layoutWeight(1)
          .onClick(() => {
            this.controller.close();
          })
      }
      .margin({ top: 10, bottom: 20 })
    }
    .width('100%')
  }
}