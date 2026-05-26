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
import {
  InfControl,
  InfDeviceInfo,
  InfDevicesBusiness,
  InfDeviceState,
  ServerType,
  InfIpInfo
} from '@ohos/common/index';
import BleDevicesConnector from './BleDevicesConnector';
import BleDevicesController from './BleDevicesController';
import BlePackage from './protocol/BlePackage';
import BlePackageManager from './protocol/BlePackageManager';

/**
 * 蓝牙业务模块
 */
export default class BleDeviceBusiness implements InfDevicesBusiness {
  public controller: BleDevicesController;
  public connector: BleDevicesConnector | undefined;
  public packageManager: BlePackageManager = new BlePackageManager();

  constructor(controller: BleDevicesController) {
    this.controller = controller;
  }

  onDataCallback(ab: ArrayBuffer) {
    //数据交给Package处理，进行分包和合包
    this.packageManager.addData(ab);
  }

  onPackageCallback(blePackage: BlePackage) {
    switch (blePackage.serverType) {
      case ServerType.speke:
        this.handleSpekeData(blePackage);
        break;
    }
    //判断响应类型，
    //speke三次握手


    //其它业务
  }

  handleSpekeData(blePackage: BlePackage) {

  }


  queryDeviceState(sids: string[]): Promise<InfDeviceState[]> {
    throw new Error('Method not implemented.');
  }

  queryDeviceAllServices(): Promise<InfDeviceState[]> {
    throw new Error('Method not implemented.');
  }

  queryDeviceInfo(): Promise<InfDeviceInfo> {
    throw new Error('Method not implemented.');
  }

  queryIpInfo(): Promise<InfIpInfo> {
    throw new Error('Method not implemented.');
  }

  controlDevice(control: InfControl): Promise<boolean> {
    throw new Error('Method not implemented.');
  }
};
