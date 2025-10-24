/*
 * Copyright (c) 2022-2025 Huawei Device Co., Ltd.
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
import vibrator from '@ohos.vibrator';
import AudioPlayer from './AudioPlayer';
import Constant from '../common/Constant';
import Logger from './Logger';
import PreferencesDataManager from './PreferencesDataManager';
import { Reminder } from '../common/Reminder';
import TimeConversion from './TimeConversion';
import common from '@ohos.app.ability.common';
import notificationManager from '@ohos.notificationManager';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';

const TAG: string = 'CalendarReminder';

class CalendarReminder {
  public calendarReminders: Reminder[] = [];

  setCalendarReminder() {
  }

  async setCalendar(date: Date) {
    let context = getContext(this) as common.UIAbilityContext;
    let selectCalendar: string = `${date.getFullYear()}-${date.getUTCMonth() + 1}-${date.getDate()} ${date.getHours()}:${date.getMinutes()}`;
    let isExistName = this.calendarReminders.find(element => element.reminderName === selectCalendar) !== undefined;
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
      // [Start calendar_reminder]
      let calendar: reminderAgent.ReminderRequestCalendar = {
        reminderType: reminderAgent.ReminderType.REMINDER_TYPE_CALENDAR,
        dateTime: {
          year: date.getFullYear(),
          month: date.getUTCMonth() + 1,
          day: date.getDate(),
          hour: date.getHours(),
          minute: date.getMinutes(),
        },
        actionButton:
        [{
          title: context.resourceManager.getStringSync($r('app.string.calendar_close').id),
          type: reminderAgent.ActionButtonType.ACTION_BUTTON_TYPE_CLOSE
        }],
        wantAgent: { pkgName: 'com.example.reminderagentmanager', abilityName: 'EntryAbility' },
        ringDuration: Constant.REMINDER_DURATION,
        title: context.resourceManager.getStringSync($r('app.string.calendar').id),
        content: context.resourceManager.getStringSync($r('app.string.calendar_reach').id),
        slotType: notificationManager.SlotType.CONTENT_INFORMATION
      }
      // [End calendar_reminder]
      Logger.info(TAG, `setCalendar this calendar is ${JSON.stringify(calendar)}}`);
      reminder.reminderRequestCalendar = calendar
      reminder.isStart = false
      this.calendarReminders.push(reminder)
      Logger.info(TAG, `setCalendar this all calendar is ${JSON.stringify(this.calendarReminders)}`);
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
      await reminderAgent.addNotificationSlot({ notificationType: notificationManager.SlotType.SERVICE_INFORMATION });
      // [Start publish_reminder]
      let reminderId: number = await reminderAgent.publishReminder(
        this.calendarReminders[index].reminderRequestCalendar!);
      this.calendarReminders[index].reminderId = reminderId;
      // [End publish_reminder]
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
                Logger.error(TAG, `setToggle this vibrator is failed err is ${JSON.stringify(err)}`);
              } else {
                Logger.info(TAG, `setToggle this vibrator is successed`);
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
      // [Start cancel_reminder]
      await reminderAgent.cancelReminder(this.calendarReminders[index].reminderId);
      // [Start cancel_reminder]
      await vibrator.stopVibration(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME);
    }
  }

  async openDialog(dialog: CustomDialogController, index: number) {
    try {
      await reminderAgent.cancelReminder(this.calendarReminders[index].reminderId);
    } catch (err) {
      Logger.error(TAG, `openDialog this cancelReminder is not exist,err is ${JSON.stringify(err)}`)
    }
    dialog.open()
  }

  async deleteCalendar(index: number) {
    try {
      clearTimeout(this.calendarReminders[index].vibratorTimeouts)
      clearTimeout(this.calendarReminders[index].audioTimeouts)
      reminderAgent.cancelReminder(this.calendarReminders[index].reminderId).then(() => {
        Logger.info(TAG, `deleteCalendar cancelReminder is succeed`);
      })
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