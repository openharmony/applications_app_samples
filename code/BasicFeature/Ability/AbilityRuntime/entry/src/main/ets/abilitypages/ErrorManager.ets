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

import { errorManager } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { promptAction } from '@kit.ArkUI';

const TAG: string = 'ErrorManager';
const DOMAIN: number = 0xFF00;

let observer: errorManager.LoopObserver = {
  onLoopTimeOut(timeout: number) {
    hilog.info(DOMAIN, TAG, `onLoopTimeOut, timeout: ${timeout}`)
    errorManager.off("loopObserver");
  }
};

@Entry
@Component
struct ErrorManager {
  private promptDuration: number = 2000;
  private loopTimeOut: number = 20;
  @State unhandledRejectionRegistered: boolean = false;

  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.ErrorManager'))
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
            Text($r('app.string.registerLoopObserver'))
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
          .id('registerLoopObserver')
          .onClick(() => {
            ((): void => {
              try {
                errorManager.on("loopObserver", this.loopTimeOut, observer);
                let msg = `loopObserver registered successfully, loopTimeOut: ${this.loopTimeOut}`;
                hilog.info(DOMAIN, TAG, msg);
                promptAction.showToast({
                  message: msg,
                  duration: this.promptDuration
                })
              } catch (error) {
                hilog.info(DOMAIN, TAG, `errorManager.on("loopObserver") failed, error: ${JSON.stringify(error)}`);
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
            Text(this.unhandledRejectionRegistered ?
            $r('app.string.unregisterUnhandledRejection') : $r('app.string.registerUnhandledRejection'))
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
          .id(this.unhandledRejectionRegistered ? ('unregisterUnhandledRejection') : ('registerUnhandledRejection'))
          .onClick(() => {
            ((): void => {
              if (this.unhandledRejectionRegistered == false) {
                let observer: errorManager.UnhandledRejectionObserver = (reason: Error, promise: Promise<void>) => {
                  let msg = `UnhandledRejectionObserver reason: ${JSON.stringify(reason)}`;
                  hilog.info(DOMAIN, TAG, msg);
                  promptAction.showToast({
                    message: msg,
                    duration: this.promptDuration
                  })
                };

                try {
                  errorManager.on("unhandledRejection", observer);
                  this.unhandledRejectionRegistered = true;
                  let msg = `unhandledRejection registered successfully`;
                  hilog.info(DOMAIN, TAG, msg);
                  promptAction.showToast({
                    message: msg,
                    duration: this.promptDuration
                  })
                } catch (error) {
                  hilog.info(DOMAIN, TAG,
                    `errorManager.on("unhandledRejection") failed, error: ${JSON.stringify(error)}`);
                  this.unhandledRejectionRegistered = false;
                }

              } else {
                try {
                  errorManager.off("unhandledRejection");
                  this.unhandledRejectionRegistered = false;
                  let msg: string = `unhandledRejection unregistered successfully`;
                  hilog.info(DOMAIN, TAG, msg);
                  promptAction.showToast({
                    message: msg,
                    duration: this.promptDuration
                  })
                } catch (error) {
                  this.unhandledRejectionRegistered = true;
                  hilog.info(DOMAIN, TAG, `unhandledRejection unregistered failed, error: ${JSON.stringify(error)}`);
                }
              }
            })()
          })
        }
        .height('8.45%')
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        if (this.unhandledRejectionRegistered) {
          ListItem() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
              Text($r('app.string.simulateUnhandledRejection'))
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
            .id('simulateUnhandledRejection')
            .onClick(() => {
              Promise.reject({ name: 'test', message: 'simulateUnhandledRejection' });
            })
          }
          .height('8.45%')
          .backgroundColor($r('app.color.start_window_background'))
          .borderRadius(24)
          .margin({ top: 12, right: 12, left: 12 })
        }
      }
      .height('86%')
      .backgroundColor($r('app.color.backGrounding'))
    }
    .height('100%')
    .width('100%')
  }
}