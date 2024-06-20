/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

@Entry
@Component
struct Index {
  build() {
    Column() {
      Column() {
        Row() {
          Text($r('app.string.zLib'))
            .fontSize(30)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bold)
        }
        .margin({ top: 63 })
        .width('86.7%')
        .height('15.6%')
      }
      .width('100%')
      .height('50%')

      Column() {
        Button($r('app.string.ziplibdecompression'))
          .id('zipLibDecompression')
          .fontFamily('HarmonyHeiTi')
          .type(ButtonType.Capsule)
          .borderRadius(20)
          .backgroundColor($r('app.color.button_color'))
          .fontColor($r('app.color.text_white_color'))
          .fontSize(16)
          .onClick(() => {
            router.pushUrl({
              url: 'zlib/ZipLibDecompressionPage'
            });
          })
          .width('91%')
          .height('11.2%')
          .margin({ bottom: 12})

        Button($r('app.string.zlibInterface'))
          .id('zlibInterface')
          .fontFamily('HarmonyHeiTi')
          .type(ButtonType.Capsule)
          .borderRadius(20)
          .backgroundColor($r('app.color.button_color'))
          .fontColor($r('app.color.text_white_color'))
          .fontSize(16)
          .onClick(() => {
            router.pushUrl({
              url: 'zlib/ZLibInterfaceListPage'
            });
          })
          .width('91%')
          .height('11.2%')
          .margin({ bottom: 16 })
      }
      .justifyContent(FlexAlign.End)
      .width('100%')
      .height('50%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.start_window_background'))
  }
}
