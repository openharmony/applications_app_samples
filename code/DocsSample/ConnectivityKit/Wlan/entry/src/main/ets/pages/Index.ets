/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import hilog from '../model/Logger';
import { TitleBar } from '../component/TitleBar';
import router from '@ohos.router'

const TAG = 'Index';

@Entry
@Component
struct Index {
  build() {
    Column({ space: 5 }) {
      TitleBar()
        Text($r('app.string.wifi_List'))
          .fontColor(Color.Black)
          .fontSize(20)
          .layoutWeight(1)
          .constraintSize({ minHeight: 50 })
          .padding({ left: 15 })
          .borderRadius(5)
          .width('100%')
          // .fontColor($r('app.color.text_color'))
          .backgroundColor($r('app.color.button_color2'))
          .onClick(() => {
            router.pushUrl({ url: 'pages/AvailableWifi' })
          })

        Text($r('app.string.wifi_Connect'))
          .fontColor(Color.Black)
          .fontSize(20)
          .layoutWeight(1)
          .constraintSize({ minHeight: 50 })
          .padding({ left: 15 })
          .borderRadius(5)
          .width('100%')
            // .fontColor($r('app.color.text_color'))
          .backgroundColor($r('app.color.text_color'))
          .onClick(() => {
            router.pushUrl({ url: 'pages/WifiConnect' })
          })

        Text($r('app.string.p2p_test'))
          .fontColor(Color.Black)
          .fontSize(20)
          .layoutWeight(1)
          .constraintSize({ minHeight: 50 })
          .padding({ left: 15 })
          .borderRadius(5)
          .width('100%')
            // .fontColor($r('app.color.text_color'))
          .backgroundColor($r('app.color.index_background'))
          .onClick(() => {
            router.pushUrl({ url: 'pages/P2pTest' })
          })
      }
      .width('100%')
      .height('8%')
      .backgroundColor($r('app.color.index_bg'))
  }
}