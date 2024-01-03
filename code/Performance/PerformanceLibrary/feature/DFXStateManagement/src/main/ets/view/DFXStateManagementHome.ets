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

import router from '@ohos.router'

@Component
export struct DFXStateManagementHome {
  @State message: string = 'Hello World DFXStateManagementHome'

  build() {
    Row() {
      Column() {
        Button($r('app.string.before_optimization'))
          .width("80%")
          .fontSize(18)
          .margin({ top: 30 })
          .onClick(() => {
            router.pushUrl({ url: "pages/DFXStateManagement/DFXStateBeforeOptimizationPage" });
          })
        Button($r('app.string.after_optimization'))
          .width("80%")
          .fontSize(18)
          .margin({ top: 30 })
          .onClick(() => {
            router.pushUrl({ url: "pages/DFXStateManagement/DFXStateAfterOptimizationPage" });
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
