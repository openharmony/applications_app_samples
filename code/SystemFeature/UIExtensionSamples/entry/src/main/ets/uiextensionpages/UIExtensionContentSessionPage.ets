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

import { UIExtensionContentSession, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { promptAction } from '@kit.ArkUI';
import uiExtension from '@ohos.arkui.uiExtension';

const TAG: string = 'UIExtensionContentSession';
const DOMAIN: number = 0xFF00;
let storage: LocalStorage = LocalStorage.getShared();

@Entry
@Component
struct UIExtensionContentSessionPage {
  private session: (UIExtensionContentSession | undefined) = storage.get<UIExtensionContentSession>('session');
  private want: (Want | undefined) = storage.get<Want>('want');
  private promptDuration: number = 2000;

  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.UIExtensionAbilityContext'))
            .fontSize(30)
            .fontWeight(700)
            .textAlign(TextAlign.Start)
            .margin({
              top: '12%',
              left: '2%'
            })
        }
      }
      .width('100%')
      .height('18%')
      .justifyContent(FlexAlign.Start)
      .backgroundColor($r('app.color.backGrounding'))

      List({ initialIndex: 0 }) {
        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.UIExtensionContentSession_terminateSelfWithResultCallback'))
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

          }
          .id('terminateSelfWithResultCallback')
          .onClick(() => {
            ((): void => {
              this.session?.terminateSelfWithResult({ resultCode: 99, want: this.want }, () => {
                hilog.info(DOMAIN, TAG, 'UIExtensionContentSession.terminateSelfWithResult(callback) called');
              })
            })()
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.UIExtensionContentSession_terminateSelfWithResultPromise'))
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
          }
          .id('terminateSelfWithResultPromise')
          .onClick(() => {
            ((): void => {
              this.session?.terminateSelfWithResult({ resultCode: 100, want: this.want }).then(() => {
                hilog.info(DOMAIN, TAG, 'UIExtensionContentSession.terminateSelfWithResult(promise) called');
              })
            })()
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })


        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.UIExtensionContentSession_setWindowPrivacyModeCallback'))
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
          }
          .id('setWindowPrivacyModeCallback')
          .onClick(() => {
            ((): void => {
              this.session?.setWindowPrivacyMode(true, () => {
                let msg = `UIExtensionContentSession.setWindowPrivacyMode(callback) called. isPrivacyMode: true`;
                hilog.info(DOMAIN, TAG, msg);
                promptAction.showToast({ message: msg, duration: this.promptDuration });
              })
            })()
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.UIExtensionContentSession_setWindowPrivacyModePromise'))
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
          }
          .id('setWindowPrivacyModePromise')
          .onClick(() => {
            ((): void => {
              this.session?.setWindowPrivacyMode(false).then(() => {
                let msg = `UIExtensionContentSession.setWindowPrivacyMode(promise) called. isPrivacyMode: false`;
                hilog.info(DOMAIN, TAG, msg);
                promptAction.showToast({ message: msg, duration: this.promptDuration });
              })
            })()
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })


        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.UIExtensionContentSession_getUIExtensionWindowProxy'))
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
          }
          .id('getUIExtensionWindowProxy')
          .onClick(() => {
            ((): void => {
              let windowProxy: (uiExtension.WindowProxy | undefined) = this.session?.getUIExtensionWindowProxy();
              let msg = `UIExtensionContentSession.getUIExtensionWindowProxy called. proxy: ${typeof windowProxy}`;
              hilog.info(DOMAIN, TAG, msg);
              promptAction.showToast({ message: msg, duration: this.promptDuration });
            })()
          })
        }
        .height('8.45%')
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