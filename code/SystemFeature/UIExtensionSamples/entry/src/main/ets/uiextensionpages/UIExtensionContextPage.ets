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

import { common, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { promptAction } from '@kit.ArkUI';

const TAG: string = 'UIExtensionContent';
const DOMAIN: number = 0xFF00;
let storage: LocalStorage = LocalStorage.getShared();

@Entry(storage)
@Component
struct UIExtensionContextPage {
  private context = getContext(this) as common.UIExtensionContext;
  private want: (Want | undefined) = storage.get<Want>('want');
  private promptDuration: number = 2000;

  build() {
    Column() {
      Row() {
      }
      .width('100%')
      .height('6%')
      .justifyContent(FlexAlign.Start)
      .backgroundColor($r('app.color.start_window_background'))

      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.UIExtensionAbilityContext'))
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
      .margin({
        top: '7.18%',
        bottom: '6.41%',
        left: '3.33%'
      })
      .width('100%')
      .height('7.18%')
      .justifyContent(FlexAlign.Start)
      .backgroundColor($r('app.color.backGrounding'))

      List({ initialIndex: 0 }) {
        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.UIExtensionContent_reportDrawnCompleted'))
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
          .id('reportDrawnCompleted')
          .onClick(() => {
            ((): void => {
              try {
                this.context.reportDrawnCompleted((err) => {
                  if (err.code) {
                    // 处理业务逻辑错误
                    let msg =
                      `UIExtensionContent.reportDrawnCompleted failed, code is ${err.code}, message is ${err.message}`;
                    hilog.info(DOMAIN, TAG, msg);
                    promptAction.showToast({ message: msg, duration: this.promptDuration });
                    return;
                  }
                  // 执行正常业务
                  let msg = `UIExtensionContent.reportDrawnCompleted succeed.`;
                  hilog.info(DOMAIN, TAG, msg);
                  promptAction.showToast({ message: msg, duration: this.promptDuration });
                });
              } catch (err) {
                // 捕获同步的参数错误
                let msg = `UIExtensionContent.reportDrawnCompleted failed,err is ${JSON.stringify(err)}`;
                hilog.info(DOMAIN, TAG, msg);
                promptAction.showToast({ message: msg, duration: this.promptDuration });
              }
            })()
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.UIExtensionContent_terminateSelfCallback'))
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
          .id('terminateSelfCallback')
          .onClick(() => {
            ((): void => {
              this.context?.terminateSelf(() => {
                hilog.info(DOMAIN, TAG, 'UIExtensionContent_terminateSelfCallback(callback) called');
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
            Text($r('app.string.UIExtensionContent_terminateSelfPromise'))
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
          .id('terminateSelfPromise')
          .onClick(() => {
            ((): void => {
              this.context?.terminateSelf().then(() => {
                hilog.info(DOMAIN, TAG, 'UIExtensionContent_terminateSelfPromise(promise) called');
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
            Text($r('app.string.UIExtensionContent_terminateSelfWithResultCallback'))
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
              this.context?.terminateSelfWithResult({ resultCode: 99, want: this.want }, () => {
                hilog.info(DOMAIN, TAG, 'UIExtensionContent_terminateSelfWithResultCallback(callback) called');
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
            Text($r('app.string.UIExtensionContent_terminateSelfWithResultPromise'))
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
              this.context?.terminateSelfWithResult({ resultCode: 100, want: this.want }).then(() => {
                hilog.info(DOMAIN, TAG, 'UIExtensionContent.terminateSelfWithResult(promise) called');
              })
            })()
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

      }
      .height('85%')
      .backgroundColor($r('app.color.backGrounding'))
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.backGrounding'))
  }
}