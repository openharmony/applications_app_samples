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
import ScanModel, { ScanState } from './ScanModel';
import DragSceneConstants from '../constants/DragSceneConstants';
import DevicesManager from './DevicesManager';
import { InfDevice, Logger, ScanOptions, SubProtocolType, } from '@ohos/common';
import { DeviceManagerFactory } from '@ohos/device_manager';
import CoapDevicesManager from './CoapDevicesManager';


export default class CoapDeviceDiscoverManager {
  private static instance: CoapDeviceDiscoverManager = new CoapDeviceDiscoverManager();

  static getInstance(): CoapDeviceDiscoverManager {
    return CoapDeviceDiscoverManager.instance;
  }

  public scanModel: ScanModel = new ScanModel();

  getScanModel(): ScanModel {
    return this.scanModel;
  }

  startScan(options: ScanOptions = { filterOption: [SubProtocolType.iot_connect] },
    callback: Callback<InfDevice> | null = null) {
    //重置数据
    CoapDevicesManager.getInstance().reset(true);
    this.stopScan();
    this.scanModel.currentScanState = ScanState.SCANNING;
    this.scanModel.startScan(DragSceneConstants.SCAN_TIME_OUT);

    DeviceManagerFactory.getDeviceManager().startDeviceDiscover(options, (_error, device: InfDevice) => {
      Logger.debug('coap===>添加一个设备CoapDeviceDiscoverManager:' + device.getUnionCode());
      CoapDevicesManager.getInstance().addDevice(device);
      if (callback != null) {
        callback(device);
      }
    });
    setTimeout(() => {
      this.stopScan();
    }, DragSceneConstants.SCAN_TIME_OUT);
  }

  stopScan() {
    this.scanModel.currentScanState = ScanState.SCANNING_FINISH;
    DeviceManagerFactory.getDeviceManager().stopDeviceDiscovery();
  }
};