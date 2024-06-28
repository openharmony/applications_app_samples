/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { autoFillManager } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

let storage = LocalStorage.getShared();
let saveRequestCallback = storage.get<autoFillManager.SaveRequestCallback>('saveCallback');
const TAG: string = 'autoFill';
const DOMAIN_NUMBER: number = 0xFF00;

function SuccessFunc(success: boolean) {
  if (saveRequestCallback) {
    if (success) {
      saveRequestCallback.onSuccess();
      hilog.info(DOMAIN_NUMBER, TAG, 'saveRequestCallback success');
      return;
    }
    saveRequestCallback.onFailure();
    hilog.info(DOMAIN_NUMBER, TAG, 'saveRequestCallback onFailure');
  }
  hilog.error(DOMAIN_NUMBER, TAG, 'saveRequestCallback is nullptr!');
}

@Entry
@Component
struct SavePage {
  build() {
    Column() {
      Column() {
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Image($r('app.media.arrow'))
            .height(44)
            .width(44)
            .onClick(() => {
              SuccessFunc(false);
            })
          Text($r('app.string.scenarioization'))
            .fontWeight(500)
            .fontFamily('HarmonyHeiTi-Medium')
            .fontSize(22)
            .margin({ left: '2.4%' })
        }.margin({ top: '12.8%', left: '4.9%' })

        Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Image($r('app.media.style'))
            .height('448px')
            .width('448px')
        }.margin({ top: '19.8%' })
      }.height('70%')

      Column() {
        Column() {
          Row() {
            Button($r('app.string.cancel'))
              .type(ButtonType.Normal)
              .borderRadius(25)
              .fontSize(16)
              .fontWeight(400)
              .margin({ right: 6 })
              .fontColor($r('app.color.cancelBtnColor'))
              .backgroundColor($r('app.color.mainInterface'))
              .height('20.8%')
              .width('44.5%')
              .onClick(() => {
                SuccessFunc(true);
              })

            Button($r('app.string.confirm'))
              .type(ButtonType.Normal)
              .borderRadius(25)
              .fontSize(16)
              .fontWeight(400)
              .margin({ left: 6 })
              .fontColor($r('app.color.mainInterface'))
              .id('saveOnly')
              .backgroundColor($r('app.color.cancelBtnColor'))
              .height('20.8%')
              .width('44.5%')
              .onClick(() => {
                SuccessFunc(false);
              })
          }
        }
        .margin({ bottom: '44px' })
      }
      .height('30%')
      .justifyContent(FlexAlign.End)
      .alignItems(HorizontalAlign.Center)
    }.backgroundColor($r('app.color.pageBackColor')).height('100%')
  }
}