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

import { FullScreenLaunchComponent } from '@ohos.arkui.advanced.FullScreenLaunchComponent';
import { common } from '@kit.AbilityKit';
import AtomicServiceOptions from '@ohos.app.ability.AtomicServiceOptions';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct Index {
  // Developers need to create an AtomicService within AppGallery Connect and replace this appId.
  private appId: string = '5765880207854787517';
  private options: AtomicServiceOptions = {
    displayId: 0
  };
  private context = getContext(this) as common.UIAbilityContext;

  build() {
    Column() {
      Column() {
        Row() {
          Text($r('app.string.AtomicService'))
            .fontSize(30)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bold)
        }
        .margin({ top: 64, left: 12 })
        .width('86.7%')
        .height('14.5%')
      }
      .width('100%')
      .height('50%')
      .alignItems(HorizontalAlign.Start)

      Column() {
        FullScreenLaunchComponent({
          content: fullScreenStart,
          appId: this.appId,
          options: {}
        }).margin({ bottom: '3.08%' })

        Button($r('app.string.UIAbilityStart'))
          .onClick((event: ClickEvent) => {
            try {
              this.context.openAtomicService(this.appId, this.options)
                .then((result: common.AbilityResult) => {
                  hilog.info(0x0000, 'testTag', 'openAtomicService succeed');
                })
                .catch((err: BusinessError) => {
                  hilog.error(0x0000, 'testTag',
                    `openAtomicService failed, code is ${err.code}, message is ${err.message}`);
                });
            } catch (err) {
              let code = (err as BusinessError).code;
              let message = (err as BusinessError).message;
              hilog.error(0x0000, 'testTag', `openAtomicService failed, code is ${code}, message is ${message}`);
            }
          })
          .id('UIAbilityStart')
          .width('93.4%')
          .height('10.26%')
          .margin({ bottom: '3.08%' })

        UIExtensionComponent(
          {
            bundleName: 'com.samples.fullscreenstart',
            abilityName: 'UIExtAbility',
            moduleName: 'entry',
            parameters: {
              'ability.want.params.uiExtensionType': 'sys/commonUI',
            }
          })
          .size({ width: '100%', height: '10.26%' })
          .margin({ bottom: '4.10%' })
      }
      .justifyContent(FlexAlign.End)
      .width('100%')
      .height('50%')
    }
    .width('100%')
    .height('100%')
  }
}

@Builder
function fullScreenStart() {
  Column() {
    Button($r('app.string.EmbeddableStart'))
      .width('93.4%')
      .height('10.26%')
      .id('EmbeddableStart')
  }
}