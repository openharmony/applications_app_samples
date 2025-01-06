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

import reminderAgent from '@ohos.reminderAgentManager';
import vibrator from '@ohos.vibrator'
import AudioPlayer from './AudioPlayer'
import Constant from '../common/Constant'
import Logger from './Logger'
import PreferencesDataManager from './PreferencesDataManager'
import { Reminder } from '../common/Reminder'
import TimeConversion from './TimeConversion'
import common from '@ohos.app.ability.common';
import notificationManager from '@ohos.notificationManager';
import { BusinessError, deviceInfo } from '@kit.BasicServicesKit';
import { calendarManager } from '@kit.CalendarKit';
import { calendarMgr } from '../MainAbility/MainAbility';
import { promptAction } from '@kit.ArkUI';

let deviceTypeInfo: string = deviceInfo.deviceType;
let calendar: calendarManager.Calendar | undefined = undefined;
const TAG: string = 'CalendarReminder'

class CalendarReminder {
  public calendarReminders: Reminder[] = []

  setCalendarReminder() {
    let config: calendarManager.CalendarConfig = {
      enableReminder: true,
      color: '#aabbcc',
    };

    calendarMgr?.getCalendar(async (err: BusinessError, data: calendarManager.Calendar) => {
      if (err) {
        Logger.error(TAG, `Failed to get calendar.code: ${JSON.stringify(err.code)}, message: ${JSON.stringify(err.message)}`);
      } else {
        Logger.info(TAG, `Succeeded in getting calendar, data ->` + JSON.stringify(data));
        calendar = data;
        await calendar!.setConfig(config).then(() => {
          Logger.info(TAG, `Succeeded in setting config, config -> ` + JSON.stringify(config));
        }).catch((err: BusinessError) => {
          Logger.error(TAG, `Failed to set config. code: ${JSON.stringify(err.code)}, message: ${JSON.stringify(err.message)}`);
        });
      }
    });
  }

  async setCalendar(date: DatePickerResult) {
    let month = date.month! < 9 ? `0${date.month! + 1}` : `${date.month! + 1}`;
    let day = date.day! < 10 ? `0${date.day}` : date.day;
    let context = getContext(this) as common.UIAbilityContext;
    let selectCalendar: string = `${date.year}-${month}-${day}`
    let isExistName = this.calendarReminders.find(element => element.reminderName === selectCalendar) !== undefined
    if (!isExistName) {
      let reminder: Reminder = {
        audioSrc: '',
        audioTimeouts: 0,
        isStart: false,
        isVibrator: false,
        reminderId: 0,
        reminderName: '',
        vibratorTimeouts: 0,
        reminderRequestCalendar: undefined
      }
      await reminderAgent.addNotificationSlot({ notificationType: notificationManager.SlotType.SERVICE_INFORMATION });
      reminder.reminderName = selectCalendar
      let calendar: reminderAgent.ReminderRequestCalendar = {
        reminderType: reminderAgent.ReminderType.REMINDER_TYPE_CALENDAR,
        dateTime: {
          year: date.year!,
          month: date.month! + 1,
          day: date.day!,
          hour: 0,
          minute: 0,
        },
        actionButton:
        [{
          title: context.resourceManager.getStringSync($r('app.string.calendar_close').id),
          type: reminderAgent.ActionButtonType.ACTION_BUTTON_TYPE_CLOSE
        }],
        wantAgent: { pkgName: 'ohos.samples.reminderagentmanager', abilityName: 'MainAbility' },
        ringDuration: Constant.REMINDER_DURATION,
        title: context.resourceManager.getStringSync($r('app.string.calendar').id),
        content: context.resourceManager.getStringSync($r('app.string.calendar_reach').id),
        slotType: notificationManager.SlotType.CONTENT_INFORMATION
      }
      Logger.info(TAG, `setCalendar this calendar is ${JSON.stringify(calendar)}}`)
      reminder.reminderRequestCalendar = calendar
      reminder.isStart = false
      this.calendarReminders.push(reminder)
      Logger.info(TAG, `setCalendar this all calendar is ${JSON.stringify(this.calendarReminders)}`)
      await PreferencesDataManager.putData('Calendar', this.calendarReminders)
      this.setCalendarReminder();
    } else {
      promptAction.showToast({
        message: context.resourceManager.getStringSync($r('app.string.calendar_existence').id),
        duration: Constant.PROMPT_DURATION
      })
    }
  }

  async setToggle(isOn: boolean, index: number) {
    this.calendarReminders[index].isStart = isOn
    if (isOn) {
      if (deviceTypeInfo === 'default') {
        await reminderAgent.addNotificationSlot({ notificationType: notificationManager.SlotType.SERVICE_INFORMATION });
        let reminderId: number = await reminderAgent.publishReminder(
          this.calendarReminders[index].reminderRequestCalendar!);
        this.calendarReminders[index].reminderId = reminderId;
      } else {
        let context = getContext(this) as common.UIAbilityContext;
        let year = this.calendarReminders[index].reminderRequestCalendar!.dateTime.year;
        let month = this.calendarReminders[index].reminderRequestCalendar!.dateTime.month;
        let day = this.calendarReminders[index].reminderRequestCalendar!.dateTime.day;
        let dateHour = this.calendarReminders[index].reminderRequestCalendar!.dateTime.hour;
        let dateMinute = this.calendarReminders[index].reminderRequestCalendar!.dateTime.minute;
        let hour = dateHour < 10 ? `0${dateHour}` : dateHour;
        let minute = dateMinute < 10 ? `0${dateMinute}` : dateMinute;
        let selectDate = `${year}-${month}-${day} ${hour}:${minute}`;
        Logger.info(TAG, `selectDate:${JSON.stringify(selectDate)}`);
        let event: calendarManager.Event = {
          type: calendarManager.EventType.NORMAL,
          title: context.resourceManager.getStringSync($r('app.string.calendar').id),
          description: context.resourceManager.getStringSync($r('app.string.calendar_reach').id),
          reminderTime: [0],
          startTime: Date.parse(selectDate),
          endTime: Date.parse(selectDate) + 60 * 1000,
        };
        await calendar!.addEvent(event)
          .then((data: number) => {
            Logger.info(TAG, `Succeeded in adding event, id -> {data}`);
            this.calendarReminders[index].reminderId = data;
            Logger.info(TAG, `reminder.reminderId is` + JSON.stringify(this.calendarReminders[index].reminderId));
          })
          .catch((err: BusinessError) => {
            Logger.error(TAG, `Failed to add event.code: ${err.code}, message: ${err.message}`);
          });
      }
      if (this.calendarReminders[index].audioSrc) {
        let audioIndex: number = await AudioPlayer.getAudioID(
          this.calendarReminders[index].audioSrc, TimeConversion.dateToMillisecond(
          this.calendarReminders[index].reminderRequestCalendar!.dateTime.year,
          this.calendarReminders[index].reminderRequestCalendar!.dateTime.month,
          this.calendarReminders[index].reminderRequestCalendar!.dateTime.day,
          this.calendarReminders[index].reminderRequestCalendar!.dateTime.hour,
          this.calendarReminders[index].reminderRequestCalendar!.dateTime.minute) * Constant.SECONDS_MILLISECONDS);
        this.calendarReminders[index].audioTimeouts = audioIndex;
      }
      await PreferencesDataManager.putData('Calendar', this.calendarReminders)
      if (this.calendarReminders[index].isVibrator) {
        let vibratorId: number = 0;
        try {
          vibratorId = setTimeout(() => {
            vibrator.startVibration({
              type: 'time',
              duration: Constant.VIBRATOR_DURATION,
            }, {
              id: 0,
              usage: 'alarm'
            }, (err) => {
              if (err) {
                Logger.error(TAG, `setToggle this vibrator is failed err is ${JSON.stringify(err)}`)
              } else {
                Logger.info(TAG, `setToggle this vibrator is successed`)
              }
            })
          }, TimeConversion.dateToMillisecond(this.calendarReminders[index].reminderRequestCalendar!.dateTime.year,
            this.calendarReminders[index].reminderRequestCalendar!.dateTime.month,
            this.calendarReminders[index].reminderRequestCalendar!.dateTime.day,
            this.calendarReminders[index].reminderRequestCalendar!.dateTime.hour,
            this.calendarReminders[index].reminderRequestCalendar!.dateTime.minute) * Constant.SECONDS_MILLISECONDS);
        } catch (err) {
          Logger.error(TAG, `setToggle this vibrator occurred.
            code: ${JSON.stringify(err.code)}, message: ${JSON.stringify(err.message)}`);
        }
        this.calendarReminders[index].vibratorTimeouts = vibratorId
        await PreferencesDataManager.putData('Calendar', this.calendarReminders)
      } else {
        clearTimeout(this.calendarReminders[index].vibratorTimeouts)
        await vibrator.stopVibration(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME);
      }
    } else {
      clearTimeout(this.calendarReminders[index].vibratorTimeouts)
      clearTimeout(this.calendarReminders[index].audioTimeouts)
      await PreferencesDataManager.putData('Calendar', this.calendarReminders);
      if (deviceTypeInfo === 'default') {
        await reminderAgent.cancelReminder(this.calendarReminders[index].reminderId);
      } else {
        await calendar!.deleteEvent(this.calendarReminders[index].reminderId);
      }
      await vibrator.stopVibration(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME);
    }
  }

  async openDialog(dialog: CustomDialogController, index: number) {
    try {
      if (deviceTypeInfo === 'default') {
        await reminderAgent.cancelReminder(this.calendarReminders[index].reminderId);
      } else {
        await calendar!.deleteEvent(this.calendarReminders[index].reminderId);
      }
    } catch (err) {
      Logger.error(TAG, `openDialog this cancelReminder is not exist,err is ${JSON.stringify(err)}`)
    }
    dialog.open()
  }

  async deleteCalendar(index: number) {
    try {
      clearTimeout(this.calendarReminders[index].vibratorTimeouts)
      clearTimeout(this.calendarReminders[index].audioTimeouts)
      if (deviceTypeInfo === 'default') {
        reminderAgent.cancelReminder(this.calendarReminders[index].reminderId).then(() => {
          Logger.info(TAG, `deleteCalendar cancelReminder is succeed`);
        })
      } else {
        calendar!.deleteEvent(this.calendarReminders[index].reminderId).then(() => {
          Logger.info(TAG, `deleteCalendar cancelReminder is succeed`);
        })
      }
      vibrator.stopVibration(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME).then(() => {
        Logger.info(TAG, `deleteCalendar stop vibrator is succeed`)
      })
      this.calendarReminders[index].isStart = false
      this.calendarReminders[index].reminderName = ''
      this.calendarReminders[index].vibratorTimeouts = 0
      this.calendarReminders[index].reminderRequestCalendar = undefined
    } catch (err) {
      Logger.info(TAG, `deleteCalendar this cancel not exist err is ${JSON.stringify(err)}`)
    }
    this.calendarReminders.splice(index, 1)
    Logger.info(TAG, `deleteCalendar this all calendar is ${JSON.stringify(this.calendarReminders)}`)
    PreferencesDataManager.putData('Calendar', this.calendarReminders).then(() => {
      Logger.info(TAG, `deleteCalendar this put data is successed`)
    })
  }
}

export default new CalendarReminder()