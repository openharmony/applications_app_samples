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
import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import promptAction from '@ohos.promptAction';
import rpc from '@ohos.rpc';
import hilog from '@ohos.hilog';

const TAG: string = 'PageServiceAbility';
const domain: number = 0xFF00;

@Entry
@Component
struct PageServiceAbility {
  async startServiceAbility(): Promise<void> {
    try {
      hilog.info(domain, TAG, 'Begin to start ability');
      let want: Want = {
        bundleName: 'com.samples.famodelabilitydevelop',
        abilityName: 'com.samples.famodelabilitydevelop.ServiceAbility'
      };
      await featureAbility.startAbility({ want });
      promptAction.showToast({
        message: $r('app.string.start_service_success_toast')
      });
      hilog.info(domain, TAG, `Start ability succeed`);
    } catch (error) {
      hilog.error(domain, TAG, 'Start ability failed with ' + error);
    }
  }

  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.serviceAbility_button'))
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
          Row() {
            Row() {
              Text($r('app.string.create_service_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            this.startServiceAbility();
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 8, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row() {
              Text($r('app.string.connect_service_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            let option: common.ConnectOptions = {
              onConnect: (element, proxy) => {
                hilog.info(domain, TAG, `onConnectLocalService onConnectDone element:` + JSON.stringify(element));
                if (proxy === null) {
                  promptAction.showToast({
                    message: $r('app.string.connect_service_failed_toast')
                  });
                  return;
                }
                let data = rpc.MessageParcel.create();
                let reply = rpc.MessageParcel.create();
                let option = new rpc.MessageOption();
                data.writeInterfaceToken('connect.test.token');
                proxy.sendRequest(0, data, reply, option);
                promptAction.showToast({
                  message: $r('app.string.connect_service_success_toast')
                });
              },
              onDisconnect: (element) => {
                hilog.info(domain, TAG, `onConnectLocalService onDisconnectDone element:${element}`);
                promptAction.showToast({
                  message: $r('app.string.disconnect_service_success_toast')
                });
              },
              onFailed: (code) => {
                hilog.info(domain, TAG, `onConnectLocalService onFailed errCode:${code}`);
                promptAction.showToast({
                  message: $r('app.string.connect_service_failed_toast')
                });
              }
            };

            let request: Want = {
              bundleName: 'com.samples.famodelabilitydevelop',
              abilityName: 'com.samples.famodelabilitydevelop.ServiceAbility',
            };
            let connId = featureAbility.connectAbility(request, option);
            hilog.info(domain, TAG, `onConnectLocalService onFailed errCode:${connId}`);
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row() {
              Text($r('app.string.connect_wrong_service_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            let option: common.ConnectOptions = {
              onConnect: (element, proxy) => {
                hilog.info(domain, TAG, `onConnectLocalService onConnectDone element:` + JSON.stringify(element));
                if (proxy === null) {
                  promptAction.showToast({
                    message: $r('app.string.connect_service_failed_toast')
                  });
                  return;
                }
                let data = rpc.MessageParcel.create();
                let reply = rpc.MessageParcel.create();
                let option = new rpc.MessageOption();
                data.writeInterfaceToken('connect.test.token');
                proxy.sendRequest(0, data, reply, option);
                promptAction.showToast({
                  message: $r('app.string.connect_service_success_toast')
                });
              },
              onDisconnect: (element) => {
                hilog.info(domain, TAG, `onConnectLocalService onDisconnectDone element:${element}`)
                promptAction.showToast({
                  message: $r('app.string.disconnect_service_success_toast')
                });
              },
              onFailed: (code) => {
                hilog.info(domain, TAG, `onConnectLocalService onFailed errCode:${code}`);
                promptAction.showToast({
                  message: $r('app.string.connect_service_failed_toast')
                });
              }
            };

            let request: Want = {
              bundleName: 'com.samples.famodelabilitydevelop',
              abilityName: 'com.samples.famodelabilitydevelop.UnKnownServiceAbility',
            };
            let connId = featureAbility.connectAbility(request, option);
            hilog.info(domain, TAG, `onConnectLocalService onFailed errCode:${connId}`);
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