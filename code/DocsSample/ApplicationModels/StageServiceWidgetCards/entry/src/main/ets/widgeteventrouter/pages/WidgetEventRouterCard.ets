/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

// [Start widget_event_router_card]
// src/main/ets/widgeteventrouter/pages/WidgetEventRouterCard.ets
@Entry
@Component
struct WidgetEventRouterCard {
  build() {
    Column() {
      // $r('app.string.JumpLabel')需要替换为开发者所需的资源文件
      Text($r('app.string.JumpLabel'))
        .fontColor('#FFFFFF')
        .opacity(0.9)
        .fontSize(14)
        .margin({ top: '8%', left: '10%' })
      Row() {
        Column() {
          Button() {
            // $r('app.string.ButtonA_label')需要替换为开发者所需的资源文件
            Text($r('app.string.ButtonA_label'))
              .fontColor('#45A6F4')
              .fontSize(12)
          }
          .width(120)
          .height(32)
          .margin({ top: '20%' })
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
          .onClick(() => {
            postCardAction(this, {
              action: 'router',
              abilityName: 'EntryAbility',
              params: { targetPage: 'funA' }
            });
          })

          Button() {
            // $r('app.string.ButtonB_label')需要替换为开发者所需的资源文件
            Text($r('app.string.ButtonB_label'))
              .fontColor('#45A6F4')
              .fontSize(12)
          }
          .width(120)
          .height(32)
          .margin({ top: '8%', bottom: '15vp' })
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
          .onClick(() => {
            postCardAction(this, {
              action: 'router',
              abilityName: 'EntryAbility',
              params: { targetPage: 'funB' }
            });
          })
        }
      }.width('100%').height('80%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
    // $r('app.media.CardEvent')需要替换为开发者所需的资源文件
    .backgroundImage($r('app.media.CardEvent'))
    .backgroundImageSize(ImageSize.Cover)
  }
}
// [End widget_event_router_card]