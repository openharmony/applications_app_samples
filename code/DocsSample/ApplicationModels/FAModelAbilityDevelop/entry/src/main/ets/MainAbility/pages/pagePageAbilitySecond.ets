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

import featureAbility from '@ohos.ability.featureAbility'
import Want from '@ohos.app.ability.Want';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import bundle from '@ohos.bundle.bundleManager';
import deviceManager from '@ohos.distributedDeviceManager';
import promptAction from '@ohos.promptAction';
import { BusinessError } from '@ohos.base';
import hilog from '@ohos.hilog';

const TAG: string = 'PagePageAbilitySecond'
const domain: number = 0xFF00;

@Entry
@Component
struct PagePageAbilitySecond {
  @State deviceID: string = '';

  async requestPermission(): Promise<void> {
    hilog.info(domain, TAG, 'RequestPermission begin');
    let array: Array<string> = ['ohos.permission.DISTRIBUTED_DATASYNC'];
    let bundleFlag = 0;
    let tokenID: number | undefined = undefined;
    let userID = 100;
    let appInfo: bundle.ApplicationInfo = await bundle.getApplicationInfo('com.samples.famodelabilitydevelop', bundleFlag, userID);
    tokenID = appInfo.accessTokenId;
    let atManager = abilityAccessCtrl.createAtManager();
    let requestPermissions: Array<string> = [];
    for (let i = 0;i < array.length; i++) {
      let result = await atManager.verifyAccessToken(tokenID, array[i]);
      hilog.info(domain, TAG, 'checkAccessToken result:' + JSON.stringify(result));
      if (result != abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        requestPermissions.push(array[i]);
      }
    }
    hilog.info(domain, TAG, 'requestPermissions:' + JSON.stringify(requestPermissions));
    if (requestPermissions.length == 0) {
      return;
    }
    let context = featureAbility.getContext();
    context.requestPermissionsFromUser(requestPermissions, 1, (error, data) => {
      hilog.info(domain, TAG, 'error:' + error.message + ',data:' + JSON.stringify(data));
      hilog.info(domain, TAG, 'data requestCode:' + data.requestCode);
      hilog.info(domain, TAG, 'data permissions:' + data.permissions);
      hilog.info(domain, TAG, 'data authResults:' + data.authResults);
    });
    hilog.info(domain, TAG, 'RequestPermission end');
  }

  getRemoteDeviceId(): void {
    let dmClass: deviceManager.DeviceManager;
    dmClass = deviceManager.createDeviceManager('com.samples.famodelabilitydevelop');
    try {
      if (typeof dmClass === 'object' && dmClass !== null) {
        let list = dmClass.getAvailableDeviceListSync();
        if (typeof (list) == undefined || list.length == 0) {
          hilog.info(domain, TAG, 'EntryAbility onButtonClick getRemoteDeviceId err: list is null');
          return;
        }
        hilog.info(domain, TAG, `EntryAbility onButtonClick getRemoteDeviceId success[${list.length}]:` + JSON.stringify(list[0]));
        if (list[0].networkId != undefined) {
          this.deviceID = list[0].networkId;
        }
        promptAction.showToast({
          message: this.deviceID
        });
      } else {
        hilog.info(domain, TAG, 'EntryAbility onButtonClick getRemoteDeviceId err: dmClass is null');
      }
    } catch (error) {
      hilog.info(domain, TAG, `getRemoteDeviceId error, error=${error}, message=${error.message}`);
    }
  }

  onStartRemoteAbility(): void {
    hilog.info(domain, TAG, 'onStartRemoteAbility begin');
    let wantValue: Want = {
      bundleName: 'ohos.samples.distributedmusicplayer',
      abilityName: 'ohos.samples.distributedmusicplayer.MainAbility',
      deviceId: this.deviceID, // this.deviceID的获取方式在前面的示例代码中
    };
    hilog.info(domain, TAG, 'onStartRemoteAbility want=' + JSON.stringify(wantValue));
    featureAbility.startAbility({
      want: wantValue
    }).then((data) => {
      promptAction.showToast({
        message: $r('app.string.start_remote_success_toast')
      });
      hilog.info(domain, TAG, 'onStartRemoteAbility finished, ' + JSON.stringify(data));
    }).catch((error: BusinessError) => {
      promptAction.showToast({
        message: JSON.stringify(error)
      });
      hilog.error(domain, TAG, 'onStartRemoteAbility failed: ' + JSON.stringify(error));
    });
    hilog.info(domain, TAG, 'onStartRemoteAbility end');
  }

  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.pageAbility_second_button'))
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
              Text($r('app.string.obtain_permissions_button'))
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
            this.requestPermission();
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 8, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row() {
              Text($r('app.string.obtain_device_id_button'))
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
            this.getRemoteDeviceId();
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row() {
              Text($r('app.string.start_remote_ability_button'))
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
            this.onStartRemoteAbility();
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