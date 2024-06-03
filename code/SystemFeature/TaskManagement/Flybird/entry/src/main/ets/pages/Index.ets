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

import router from '@ohos.router';
import prompt from '@ohos.prompt'
import { ServiceModel } from '../model/ServiceModel'
import { TitleBar } from '../component/TitleBar'
import { OperateView } from '../component/OperateView'
import rpc from "@ohos.rpc"
import reminderAgent from '@ohos.reminderAgent';
import notification from '@ohos.notification';
import Logger from '../model/Logger'

const TAG = "Index"

async function routePage() {
  let options = {
    url: 'pages/Selects'
  }
  try {
    await router.push(options)
  } catch (err) {
    Logger.error(`${TAG} fail callback,code: ${err.code},msh: ${err.msg}`)
  }
}

@Entry
@Component
struct Index {
  private btnResources: Array<Resource> = [$r('app.string.connect_service'), $r('app.string.disconnect_service'), $r('app.string.set_alarm'), $r('app.string.set_calendar'), $r('app.string.start_game')]
  private serviceModel = new ServiceModel()
  private isStart: boolean = false;
  @State beforeSortString: string = ''
  @State afterSortString: string = ''

  async sortString() {
    Logger.info(`${TAG} sortString begin`)
    let mRemote = this.serviceModel.getRemoteObject()
    if (mRemote === null) {
      prompt.showToast({
        message: 'please connect service'
      })
    }
    if (this.beforeSortString.length === 0) {
      prompt.showToast({
        message: 'please input a string'
      })
    }
    let messageOption: rpc.MessageOption = new rpc.MessageOption()
    let data: rpc.MessageParcel = rpc.MessageParcel.create()
    let reply: rpc.MessageParcel = rpc.MessageParcel.create()
    data.writeString(this.beforeSortString)
    await mRemote.sendRequest(1, data, reply, messageOption)
    let msg = reply.readString()
    this.afterSortString = msg
  }
  // 闹钟实例对象，用于设置提醒的时间
  async setGameRenmindAlarm() {
    Logger.info(`${TAG} setGameRenmindAlarm begin`)

    // publish reminder
    let reminder: reminderAgent.ReminderRequestAlarm = {
      reminderType: reminderAgent.ReminderType.REMINDER_TYPE_ALARM,
      // 指明提醒的目标时刻
      hour: 7,
      // 指明提醒的目标分钟
      minute: 24,
      // 指明每周哪几天需要重复提醒。范围为周一到周末，对应数字为1到7
      daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
      // 用于设置弹出的提醒通知信息上显示的按钮类型和标题
      actionButton: [
        {
          title: "snooze",
          type: reminderAgent.ActionButtonType.ACTION_BUTTON_TYPE_SNOOZE,
        }
      ],
      // wantAgent用于点击提醒通知后跳转的目标ability信息
      wantAgent: {
        pkgName: "ohos.samples.flybird",
        abilityName: "EntryAbility"
      },
      // maxScreenWantAgent用于全屏显示提醒到达时自动拉起的目标ability信息，该接口预留
      maxScreenWantAgent: {
        pkgName: "ohos.samples.flybird",
        abilityName: "EntryAbility"
      },
      // 指明响铃时长
      ringDuration: 10,
      // 指明延迟提醒次数
      snoozeTimes: 2,
      // 执行延迟提醒间隔
      timeInterval: 5 * 60,
      // 指明延迟提醒时需要显示的内容
      snoozeContent: "later",
      // 指明提醒标题
      title: "game alarm",
      // 指明提醒内容
      content: "remember play game",
      // 指明提醒过期后需要显示的内容
      expiredContent: "expiredContent",
      // 指明提醒使用的通知的id号，相同id号的提醒会覆盖
      notificationId: 200,
    }
    reminderAgent.publishReminder(reminder);
  }

  async callback(err, data) {
    if (err) {
      Logger.error(TAG,`setGameRenmindAlarm failed Cause: ${err}`);
    } else {
      Logger.info(TAG ,'setGameRenmindAlarm succeeded');
    }
  }
  // 日历实例对象，用于设置提醒的时间
  async setGameRenmindCalendar() {
    Logger.info(`${TAG} setGameRenmindCalendar begin`)
    let calendar: {
      reminderType: reminderAgent.ReminderType.REMINDER_TYPE_CALENDAR,
      // 指明提醒的目标时间
      dateTime: {
        year: 2022,
        month: 4,
        day: 14,
        hour: 7,
        minute: 50,
        second: 30
      },
      // 指明重复提醒的月份
      repeatMonths: [1],
      // 指明重复提醒的日期
      repeatDays: [1],
      wantAgent: {
        pkgName: "ohos.samples.flybird",
        abilityName: "EntryAbility"
      },
      maxScreenWantAgent: {
        pkgName: "ohos.samples.flybird",
        abilityName: "EntryAbility"
      },
      ringDuration: 5,
      snoozeTimes: 2,
      timeInterval: 5,
      title: "game calendar",
      content: "game calender",
      expiredContent: "this reminder has expired",
      snoozeContent: "remind later",
      notificationId: 100,
      slotType: notification.SlotType.SOCIAL_COMMUNICATION
    }
    reminderAgent.publishReminder(calendar);
  }

  async disconenctService() {
    Logger.info(`${TAG} disconenctService begin`)
    let mRemote = this.serviceModel.getRemoteObject()
    if (mRemote === null) {
      prompt.showToast({
        message: 'please connect service'
      })
    }

    let option: rpc.MessageOption = new rpc.MessageOption()
    let data: rpc.MessageParcel = rpc.MessageParcel.create()
    let reply: rpc.MessageParcel = rpc.MessageParcel.create()
    data.writeString('disconnect_service')
    await mRemote.sendRequest(1, data, reply, option)
    let msg = reply.readString()
    this.afterSortString = msg
  }

  async startGame() {
    let mRemote = this.serviceModel.getRemoteObject()
    if (mRemote === null) {
      prompt.showToast({
        message: 'please connect service'
      })
    } else {
      if (!this.isStart) {
        this.startGameEx()
        this.isStart = true
      }
      routePage()
    }
  }

  async startGameEx() {
    Logger.info(`${TAG} startGame begin`)
    let mRemote = this.serviceModel.getRemoteObject()
    if (mRemote === null) {
      prompt.showToast({
        message: 'please connect service'
      })
    }

    let option: rpc.MessageOption = new rpc.MessageOption()
    let data: rpc.MessageParcel = rpc.MessageParcel.create()
    let reply: rpc.MessageParcel = rpc.MessageParcel.create()
    data.writeString("start_game")
    await mRemote.sendRequest(1, data, reply, option)
    let msg = reply.readString()
    this.afterSortString = msg
  }

  build() {
    Column() {
      TitleBar()
      Scroll() {
        Column() {
          OperateView({ before: $beforeSortString, after: $afterSortString })
          ForEach(this.btnResources, (item, index) => {
            Button() {
              Text(item)
                .fontColor(Color.White)
                .fontSize(20)
            }
            .type(ButtonType.Capsule)
            .backgroundColor('#0D9FFB')
            .width('94%')
            .height(50)
            .margin(10)
            .onClick(() => {
              Logger.info(`${TAG} button clicked,index=${index}`)
              switch (index) {
                case 0:
                  this.serviceModel.connectService()
                  break
                case 1:
                  this.disconenctService();
                  this.serviceModel.disconnectService()
                  break
                case 2:
                  this.setGameRenmindAlarm();
                  break
                case 3:
                  this.setGameRenmindCalendar();
                  break
                case 4:
                  this.startGame()
                  break
                default:
                  break
              }
            })
          }, item => JSON.stringify(item))
        }
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}