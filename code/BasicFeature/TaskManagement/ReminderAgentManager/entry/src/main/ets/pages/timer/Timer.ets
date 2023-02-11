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
import reminderAgent from '@ohos.reminderAgent'
import vibrator from '@ohos.vibrator'
import AudioPlayer from '../../util/AudioPlayer'
import Constant from '../../common//Constant'
import Logger from '../../util/Logger'
import { SelectTime } from './SelectTime'

const TAG: string = 'CountDown'

@Component
export struct Timer {
  @State timer: number = 0
  @State rotates: number = 0
  @State passSec: number = 0
  @State pickerHour: number = 0
  @State pickerMinute: number = 0
  @State pickerSecond: number = 0
  @State audioId: number = 0
  @State hoursTime: number = 0
  @State minuteTime: number = 0
  @State secondTime: number = 0
  @State vibratorId: number = 0
  @State reminderId: number = 0
  @State countInSec: number = 0
  @State progressVal: number = 0
  @State countdownTime: number = 0
  @State isRunning: boolean = false
  @State isPausing: boolean = false
  @State startImg: Resource = $r('app.media.ic_public_start')
  @State resetImg: Resource = $r('app.media.ic_countdown_reset')
  private title: Resource
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize(24)
          .margin({ left: 8 })
        Blank()
      }
      .height(56)
      .padding(8)
      .width('100%')

      Column({ space: 20 }) {
        Stack() {
          Image($r('app.media.ic_countdown_clock'))
            .width(280)
            .height(280)
          Progress({ value: this.progressVal, style: ProgressStyle.ScaleRing })
            .width(250)
            .height(250)
            .style({ strokeWidth: 10, scaleCount: 80, scaleWidth: 2 })
          Canvas(this.context)
            .onReady(() => {
              this.context.lineWidth = 8
              this.context.strokeStyle = '#f2400a'
              this.context.beginPath()
              this.context.moveTo(15, 0)
              this.context.arc(15, undefined, 10, 3.14 * 1.5, 3.14 * 0.5)
              this.context.lineTo(15, undefined)
              this.context.arc(15, undefined, 10, 3.14 * 0.5, 3.14 * 1.5)
              this.context.stroke()
            })
            .width(10)
            .height(250)
            .position({ x: '48.5%', y: 15 })
            .animation({ curve: Curve.Linear })
            .rotate({
              x: 0,
              y: 0,
              z: 1,
              angle: this.rotates,
              centerX: '50%',
              centerY: 125
            })
          Image($r('app.media.ic_countdown_seconds'))
            .width('25%')
            .height('92%')
            .objectFit(ImageFit.Contain)
            .rotate({ z: 1, angle: -this.rotates })
        }

        Text(`${this.formatTime(this.hoursTime)}:${this.formatTime(this.minuteTime)}:${this.formatTime(this.secondTime)}`)
          .fontSize(24)
          .fontFamily('HarmonyHeiTi-Medium')
          .fontColor($r('app.color.font_dark'))
        if (this.isRunning) {
          Blank()
            .height(180)
        } else {
          SelectTime({ hour: $pickerHour, minute: $pickerMinute, second: $pickerSecond })
        }
        Row() {
          Image(this.resetImg)
            .width(48)
            .height(48)
            .margin({ right: 100 })
            .objectFit(ImageFit.Fill)
            .onClick(async () => {
              await this.reset()
            })
          Image(this.startImg)
            .width(48)
            .height(48)
            .onClick(async () => {
              if (this.pickerHour + this.pickerMinute + this.pickerSecond == 0) {
                return
              }
              if (!this.isRunning || this.isPausing) {
                await this.start()
              } else {
                await this.pause()
              }
            })
        }
      }
      .alignItems(HorizontalAlign.Center)

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

  formatTime(num) {
    if (num > 99 || num < 0) {
      return '**'
    }
    return (num < 10) ? ('0' + num).toString() : num.toString()
  }

  async timerCountDown() {
    this.secondTime--
    if (this.secondTime < 0) {
      this.minuteTime--
      this.secondTime = Constant.TIME_COUNTDOWN
    }
    if (this.minuteTime < 0) {
      this.minuteTime = Constant.TIME_COUNTDOWN
      this.hoursTime--
    }
    if (this.hoursTime < 0) {
      await this.reset()
      return
    }
    this.passSec++
    this.progressVal = 100 - this.passSec * 100 / this.countInSec
    this.rotates = this.passSec * Constant.ANGLE / this.countInSec
  }

  async start() {
    if (!this.isPausing) {
      this.hoursTime = this.pickerHour
      this.minuteTime = this.pickerMinute
      this.secondTime = this.pickerSecond
    }
    let context: any = getContext(this)
    this.countInSec = this.pickerHour * Constant.HOUR_SECONDS + this.pickerMinute * Constant.MINUTES_SECONDS + this.pickerSecond
    this.countdownTime = this.hoursTime * Constant.HOUR_SECONDS + this.minuteTime * Constant.MINUTES_SECONDS + this.secondTime
    this.isRunning = true
    this.isPausing = false
    this.startImg = $r('app.media.ic_public_pause')
    this.resetImg = $r('app.media.ic_public_reset')
    this.timer = setInterval(await this.timerCountDown.bind(this), Constant.SECONDS_MILLISECONDS)
    await reminderAgent.addNotificationSlot({ type: notification.SlotType.SERVICE_INFORMATION })
    let timer: reminderAgent.ReminderRequestTimer = {
      reminderType: reminderAgent.ReminderType.REMINDER_TYPE_TIMER,
      ringDuration: Constant.REMINDER_DURATION,
      title: context.resourceManager.getStringSync($r('app.string.timer').id),
      content: context.resourceManager.getStringSync($r('app.string.countdown_close').id),
      wantAgent: { pkgName: 'ohos.samples.reminderagentmanager', abilityName: 'MainAbility' },
      slotType: notification.SlotType.CONTENT_INFORMATION,
      triggerTimeInSeconds: this.countdownTime
    }
    Logger.info(TAG, `this timer is ${JSON.stringify(timer)}}`)
    this.reminderId = await reminderAgent.publishReminder(timer)
    this.vibratorId = setTimeout(function () {
      vibrator.vibrate(Constant.VIBRATOR_DURATION, function (err) {
        if (err) {
          Logger.error(TAG, `this vibrator is failed err is ${JSON.stringify(err)}`)
        } else {
          Logger.info(TAG, `this vibrator is successed`)
        }
      })
    }, this.countdownTime * Constant.SECONDS_MILLISECONDS)
    this.audioId = await AudioPlayer.getAudioID('/system/etc/demo.wav', this.countdownTime * Constant.SECONDS_MILLISECONDS)
  }

  async pause() {
    clearInterval(this.timer)
    clearTimeout(this.audioId)
    clearTimeout(this.vibratorId)
    this.isRunning = true
    this.isPausing = true
    this.startImg = $r('app.media.ic_public_start')
    await reminderAgent.cancelReminder(this.reminderId)
    await vibrator.stop(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME)
  }

  async reset() {
    clearInterval(this.timer)
    clearTimeout(this.audioId)
    clearTimeout(this.vibratorId)
    this.isRunning = false
    this.isPausing = false
    this.progressVal = 0
    this.rotates = 0
    this.passSec = 0
    this.hoursTime = 0
    this.minuteTime = 0
    this.secondTime = 0
    this.pickerHour = 0
    this.pickerMinute = 0
    this.pickerSecond = 0
    this.startImg = $r('app.media.ic_public_start')
    this.resetImg = $r('app.media.ic_countdown_reset')
    await reminderAgent.cancelReminder(this.reminderId)
    await vibrator.stop(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME)
  }
}