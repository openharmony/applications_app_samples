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

import router from '@ohos.router';

const BUTTON_HEIGHT = 50; // 按钮的高度
const BUTTON_FONT_SIZE = 19; // 按钮的字体大小
const BUTTON_RADIUS = 5; // 按钮的圆角半径
const TEXT_MARGIN_TOP_L = 20; // 长文本的上边距

@Entry
@Component
struct Index {
  build() {
    Column() {
      // 802.1X认证流程中加入自定义的安全校验
      Button($r('app.string.first_part'))
        .onClick(() => {
          router.pushUrl({
            url: 'pages/AccreditationProcess',
          });
        })
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: TEXT_MARGIN_TOP_L })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_RADIUS)
      // 使用eth接口发起802.1X认证流程
      Button($r('app.string.second_part'))
        .onClick(() => {
          router.pushUrl({
            url: 'pages/EthInterface',
          });
        })
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: TEXT_MARGIN_TOP_L })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_RADIUS)
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}