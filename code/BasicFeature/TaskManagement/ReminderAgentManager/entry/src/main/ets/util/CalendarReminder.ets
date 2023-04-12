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

import notification from '@ohos.notification'
import prompt from '@ohos.prompt'
import reminderAgent from '@ohos.reminderAgent'
import vibrator from '@ohos.vibrator'
import AudioPlayer from './AudioPlayer'
import Constant from '../common/Constant'
import Logger from './Logger'
import PreferencesDataManager from './PreferencesDataManager'
import { Reminder } from '../common/Reminder'
import TimeConversion from './TimeConversion'

const TAG: string = 'CalendarReminder'

class CalendarReminder {
  public calendarReminders: Reminder[] = []

  async setCalendar(date: DatePickerResult) {
    let month = date.month < 9 ? `0${date.month + 1}` : date.month
    let day = date.day < 10 ? `0${date.day}` : date.day
    let context: any = getContext(this)
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
      await reminderAgent.addNotificationSlot({ type: notification.SlotType.SERVICE_INFORMATION })
      reminder.reminderName = selectCalendar
      let calendar: reminderAgent.ReminderRequestCalendar = {
        reminderType: reminderAgent.ReminderType.REMINDER_TYPE_CALENDAR,
        dateTime: {
          year: date.year,
          month: date.month + 1,
          day: date.day,
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
        slotType: notification.SlotType.CONTENT_INFORMATION
      }
      Logger.info(TAG, `setCalendar this calendar is ${JSON.stringify(calendar)}}`)
      reminder.reminderRequestCalendar = calendar
      reminder.isStart = false
      this.calendarReminders.push(reminder)
      Logger.info(TAG, `setCalendar this all calendar is ${JSON.stringify(this.calendarReminders)}`)
      await PreferencesDataManager.putData('Calendar', this.calendarReminders)
    } else {
      prompt.showToast({
        message: context.resourceManager.getStringSync($r('app.string.calendar_existence').id),
        duration: Constant.PROMPT_DURATION
      })
    }
  }

  async setToggle(isOn: boolean, index: number) {
    this.calendarReminders[index].isStart = isOn
    if (isOn) {
      await reminderAgent.addNotificationSlot({ type: notification.SlotType.SERVICE_INFORMATION });
      let reminderId = await reminderAgent.publishReminder(this.calendarReminders[index].reminderRequestCalendar)
      this.calendarReminders[index].reminderId = reminderId;
      if (this.calendarReminders[index].audioSrc) {
        let audioIndex: number = await AudioPlayer.getAudioID(
        this.calendarReminders[index].audioSrc, TimeConversion.dateToMillisecond(
        this.calendarReminders[index].reminderRequestCalendar.dateTime.year,
        this.calendarReminders[index].reminderRequestCalendar.dateTime.month,
        this.calendarReminders[index].reminderRequestCalendar.dateTime.day,
        this.calendarReminders[index].reminderRequestCalendar.dateTime.hour,
        this.calendarReminders[index].reminderRequestCalendar.dateTime.minute) * Constant.SECONDS_MILLISECONDS);
        this.calendarReminders[index].audioTimeouts = audioIndex;
      }
      await PreferencesDataManager.putData('Calendar', this.calendarReminders)
      if (this.calendarReminders[index].isVibrator) {
        let vibratorId = setTimeout(function () {
          vibrator.vibrate(Constant.VIBRATOR_DURATION, function (err) {
            if (err) {
              Logger.error(TAG, `setToggle this vibrator is failed err is ${JSON.stringify(err)}`)
            } else {
              Logger.info(TAG, `setToggle this vibrator is successed`)
            }
          })
        }, TimeConversion.dateToMillisecond(this.calendarReminders[index].reminderRequestCalendar.dateTime.year,
        this.calendarReminders[index].reminderRequestCalendar.dateTime.month,
        this.calendarReminders[index].reminderRequestCalendar.dateTime.day,
        this.calendarReminders[index].reminderRequestCalendar.dateTime.hour,
        this.calendarReminders[index].reminderRequestCalendar.dateTime.minute) * Constant.SECONDS_MILLISECONDS)
        this.calendarReminders[index].vibratorTimeouts = vibratorId
        await PreferencesDataManager.putData('Calendar', this.calendarReminders)
      } else {
        clearTimeout(this.calendarReminders[index].vibratorTimeouts)
        await vibrator.stop(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME)
      }
    } else {
      clearTimeout(this.calendarReminders[index].vibratorTimeouts)
      clearTimeout(this.calendarReminders[index].audioTimeouts)
      await PreferencesDataManager.putData('Calendar', this.calendarReminders);
      await reminderAgent.cancelReminder(this.calendarReminders[index].reminderId)
      await vibrator.stop(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME)
    }
  }

  async openDialog(dialog: CustomDialogController, index: number) {
    try {
      await reminderAgent.cancelReminder(this.calendarReminders[index].reminderId)
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
        Logger.info(TAG, `deleteCalendar cancelReminder is succeed`)
      })
      vibrator.stop(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME).then(() => {
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