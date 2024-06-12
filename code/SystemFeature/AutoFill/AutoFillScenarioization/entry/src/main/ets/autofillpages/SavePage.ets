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
          .height('44%')
          .width('60.5%')
      }.margin({ top: '19.8%' })

      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.End }) {
        Row() {
          Button($r('app.string.cancel'))
            .type(ButtonType.Normal)
            .borderRadius(25)
            .fontSize(20)
            .margin({ top: 30, right: 10 })
            .fontColor($r('app.color.cancelBtnColor'))
            .backgroundColor($r('app.color.mainInterface'))
            .height('7.8%')
            .width('42.2%')
            .onClick(() => {
              SuccessFunc(true);
            })

          Button($r('app.string.confirm'))
            .type(ButtonType.Normal)
            .borderRadius(25)
            .fontSize(20)
            .margin({ top: 30, left: 10 })
            .fontColor($r('app.color.mainInterface'))
            .id('saveOnly')
            .backgroundColor($r('app.color.cancelBtnColor'))
            .height('7.8%')
            .width('42.2%')
            .onClick(() => {
              SuccessFunc(false);
            })
        }
      }
      .margin({ top: '38.8%' })
    }.backgroundColor($r('app.color.pageBackColor')).height('100%')
  }
}