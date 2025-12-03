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
// [Start widget_event_call_card]
//src/main/ets/widgeteventcall/pages/WidgetEventCallCard.ets
let storageEventCall = new LocalStorage();

@Entry(storageEventCall)
@Component
struct WidgetEventCallCard {
  @LocalStorageProp('formId') formId: string = '12400633174999288';
  private funA: Resource = $r('app.string.ButtonA_label');
  private funB: Resource = $r('app.string.ButtonB_label');

  build() {
    RelativeContainer() {
      Button(this.funA)
        .id('funA__')
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          postCardAction(this, {
            action: 'call',
            // 只能跳转到当前应用下的UIAbility，与module.json5中定义保持一致
            abilityName: 'WidgetEventCallEntryAbility',
            params: {
              formId: this.formId,
              // 需要调用的方法名称
              method: 'funA'
            }
          });
        })

      Button(this.funB)
        .id('funB__')
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 10 })
        .alignRules({
          top: { anchor: 'funA__', align: VerticalAlign.Bottom },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          postCardAction(this, {
            action: 'call',
            abilityName: 'WidgetEventCallEntryAbility',
            params: {
              formId: this.formId,
              // 需要调用的方法名称
              method: 'funB',
              num: 1
            }
          });
        })
    }
    .height('100%')
    .width('100%')
  }
}

// [End widget_event_call_card]