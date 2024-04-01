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

import common from '@ohos.app.ability.common';
import deviceManager from '@ohos.distributedDeviceManager';
import hilog from '@ohos.hilog';
import promptAction from '@ohos.promptAction';
import rpc from '@ohos.rpc';
import Want from '@ohos.app.ability.Want';
// 客户端需要将服务端对外提供的idl_service_ext_proxy.ts导入到本地工程中
import IdlServiceExtProxy from '../IdlServiceExt/idl_service_ext_proxy';

import { BusinessError } from '@ohos.base';

const TAG: string = '[Page_ServiceExtensionAbility]';
const DOMAIN_NUMBER: number = 0xFF00;

let connectionId: number;
let dmClass: deviceManager.DeviceManager;

let want: Want = {
  deviceId: '',
  bundleName: 'com.samples.stagemodelabilitydevelop',
  abilityName: 'ServiceExtAbility'
};

let options: common.ConnectOptions = {
  onConnect(elementName, remote: rpc.IRemoteObject): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onConnect callback');
    if (remote === null) {
      hilog.info(DOMAIN_NUMBER, TAG, `onConnect remote is null`);
      return;
    }
    let serviceExtProxy: IdlServiceExtProxy = new IdlServiceExtProxy(remote);
    // 通过接口调用的方式进行通信，屏蔽了RPC通信的细节，简洁明了
    serviceExtProxy.processData(1, (errorCode: number, retVal: number) => {
      hilog.info(DOMAIN_NUMBER, TAG, `processData, errorCode: ${errorCode}, retVal: ${retVal}`);
    });
    serviceExtProxy.insertDataToMap('theKey', 1, (errorCode: number) => {
      hilog.info(DOMAIN_NUMBER, TAG, `insertDataToMap, errorCode: ${errorCode}`);
    })
  },
  onDisconnect(elementName): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onDisconnect callback');
  },
  onFailed(code: number): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onFailed callback', JSON.stringify(code));
  }
};

function getRemoteDeviceId(): string | undefined {
  if (typeof dmClass === 'object' && dmClass !== null) {
    let list = dmClass.getAvailableDeviceListSync();
    hilog.info(DOMAIN_NUMBER, TAG, JSON.stringify(dmClass), JSON.stringify(list));
    if (typeof (list) === 'undefined' || typeof (list.length) === 'undefined') {
      hilog.info(DOMAIN_NUMBER, TAG, 'getRemoteDeviceId err: list is null');
      return;
    }
    if (list.length === 0) {
      hilog.info(DOMAIN_NUMBER, TAG, `getRemoteDeviceId err: list is empty`);
      return;
    }
    return list[0].networkId;
  } else {
    hilog.info(DOMAIN_NUMBER, TAG, 'getRemoteDeviceId err: dmClass is null');
    return;
  }
}

@Entry
@Component
struct Page_ServiceExtensionAbility {
  private context = getContext(this) as common.UIAbilityContext;

  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.ServiceExtension'))
            .fontSize(24)
            .fontWeight(700)
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
              Text($r('app.string.StartBackendService'))
                .textAlign(TextAlign.Start)
                .fontWeight(500)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 12 })
          }
          .onClick(() => {
            let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext; // UIAbilityContext
            let want: Want = {
              deviceId: '',
              bundleName: 'com.samples.stagemodelabilitydevelop',
              abilityName: 'ServiceExtAbility'
            };
            context.startServiceExtensionAbility(want).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in starting ServiceExtensionAbility.');
              // 成功启动后台服务
              promptAction.showToast({
                message: $r('app.string.SuccessfullyStartBackendService')
              });
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to start ServiceExtensionAbility. Code is ${err.code}, message is ${err.message}`);
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 8, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row() {
              Text($r('app.string.StopStartedBackendService'))
                .textAlign(TextAlign.Start)
                .fontWeight(500)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 12 })
          }
          .onClick(() => {
            let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext; // UIAbilityContext
            let want: Want = {
              deviceId: '',
              bundleName: 'com.samples.stagemodelabilitydevelop',
              abilityName: 'ServiceExtAbility'
            };
            context.stopServiceExtensionAbility(want).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in stopping ServiceExtensionAbility.');
              promptAction.showToast({
                message: $r('app.string.SuccessfullyStoppedAStartedBackendService')
              });
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to stop ServiceExtensionAbility. Code is ${err.code}, message is ${err.message}`);
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row() {
              Text($r('app.string.StopBackendServices'))
                .textAlign(TextAlign.Start)
                .fontWeight(500)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 12 })
          }
          .onClick(() => {
            let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext; // UIAbilityContext
            context.terminateSelf().then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in terminating self.');
              // 成功停止当前后台服务
              promptAction.showToast({
                message: $r('app.string.SuccessfullyStopStartedBackendService')
              });
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to terminate self. Code is ${err.code}, message is ${err.message}`);
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row() {
              Text($r('app.string.ConnectBackendService'))
                .textAlign(TextAlign.Start)
                .fontWeight(500)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 12 })
          }
          .onClick(() => {
            let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext; // UIAbilityContext
            // 建立连接后返回的Id需要保存下来，在解绑服务时需要作为参数传入
            connectionId = context.connectServiceExtensionAbility(want, options);
            // 成功连接后台服务
            promptAction.showToast({
              message: $r('app.string.SuccessfullyConnectBackendService')
            });
            // connectionId = context.connectAbility(want, options);
            hilog.info(DOMAIN_NUMBER, TAG, `connectionId is : ${connectionId}`);
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row() {
              Text($r('app.string.DisconnectBackendService'))
                .textAlign(TextAlign.Start)
                .fontWeight(500)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 12 })
          }
          .onClick(() => {
            let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext; // UIAbilityContext
            // connectionId为调用connectServiceExtensionAbility接口时的返回值，需开发者自行维护
            context.disconnectServiceExtensionAbility(connectionId).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'disconnectServiceExtensionAbility success');
              // 成功断连后台服务
              promptAction.showToast({
                message: $r('app.string.SuccessfullyDisconnectBackendService')
              });
            }).catch((error: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, 'disconnectServiceExtensionAbility failed');
            });
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