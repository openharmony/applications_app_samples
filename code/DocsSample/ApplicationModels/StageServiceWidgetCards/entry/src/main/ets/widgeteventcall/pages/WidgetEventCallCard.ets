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

let storageEventCall = new LocalStorage();

// [Start widget_event_call_card]
@Entry(storageEventCall)
@Component
struct WidgetEventCallCard {
  @LocalStorageProp('formId') formId: string = '12400633174999288';

  build() {
    Column() {
      // [StartExclude widget_event_call_card]
      Text($r('app.string.WidgetEventCallEntryAbility_desc'))
        .fontColor('#FFFFFF')
        .opacity(0.9)
        .fontSize(14)
        .margin({ top: '8%', left: '10%' })
        // [EndExclude widget_event_call_card]
      Row() {
        Column() {
          Button() {
            // [StartExclude widget_event_call_card]
            Text($r('app.string.ButtonA_label'))
              .fontColor('#45A6F4')
              .fontSize(12)
              // [EndExclude widget_event_call_card]
          }
          // [StartExclude widget_event_call_card]
          .width(120)
          .height(32)
          .margin({ top: '20%' })
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
          // [EndExclude widget_event_call_card]
          .onClick(() => {
            postCardAction(this, {
              action: 'call',
              abilityName: 'WidgetEventCallEntryAbility', // 只能跳转到当前应用下的UIAbility
              params: {
                formId: this.formId,
                method: 'funA' // 在EntryAbility中调用的方法名
              }
            });
          })

          Button() {
            // [StartExclude widget_event_call_card]
            Text($r('app.string.ButtonB_label'))
              .fontColor('#45A6F4')
              .fontSize(12)
              // [EndExclude widget_event_call_card]
          }
          // [StartExclude widget_event_call_card]
          .width(120)
          .height(32)
          .margin({ top: '8%', bottom: '15vp' })
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
          // [EndExclude widget_event_call_card]
          .onClick(() => {
            postCardAction(this, {
              action: 'call',
              abilityName: 'WidgetEventCallEntryAbility', // 只能跳转到当前应用下的UIAbility
              params: {
                formId: this.formId,
                method: 'funB', // 在EntryAbility中调用的方法名
                num: 1 // 需要传递的其他参数
              }
            });
          })
        }
      }.width('100%').height('80%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
    // [StartExclude widget_event_call_card]
    .backgroundImage($r('app.media.CardEvent'))
    .backgroundImageSize(ImageSize.Cover)
    // [EndExclude widget_event_call_card]
  }
}
// [End widget_event_call_card]