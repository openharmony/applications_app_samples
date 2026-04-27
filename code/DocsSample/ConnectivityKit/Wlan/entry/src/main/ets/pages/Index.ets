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

import { TitleBar } from '../component/TitleBar';

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
        .backgroundColor($r('app.color.button_color2'))
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/AvailableWifi'
          })
            .then(() => {
              console.info('跳转到 AvailableWifi 页面成功');
            })
            .catch((error: BusinessError<number>) => {
              console.error(`跳转失败，错误码：${error.code}，错误信息：${error.message}`);
            });
        })

      Text($r('app.string.wifi_Connect'))
        .fontColor(Color.Black)
        .fontSize(20)
        .layoutWeight(1)
        .constraintSize({ minHeight: 50 })
        .padding({ left: 15 })
        .borderRadius(5)
        .width('100%')
        .backgroundColor($r('app.color.text_color'))
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/WifiConnect'
          })
            .then(() => {
              console.info('跳转到 Wi-Fi 连接页面成功');
            })
            .catch((error: BusinessError<number>) => {
              console.error(`跳转失败，错误码：${error.code}，错误信息：${error.message}`);
            });
        })

      Text($r('app.string.p2p_test'))
        .fontColor(Color.Black)
        .fontSize(20)
        .layoutWeight(1)
        .constraintSize({ minHeight: 50 })
        .padding({ left: 15 })
        .borderRadius(5)
        .width('100%')
        .backgroundColor($r('app.color.index_background'))
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/P2pTest'
          })
            .then(() => {
              console.info('跳转到 P2pTest 页面成功');
            })
            .catch((error: BusinessError<number>) => {
              console.error(`跳转失败，错误码：${error.code}，错误信息：${error.message}`);
            });
        })
    }
    .width('100%')
    .height('8%')
    .backgroundColor($r('app.color.index_bg'))
  }
}