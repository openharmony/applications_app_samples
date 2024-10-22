/*
 * Copyright (C) 2023-2024 Huawei Device Co., Ltd.
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

import { router } from '@kit.ArkUI';
import Logger from '../utils/Logger';

@Entry
@Component
struct ListPage {
  build() {
    Column() {
      Text($r('app.string.page_title'))
        .fontFamily('HarmonyHeiTi-Bold')
        .fontSize(24)
        .fontColor($r('app.color.title_color'))
        .height(33)
        .width(312)
        .margin({left: 24, right:24, top:12, bottom: 12})
      Button() {
        Text($r('app.string.page_title_video'))
          .fontFamily('HarmonyHeiTi-Medium')
          .width(64)
          .height(20)
          .fontColor($r('app.color.title_color'))
          .fontSize(16)
          .margin({left: 12, right:336, top:12, bottom: 12})
      }
      .id('videoRecorderPage')
      .height(48)
      .backgroundColor($r('app.color.button_background'))
      .borderRadius(24)
      .onClick(() => {
        router.pushUrl({
          url: 'recorder/VideoRecorder',
        })
      })
      .margin({ left: 12, right:12, top: 0, bottom:12})
      Button() {
        Text($r('app.string.page_title_audio'))
          .fontFamily('HarmonyHeiTi-Medium')
          .width(64)
          .height(20)
          .fontColor($r('app.color.title_color'))
          .fontSize(16)
          .margin({left: 12, right:336, top:12, bottom: 12})
      }
      .id('audioRecorderPage')
      .height(48)
      .backgroundColor($r('app.color.button_background'))
      .borderRadius(24)
      .onClick(() => {
        router.pushUrl({
          url: 'recorder/AudioRecorder',
        })
      })
      .margin({ left: 12, right:12, top: 0, bottom:12})
    }
    .backgroundColor($r('app.color.homepage_background'))
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
  }
}
