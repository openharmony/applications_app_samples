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
import { hilog } from '@kit.PerformanceAnalysisKit';
import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
import OpenLinkOptions from '@ohos.app.ability.OpenLinkOptions';

const TAG: string = 'UniversalLink';
const DOMAIN: number = 0xFF00;

@Entry
@Component
struct UniversalLink {
  private promptDuration: number = 2000;

  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.UniversalLink'))
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
            Text($r('app.string.UIAbilityContext_openLink'))
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
          .id('openLinkPromise')
          .onClick(() => {
            let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
            let link: string = 'http://docs.openharmony.cn';
            let openLinkOptions: OpenLinkOptions = {
              appLinkingOnly: false
            };

            try {
              context.openLink(link, openLinkOptions).then(() => {
                hilog.info(DOMAIN, TAG, 'open link success.');
              }).catch((err: BusinessError) => {
                hilog.error(DOMAIN, TAG, `open link failed. Code is ${err.code}, message is ${err.message}`);
              })
            } catch (paramError) {
              hilog.error(DOMAIN, TAG,
                `Failed to start link. Code is ${paramError.code}, message is ${paramError.message}`);
            }
          })
        }
        .height('8.65%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.UIAbilityContext_openLink_withResult'))
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
          .id('openLinkCallback')
          .onClick(() => {
            let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
            let link: string = 'http://docs.openharmony.cn';
            let openLinkOptions: OpenLinkOptions = {
              appLinkingOnly: false
            };

            try {
              context.openLink(link, openLinkOptions, (err, data) => {
                let msg = `open link success. Callback result: ${JSON.stringify(data)}`
                hilog.info(DOMAIN, TAG, msg);
                promptAction.showToast({ message: msg, duration: this.promptDuration });
              }).then(() => {
                hilog.info(DOMAIN, TAG, 'open link success.');
              }).catch((err: BusinessError) => {
                hilog.error(DOMAIN, TAG, `open link failed. Code is ${err.code}, message is ${err.message}`);
              })
            } catch (paramError) {
              hilog.error(DOMAIN, TAG,
                `Failed to start link. Code is ${paramError.code}, message is ${paramError.message}`);
            }
          })
        }
        .height('8.65%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })
      }
      .height('86%')
      .backgroundColor($r('app.color.backGrounding'))
    }
    .height('100%')
    .width('100%')
  }
}