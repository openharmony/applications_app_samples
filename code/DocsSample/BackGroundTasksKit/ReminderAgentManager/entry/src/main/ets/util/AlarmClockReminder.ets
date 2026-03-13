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

import notificationManager from '@ohos.notificationManager';
import { reminderAgentManager } from '@kit.BackgroundTasksKit';
import vibrator from '@ohos.vibrator';
import AudioPlayer from './AudioPlayer';
import Constant from '../common/Constant';
import Logger from './Logger';
import PreferencesDataManager from './PreferencesDataManager';
import { Reminder } from '../common/Reminder';
import TimeConversion from './TimeConversion';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import { promptAction } from '@kit.ArkUI';

const TAG: string = 'AlarmClockReminder';

class AlarmClockReminder {
  public alarmClockReminders: Reminder[] = []
  private date: Date = new Date();

  async setAlarmReminder(time: TimePickerResult) {
    let hour = time.hour! < 10 ? `0${time.hour}` : time.hour;
    let minute = time.minute! < 10 ? `0${time.minute}` : time.minute;
    let context = getContext(this) as common.UIAbilityContext;
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
      await reminderAgentManager.addNotificationSlot({
        notificationType: notificationManager.SlotType.CONTENT_INFORMATION
      });
      reminder.reminderName = selectTime
      // [Start alarm_reminder]
      let alarm: reminderAgentManager.ReminderRequestAlarm = {
        reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_ALARM,  // 提醒类型为闹钟类型
        hour: time.hour,  // 指明提醒的目标时刻
        minute: time.minute,  // 指明提醒的目标分钟
        actionButton:  // 设置弹出的提醒通知信息上显示的按钮类型和标题
        [
          {
            title: context.resourceManager.getStringSync($r('app.string.alarm_clock_close').id),  // "app.string.alarm_clock_close"资源文件中的value值为"关闭闹钟"
            type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_CLOSE
          },
          {
            title: context.resourceManager.getStringSync($r('app.string.alarm_clock_postpone').id),  // "app.string.alarm_clock_postpone"资源文件中的value值为"推迟闹钟"
            type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_SNOOZE
          }
        ],
        slotType: notificationManager.SlotType.CONTENT_INFORMATION,  // 指明提醒的Slot类型
        ringDuration: Constant.REMINDER_DURATION,  // 指明响铃时长（单位：秒）
        wantAgent: {  // 点击提醒通知后跳转的目标UIAbility信息
          pkgName: 'com.example.reminderagentmanager',
          abilityName: 'EntryAbility'
        },
        title: context.resourceManager.getStringSync($r('app.string.alarm_clock').id),  // 指明提醒标题, "app.string.alarm_clock"资源文件中的value值为"闹钟"
        content: context.resourceManager.getStringSync($r('app.string.alarm_clock_reach').id),  // 指明提醒内容, "app.string.alarm_clock_reach"资源文件中的value值为"闹钟时间已到"
        snoozeTimes: 0,  // 指明延迟提醒次数
        timeInterval: 0,  // 执行延迟提醒间隔（单位：秒）
        daysOfWeek: []  // 指明每周哪几天需要重复提醒
      }
      // [End alarm_reminder]
      Logger.info(TAG, `this alarm clock is ${JSON.stringify(alarm)}`)
      reminder.reminderRequestAlarm = alarm
      reminder.isStart = false
      this.alarmClockReminders.push(reminder)
      Logger.info(TAG, `setAlarmReminder this all alarmclock is ${JSON.stringify(this.alarmClockReminders)}`)
      await PreferencesDataManager.putData('alarmClock', this.alarmClockReminders)
    } else {
      promptAction.showToast({
        message: context.resourceManager.getStringSync($r('app.string.alarm_clock_existence').id),
        duration: Constant.PROMPT_DURATION
      })
    }
  }

  async setToggle(isOn: boolean, index: number) {
    let hour = this.alarmClockReminders[index].reminderRequestAlarm!.hour;
    let minute = this.alarmClockReminders[index].reminderRequestAlarm!.minute;
    let selectTime: string = `${hour}:${minute}`;
    let year = this.date.getFullYear();
    let month = this.date.getMonth() + 1;
    let day = this.date.getDate();
    this.alarmClockReminders[index].isStart = isOn
    if (isOn) {
      await reminderAgentManager.addNotificationSlot(
        { notificationType: notificationManager.SlotType.SOCIAL_COMMUNICATION });
      let reminderId = await reminderAgentManager.publishReminder(
        this.alarmClockReminders[index].reminderRequestAlarm!);
      Logger.info(TAG, `publish reminder result: id is ${reminderId}`);
      this.alarmClockReminders[index].reminderId = reminderId;
      if (this.alarmClockReminders[index].audioSrc) {
        let audioIndex: number = await AudioPlayer.getAudioID(this.alarmClockReminders[index].audioSrc,
          TimeConversion.timeToMillisecond(this.alarmClockReminders[index].reminderRequestAlarm!.hour,
            this.alarmClockReminders[index].reminderRequestAlarm!.minute) * Constant.SECONDS_MILLISECONDS);
        this.alarmClockReminders[index].audioTimeouts = audioIndex
      }
      await PreferencesDataManager.putData('alarmClock', this.alarmClockReminders)
      if (this.alarmClockReminders[index].isVibrator) {
        let vibratorId: number = 0;
        try {
          vibratorId = setTimeout(() => {
            vibrator.startVibration({
              type: 'time',
              duration: Constant.VIBRATOR_DURATION
            }, {
              id: 0,
              usage: 'alarm'
            })
              .then(() => {
                Logger.info(TAG, `succeed in starting vibration`);
              }, (error: BusinessError) => {
                Logger.error(TAG, `setToggle this vibrator is failed.
                  code: ${JSON.stringify(error.code)}, message: ${JSON.stringify(error.message)}`);
              });
          }, TimeConversion.timeToMillisecond(this.alarmClockReminders[index].reminderRequestAlarm!.hour,
            this.alarmClockReminders[index].reminderRequestAlarm!.minute) * Constant.SECONDS_MILLISECONDS);
        } catch (err) {
          Logger.error(TAG, `start vibration error occurred.
            code: ${JSON.stringify(err.code)}, message: ${JSON.stringify(err.message)}`);
        }
        this.alarmClockReminders[index].vibratorTimeouts = vibratorId;
        await PreferencesDataManager.putData('alarmClock', this.alarmClockReminders);
      } else {
        clearTimeout(this.alarmClockReminders[index].vibratorTimeouts);
        await vibrator.stopVibration(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME);
      }
    } else {
      clearTimeout(this.alarmClockReminders[index].vibratorTimeouts)
      clearTimeout(this.alarmClockReminders[index].audioTimeouts)
      await PreferencesDataManager.putData('alarmClock', this.alarmClockReminders)
      await reminderAgentManager.cancelReminder(this.alarmClockReminders[index].reminderId);
      await vibrator.stopVibration(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME);
    }
  }

  async openDialog(dialog: CustomDialogController, index: number) {
    dialog.open();
  }

  async deleteAlarmReminder(index: number) {
    try {
      clearTimeout(this.alarmClockReminders[index].vibratorTimeouts)
      clearTimeout(this.alarmClockReminders[index].audioTimeouts)
      reminderAgentManager.cancelReminder(this.alarmClockReminders[index].reminderId).then(() => {
        Logger.info(TAG, `deleteAlarmReminder cancelReminder is succeed`);
      }).catch((err: BusinessError) => {
        Logger.info(TAG, `deleteAlarmReminder cancelReminder is not exist err is ${JSON.stringify(err)}`);
      })
      vibrator.stopVibration(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME).then(() => {
        Logger.info(TAG, `deleteAlarmReminder stop vibrator is succeed`)
      }).catch((err: BusinessError) => {
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