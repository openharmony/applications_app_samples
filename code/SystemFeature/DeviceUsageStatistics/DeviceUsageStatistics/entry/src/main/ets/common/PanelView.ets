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

import { AppTime, BundleStateUtil, getAppName, getTotalTime } from 'feature-util'

const TAG = 'PanelView'
const oftenUsed = 5

@Component
export struct PanelView {
  @State statisticals: Array<AppTime> = []
  @State panelName: string[] = []
  @State panelValue: number[] = []
  @State totalTime: number = 0
  @State panelViewHeight: number = 0

  aboutToAppear() {
    this.getTime()
  }

  async getTime() {
    let bundleStateUtil = new BundleStateUtil()
    let list = await bundleStateUtil.getTotalAppList()

    this.totalTime = getTotalTime(list)
    list.sort((a, b) => b.totalTime - a.totalTime)
    this.statisticals = list
    let topFiveTotalTime = 0
    for (let i = 0;i < oftenUsed; i++) {
      this.panelName.push(getAppName(this.statisticals[i].bundleName))
      this.panelValue.push(this.statisticals[i].totalTime)
      topFiveTotalTime += this.statisticals[i].totalTime
    }
    this.panelName.push('others')
    this.panelValue.push(this.totalTime - topFiveTotalTime)
  }

  build() {
    Column() {
      Text($r('app.string.application_duration'))
        .fontSize(20)
        .width('100%')
        .margin({ top: 10 })
        .textAlign(TextAlign.Center)
      Row() {
        DataPanel({ values: this.panelValue, max: this.totalTime, type: DataPanelType.Circle })
          .width(200)
          .height(200)
        Column() {
          ForEach(this.panelName, (item) => {
            Text(item)
              .fontSize(20)
              .margin({ top: 5 })
          }, item => item)
        }
        .margin({ top: 10, left: 35 })
      }
      .height(250)
      .margin({ top: 10 })
      .alignSelf(ItemAlign.Center)

    }
    .width('100%')
    .onAreaChange((oldArea: Area, newArea: Area) => {
      this.panelViewHeight = (newArea.height) as number * 0.3 // percentage
    })
  }
}