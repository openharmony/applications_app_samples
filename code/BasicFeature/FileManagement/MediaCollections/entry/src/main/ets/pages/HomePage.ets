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

import display from '@ohos.display'
import router from '@ohos.router'

@Entry
@Component
struct HomePage {
  build() {
    Row() {
      Column({ space: 50 }) {
        Button($r('app.string.homePage_online'))
          .onClick(() => {
            router.pushUrl({
              url: 'pages/online/OnlineList'
            })
          })

        Button($r('app.string.homePage_offline'))
          .onClick(() => {
            let abilityDisplay = display.getDefaultDisplaySync()
            let abilityDisplayWidth = abilityDisplay.width
            const displayWidth: number = 2500

            if (abilityDisplayWidth > displayWidth) {
              router.pushUrl({
                url: 'pages/index'
              })
            } else {
              router.pushUrl({
                url: 'pages/phoneMain'
              })
            }
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}