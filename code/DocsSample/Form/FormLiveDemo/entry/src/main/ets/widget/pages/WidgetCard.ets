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
// [Start liveform_WidgetCard]
// entry/src/main/ets/widget/pages/WidgetCard.ets
@Entry
@Component
struct WidgetCard {
  build() {
    Row() {
      Column() {
        Text($r('app.string.liveform_click1'))
          .fontSize($r('app.float.font_size'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
      }
      .width('100%')
    }
    .height('100%')
    .onClick(() => {
      // 点击卡片时，选择向EntryFormAbility发送消息，并在其onFormEvent回调中调用formProvider.requestOverflow，请求卡片动效
      postCardAction(this, {
        action: 'message',
        abilityName: 'EntryFormAbility',
        params: {
          message: 'requestOverflow'
        }
      });
    })
  }
}
// [End liveform_WidgetCard]