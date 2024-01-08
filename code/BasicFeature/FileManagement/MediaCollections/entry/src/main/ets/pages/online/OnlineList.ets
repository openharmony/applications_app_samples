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

import OnlineListView from '../../phoneView/online/OnlineListView'
import router from '@ohos.router'

@Entry
@Component
struct OnlineList {
  @Builder
  titleBar() {
    Row({ space: 20 }) {
      Image(($r('app.media.icon_back')))
        .height('80%')
        .onClick(() => {
          router.back()
        })

      Text('MediaCollections')
        .fontColor(0xE6E6E6)
        .fontSize(24)
        .fontWeight(700)
    }
    .width('100%')
    .height('10%')
    .backgroundColor(0x212121)
    .padding(20)
  }

  build() {
    Column() {
      this.titleBar()
      OnlineListView()
        .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}