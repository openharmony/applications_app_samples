/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { BusinessError } from '@kit.BasicServicesKit';
import { common, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { promptAction } from '@kit.ArkUI';

const TAG: string = '[UIExtensionContentSession]';
const DOMAIN: number = 0xFF00;

@Entry
@Component
struct UIExtensionContentSession {
  private promptDuration: number = 2000;
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.UIExtensionContentSession'))
            .fontSize(30)
            .fontWeight(700)
            .textAlign(TextAlign.Start)
            .margin({
              top: 8,
              bottom: 8,
              left: 12
            })
        }
      }
      .width('100%')
      .height('14.36%')
      .justifyContent(FlexAlign.Start)
      .backgroundColor($r('app.color.backGrounding'))

      List({ initialIndex: 0 }) {
        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.UIExtensionAbilityContext_requestModalUIExtension'))
              .textAlign(TextAlign.Start)
              .fontWeight(500)
              .margin({
                top: 17,
                bottom: 17,
                left: 12
              })
              .fontSize(16)
              .width('77.87%')
              .height('39.29%')
              .fontColor($r('app.color.text_color'))

            Row() {
              Image($r('app.media.ic_arrow'))
                .width(24)
                .height(24)
                .margin({ top: 16, bottom: 16, right: 6 })
            }
          }
          .id('startUIExtensionAbility')
          .onClick(() => {
            ((): void => {
              let want: Want = {
                bundleName: 'com.samples.UIExtension',
                moduleName: 'entry',
                abilityName: 'SessionUIExtensionAbility',
                type: 'sys/commonUI',
                parameters: {
                  bundleName: 'com.samples.UIExtension',
                  'ability.want.params.uiExtensionType': 'sys/commonUI',
                }
              };

              this.context.requestModalUIExtension(want)
                .then(() => {
                  let msg: string = `requestModalUIExtension succeed.`;
                  hilog.info(DOMAIN, TAG, msg);
                  promptAction.showToast({ message: msg, duration: this.promptDuration });
                })
                .catch((err: BusinessError) => {
                  let msg = `requestModalUIExtension failed, code is ${err.code}, message is ${err.message}`;
                  hilog.info(DOMAIN, TAG, msg);
                  promptAction.showToast({ message: msg, duration: this.promptDuration });
                })
            })()
          })
        }
        .height('8.86%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

      }
      .height('86%')
      .backgroundColor($r('app.color.backGrounding'))
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.backGrounding'))
  }
}