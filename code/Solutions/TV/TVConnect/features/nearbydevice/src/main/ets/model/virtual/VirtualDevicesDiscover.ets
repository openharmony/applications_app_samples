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
import VirtualDevice from './VirtualDevice';
import VirtualConfig from './VirtualConfig';
import { Device, DeviceLibraryAccess, InfDevice, InfDevicesDiscover, ScanOptions } from '@ohos/common';

let virtualCfg = VirtualConfig.getInstance().simulateDev;

export default class VirtualDevicesDiscover implements InfDevicesDiscover {
  async startScan(options: ScanOptions, callback: Callback<InfDevice>): Promise<void> {
    for (let i = 0; i < 9; i++) {
      const device: Device | null = await DeviceLibraryAccess.queryDevice(virtualCfg.devices[i].productID);
      if (device) {
        let virtualDevice: VirtualDevice = VirtualDevice.generateVirtualDevice(device);
        await delay(getRandomInt(1000));
        callback(virtualDevice);
      }
    }
  }

  stopScan(): void {

  }

  isScanEnable(): boolean {
    return true;
  }
};

// 返回整型，[0,max-1]
function getRandomInt(max: number) {
  return Math.floor(Math.random() * max);
}

function delay(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}