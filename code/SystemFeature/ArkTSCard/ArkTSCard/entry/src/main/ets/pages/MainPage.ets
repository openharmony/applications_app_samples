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

@Entry
@Component
struct MainPage {
  build() {
    Row() {
      Column() {
        Text($r('app.string.ark_text'))
          .fontColor('#182431')
          .fontSize(32)
          .fontWeight(700)
          .margin({ left: '72px', top: 32 })
          .textAlign(TextAlign.Start)
          .width('100%')
        Button('DeepLink')
          .type(ButtonType.Capsule)
          .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
          .backgroundColor('#FF007DFF')
          .fontColor($r('sys.color.ohos_id_color_foreground_contrary'))
          .fontSize($r('sys.float.ohos_id_text_size_button1'))
          .height(48)
          .width('624px')
          .margin({ top: 500 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/FormDeepLink' });
          })
        Button($r('app.string.lock'))
          .backgroundColor('#FF007DFF')
          .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
          .backgroundColor('#FF007DFF')
          .fontColor($r('sys.color.ohos_id_color_foreground_contrary'))
          .fontSize($r('sys.float.ohos_id_text_size_button1'))
          .height(48)
          .width('624px')
          .margin({ top: 16 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/LockPage' });
          })
      }
      .padding(0)
      .width('100%')
    }
    .alignItems(VerticalAlign.Top)
    .padding(0)
    .backgroundColor($r('app.color.page_background'))
    .width('100%')
    .height('100%')
  }
}