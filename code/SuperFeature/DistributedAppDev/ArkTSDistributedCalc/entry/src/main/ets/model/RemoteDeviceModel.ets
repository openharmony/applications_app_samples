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
import Logger from '../model/Logger'
import { Callback } from '@ohos.base'

interface deviceData {
  device: deviceManager.DeviceBasicInfo
}

interface extraInfo {
  bindType: number
  targetPkgName: string
  appName: string
}

const TAG: string = 'RemoteDeviceModel'
let SUBSCRIBE_ID: number = 100

export const BUNDLE_NAME: string = 'ohos.samples.distributedcalc'

export class RemoteDeviceModel {
  public deviceList: Array<deviceManager.DeviceBasicInfo> | null = []
  public discoverList: Array<deviceManager.DeviceBasicInfo> = []
  private callback: () => void = () => {
  }
  private authCallback: () => void = () => {
  }
  private deviceManager: deviceManager.DeviceManager | undefined = undefined

  registerDeviceListCallback(callback: Callback<void>) {
    Logger.info(TAG, `deviceManager type =${typeof (this.deviceManager)} ,${JSON.stringify(this.deviceManager)} ,${JSON.stringify(this.deviceManager) === '{}'}`)
    if (typeof (this.deviceManager) !== 'undefined') {
      this.registerDeviceListCallbackImplement(callback)
      return
    }
    Logger.info(TAG, 'deviceManager.createDeviceManager begin')
    try {
      let dmInstance = deviceManager.createDeviceManager(BUNDLE_NAME);
      this.deviceManager = dmInstance
      this.registerDeviceListCallbackImplement(callback)
      Logger.info(TAG, `createDeviceManager callback returned, value= ${JSON.stringify(this.deviceManager)}`)
    } catch (error) {
      Logger.error(TAG, `createDeviceManager throw code:${error.code} message:${error.message}`)
    }
    Logger.info(TAG, 'deviceManager.createDeviceManager end')
  }

  changeStateOnline(device: deviceManager.DeviceBasicInfo) {
    if (this.deviceList !== null) {
      this.deviceList![this.deviceList!.length] = device;
    }
    Logger.debug(TAG, `online, device list= ${JSON.stringify(this.deviceList)}`);
    this.callback();
    if (this.authCallback !== null) {
      this.authCallback();
      this.authCallback = () => {
      }
    }
  }

  changeStateOffline(device: deviceManager.DeviceBasicInfo) {
    if (this.deviceList !== null && this.deviceList!.length > 0) {
      let list: Array<deviceManager.DeviceBasicInfo> = [];
      for (let j = 0; j < this.deviceList!.length; j++) {
        if (this.deviceList![j].deviceId !== device.deviceId) {
          list[j] = device;
        }
      }
      this.deviceList = list;
    }
    Logger.info(TAG, `offline, updated device list=${JSON.stringify(device)}`);
    this.callback();
  }

  changeState(device: deviceManager.DeviceBasicInfo, state: number) {
    if (this.deviceList !== null && this.deviceList!.length <= 0) {
      this.callback();
      return;
    }
    if (this.deviceList !== null && state === deviceManager.DeviceStateChange.AVAILABLE) {
      let list: Array<deviceManager.DeviceBasicInfo> = new Array();
      for (let i = 0; i < this.deviceList!.length; i++) {
        if (this.deviceList![i].deviceId !== device.deviceId) {
          list[i] = device;
        }
      }
      this.deviceList = list;
      Logger.debug(TAG, `ready, device list= ${JSON.stringify(device)}`);
      this.callback();
    } else {
      if (this.deviceList !== null) {
        for (let j = 0; j < this.deviceList!.length; j++) {
          if (this.deviceList![j].deviceId === device.deviceId) {
            this.deviceList![j] = device;
            break;
          }
        }
        Logger.debug(TAG, `offline, device list= ${JSON.stringify(this.deviceList)}`);
        this.callback();
      }
    }
  }

  registerDeviceListCallbackImplement(callback: Callback<void>) {
    Logger.info(TAG, 'registerDeviceListCallback')
    this.callback = callback
    if (this.deviceManager === undefined) {
      Logger.error(TAG, 'deviceManager has not initialized')
      this.callback()
      return
    }
    Logger.info(TAG, 'getTrustedDeviceListSync begin')
    try {
      let list = this.deviceManager !== undefined ? this.deviceManager.getAvailableDeviceListSync() : null;
      Logger.debug(TAG, `getTrustedDeviceListSync end, deviceList= ${JSON.stringify(list)}`);
      if (typeof (list) !== 'undefined' && JSON.stringify(list) !== '[]') {
        this.deviceList = list!;
      }
      Logger.info(TAG, `getTrustedDeviceListSync end, deviceList=${JSON.stringify(list)}`);
    } catch (error) {
      Logger.error(TAG, `getTrustedDeviceListSync throw code:${error.code} message:${error.message}`);
    }
    this.callback();
    Logger.info(TAG, 'callback finished');
    try {
      if (this.deviceManager !== undefined) {
        this.deviceManager.on('deviceStateChange', (data) => {
          if (data === null) {
            return
          }
          Logger.debug(TAG, `deviceStateChange data= ${JSON.stringify(data)}`)
          switch (data.action) {
            case deviceManager.DeviceStateChange.AVAILABLE:
              this.changeState(data.device, deviceManager.DeviceStateChange.AVAILABLE)
              break
            case deviceManager.DeviceStateChange.UNKNOWN:
              this.changeStateOnline(data.device)
              break
            case deviceManager.DeviceStateChange.UNAVAILABLE:
              this.changeStateOffline(data.device)
              break
            default:
              break
          }
        })
      }
      if (this.deviceManager !== undefined) {
        this.deviceManager.on('discoverSuccess', (data) => {
          if (data === null) {
            return
          }
          this.discoverList = []
          Logger.info(TAG, `discoverSuccess data=${JSON.stringify(data)}`)
          this.deviceFound(data.device)
        })
        this.deviceManager.on('discoverFailure', (data) => {
          Logger.info(TAG, `discoverFailure data= ${JSON.stringify(data)}`)
        })
        this.deviceManager.on('serviceDie', () => {
          Logger.error(TAG, 'serviceDie')
        })
      }
    } catch (error) {
      Logger.error(TAG, `on throw code:${error.code} message:${error.message}`)
    }
    this.startDeviceDiscovery()
  }

  deviceFound(data: deviceManager.DeviceBasicInfo) {
    for (let i = 0;i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId === data.deviceId) {
        Logger.info(TAG, 'device founded ignored')
        return
      }
    }
    this.discoverList[this.discoverList.length] = data
    Logger.debug(TAG, `deviceFound self.discoverList= ${this.discoverList}`)
    this.callback()
  }

  /**
   * 通过SUBSCRIBE_ID搜索分布式组网内的设备
   */
  startDeviceDiscovery() {
    let discoverParam: Record<string, number> = {
      'discoverTargetType': 1
    };

    let filterOptions: Record<string, number> = {
      'availableStatus': 0,
    };

    Logger.info(TAG, `startDeviceDiscovery${SUBSCRIBE_ID}`);
    try {
      if (this.deviceManager !== undefined) {
        this.deviceManager.startDiscovering(discoverParam, filterOptions)
      }
    } catch (error) {
      Logger.error(TAG, `startDeviceDiscovery throw code:${error.code} message:${error.message}`)
    }
  }

  unregisterDeviceListCallback() {
    Logger.debug(TAG, `stopDeviceDiscovery ${SUBSCRIBE_ID}`)
    if (this.deviceManager === undefined) {
      return
    }
    if (this.deviceManager !== undefined) {
      try {
        Logger.info(TAG, `stopDiscovering`)
        this.deviceManager.stopDiscovering();
      } catch (error) {
        Logger.error(TAG, `stopDeviceDiscovery throw code:${JSON.stringify(error.code)} message:${error.message}`)
      }
      try {
        this.deviceManager.off('deviceStateChange')
        this.deviceManager.off('discoverSuccess')
        this.deviceManager.off('discoverFailure')
        this.deviceManager.off('serviceDie')
      } catch (error) {
        Logger.error(TAG, `off throw code:${error.code} message:${error.message}`)
      }
    }
    this.deviceList = []
    this.discoverList = []
  }

  authenticateDevice(device: deviceManager.DeviceBasicInfo, callBack: Callback<void>) {
    Logger.info(TAG, `authenticateDevice ${JSON.stringify(device)}`)
    for (let i = 0; i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId !== device.deviceId) {
        continue
      }
      if (this.deviceManager === undefined) {
        return
      }
      try {
        if (this.deviceManager !== undefined) {
          this.deviceManager.bindTarget(device.deviceId, {
            bindLevel: 3,
            bindType: 1,
            targetPkgName: BUNDLE_NAME,
            appName: 'Distributed distributecalc',
          }, (err, data) => {
            if (err) {
              Logger.error(TAG, `authenticateDevice error: ${JSON.stringify(err)}`)
              this.authCallback = () => {
              }
              return
            }
            Logger.debug(TAG, `authenticateDevice succeed: ${JSON.stringify(data)}`)
            this.authCallback = callBack
          })
        }
      } catch (error) {
        Logger.error(TAG, `authenticateDevice throw throw code:${error.code} message:${error.message}`)
      }
    }
  }
}