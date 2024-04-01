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
import { BusinessError } from '@ohos.base';
import { Caller } from '@ohos.app.ability.UIAbility';

const TAG: string = '[Page_CollaborateAbility]';
const DOMAIN_NUMBER: number = 0xFF00;
const REQUEST_CODE = 1;

let dmClass: deviceManager.DeviceManager;

let connectionId: number;
let options: common.ConnectOptions = {
  onConnect(elementName, remote): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onConnect callback');
    if (remote === null) {
      hilog.info(DOMAIN_NUMBER, TAG, `onConnect remote is null`);
      return;
    }
    let option = new rpc.MessageOption();
    let data = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();
    data.writeInt(99);
    // 开发者可发送data到目标端应用进行相应操作
    // @param code 表示客户端发送的服务请求代码。
    // @param data 表示客户端发送的{@link MessageSequence}对象。
    // @param reply 表示远程服务发送的响应消息对象。
    // @param options 指示操作是同步的还是异步的。
    // @return 如果操作成功返回{@code true}； 否则返回 {@code false}。
    remote.sendMessageRequest(REQUEST_CODE, data, reply, option).then((ret: rpc.RequestResult) => {
      let errCode = reply.readInt(); // 在成功连接的情况下，会收到来自目标端返回的信息（100）
      let msg: number = 0;
      if (errCode === 0) {
        msg = reply.readInt();
      }
      hilog.info(DOMAIN_NUMBER, TAG, `sendRequest msg:${msg}`);
      // 成功连接后台服务
      promptAction.showToast({
        message: `sendRequest msg:${msg}`
      });
    }).catch((error: BusinessError) => {
      hilog.info(DOMAIN_NUMBER, TAG, `sendRequest failed, ${JSON.stringify(error)}`);
    });
  },
  onDisconnect(elementName): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onDisconnect callback');
  },
  onFailed(code): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onFailed callback');
  }
};

function initDmClass(): void {
  // 其中createDeviceManager接口为系统API
  try {
    dmClass = deviceManager.createDeviceManager('com.samples.stagemodelabilitydevelop');
    hilog.info(DOMAIN_NUMBER, TAG, JSON.stringify(dmClass) ?? '');
    promptAction.showToast({
      message: $r('app.string.InitializedSuccessfully')
    });
  } catch (err) {
    hilog.error(DOMAIN_NUMBER, TAG, 'createDeviceManager err: ' + JSON.stringify(err));
  };
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
};

@Entry
@Component
struct Page_CollaborateAbility {
  private context = getContext(this) as common.UIAbilityContext;

  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.MultiDeviceCollaboration'))
            .fontSize(24)
            .fontWeight(700)
            .textAlign(TextAlign.Start)
            .margin({ top: 12 , bottom: 11 , right: 24 , left: 24})
        }
      }
      .width('100%')
      .height(56)
      .justifyContent(FlexAlign.Start)
      .backgroundColor($r('app.color.backGrounding'))

      List({ initialIndex: 0 }) {
        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.CollaborativeInitialization'))
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
            initDmClass()
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 8, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.MultiDeviceCollaborationWithoutReturningData'))
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
            let want: Want = {
              deviceId: getRemoteDeviceId(),
              bundleName: 'com.samples.stagemodelabilityinteraction',
              abilityName: 'CollaborateAbility'
            };
            this.context.startAbility(want).then(() => {
              promptAction.showToast({
                message: $r('app.string.SuccessfulCollaboration')
              });
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `startAbility err: ` + JSON.stringify(err));
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.MultiDeviceCollaborationWithReturningData'))
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
            let want: Want = {
              deviceId: getRemoteDeviceId(),
              bundleName: 'com.samples.stagemodelabilityinteraction',
              abilityName: 'CollaborateAbility',
              moduleName: 'entry' // moduleName非必选
            };
            const RESULT_CODE: number = 1001;
            // context为调用方UIAbility的UIAbilityContext
            this.context.startAbilityForResult(want).then((data) => {
              if (data?.resultCode === RESULT_CODE) {
                // 解析目标端UIAbility返回的信息
                let info = data.want?.parameters?.info;
                hilog.info(DOMAIN_NUMBER, TAG, JSON.stringify(info) ?? '');
                if (info !== null) {
                  promptAction.showToast({
                    message : JSON.stringify(info)
                    });
                  }
                }
              }).catch((error: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `startAbilityForResult err: ` + JSON.stringify(error));
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.StartServiceExtensionAbility'))
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
            let want: Want = {
              deviceId: getRemoteDeviceId(),
              bundleName: 'com.samples.stagemodelabilityinteraction',
              abilityName: 'ServiceExtAbility',
              moduleName: 'entry' // moduleName非必选
            };
            // context为发起端UIAbility的AbilityContext
            this.context.startAbility(want).then(() => {
              // ...
              promptAction.showToast({
                message: $r('app.string.SuccessfullyStart')
              });
            }).catch((err: BusinessError) => {
              // ...
              hilog.error(DOMAIN_NUMBER, TAG, `startAbility err: ` + JSON.stringify(err));
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.StopServiceExtensionAbility'))
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
            let want: Want = {
              deviceId: getRemoteDeviceId(),
              bundleName: 'com.samples.stagemodelabilityinteraction',
              abilityName: 'ServiceExtAbility',
              moduleName: 'entry' // moduleName非必选
            };
            // 退出由startAbility接口启动的ServiceExtensionAbility
            this.context.stopServiceExtensionAbility(want).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, "stop service extension ability success")
              promptAction.showToast({
                message: $r('app.string.SuccessfullyStop')
              });
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `stop service extension ability err is ` + JSON.stringify(err));
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.Caller'))
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
            let caller: Caller | undefined;
            let context = this.context;

            context.startAbilityByCall({
              deviceId: getRemoteDeviceId(),
              bundleName: 'com.samples.stagemodelabilitydevelop',
              abilityName: 'CollaborateAbility',
            }).then((data) => {
              if (data !== null) {
                caller = data;
                hilog.info(DOMAIN_NUMBER, TAG, 'get remote caller success');
                // 注册caller的release监听
                caller.onRelease((msg) => {
                  hilog.info(DOMAIN_NUMBER, TAG, `remote caller onRelease is called ${msg}`);
                });
                hilog.info(DOMAIN_NUMBER, TAG, 'remote caller register OnRelease succeed');
                promptAction.showToast({
                  message: $r('app.string.CallerSuccess')
                });
                // 注册caller的协同场景下跨设备组件状态变化监听通知
                try {
                  caller.onRemoteStateChange((str) => {
                    hilog.info(DOMAIN_NUMBER, TAG, 'Remote state changed ' + str);
                  });
                } catch (error) {
                  hilog.info(DOMAIN_NUMBER, TAG, `Caller.onRemoteStateChange catch error, error.code: ${JSON.stringify(error.code)}, error.message: ${JSON.stringify(error.message)}`);
                };
              }
            }).catch((error: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `get remote caller failed with ${error}`);
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
            let want: Want = {
              'deviceId': getRemoteDeviceId(),
              'bundleName': 'com.samples.stagemodelabilityinteraction',
              'abilityName': 'ServiceExtAbility'
            };
            // 建立连接后返回的Id需要保存下来，在解绑服务时需要作为参数传入
            connectionId = this.context.connectServiceExtensionAbility(want, options);
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
            this.context.disconnectServiceExtensionAbility(connectionId).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'disconnectServiceExtensionAbility success');
              // 成功断连后台服务
              promptAction.showToast({
                message: $r('app.string.SuccessfullyDisconnectBackendService')
              })
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