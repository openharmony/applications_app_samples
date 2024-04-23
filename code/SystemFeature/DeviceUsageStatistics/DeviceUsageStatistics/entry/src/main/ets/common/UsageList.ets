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

import { AppTime, BundleStateUtil, hmsToString, getAppName, getAppIcon, getTotalTime } from 'feature-util'

const TAG = 'UsageList'

@Component
export struct UsageList {
  @State statisticals: Array<AppTime> = []
  @State totalTime: number = 0

  aboutToAppear() {
    this.getTime()
  }

  async getTime() {
    let bundleStateUtil = new BundleStateUtil()
    let list = await bundleStateUtil.getTotalAppList()

    this.totalTime = getTotalTime(list)
    list.sort((a, b) => b.totalTime - a.totalTime)
    this.statisticals = list
  }

  build() {
    Column() {
      Text(hmsToString(this.totalTime / 1000))
        .width('80%')
        .fontSize(30)
        .textAlign(TextAlign.Start)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 15, bottom: 15 })
      Scroll() {
        Column() {
          ForEach(this.statisticals, (item) => {
            Row() {
              Image(getAppIcon(item.bundleName))
                .width(80)
                .height(80)
                .objectFit(ImageFit.Fill)
              Column() {
                Row() {
                  Text(getAppName(item.bundleName))
                    .width('60%')
                    .fontSize(25)
                    .fontWeight(FontWeight.Bold)
                  Text(hmsToString(Math.floor(item.totalTime / 1000)))
                    .width('40%')
                    .fontSize(22)
                    .textAlign(TextAlign.End)
                }
                .width('100%')
                .alignSelf(ItemAlign.Start)

                Progress({ value: item.totalTime, total: this.totalTime, type: ProgressType.Linear })
                  .height(20)
                  .width('100%')
                  .color(Color.Grey)
                  .margin({ top: 12 })
                  .style({ strokeWidth: 10 })
                  .alignSelf(ItemAlign.Start)

                Row() {
                  Text($r('app.string.application_last_used')).fontSize(15)
                  Text(hmsToString(Math.floor(item.prevAccessTime / 1000))).fontSize(15)
                }
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
              .padding({ left: 5, right: 5 })
            }
            .height(95)
            .margin({ bottom: 50 })
          }, item => item.bundleName)
        }
        .justifyContent(FlexAlign.Start)
      }
      .width('90%')
      .height('80%')
      .scrollBar(BarState.Off)
      .backgroundColor(Color.White)
      .scrollable(ScrollDirection.Vertical)
      .borderRadius(10)
      .padding(20)
    }
    .width('100%')
    .height('55%')
    .margin({ top: 40 })
  }
}