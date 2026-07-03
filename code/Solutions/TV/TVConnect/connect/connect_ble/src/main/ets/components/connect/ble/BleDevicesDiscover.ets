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
import { BusinessError, Callback } from '@ohos.base';
import ble from '@ohos.bluetooth.ble';
import { DeviceLibraryAccess, EnvManager, Logger } from '@ohos/common/index';
import BleDevicesController from './BleDevicesController';
import BleDevice from './BleDevice';
import BleScanner from './BleScanner';
import { Device } from '@ohos/common/index';
import BleConstants from './constants/BleConstants';
import { InfDevice, InfDevicesDiscover, ProtocolType, ScanOptions } from '@ohos/common/index';

const listenerKey = 'BleDevicesDiscover';

export default class BleDevicesDiscover implements InfDevicesDiscover {
  public controller: BleDevicesController;

  constructor(controller: BleDevicesController) {
    this.controller = controller;
    BleScanner.getInstance().registerScanCallback(listenerKey, (result: ble.ScanResult) => this.onReceiveEvent(result));
  }

  isScanEnable(): boolean {
    return EnvManager.getInstance().isProtocolEnable(ProtocolType.BLE);
  }

  public scanCallback: Callback<InfDevice> | undefined;

  stopScan() {
    try {
      BleScanner.getInstance().stopScan();
    } catch (err) {
      Logger.error('stop ble scan,errCode: ' + (err as BusinessError).code + ', errMessage: ' +
      (err as BusinessError).message);
    }
  }

  async startScan(options: ScanOptions, callback: Callback<InfDevice>) {
    this.scanCallback = callback;
    BleScanner.getInstance()
      .registerScanCallback('BleDeviceDiscover', (result: ble.ScanResult) => this.onReceiveEvent(result));
    BleScanner.getInstance().startScan();
  }

  async onReceiveEvent(scanResult: ble.ScanResult): Promise<boolean> {
    if (!scanResult) {
      return false;
    }
    let exp: RegExp = new RegExp(BleConstants.bleScanRegStr);
    if (exp.test(scanResult.deviceName)) {
      let deviceInfo: Device | null = null;
      deviceInfo = await DeviceLibraryAccess.queryDevice(getDeviceIdFromDeviceName(scanResult.deviceName));
      if (deviceInfo != undefined) {
        const bleDevice: BleDevice = new BleDevice(scanResult.data[0].rssi, '00:00:00:00', 'randomFlag', deviceInfo);
        if (this.scanCallback != null) {
          this.scanCallback(bleDevice);
          return true;
        }
      }
    }
    return false;
  }
};

function getDeviceIdFromDeviceName(ssid: string) {
  let part: string[] = ssid.split('-');
  let str = part[2];
  return str.substring(1, 6);
}
