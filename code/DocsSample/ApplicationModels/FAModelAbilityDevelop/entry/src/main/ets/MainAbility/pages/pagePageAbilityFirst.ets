/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import featureAbility from '@ohos.ability.featureAbility';
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@ohos.base';
import fs from '@ohos.file.fs';
import promptAction from '@ohos.promptAction';
import worker from '@ohos.worker';
import hilog from '@ohos.hilog';

const TAG: string = 'PagePageAbilityFirst';
const domain: number = 0xFF00;

@Entry
@Component
struct PagePageAbilityFirst {
  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.pageAbility_first_button'))
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .margin({ top: 12, bottom: 11, right: 24, left: 24 })
        }
      }
      .width('100%')
      .height(56)
      .justifyContent(FlexAlign.Start)
      .backgroundColor($r('app.color.backGrounding'))

      List({ initialIndex: 0 }) {
        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.getDirectory_button'))
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 17, bottom: 17, left: 12, right: 92 })
              .fontSize(16)
              .width(232)
              .height(22)
              .fontColor($r('app.color.text_color'))
          }
          .onClick(() => {
            (async (): Promise<void> => {
              let dir: string;
              try {
                hilog.info(domain, TAG, 'Begin to getOrCreateDistributedDir');
                dir = await featureAbility.getContext().getOrCreateDistributedDir();
                promptAction.showToast({
                  message: dir
                });
                hilog.info(domain, TAG, 'distribute dir is ' + dir);
                let fd: number;
                let path = dir + '/a.txt';
                fd = fs.openSync(path, fs.OpenMode.READ_WRITE).fd;
                fs.close(fd);
              } catch (error) {
                hilog.error(domain, TAG, 'getOrCreateDistributedDir failed with : ' + error);
              }
            })()
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 8, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.start_singleton_button'))
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 17, bottom: 17, left: 12, right: 92 })
              .fontSize(16)
              .width(232)
              .height(22)
              .fontColor($r('app.color.text_color'))
          }
          .onClick(() => {
            (async (): Promise<void> => {
              try {
                hilog.info(domain, TAG, 'Begin to start ability');
                let want: Want = {
                  bundleName: 'com.samples.famodelabilitydevelop',
                  moduleName: 'entry',
                  abilityName: 'com.samples.famodelabilitydevelop.PageAbilitySingleton'
                };
                await featureAbility.startAbility({ want: want });
                hilog.info(domain, TAG, `Start ability succeed`);
              }
              catch (error) {
                hilog.error(domain, TAG, 'Start ability failed with ' + error);
              }
            })()
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.restart_singleton_button'))
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 17, bottom: 17, left: 12, right: 92 })
              .fontSize(16)
              .width(232)
              .height(22)
              .fontColor($r('app.color.text_color'))
          }
          .onClick(() => {
            (async (): Promise<void> => {
              let wantInfo: Want = {
                bundleName: 'com.samples.famodelabilitydevelop',
                abilityName: 'com.samples.famodelabilitydevelop.PageAbilitySingleton',
                parameters: { page: 'pages/second' }
              };
              featureAbility.startAbility({ want: wantInfo }).then((data) => {
                hilog.debug(domain, TAG, `restartAbility success : ${data}`);
              });
            })()
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.start_standard_first_button'))
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 17, bottom: 17, left: 12, right: 92 })
              .fontSize(16)
              .width(232)
              .height(22)
              .fontColor($r('app.color.text_color'))
          }
          .onClick(() => {
            let want: Want = {
              bundleName: 'com.samples.famodelabilitydevelop',
              abilityName: 'com.samples.famodelabilitydevelop.PageAbilityStandard',
              parameters: { page: 'pages/first' }
            };
            featureAbility.startAbility({ want: want }).then((data) => {
              hilog.info(domain, TAG, `startAbility finish:${data}`);
            }).catch((err: BusinessError) => {
              hilog.info(domain, TAG, `startAbility failed errcode:${err.code}`);
            })
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.start_standard_second_button'))
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 17, bottom: 17, left: 12, right: 92 })
              .fontSize(16)
              .width(232)
              .height(22)
              .fontColor($r('app.color.text_color'))
          }
          .onClick(() => {
            let want: Want = {
              bundleName: 'com.samples.famodelabilitydevelop',
              abilityName: 'com.samples.famodelabilitydevelop.PageAbilityStandard',
              parameters: { page: 'pages/second' }
            };
            featureAbility.startAbility({ want: want }).then((data) => {
              hilog.info(domain, TAG, `startAbility finish:${data}`);
            }).catch((err: BusinessError) => {
              hilog.info(domain, TAG, `startAbility failed errcode:${err.code}`);
            })
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.stop_pageAbility_button'))
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 17, bottom: 17, left: 12, right: 92 })
              .fontSize(16)
              .width(232)
              .height(22)
              .fontColor($r('app.color.text_color'))
          }
          .onClick(() => {
            (async (): Promise<void> => {
              try {
                hilog.info(domain, TAG, 'Begin to terminateSelf');
                await featureAbility.terminateSelf();
                hilog.info(domain, TAG, 'terminateSelf succeed');
              } catch (error) {
                hilog.error(domain, TAG, 'terminateSelf failed with ' + error);
              }
            })()
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
            Text($r('app.string.worker_button'))
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 17, bottom: 17, left: 12, right: 92 })
              .fontSize(16)
              .width(232)
              .height(22)
              .fontColor($r('app.color.text_color'))
          }
          .onClick(() => {
            let wk = new worker.ThreadWorker('../workers/worker.ts');

            // 发送消息到worker线程
            wk.postMessage('message from main thread.')

            // 处理来自worker线程的消息
            wk.onmessage = (message): void => {
              promptAction.showToast({
                message: JSON.stringify(message)
              });
              hilog.info(domain, TAG, 'message from worker: ' + JSON.stringify(message));

              // 根据业务按需停止worker线程
              wk.terminate();
            }
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })
      }
      .height('100%')
      .backgroundColor($r('app.color.backGrounding'))
    }
    .width('100%')
    .margin({ top: 8 })
    .backgroundColor($r('app.color.backGrounding'))
  }
}