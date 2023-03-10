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

const TAG: string = 'AlarmClockReminder'

class AlarmClockReminder {
  public alarmClockReminders: Reminder[] = []

  async setAlarmReminder(time: TimePickerResult) {
    let hour = time.hour < 10 ? `0${time.hour}` : time.hour
    let minute = time.minute < 10 ? `0${time.minute}` : time.minute
    let context: any = getContext(this)
    let selectTime: string = `${hour}:${minute}`
    let isExistName = this.alarmClockReminders.find(element => element.reminderName === selectTime) !== undefined
    if (!isExistName) {
      let reminder: Reminder = {
        audioSrc: '',
        audioTimeouts: 0,
        isStart: false,
        isVibrator: false,
        reminderId: 0,
        reminderName: '',
        vibratorTimeouts: 0,
        reminderRequestAlarm: undefined
      }
      await reminderAgent.addNotificationSlot({ type: notification.SlotType.CONTENT_INFORMATION })
      reminder.reminderName = selectTime
      let alarm: reminderAgent.ReminderRequestAlarm = {
        reminderType: reminderAgent.ReminderType.REMINDER_TYPE_ALARM,
        hour: time.hour,
        minute: time.minute,
        actionButton:
        [
          {
            title: context.resourceManager.getStringSync($r('app.string.alarm_clock_close').id),
            type: reminderAgent.ActionButtonType.ACTION_BUTTON_TYPE_CLOSE
          },
          {
            title: context.resourceManager.getStringSync($r('app.string.alarm_clock_postpone').id),
            type: reminderAgent.ActionButtonType.ACTION_BUTTON_TYPE_SNOOZE
          }
        ],
        slotType: notification.SlotType.CONTENT_INFORMATION,
        ringDuration: Constant.REMINDER_DURATION,
        wantAgent: { pkgName: 'ohos.samples.reminderagentmanager', abilityName: 'MainAbility' },
        title: context.resourceManager.getStringSync($r('app.string.alarm_clock').id),
        content: context.resourceManager.getStringSync($r('app.string.alarm_clock_reach').id),
        snoozeTimes: 0,
        timeInterval: 0,
        daysOfWeek: []
      }
      Logger.info(TAG, `this alarm clock is ${JSON.stringify(alarm)}`)
      reminder.reminderRequestAlarm = alarm
      reminder.isStart = false
      this.alarmClockReminders.push(reminder)
      Logger.info(TAG, `setAlarmReminder this all alarmclock is ${JSON.stringify(this.alarmClockReminders)}`)
      await PreferencesDataManager.putData('alarmClock', this.alarmClockReminders)
    } else {
      prompt.showToast({
        message: context.resourceManager.getStringSync($r('app.string.alarm_clock_existence').id),
        duration: Constant.PROMPT_DURATION
      })
    }
  }

  async setToggle(isOn: boolean, index: number) {
    this.alarmClockReminders[index].isStart = isOn
    if (isOn) {
      await reminderAgent.addNotificationSlot({ type: notification.SlotType.SOCIAL_COMMUNICATION })
      let reminderId = await reminderAgent.publishReminder(this.alarmClockReminders[index].reminderRequestAlarm)
      this.alarmClockReminders[index].reminderId = reminderId
      if (this.alarmClockReminders[index].audioSrc) {
        let audioIndex: number = await AudioPlayer.getAudioID(this.alarmClockReminders[index].audioSrc,
          TimeConversion.timeToMillisecond(this.alarmClockReminders[index].reminderRequestAlarm.hour,
          this.alarmClockReminders[index].reminderRequestAlarm.minute) * Constant.SECONDS_MILLISECONDS)
        this.alarmClockReminders[index].audioTimeouts = audioIndex
      }
      await PreferencesDataManager.putData('alarmClock', this.alarmClockReminders)
      if (this.alarmClockReminders[index].isVibrator) {
        let vibratorId = setTimeout(function () {
          vibrator.vibrate(Constant.VIBRATOR_DURATION, function (err) {
            if (err) {
              Logger.error(TAG, `setToggle this vibrator is failed err is ${JSON.stringify(err)}`)
            }
          })
        }, TimeConversion.timeToMillisecond(this.alarmClockReminders[index].reminderRequestAlarm.hour,
        this.alarmClockReminders[index].reminderRequestAlarm.minute) * Constant.SECONDS_MILLISECONDS)
        this.alarmClockReminders[index].vibratorTimeouts = vibratorId
        Logger.info(TAG, `setToggle this all alarmclock is ${JSON.stringify(this.alarmClockReminders)}`)
        await PreferencesDataManager.putData('alarmClock', this.alarmClockReminders)
      } else {
        clearTimeout(this.alarmClockReminders[index].vibratorTimeouts)
        await vibrator.stop(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME)
      }
    } else {
      clearTimeout(this.alarmClockReminders[index].vibratorTimeouts)
      clearTimeout(this.alarmClockReminders[index].audioTimeouts)
      await PreferencesDataManager.putData('alarmClock', this.alarmClockReminders)
      await reminderAgent.cancelReminder(this.alarmClockReminders[index].reminderId)
      await vibrator.stop(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME)
    }
  }

  async openDialog(dialog: CustomDialogController, index: number) {
    try {
      await reminderAgent.cancelReminder(this.alarmClockReminders[index].reminderId)
    } catch (err) {
      Logger.error(TAG, `openDialog this cancelReminder is not exist,err is ${JSON.stringify(err)}`)
    }
    dialog.open()
  }

  async deleteAlarmReminder(index: number) {
    try {
      clearTimeout(this.alarmClockReminders[index].vibratorTimeouts)
      clearTimeout(this.alarmClockReminders[index].audioTimeouts)
      reminderAgent.cancelReminder(this.alarmClockReminders[index].reminderId).then(() => {
        Logger.info(TAG, `deleteAlarmReminder cancelReminder is succeed`)
      }).catch((err) => {
        Logger.info(TAG, `deleteAlarmReminder cancelReminder is not exist err is ${JSON.stringify(err)}`)
      })
      vibrator.stop(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME).then(() => {
        Logger.info(TAG, `deleteAlarmReminder stop vibrator is succeed`)
      }).catch((err) => {
        Logger.error(TAG, `deleteAlarmReminder vibrator is not exist err is ${JSON.stringify(err)}`)
      })
      this.alarmClockReminders[index].isStart = false
      this.alarmClockReminders[index].reminderName = ''
      this.alarmClockReminders[index].vibratorTimeouts = 0
      this.alarmClockReminders[index].reminderRequestAlarm = undefined
    } catch (err) {
      Logger.info(TAG, `this cancel not exist err is ${JSON.stringify(err)}`)
    }
    this.alarmClockReminders.splice(index, 1)
    Logger.info(TAG, `deleteAlarmReminder this all alarmclock is ${JSON.stringify(this.alarmClockReminders)}`)
    PreferencesDataManager.putData('alarmClock', this.alarmClockReminders).then(() => {
      Logger.info(TAG, `deleteAlarmReminder this put data is successed`)
    })
  }
}

export default new AlarmClockReminder()