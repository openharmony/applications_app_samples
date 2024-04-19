/*
 * Copyright (c) 2020-2023 Huawei Device Co., Ltd.
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
import Logger from '../util/Logger'
import { BusinessError } from '@ohos.base';
import { Callback } from '@ohos.base';

let SUBSCRIBE_ID = 100
const TAG: string = '[RemoteDeviceModel]'

export class RemoteDeviceModel {
  public deviceList: Array<deviceManager.DeviceBasicInfo> = [];
  public discoverList: Array<deviceManager.DeviceBasicInfo> = [];
  private callback: () => void = () => {};
  private authCallback: () => void = () => {};
  private deviceManager?: deviceManager.DeviceManager = undefined;

  constructor() {
  }

  registerDeviceListCallback(callback: Callback<void>) {
    if (typeof (this.deviceManager) !== 'undefined') {
      this.registerDeviceListCallbackImplement(callback)
      return
    }
    Logger.info(TAG, `deviceManager.createDeviceManager begin`)
    let self = this
    try {
      let dmInstance = deviceManager.createDeviceManager('ohos.samples.kvstore');
      Logger.info(TAG, `dmInstance= ${JSON.stringify (dmInstance)}`);
      self.deviceManager = dmInstance;
      self.registerDeviceListCallbackImplement(callback);
      Logger.info(TAG, `createDeviceManager callback returned, value= ${JSON.stringify(this.deviceManager)}`);
    } catch (error) {
      Logger.error(TAG, `createDeviceManager throw error, code: ${(error as BusinessError).code} message: ${(error as BusinessError).message}`);
    }
    Logger.info(TAG, `deviceManager.createDeviceManager end`)
  }

  deviceStateChangeActionOnline(device: deviceManager.DeviceBasicInfo) {
    this.deviceList[this.deviceList.length] = device
    Logger.info(TAG, `online, device list=${JSON.stringify(this.deviceList)}`)
    this.callback()
    if (this.authCallback !== null) {
      this.authCallback()
      this.authCallback = () => {};
    }
  }

  deviceStateChangeActionReady(device: deviceManager.DeviceBasicInfo) {
    if (this.deviceList.length <= 0) {
      this.callback()
      return
    }
    let list: Array<deviceManager.DeviceBasicInfo> = new Array()
    for (let i = 0; i < this.deviceList.length; i++) {
      if (this.deviceList[i].deviceId !== device.deviceId) {
        list[i] = device
      }
    }
    this.deviceList = list
    Logger.info(TAG, `ready, device list=${JSON.stringify(device)}`)
    this.callback()
  }

  deviceStateChangeActionOffline(device: deviceManager.DeviceBasicInfo) {
    if (this.deviceList.length <= 0) {
      this.callback()
      return
    }
    for (let j = 0; j < this.deviceList.length; j++) {
      if (this.deviceList[j].deviceId === device.deviceId) {
        this.deviceList[j] = device
        break
      }
    }
    Logger.info(TAG, `offline, device list=${JSON.stringify(this.deviceList)}`)
    this.callback()
  }

  registerDeviceListCallbackImplement(callback: Callback<void>) {
    Logger.info(TAG, `registerDeviceListCallback`)
    this.callback = callback
    if (this.deviceManager === undefined) {
      Logger.error(TAG, `deviceManager has not initialized`)
      this.callback()
      return
    }
    Logger.info(TAG, `getAvailableDeviceListSync begin`);
    try {
      let list = this.deviceManager.getAvailableDeviceListSync();
      Logger.info(TAG, `getAvailableDeviceListSync end, deviceList=${JSON.stringify(list)}`);
      if (typeof (list) !== 'undefined' && typeof (list.length) !== 'undefined') {
        this.deviceList = list
      }
    } catch (error) {
      Logger.error(TAG, `getAvailableDeviceListSync throw error, code: ${(error as BusinessError).code} message: ${(error as BusinessError).message}`);
    }
    this.callback()
    Logger.info(TAG, `callback finished`)
    let self = this
    try {
      this.deviceManager.on('deviceStateChange', (data) => {
        if (data == null) {
          return
        }
        Logger.info(TAG, `deviceStateChange data=${JSON.stringify(data)}`)
        switch (data.action) {
          case deviceManager.DeviceStateChange.UNKNOWN:
            self.deviceStateChangeActionOnline(data.device)
            break;
          case deviceManager.DeviceStateChange.AVAILABLE:
            self.deviceStateChangeActionReady(data.device)
            break;
          case deviceManager.DeviceStateChange.UNAVAILABLE:
            self.deviceStateChangeActionOffline(data.device)
            break
          default:
            break
        }
      });
      this.deviceManager.on('discoverSuccess', (data) => {
        if (data === null) {
          return
        }
        Logger.info(TAG, `discoverSuccess data=${JSON.stringify(data)}`);
        self.deviceFound(data.device);
      });
      this.deviceManager.on('discoverFailure', (data) => {
        Logger.info(TAG, `discoverFailure data= ${JSON.stringify(data)}`);
      })
      this.deviceManager.on('serviceDie', () => {
        Logger.error(TAG, `serviceDie`)
      })
    } catch (error) {
      Logger.error(TAG, `on throw error, code: ${(error as BusinessError).code} message: ${(error as BusinessError).message}`);
    }
    this.startDeviceDiscovery()
  }

  deviceFound(data: deviceManager.DeviceBasicInfo) {
    for (let i = 0; i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId === data.deviceId) {
        Logger.info(TAG, `device founded ignored`)
        return
      }
    }
    this.discoverList[this.discoverList.length] = data;
    Logger.info(TAG, `deviceFound self.discoverList= ${this.discoverList}`)
    this.callback()
  }

  startDeviceDiscovery() {
    let discoverParam: Record<string, number> = {
      'discoverTargetType': 1
    };
    let filterOptions: Record<string, number> = {
      'availableStatus': 0
    };
    Logger.info(TAG, `startDeviceDiscovery${SUBSCRIBE_ID}`);
    try {
      if (this.deviceManager !== undefined) {
        this.deviceManager.startDiscovering(discoverParam, filterOptions);
      }
    } catch (error) {
      Logger.error(TAG, `startDeviceDiscovery throw error, code: ${(error as BusinessError).code} message: ${(error as BusinessError).message}`);
    }
  }

  unregisterDeviceListCallback() {
    Logger.info(TAG, `stopDeviceDiscovery ${SUBSCRIBE_ID}`);
    if (this.deviceManager === undefined) {
      return
    }
    if (this.deviceManager !== undefined) {
      try {
        Logger.info(TAG, `stopDiscovering`);
        this.deviceManager.stopDiscovering();
      } catch (error) {
        Logger.error(TAG, `stopDeviceDiscovery throw error, code: ${(error as BusinessError).code} message: ${(error as BusinessError).message}`);
      }
      try {
        this.deviceManager.off('deviceStateChange');
        this.deviceManager.off('discoverSuccess');
        this.deviceManager.off('discoverFailure');
        this.deviceManager.off('serviceDie');
      } catch (error) {
        Logger.error(TAG, `off throw error, code: ${(error as BusinessError).code} message: ${(error as BusinessError).message}`);
      }
    }
    this.deviceList = [];
    this.discoverList = [];
  }

  authenticateDevice(device: deviceManager.DeviceBasicInfo, callBack: Callback<void>) {
    Logger.info(TAG, `authenticateDevice ${JSON.stringify(device)}`)
    for (let i = 0; i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId !== device.deviceId) {
        continue
      }
      if (this.deviceManager === undefined) {
        return;
      }
      try {
        if (this.deviceManager !== null) {
          this.deviceManager.bindTarget(device.deviceId, {
            bindLevel: 3,
            bindType: 1,
            targetPkgName: 'ohos.samples.kvstore',
            appName: 'Distributed kvstore',
          }, (err, data) => {
            if (err) {
              Logger.error(TAG, `authenticateDevice error: ${JSON.stringify(err)}`);
              this.authCallback = () => {
              }
              return
            }
            Logger.debug(TAG, `authenticateDevice succeed: ${JSON.stringify(data)}`);
            this.authCallback = callBack;
          })
        }
      } catch (error) {
        Logger.error(TAG, `authenticateDevice throw error, code: ${(error as BusinessError).code} message: ${(error as BusinessError).message}`);
      }
    }
  }
}