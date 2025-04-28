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
import reminderAgent from '@ohos.reminderAgentManager';
import vibrator from '@ohos.vibrator';
import AudioPlayer from './AudioPlayer';
import Constant from '../common/Constant';
import Logger from './Logger';
import PreferencesDataManager from './PreferencesDataManager';
import { Reminder } from '../common/Reminder';
import TimeConversion from './TimeConversion';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import { deviceInfo } from '@kit.BasicServicesKit';
import { calendarManager } from '@kit.CalendarKit';
import { calendarMgr } from '../MainAbility/MainAbility';
import { promptAction } from '@kit.ArkUI';

const TAG: string = 'AlarmClockReminder';
let deviceTypeInfo: string = deviceInfo.deviceType;
let calendar: calendarManager.Calendar | undefined = undefined;

class AlarmClockReminder {
  public alarmClockReminders: Reminder[] = []
  private date: Date = new Date();

  setCalendarReminder() {
    let config: calendarManager.CalendarConfig = {
      // 日历配置信息
      enableReminder: true,
      color: '#aabbcc',
    };

    calendarMgr?.getCalendar(async (err: BusinessError, data: calendarManager.Calendar) => {
      if (err) {
        Logger.error(TAG, `Failed to get calendar.code: ${JSON.stringify(err.code)}, message: ${JSON.stringify(err.message)}`);
      } else {
        Logger.info(TAG, `Succeeded in getting calendar, data ->` + JSON.stringify(data));
        calendar = data;
        // 设置日历配置信息
        await calendar!.setConfig(config).then(() => {
          Logger.info(TAG, `Succeeded in setting config, config -> ` + JSON.stringify(config));
        }).catch((err: BusinessError) => {
          Logger.error(TAG, `Failed to set config. code: ${JSON.stringify(err.code)}, message: ${JSON.stringify(err.message)}`);
        });
      }
    });
  }

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
      await reminderAgent.addNotificationSlot({
        notificationType: notificationManager.SlotType.CONTENT_INFORMATION
      });
      reminder.reminderName = selectTime
      let alarm: reminderAgent.ReminderRequestAlarm = {
        reminderType: reminderAgent.ReminderType.REMINDER_TYPE_ALARM,
        hour: time.hour!,
        minute: time.minute!,
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
        slotType: notificationManager.SlotType.CONTENT_INFORMATION,
        ringDuration: Constant.REMINDER_DURATION,
        wantAgent: {
          pkgName: 'ohos.samples.reminderagentmanager',
          abilityName: 'MainAbility'
        },
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
      this.setCalendarReminder();
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
      if (deviceTypeInfo === 'default') {
        await reminderAgent.addNotificationSlot(
          { notificationType: notificationManager.SlotType.SOCIAL_COMMUNICATION });
        let reminderId = await reminderAgent.publishReminder(this.alarmClockReminders[index].reminderRequestAlarm!);
        this.alarmClockReminders[index].reminderId = reminderId;
      } else {
        let context = getContext(this) as common.UIAbilityContext;
        let selectDate = `${year}-${month}-${day} ${selectTime} `;
        let event: calendarManager.Event = {
          type: calendarManager.EventType.NORMAL,
          title: context.resourceManager.getStringSync($r('app.string.alarm_clock').id),
          description: context.resourceManager.getStringSync($r('app.string.alarm_clock_reach').id),
          reminderTime: [0],
          startTime: Date.parse(selectDate),
          endTime: Date.parse(selectDate) + 60 * 1000
        };
        await calendar!.addEvent(event)
          .then((data: number) => {
            Logger.info(TAG, `Succeeded in adding event, id -> {data}`);
            this.alarmClockReminders[index].reminderId = data;
          })
          .catch((err: BusinessError) => {
            Logger.error(TAG, `Failed to add event.
              code: ${JSON.stringify(err.code)}, message: ${JSON.stringify(err.message)}`);
          });
      }
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
      if (deviceTypeInfo === 'default') {
        await reminderAgent.cancelReminder(this.alarmClockReminders[index].reminderId);
      } else {
        await calendar!.deleteEvent(this.alarmClockReminders[index].reminderId);
      }
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
      if (deviceTypeInfo === 'default') {
        reminderAgent.cancelReminder(this.alarmClockReminders[index].reminderId).then(() => {
          Logger.info(TAG, `deleteAlarmReminder cancelReminder is succeed`);
        }).catch((err: BusinessError) => {
          Logger.info(TAG, `deleteAlarmReminder cancelReminder is not exist err is ${JSON.stringify(err)}`);
        })
      } else {
        calendar!.deleteEvent(this.alarmClockReminders[index].reminderId).then(() => {
          Logger.info(TAG, `Succeeded in deleting event`);
        }).catch((err: BusinessError) => {
          Logger.error(TAG, `Failed to delete event. Code: ${err.code}, message: ${err.message}`);
        });
      }
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