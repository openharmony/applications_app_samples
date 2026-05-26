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

import { Callback } from '@ohos.base';
import OpenValleyDevicesController from './OpenValleyDevicesController';
import { ble } from '@kit.ConnectivityKit';
import OpenValleyDevice from './OpenValleyDevice';
import { EnvManager, InfDevice, InfDevicesDiscover, Logger, ProtocolType, ScanOptions } from '@ohos/common';
import { VirtualDeviceTypes } from './VirtualDevceType';
import { BleScanner } from '@ohos/connect_ble/Index';

export default class OpenValleyDevicesDiscover implements InfDevicesDiscover {
  constructor(controller: OpenValleyDevicesController) {
  }

  isScanEnable(): boolean {
    return EnvManager.getInstance().isProtocolEnable(ProtocolType.BLE);
  }

  public callback: Callback<InfDevice> | null = null;

  startScan(options: ScanOptions, callback: Callback<InfDevice>): void {
    this.callback = callback;
    BleScanner.getInstance()
      .registerScanCallback('OpenValleyDevicesDiscover', (result: ble.ScanResult) => this.onScan(result));
    BleScanner.getInstance().startScan();
  }

  stopScan(): void {
    BleScanner.getInstance().stopScan();
  }

  async onScan(result: ble.ScanResult): Promise<boolean> {
    Logger.debug('触发OpenValleyDevicesDiscover.onScan()');
    //只判断蓝牙名
    if (result.deviceName.startsWith('ccBle-')) {
      if (this.callback) {
        const device: OpenValleyDevice =
          new OpenValleyDevice(result.deviceId, result.rssi, result.deviceName, VirtualDeviceTypes.GATE);
        this.callback(device);
        return true;
      }
    }
    return false;
  }
};