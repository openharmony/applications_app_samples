/*
 * Copyright (c) 2023-2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// [Start fun_a]
// src/main/ets/funpages/FunA.ets
@Entry
@Component
struct FunA {
  build() {
    Column() {
      Row() {
        // $r('app.string.ButtonA_label')需要替换为开发者所需的资源文件
        Text(($r('app.string.ButtonA_label')))
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
          .margin({
            top: 12,
            bottom: 11,
            right: 24,
            left: 24
          })
      }
      .width('100%')
      .height(56)
      .justifyContent(FlexAlign.Start)

      // $r('app.media.pic_empty')需要替换为开发者所需的资源文件
      Image($r('app.media.pic_empty'))
        .width(120)
        .height(120)
        .margin({ top: 224 })

      // $r('app.string.NoContentAvailable')需要替换为开发者所需的资源文件
      Text($r('app.string.NoContentAvailable'))
        .fontSize(14)
        // $r('app.color.text_color')需要替换为开发者所需的资源文件
        .fontColor($r('app.color.text_color'))
        .opacity(0.4)
        .margin({
          top: 8,
          bottom: 317,
          right: 152,
          left: 152
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [End fun_a]