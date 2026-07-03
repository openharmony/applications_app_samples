/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import access from '@ohos.bluetooth.access';
import window from '@ohos.window';
import { Permissions } from '@ohos.abilityAccessCtrl';
import { InfAccessManager } from './InfAccessManager';
import {
  checkPermission,
  getPermissions,
  isAllGrant,
  PermissionsClass,
  requestPermission
} from '../utils/PermissionUtil';
import { Logger } from '../utils/Logger';
import { getProtocolCode, ProtocolType } from './TypeEnum';
import { common, Want } from '@kit.AbilityKit';
import { Callback } from '@kit.BasicServicesKit';

const STATE_ENABLE_SET: access.BluetoothState[] = [
  access.BluetoothState.STATE_ON,
  access.BluetoothState.STATE_TURNING_ON,
  access.BluetoothState.STATE_BLE_TURNING_ON,
  access.BluetoothState.STATE_BLE_ON,
];

const BLE_TAG = 'IotAccessManagerBle';

export class InfAccessManagerBluetooth implements InfAccessManager {
  async isEnable(): Promise<boolean> {
    // 先检查权限，如果未获取蓝牙权限，返回false
    const result: boolean[] = await checkPermission(getPermissions(this.getUserAuthPermission()));
    if (!isAllGrant(result)) {
      Logger.warn(BLE_TAG, 'no bluetooth Permissions');
      return false;
    } else {
      //检查蓝牙状态
      return this.getBleAccessState();
    }
  }

  getAccessCode(): string {
    return getProtocolCode(ProtocolType.BLE);
  }

  getAccessName(): Resource {
    return $r('app.string.access_name_bluetooth');
  }

  getUserAuthPermission(): PermissionsClass[] {
    return [new PermissionsClass($r('app.string.access_name_bluetooth'),
      'ohos.permission.ACCESS_BLUETOOTH')];
  }

  async applyAccess(context: Context): Promise<boolean> {
    Logger.debug(BLE_TAG, `applyAccess start`);
    const permissions: Permissions[] = getPermissions(this.getUserAuthPermission());
    const hasBluetoothPermission = async () => {
      const result: boolean[] = await checkPermission(permissions);
      return isAllGrant(result);
    };
    const requestBluetoothPermission = async () => {
      const requestResult: boolean[] = await requestPermission(context, permissions);
      return isAllGrant(requestResult);
    };
    let hasPermission = await hasBluetoothPermission();
    if (!hasPermission) {
      hasPermission = await requestBluetoothPermission();
      if (!hasPermission) {
        // 用户拒绝，申请权限弹框不会再次弹出，引导用户跳转权限设置页面
        let abilityContext = context as common.UIAbilityContext;
        let want: Want = {
          bundleName: 'com.huawei.hmos.settings',
          abilityName: 'com.huawei.hmos.settings.MainAbility',
          uri: 'application_info_entry',
          parameters: {
            'pushParams': abilityContext.abilityInfo.bundleName
          }
        };
        await abilityContext.startAbilityForResult(want);
        hasPermission = await hasBluetoothPermission();
        if (!hasPermission) {
          return false;
        }
      }
    }
    const accessResult = this.getBleAccessState();
    if (!accessResult) {
      const openBluetooth = (resolve: Callback<boolean>) => {
        Logger.debug(BLE_TAG, `enableBluetooth start`);
        // enableBluetooth 会拉起一个弹框，根据主Window的生命周期判断Bluetooth弹框是否消失
        window.getLastWindow(context, (e, win) => {
          if (win == undefined) {
            resolve(this.getBleAccessState());
            return;
          }
          win.on('windowEvent', (event) => {
            Logger.debug(BLE_TAG, `windiw event ${event}`);
            if (event == window.WindowEventType.WINDOW_ACTIVE) {
              win.off('windowEvent');
              resolve(this.getBleAccessState());
            }
          });
        });
        access.enableBluetooth();
      };
      return new Promise((resolve, reject) => {
        openBluetooth(resolve);
      });
    }
    return true;
  }

  private getBleAccessState(): boolean {
    try {
      let state = access.getState();
      Logger.debug(BLE_TAG, `ble state ${state}`);
      return STATE_ENABLE_SET.indexOf(state) != -1;
    } catch (err) {
      Logger.error(BLE_TAG, `getBleAccessState error ${err?.message}`);
      return false;
    }
  }
}