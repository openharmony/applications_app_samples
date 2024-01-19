/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

@Component
export struct ThreadCommunicationHomePage {
  build() {
    Column() {
      Row() {
        Row() {
          Text($r('app.string.thread_communication'))
            .fontSize(20)
            .lineHeight(30)
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .width($r('app.string.percent_100'))
            .height(30)
        }
        .height(56)
        .backgroundColor(Color.White)
      }
      .margin({
        left: 24
      })

      Button($r('app.string.scenario_1'), { type: ButtonType.Normal, stateEffect: true })
        .id('Scenario_1')
        .fontSize(14)
        .borderRadius(8)
        .backgroundColor(Color.Blue)
        .width(250)
        .height(60)
        .margin({
          top: 30
        })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/ThreadCommunication/IndependentTaskPage'
          })
        })

      Button($r('app.string.scenario_2'), { type: ButtonType.Normal, stateEffect: true })
        .id('Scenario_2')
        .fontSize(14)
        .borderRadius(8)
        .backgroundColor(Color.Blue)
        .width(250)
        .height(60)
        .margin({
          top: 30
        })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/ThreadCommunication/MultiTaskPage'
          })
        })

      Button($r('app.string.scenario_3'), { type: ButtonType.Normal, stateEffect: true })
        .id('Scenario_3')
        .fontSize(14)
        .borderRadius(8)
        .backgroundColor(Color.Blue)
        .width(250)
        .height(60)
        .margin({
          top: 30
        })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/ThreadCommunication/TaskSendDataUsagePage'
          })
        })

      Button($r('app.string.scenario_4'), { type: ButtonType.Normal, stateEffect: true })
        .id('Scenario_4')
        .fontSize(14)
        .borderRadius(8)
        .backgroundColor(Color.Blue)
        .width(250)
        .height(60)
        .margin({
          top: 30
        })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/ThreadCommunication/WorkerUsagePage'
          })
        })

      Button($r('app.string.scenario_5'), { type: ButtonType.Normal, stateEffect: true })
        .id('Scenario_5')
        .fontSize(14)
        .borderRadius(8)
        .backgroundColor(Color.Blue)
        .width(250)
        .height(60)
        .margin({
          top: 30
        })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/ThreadCommunication/WorkerCallGlobalUsagePage'
          })
        })
    }
    .height(200)
    .width($r('app.string.percent_100'))
  }
}