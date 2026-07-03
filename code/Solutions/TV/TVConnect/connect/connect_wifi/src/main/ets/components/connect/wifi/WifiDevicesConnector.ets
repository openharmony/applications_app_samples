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

import wifiManager from '@ohos.wifiManager';
import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';

import WifiDevicesController from './WifiDevicesController';
import WifiDevice from './WifiDevice';
import { InfDevice, InfDevicesConnector } from '@ohos/common/Index';
import { Logger } from '@ohos/common';

export default class WifiDevicesConnector implements InfDevicesConnector {
  public controller: WifiDevicesController;

  constructor(controller: WifiDevicesController) {
    this.controller = controller;
  }

  private connectedDevice: InfDevice | undefined;

  getCurrentConnectedDevice(): InfDevice | undefined {
    return this.connectedDevice;
  }

  async stopConnect(device: InfDevice): Promise<boolean> {
    return true;
  }

  async connect(device: InfDevice): Promise<boolean> {
    if (wifiManager.isWifiActive() == false) {
      throw Error('wifi is not open');
    }

    let wifiDevice = device as WifiDevice;
    await this.connectWifi();

    let targetIp: string = '0.0.0.0';
    while (1) {
      if ((targetIp = this.getWifiDeviceIp()) != '0.0.0.0') {
        break;
      }
    }
    this.connectedDevice = wifiDevice;
    return true;
  }

  private async connectWifi() {
    let want: Want = {
      deviceId: '',
      bundleName: 'com.huawei.hmos.settings',
      abilityName: 'com.huawei.hmos.settings.ExternalWifiSettingsAbility'
    };
    let context = getContext() as common.UIAbilityContext;
    context.startAbility(want, (error) => {
      if (error.code) {
        // 处理错误逻辑
        Logger.info('startAbility failed, error.code: ' + JSON.stringify(error.code) +
          ' error.message: ' + JSON.stringify(error.message));
        return;
      }
      Logger.info('startAbility succeed');
    });
  }

  private getWifiDeviceIp(): string {
    let ipInfo = wifiManager.getIpInfo();
    let wifiDeviceIp = ipInfo.gateway;
    return (wifiDeviceIp >>> 24) + '.' + (wifiDeviceIp >> 16 & 0xFF) + '.' + (wifiDeviceIp >> 8 & 0xFF) + '.' +
      (wifiDeviceIp & 0xFF);
  }
};