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

import { EnvManager, InfDevice, InfDevicesDiscover, Logger, ProtocolType, ScanOptions } from '@ohos/common';
import { Callback } from '@ohos.base';
import IotConstants from './IotConstants';
import IotHelper from './IotHelper';

export default class IotDevicesDiscover implements InfDevicesDiscover {
  startScan(options: ScanOptions | null, callback: Callback<InfDevice>): void {
    Logger.info(IotConstants.IOT_TAG, '===>iot startScan');
    IotHelper.getInstance().deviceDiscovery(options, (error, infDevice) => {
      if (error) {
        Logger.error(IotConstants.IOT_TAG, `startScan error ${error.message}`);
        return;
      }
      callback(infDevice);
    });
  }

  stopScan(): void {
    Logger.info(IotConstants.IOT_TAG, 'iot stopScan');
  }

  isScanEnable(): boolean {
    return EnvManager.getInstance().isProtocolEnable(ProtocolType.BLE) ||
    EnvManager.getInstance().isProtocolEnable(ProtocolType.WIFI);
  }
};
