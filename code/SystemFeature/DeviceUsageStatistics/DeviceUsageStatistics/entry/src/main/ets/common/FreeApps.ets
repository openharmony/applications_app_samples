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

import { AppInfo, appInit, BundleStateUtil } from 'feature-util'

const TAG = 'FreeApps'

@Component
export struct FreeApps {
  @State apps: Array<AppInfo> = appInit()
  @State freeApps: Array<AppInfo> = []

  aboutToAppear() {
    this.getFreeApps()
  }

  async getFreeApps() {
    let bundleStateUtil = new BundleStateUtil()
    this.freeApps = await bundleStateUtil.getFreeAppList()
  }

  build() {
    Column() {
      Text($r('app.string.free_apps'))
        .width('80%')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .direction(Direction.Ltr)
        .margin({ bottom: 10 })
      Column() {
        Scroll() {
          Row() {
            ForEach(this.freeApps, (item) => {
              Column() {
                Image(item.icon)
                  .margin({ top: 10 })
                  .width(70)
                  .height(70)
                  .objectFit(ImageFit.Fill)
                Text(item.name)
                  .fontSize(10)
                  .margin({ top: 5 })
              }
              .width(70)
              .height(120)
              .margin(10)
            }, item => item.name)
          }
          .borderRadius(10)
          .backgroundColor(Color.White)
        }
        .margin(5)
        .width('90%')
        .scrollable(ScrollDirection.Horizontal)
      }
      .width('95%')
      .padding(10)
    }.margin({ top: 20 })
  }
}