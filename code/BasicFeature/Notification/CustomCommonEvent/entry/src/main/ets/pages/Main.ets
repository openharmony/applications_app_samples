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

import surveillanceEventsManager from '../module/SurveillanceEventsManager'
import commonEvent from '@ohos.commonEvent'
import sysTime from '@ohos.systemTime'
import utils from '../module/Utils'
import consts from '../module/Consts'
import mainFeature from '../feature/MainFeature'
import router from '@ohos.router'
import Logger from '../module/Logger'

@Entry
@Component
struct Main {
  @State btnSrc: Resource = $rawfile('start.png')
  @State btnState: boolean = false
  @State startTime: number = 0
  @State totalTimeInString: string = ''
  @State totalEvents: number = 0
  @State totalEventsInString: string = ''
  @State recTimesArray: Array<number> = [0, 0, 0, 0]
  @State recEventsArray: Array<string> = []
  @State currentEvent: string = ''
  @State detailState: Visibility = Visibility.None
  @State currentState: Visibility = Visibility.None
  private validEventsSubscriber = null // this subscriber subscribe system defined ordinary events
  private feature:mainFeature = new mainFeature()

  async onPageShow() {
    Logger.info("enter onPageShow")
    await this.feature.init()
  }

  async onPageHide() {
    Logger.info("enter onPageHide")
    await this.feature.reset()
  }

  private getMsg(event: string): Resource {
    switch (event) {
      case commonEvent.Support.COMMON_EVENT_SCREEN_ON:
        return $r('app.string.screen_on_tips')
      case commonEvent.Support.COMMON_EVENT_SCREEN_OFF:
        return $r('app.string.screen_off_tips')
      case commonEvent.Support.COMMON_EVENT_WIFI_POWER_STATE:
        return $r('app.string.wifi_tips')
      default:
        return $r('app.string.no_interrupt_tips')
    }
  }

  private systemEventCallback = (error, event) => {
    let index = this.feature.getCurrentValidEvents().indexOf(event.event)
    this.recTimesArray[index]++
    this.recEventsArray[index] = event.event + ' : ' + this.recTimesArray[index].toString()
    this.totalEvents++
    this.currentEvent = event.event
  }

  private handleStart = () => {
    this.btnState = true
    this.btnSrc = $rawfile('stop.png')
    this.detailState = Visibility.None
    this.currentState = Visibility.Visible
    this.totalEventsInString = ''
    this.totalEvents = 0
    this.totalTimeInString = ''
    sysTime.getCurrentTime().then((curTime) => {
      this.startTime = curTime
      // start subscribe
      let subscriberInfo = {
        events: this.feature.getCurrentValidEvents()
      }
      commonEvent.createSubscriber(subscriberInfo, (error, subscriber) => {
        this.validEventsSubscriber = subscriber
        commonEvent.subscribe(subscriber, this.systemEventCallback)
      })
    })
  }

  private handleStop = () => {
    this.btnState = false
    this.btnSrc = $rawfile('start.png')
    this.detailState = Visibility.Visible
    this.currentState = Visibility.None
    this.totalEventsInString = this.totalEvents.toString()
    // refresh time
    sysTime.getCurrentTime().then((curTime) => {
      this.totalTimeInString = utils.convertTimeToFormatString(curTime - this.startTime)
      // unsubscribe
      commonEvent.unsubscribe(this.validEventsSubscriber, () => {
        Logger.info("unsubscribe called")
      })
      let options = {
        isOrdered: true,
        parameters: {
          'startTime': utils.getLocaleTime(this.startTime),
          'endTime': utils.getLocaleTime(curTime),
          'totalTime': this.totalTimeInString,
          'totalEvents': this.totalEventsInString,
        }
      }
      commonEvent.publish(consts.COMMON_EVENT_FINISH_MEDITATION, options, () => {
        Logger.info("success to publish COMMON_EVENT_FINISH_MEDITATION")
      })
    })
  }

  private executeCallBack = () => {
    if (!this.btnState) {
      this.handleStart()
    } else {
      this.handleStop()
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Image(this.btnSrc)
          .objectFit(ImageFit.Contain).size({ width: 320, height: 150 })
          .onClick(this.executeCallBack)
        Column() {
          Text($r('app.string.current_listen_tips')).size({ width: '80%', height: '50%' })
            .fontSize(20)
            .fontColor(0xCCCCCC)
            .visibility(this.currentState)
          Text(this.getMsg(this.currentEvent)).size({ width: '80%', height: '50%' })
            .fontSize(20)
            .fontColor(0xCCCCCC)
            .visibility(this.currentState)
          Row() {
            Text($r('app.string.total_time_tips')).size({ width: '50%', height: '100%' })
              .fontSize(20)
              .fontColor(0xCCCCCC)
              .offset({ x: '10%', y: '0%' })
            Text(this.totalTimeInString).size({ width: '30%', height: '100%' })
              .fontSize(20)
              .fontColor(0xCCCCCC)
          }.size({ width: '80%', height: '50%' })
          .offset({ x: '0%', y: '5%' })
          .visibility(this.detailState)
          Row() {
            Text($r('app.string.total_interrupt_tips')).size({ width: '70%', height: '100%' })
              .fontSize(20)
              .fontColor(0xCCCCCC)
              .offset({ x: '10%', y: '0%' })
            Text(this.totalEventsInString).size({ width: '10%', height: '100%' })
              .fontSize(20)
              .fontColor(0xCCCCCC)
          }.size({ width: '80%', height: '50%' })
          .offset({ x: '0%', y: '5%' })
          .visibility(this.detailState)
        }
        .size({ width: '90%', height: '20%' })
        .backgroundColor(0xfbfafb)
        .opacity(0.8)
        .offset({ x: '0%', y: '5%' })
        .borderRadius(10)
      }.size({ width: '100%', height: '100%' })
      .offset({ x: '0%', y: '-15%' })

      Image($rawfile('nextDetail.png'))
        .size({ width: 160, height: 50 })
        .objectFit(ImageFit.Contain)
        .position({ x: '60%', y: '85%' })
        .visibility(this.detailState)
        .onClick(() => {
          let validRecEvents: Array<string> = []
          this.recEventsArray.forEach((element: string) => {
            if (element != '') {
              validRecEvents.push(element)
            }
          })
          router.push({
            url: 'pages/Detail',
            params: {
              'recEvents': validRecEvents,
              'onceEvents': this.feature.getOnceEvents()
            }
          })
        })
    }.size({ width: '100%', height: '100%' })
    .backgroundImage($rawfile('vbg720.png'))
    .backgroundImageSize(ImageSize.Contain)
  }
}