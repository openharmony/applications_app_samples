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
import { BUNDLE } from '../model/Const'
import Logger from '../model/Logger'
import { BusinessError } from '@ohos.base';

let SUBSCRIBE_ID: number = 100
const TAG: string = 'RemoteDeviceModel'

class RemoteDeviceModel {
  public devices: Array<deviceManager.DeviceBasicInfo> = [];
  public discoverDevices: Array<deviceManager.DeviceBasicInfo> = [];
  private stateChangeCallback?: () => void
  private authCallback?: (device: deviceManager.DeviceBasicInfo) => void;
  private deviceManager?: deviceManager.DeviceManager

  registerDeviceListCallback(stateChangeCallback: () => void) {
    if (typeof (this.deviceManager) !== 'undefined') {
      this.registerDeviceListCallbackImplement(stateChangeCallback)
      return
    }
    Logger.info(TAG, 'deviceManager.createDeviceManager begin')
    try {
      let dmInstance = deviceManager.createDeviceManager(BUNDLE);
      Logger.info(TAG, `dmInstance= ${JSON.stringify(dmInstance)}`);
      this.deviceManager = dmInstance;
      this.registerDeviceListCallbackImplement(stateChangeCallback);
      Logger.info(TAG, `createDeviceManager callback returned, value= ${JSON.stringify(this.deviceManager)}`);
    } catch (error) {
      Logger.error(TAG, `createDeviceManager throw error, code: ${(error as BusinessError).code} message: ${(error as BusinessError).message}`);
    }
    Logger.info(TAG, 'deviceManager.createDeviceManager end');
  }

  onDeviceStateChangeActionOnline(device) {
    this.devices[this.devices.length] = device
    Logger.info(TAG, `online, device list=${JSON.stringify(this.devices)}`)
    if (this.authCallback !== null) {
      this.authCallback(device)
      this.authCallback = null
    }
  }

  onDeviceStateChangeActionReady(device) {
    if (this.devices.length <= 0) {
      this.stateChangeCallback()
      return
    }

    let list = this.devices.filter((value) => {
      return value !== device.deviceId
    })

    this.devices = list
    Logger.info(TAG, `ready, device list=${JSON.stringify(this.devices)}`)
    this.stateChangeCallback()
  }

  getLocalDevice() {
    try {
      Logger.info(TAG, 'getLocalDevice');
      let deviceId: string = this.deviceManager.getLocalDeviceId();
      Logger.info(TAG, `local deviceInfo=${JSON.stringify(deviceId)}`);
      return deviceId;
    } catch (error) {
      Logger.error(TAG, `getLocalDeviceInfoSync throw error, code: ${(error as BusinessError).code} message: ${(error as BusinessError).message}`);
    }
  }

  registerDeviceListCallbackImplement(stateChangeCallback: () => void) {
    Logger.info(TAG, 'registerDeviceListCallback')
    this.stateChangeCallback = stateChangeCallback
    if (this.deviceManager === undefined) {
      Logger.error(TAG, 'deviceManager has not initialized')
      this.stateChangeCallback()
      return
    }
    Logger.info(TAG, 'getAvailableDeviceListSync begin');
    try {
      let list = this.deviceManager.getAvailableDeviceListSync();
      Logger.info(TAG, `getAvailableDeviceListSync end, devices=${JSON.stringify(list)}`);
      if (typeof (list) !== 'undefined' && typeof (list.length) !== 'undefined') {
        this.devices = list
      }
    } catch (error) {
      Logger.error(TAG, `getAvailableDeviceListSync throw error, code: ${(error as BusinessError).code} message: ${(error as BusinessError).message}`);

    }
    this.stateChangeCallback()
    Logger.info(TAG, 'callback finished')
    try {
      this.deviceManager.on('deviceStateChange', (data) => {
        if (data === null) {
          return
        }
        Logger.info(TAG, `deviceStateChange data = ${JSON.stringify(data)}`)
        switch (data.action) {
          case deviceManager.DeviceStateChange.AVAILABLE:
            this.discoverDevices = []
            this.devices.push(data.device)
            this.stateChangeCallback()
            try {
              let list = this.deviceManager.getAvailableDeviceListSync();
              if (typeof (list) !== 'undefined' && typeof (list.length) !== 'undefined') {
                this.devices = list
              }
            } catch (error) {
              Logger.error(TAG, `getTrustedDeviceListSync throw error, code: ${(error as BusinessError).code} message: ${(error as BusinessError).message}`);
            }
            this.stateChangeCallback()
            break
          default:
            break
        }
      })
      this.deviceManager.on('discoverSuccess', (data) => {
        if (data === null) {
          return
        }
        Logger.info(TAG, `discoverSuccess data=${JSON.stringify(data)}`);
        this.onDeviceFound(data)
      })
      this.deviceManager.on('discoverFailure', (data) => {
        Logger.info(TAG, `discoverFailure data=${JSON.stringify(data)}`);
      })
      this.deviceManager.on('serviceDie', () => {
        Logger.info(TAG, 'serviceDie')
      })
    } catch (error) {
      Logger.error(TAG, `on throw error, code: ${(error as BusinessError).code} message: ${(error as BusinessError).message}`);
    }
    this.startDeviceDiscovery()
  }

  onDeviceFound(data) {
    for (let i = 0;i < this.discoverDevices.length; i++) {
      if (this.discoverDevices[i].deviceId === data.device.deviceId) {
        Logger.info(TAG, 'device founded ignored')
        return
      }
    }
    this.discoverDevices[this.discoverDevices.length] = data.device
    Logger.info(TAG, `deviceFound self.discoverDevices=${this.discoverDevices}`)
    this.stateChangeCallback()
  }

  startDeviceDiscovery() {
    let discoverParam: Record<string, number> = {
      'discoverTargetType': 1
    };
    let filterOptions: Record<string, number> = {
      'availableStatus': 0
    };
    Logger.info(TAG, `startDiscovering${SUBSCRIBE_ID}`);
    try {
      if (this.deviceManager !== null) {
        this.deviceManager.startDiscovering(discoverParam, filterOptions);
      }
    } catch (error) {
      Logger.error(TAG, `startDiscovering throw error, code: ${(error as BusinessError).code} message: ${(error as BusinessError).message}`);
    }
  }

  unregisterDeviceListCallback() {
    try {
      Logger.info(TAG, `stopDeviceDiscovery${SUBSCRIBE_ID}`);
      this.deviceManager.stopDiscovering();
      this.deviceManager.off('deviceStateChange')
      this.deviceManager.off('discoverSuccess');
      this.deviceManager.off('discoverFailure');
      this.deviceManager.off('serviceDie')
      this.devices = []
      this.discoverDevices = []
    } catch (error) {
      Logger.error(TAG, `off throw error, code: ${(error as BusinessError).code} message: ${(error as BusinessError).message}`);
    }

  }

  authenticateDevice(device, callBack) {
    Logger.info(TAG, `authenticateDevice ${JSON.stringify(device)}`)
    for (let i = 0; i < this.discoverDevices.length; i++) {
      if (this.discoverDevices[i].deviceId !== device.deviceId) {
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
            targetPkgName: BUNDLE,
            appName: 'Distributed rdb',
          }, (err, data) => {
            if (err) {
              Logger.error(TAG, `authenticateDevice throw error, code: ${(err as BusinessError).code} message: ${(err as BusinessError).message}`);
              this.authCallback = () => {};
              return;
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

export default new RemoteDeviceModel()