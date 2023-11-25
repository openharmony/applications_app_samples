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
export struct HiDumperHomeView {
  build() {
    Row() {
      Column() {
        Text($r('app.string.title'))
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 30 })

        Button($r('app.string.check_component_tree'))
          .width("80%")
          .fontSize(18)
          .margin({ top: 30 })
          .onClick(() => {
            router.pushUrl({ url: "pages/hiDumper/GridPage" });
          })
        Button($r('app.string.check_if_else_component'))
          .width("80%")
          .fontSize(18)
          .margin({ top: 30 })
          .onClick(() => {
            router.pushUrl({ url: "pages/hiDumper/ConditionPage" });
          })
        Button($r('app.string.check_visibility'))
          .width("80%")
          .fontSize(18)
          .margin({ top: 30 })
          .onClick(() => {
            router.pushUrl({ url: "pages/hiDumper/VisibilityPage" });
          })
      }
      .width('100%')
      .height("100%")
    }
    .height('100%')
  }
}