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
import Logger from '../../utils/Logger';
import promptAction from '@ohos.promptAction'
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@ohos.base';
import { Caller } from '@ohos.app.ability.UIAbility';

const TAG: string = '[Page_CollaborateAbility]';
const DOMAIN_NUMBER: number = 0xFF00;

let dmClass: deviceManager.DeviceManager;

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
}

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
              bundleName: 'com.samples.stagemodelabilityinteraction',
              abilityName: 'CalleeAbility'
            }).then((data) => {
              if (data !== null) {
                caller = data;
                Logger.info('get remote caller success');
                // 注册caller的release监听
                caller.onRelease((msg) => {
                  Logger.info(`remote caller onRelease is called ${msg}`);
                })
                Logger.info('remote caller register OnRelease succeed');
                promptAction.showToast({
                  message: $r('app.string.CallerSuccess')
                });
                // 注册caller的协同场景下跨设备组件状态变化监听通知
                try {
                  caller.onRemoteStateChange((str) => {
                    Logger.info('Remote state changed ' + str);
                  });
                } catch (error) {
                  Logger.info(`Caller.onRemoteStateChange catch error, error.code: ${JSON.stringify(error.code)}, error.message: ${JSON.stringify(error.message)}`);
                };
              }
            }).catch((error: BusinessError) => {
              Logger.error(`get remote caller failed with ${error}`);
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