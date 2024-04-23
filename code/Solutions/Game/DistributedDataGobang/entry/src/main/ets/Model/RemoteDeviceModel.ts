/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import deviceManager from '@ohos.distributedDeviceManager';
import Logger from '../util/Logger';

const TAG: string = 'RemoteDeviceModel';
let subscribeId: number = 100;

export class RemoteDeviceModel {
  public deviceList: Array<deviceManager.DeviceBasicInfo> = [];
  public discoverList: Array<deviceManager.DeviceBasicInfo> = [];
  public callback: () => void;
  public authCallback: () => void;
  public deviceManager: deviceManager.DeviceManager;

  constructor() {
  };

  registerDeviceListCallback(callback) {
    if (typeof (this.deviceManager) !== 'undefined') {
      this.registerDeviceListCallbackImplement(callback);
      return;
    }
    Logger.info(TAG, `deviceManager.createDeviceManager begin`);
    try {
      this.deviceManager = deviceManager.createDeviceManager("ohos.samples.distributeddatagobang");
      this.registerDeviceListCallbackImplement(callback);
      Logger.info(TAG, `createDeviceManager callback returned, value= ${JSON.stringify(this.deviceManager)}`);
    } catch (err) {
      Logger.error(TAG, `createDeviceManager failed, code is ${err.code}, message is ${err.message}`);
    };

    Logger.info(TAG, `deviceManager.createDeviceManager end`);
  }

  deviceStateChangeActionOffline(device) {
    if (this.deviceList.length <= 0) {
      this.callback();
      return;
    };
    for (let j = 0; j < this.deviceList.length; j++) {
      if (this.deviceList[j ].deviceId === device.deviceId) {
        this.deviceList[j] = device;
        break;
      };
    };
    Logger.info(TAG, `offline, device list= ${JSON.stringify(this.deviceList)}`);
    this.callback();
  }

  registerDeviceListCallbackImplement(callback) {
    Logger.info(TAG, `registerDeviceListCallback`);
    this.callback = callback;
    if (this.deviceManager === undefined) {
      Logger.info(TAG, `deviceManager has not initialized`);
      this.callback();
      return;
    };
    Logger.info(TAG, `getTrustedDeviceListSync begin`);
    try {
      let list = this.deviceManager.getAvailableDeviceListSync();
      Logger.info(TAG, `getTrustedDeviceListSync end, deviceList= ${JSON.stringify(list)}`);
      if (typeof (list) !== 'undefined' && typeof (list.length) !== 'undefined') {
        this.deviceList = list;
      };
    } catch (err) {
      Logger.error(`getTrustedDeviceListSync failed, code is ${err.code}, message is ${err.message}`);
    }
    this.callback();
    Logger.info(TAG, `callback finished`);
    this.deviceManager.on('deviceStateChange', (data) => {
      if (data === null) {
        return;
      };
      Logger.info(TAG, `deviceStateChange data= ${JSON.stringify(data)}`);
      switch (data.action) {
        case deviceManager.DeviceStateChange.AVAILABLE:
          this.discoverList = [];
          this.deviceList.push(data.device);
          try {
            let list = this.deviceManager.getAvailableDeviceListSync();
            if (typeof (list) !== 'undefined' && typeof (list.length) !== 'undefined') {
              this.deviceList = list;
            };
            this.callback();
          } catch (err) {
            Logger.error(TAG, `getTrustedDeviceListSync failed, code is ${err.code}, message is ${err.message}`);
          }
          break;
        case deviceManager.DeviceStateChange.UNAVAILABLE:
        default:
          break;
      };
    })
    this.deviceManager.on('discoverSuccess', (data) => {
      if (data === null) {
        return;
      };
      Logger.info(TAG, `deviceFound data= ${JSON.stringify(data)}`);
      this.deviceFound(data);
    })
    this.deviceManager.on('discoverFailure', (data) => {
      Logger.info(TAG, `discoverFail data= ${JSON.stringify(data)}`);
    });
    this.deviceManager.on('serviceDie', () => {
      Logger.info(TAG, `serviceDie`);
    });
    this.startDeviceDiscovery();
  }

  deviceFound(data) {
    for (var i = 0;i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId === data.device.deviceId) {
        Logger.info(TAG, `device founded ignored`);
        return;
      };
    };
    this.discoverList[this.discoverList.length] = data.device;
    Logger.info(TAG, `deviceFound self.discoverList= ${this.discoverList}`);
    this.callback();
  }

  startDeviceDiscovery() {
    let discoverParam = {
      'discoverTargetType': 1
    };
    let filterOptions = {
      'availableStatus': 0
    };
    Logger.info(TAG, `startDeviceDiscovery ${subscribeId}`);
    try {
      this.deviceManager.startDiscovering(discoverParam, filterOptions);
    } catch (err) {
      Logger.error(TAG, `startDeviceDiscovery failed, code is ${err.code}, message is ${err.message}`);
    };
  }

  unregisterDeviceListCallback() {
    Logger.info(TAG, `stopDeviceDiscovery $subscribeId}`);
    try {
      this.deviceManager.stopDiscovering();
    } catch (err) {
      Logger.error(TAG, `stopDeviceDiscovery failed, code is ${err.code}, message is ${err.message}`);
    };
    this.deviceManager.off('deviceStateChange');
    this.deviceManager.off('discoverSuccess');
    this.deviceManager.off('discoverFailure');
    this.deviceManager.off('serviceDie');
    this.deviceList = [];
    this.discoverList = [];
  }

  authenticateDevice(device, callBack) {
    Logger.info(TAG, `authenticateDevice ${JSON.stringify(device)}`);
    for (let i = 0; i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId !== device.deviceId) {
        continue;
      };
      let bindParam = {
        bindLevel: 3,
        bindType: 1,
        targetPkgName: 'ohos.samples.distributeddatagobang',
        appName: 'distributeddatagobang',
      };
      try {
        this.deviceManager.bindTarget(device.deviceId, bindParam, (err, data) => {
          if (err) {
            Logger.error(TAG, `authenticateDevice error: ${JSON.stringify(err)}`);
            this.authCallback = null;
            return;
          }
          Logger.info(TAG, `authenticateDevice succeed: ${JSON.stringify(data)}`);
          this.authCallback = callBack;
        });
      } catch (err) {
        Logger.error(TAG, `authenticateDevice failed, code is ${err.code}, message is ${err.message}`);
      }
    }
  }
}