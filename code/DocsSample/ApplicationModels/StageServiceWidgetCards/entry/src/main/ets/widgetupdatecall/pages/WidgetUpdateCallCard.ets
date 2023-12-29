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

let storageUpdtCall = new LocalStorage();

@Entry(storageUpdtCall)
@Component
struct WidgetUpdateCallCard {
  @LocalStorageProp('formId') formId: string = '12400633174999288';
  @LocalStorageProp('calleeDetail') calleeDetail: ResourceStr = $r('app.string.init');

  build() {
    Column() {
      Column() {
          Text(this.calleeDetail)
          .fontColor('#FFFFFF')
          .opacity(0.9)
          .fontSize(14)
          .margin({ top: '8%', left: '10%' })
      }.width('100%').height('50%')
      .alignItems(HorizontalAlign.Start)

      Row() {
        Button() {
          Text($r('app.string.CalleeJumpLabel'))
            .fontColor('#45A6F4')
            .fontSize(12)
        }
        .width(120)
        .height(32)
        .margin({ top: '30%', bottom: '10%' })
        .backgroundColor('#FFFFFF')
        .borderRadius(16)
        .onClick(() => {
          postCardAction(this, {
            action: 'call',
            abilityName: 'WidgetCalleeEntryAbility', // 只能拉起当前应用下的UIAbility
            params: {
              method: 'funA',
              formId: this.formId,
              calleeDetail: 'CallFrom'
            }
          });
        })
      }.width('100%').height('40%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
    .backgroundImage($r('app.media.CardEvent'))
    .backgroundImageSize(ImageSize.Cover)
  }
}