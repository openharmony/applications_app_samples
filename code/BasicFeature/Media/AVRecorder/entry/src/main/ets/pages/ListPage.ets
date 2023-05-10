/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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

@Entry
@Component
struct ListPage {
  build() {
    Column() {
      Text($r('app.string.page_title'))
        .fontFamily('HarmonyHeiTi-Bold')
        .fontSize(24)
        .fontColor("#182431")
        .height(33)
        .width(312)
        .margin({left: 24, right:24, top:12, bottom: 12})
      Button() {
        Text($r('app.string.page_title_video'))
          .fontFamily('HarmonyHeiTi-Medium')
          .width(64)
          .height(20)
          .fontColor('#000000')
          .fontSize(16)
          .margin({left: 12, right:336, top:12, bottom: 12})
      }
      .height(48)
      .backgroundColor('#FFFFFF')
      .borderRadius(24)
      .onClick(() => {
        router.push({
          url: 'recorder/VRecorder',
        })
      })
      .margin({ left: 12, right:12, top: 0, bottom:12})
      Button() {
        Text($r('app.string.page_title_audio'))
          .fontFamily('HarmonyHeiTi-Medium')
          .width(64)
          .height(20)
          .fontColor('#000000')
          .fontSize(16)
          .margin({left: 12, right:336, top:12, bottom: 12})
      }
      .height(48)
      .backgroundColor('#FFFFFF')
      .borderRadius(24)
      .onClick(() => {
        router.push({
          url: 'recorder/ARecorder',
        })
      })
      .margin({ left: 12, right:12, top: 0, bottom:12})
    }
    .backgroundColor('#F1F3F5')
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
  }
}
