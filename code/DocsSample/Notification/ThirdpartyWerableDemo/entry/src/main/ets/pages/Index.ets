/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { abilityAccessCtrl, common } from '@kit.AbilityKit';
import { notificationExtensionSubscription } from '@kit.NotificationKit';
import { HashSet } from '@kit.ArkTS';
import { connection } from '@kit.ConnectivityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@ohos.base';

const DOMAIN = 0x0000;

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State selectedAddr: HashSet<string> = new HashSet();
  @State devices: string[] = [];

  aboutToAppear(): void {
    //开启授权
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    try {
      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      atManager.requestPermissionsFromUser(context, ['ohos.permission.ACCESS_BLUETOOTH'],
        (err, _) => {
          hilog.error(DOMAIN, 'testTag', `failed to requestPermissionsFromUser ${err}`)
        });
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', `failed to requestPermissionsFromUser ${err}`)
    }
  }

  build() {
    RelativeContainer() {
      Column({ space: 10 }) {
        Button("openSubscriberSettings").backgroundColor('#FFFF00FF')
          .onClick(async () => {
            try {
              let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
              await notificationExtensionSubscription.openSubscriptionSettings(context);
            } catch (error) {
              hilog.error(DOMAIN, 'testTag', `failed to call openSubscriptionSettings ${error}`)
            }
            hilog.info(DOMAIN, 'testTag', `openSubscriberSettings success`);
          })
        Button("queryBluetooth").backgroundColor('#FFFF00FF')
          .onClick(async () => {
            try {
              // 获取已配对设备信息
              this.devices = connection.getPairedDevices();
            } catch (err) {
              hilog.error(DOMAIN, 'testTag', `errCode: ${err.code}, errMessage: ${err.message}`);
            }
          })

        ForEach(this.devices, (item: string) => {
          Row({ space: 5 }) {
            Checkbox({ name: `${item} ${connection.getRemoteDeviceName(item)}`, group: 'checkboxGroup' })
              .select(false)
              .selectedColor(0xed6f21)
              .shape(CheckBoxShape.CIRCLE)
              .onChange((value: boolean) => {
                if (value) {
                  this.selectedAddr.add(item)
                } else {
                  this.selectedAddr.remove(item)
                }
              })
            Text(`${item} ${connection.getRemoteDeviceName(item)}`).fontSize(20)
              .backgroundColor(`${connection.getPairState(item) == 1 ? '#ff0d9d31'
                : connection.getPairState(item) == 2 ? '#ffdee578'
                  : '#8b838285'}`)
          }
        })

        Button("subscribe").backgroundColor('#FFFF00FF')
          .onClick(async (e: ClickEvent) => {
            let subscribeInfo: notificationExtensionSubscription.NotificationExtensionSubscriptionInfo[] = new Array()
            this.selectedAddr.forEach((value, _) => {
              subscribeInfo.push({
                addr: value!,
                type: notificationExtensionSubscription.SubscribeType.BLUETOOTH
              })
            })
            notificationExtensionSubscription.subscribe(subscribeInfo).then(() => {
              hilog.info(DOMAIN, 'testTag', "subscribe success");
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN, 'testTag', `subscribe fail: ${JSON.stringify(err)}`);
            });
          })
        Button("unsubscribe").backgroundColor('#FFFF00FF')
          .onClick(async (e: ClickEvent) => {
            try {
              let result = await notificationExtensionSubscription.unsubscribe();
              hilog.info(DOMAIN, 'testTag', `unsubscribe result ${result}`);
            } catch (error) {
              hilog.error(DOMAIN, 'testTag', `failed to call unsubscribe`)
            }
          })
      }
    }
    .height('100%')
    .width('100%')
  }
}