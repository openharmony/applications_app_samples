/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
export struct SmartPerfHostHomeView {
  build() {
    Row() {
      Column() {
        Text($r('app.string.smart_perf_host'))
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 30 })

        Button($r('app.string.frame_timeline_before_optimization'))
          .width("80%")
          .fontSize(18)
          .margin({ top: 30 })
          .onClick(() => {
            router.pushUrl({ url: "pages/smartPerfHost/FrameTimelineBeforeOptimizationPage" });
          })
        Button($r('app.string.frame_timeline_after_optimization'))
          .width("80%")
          .fontSize(18)
          .margin({ top: 30 })
          .onClick(() => {
            router.pushUrl({ url: "pages/smartPerfHost/FrameTimelineAfterOptimizationPage" });
          })

        Button($r('app.string.app_startup_before_optimization'))
          .width("80%")
          .fontSize(18)
          .margin({ top: 30 })
          .onClick(() => {
            router.pushUrl({ url: "pages/smartPerfHost/AppStartupBeforeOptimizationPage" });
          })
        Button($r('app.string.app_startup_after_optimization'))
          .width("80%")
          .fontSize(18)
          .margin({ top: 30 })
          .onClick(() => {
            router.pushUrl({ url: "pages/smartPerfHost/AppStartupAfterOptimizationPage" });
          })
      }
      .width('100%')
      .height("100%")
    }
    .height('100%')
  }
}