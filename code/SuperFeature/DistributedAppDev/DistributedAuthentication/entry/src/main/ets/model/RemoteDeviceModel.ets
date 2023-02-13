/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import deviceManager from '@ohos.distributedHardware.deviceManager';
import Logger from '../model/Logger'

const TAG = 'RemoteDeviceModel'
const SUBSCRIBE_ID = 100 // 发现标识，用于标识不同的发现周期

export class RemoteDeviceModel {
  deviceList: Array<any> = []
  discoverList: Array<any> = []
  callback
  public deviceManager: deviceManager.DeviceManager

  constructor() {
  }

  registerDeviceListCallback(callback) {
    if (typeof (this.deviceManager) != 'undefined') {
      this.registerDeviceListCallbackImplement(callback)
      return
    }
    Logger.info(TAG, 'deviceManager.createDeviceManager begin')
    try {
      deviceManager.createDeviceManager('ohos.samples.devicemanager', (error, value) => {
        if (error) {
          Logger.error(TAG, 'createDeviceManager failed.')
          return;
        }
        this.deviceManager = value
        this.registerDeviceListCallbackImplement(callback)
        Logger.info(TAG, `createDeviceManager callback returned, error= ${error} value= ${value}`)
      });
    } catch (err) {
      Logger.error(TAG, `createDeviceManager failed, code is ${err.code}, message is ${err.message}`)
    }
    Logger.info(TAG, 'deviceManager.createDeviceManager end')
  }

  deviceStateChangeActionOnline(device) {
    this.deviceList[this.deviceList.length] = device
    Logger.info(TAG, `device list=${JSON.stringify(this.deviceList)}`)
    for (let i = this.discoverList.length - 1; i >= 0; i--) {
      if (this.discoverList[i].deviceId != device.deviceId) {
        this.discoverList.splice(i, 1)
        break
      }
    }
    for (let j = 0; j < this.deviceList.length; j++) {
      if (this.deviceList[j].deviceId === device.deviceId) {
        this.deviceList[j] = device
        break
      }
    }
    this.callback()
  }

  deviceStateChangeActionOffline(device) {
    Logger.info(TAG, `this.deviceList.length=${this.deviceList.length}`)
    let list = []
    for (let i = 0; i < this.deviceList.length; i++) {
      if (this.deviceList[i].deviceId !== device.deviceId) {
        list.push(device)
      }
    }
    this.deviceList = list
    Logger.info(TAG, `device list=${JSON.stringify(this.deviceList)}`)
    this.callback()
  }

  registerDeviceListCallbackImplement(callback) {
    Logger.info(TAG, 'registerDeviceListCallback')
    this.callback = callback
    if (this.deviceManager === undefined) {
      Logger.error(TAG, 'deviceManager has not initialized')
      this.callback()
      return
    }
    Logger.info(TAG, 'getTrustedDeviceListSync begin')
    let list = this.deviceManager.getTrustedDeviceListSync()
    Logger.info(TAG, `getTrustedDeviceListSync end, deviceList=${JSON.stringify(list)}`)
    if (typeof (list) != 'undefined' && typeof (list.length) != 'undefined') {
      this.deviceList = list
    }
    this.callback()
    Logger.info(TAG, 'callback finished');
    let self = this
    this.deviceManager.on('deviceStateChange', (data) => {
      if (data == null) {
        return
      }
      Logger.info(TAG, `deviceStateChange data=${JSON.stringify(data)}`)
      switch (data.action) {
        case deviceManager.DeviceStateChangeAction.ONLINE:
          Logger.info(TAG, 'deviceStateChange ONLINE')
          self.deviceStateChangeActionOnline(data.device)
          break
        case deviceManager.DeviceStateChangeAction.READY:
          Logger.info(TAG, 'deviceStateChange READY')
          break
        case deviceManager.DeviceStateChangeAction.OFFLINE:
          Logger.info(TAG, 'deviceStateChange OFFLINE')
          self.deviceStateChangeActionOffline(data.device)
          break
        default:
          break
      }
    })
    this.deviceManager.on('deviceFound', (data) => {
      if (data == null) {
        return
      }
      Logger.info(TAG, `deviceFound data=${JSON.stringify(data)}`)
      self.deviceFound(data)
    })
    this.deviceManager.on('discoverFail', (data) => {
      Logger.info(TAG, `discoverFail data=${JSON.stringify(data)}`)
    })
    this.deviceManager.on('serviceDie', () => {
      Logger.error(TAG, 'serviceDie')
    })
    this.startDeviceDiscovery()
  }

  deviceFound(data) {
    for (let i = 0;i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId == data.device.deviceId) {
        Logger.info(TAG, 'device founded ignored')
        return
      }
    }
    this.discoverList[this.discoverList.length] = data.device
    Logger.info(TAG, `deviceFound self.discoverList=${this.discoverList}`)
    this.callback()
  }

  startDeviceDiscovery() {
    let info = {
      subscribeId: SUBSCRIBE_ID,
      mode: 0xAA,
      medium: 2, // WiFi发现类型
      freq: 2, // 表示发现高频率的枚举
      isSameAccount: false,
      isWakeRemote: true,
      capability: 0 // 表示发现DDMP能力的枚举
    }
    Logger.info(TAG, `startDeviceDiscovery${SUBSCRIBE_ID}`)
    try {
      this.deviceManager.startDeviceDiscovery(info)
    } catch (err) {
      Logger.error(`startDeviceDiscovery failed, code is ${err.code}, message is ${err.message}`)
    }
  }

  unregisterDeviceListCallback() {
    Logger.info(TAG, `stopDeviceDiscovery${SUBSCRIBE_ID}`)
    this.deviceManager.stopDeviceDiscovery(SUBSCRIBE_ID)
    this.deviceManager.off('deviceStateChange')
    this.deviceManager.off('deviceFound')
    this.deviceManager.off('discoverFail')
    this.deviceManager.off('serviceDie')
    this.deviceList = []
    this.discoverList = []
  }

  authenticateDevice(device) {
    Logger.info(TAG, `authenticateDevice${JSON.stringify(device)}`)
    for (let i = 0; i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId != device.deviceId) {
        continue
      }
      let extraInfo = {
        'targetPkgName': 'ohos.samples.devicemanager',
        'appName': 'eTSDeviceManger',
        'appDescription': 'eTSDeviceManger Ability',
        'business': '0'
      }
      let authParam = {
        'authType': 1, // 认证类型
        'appIcon': '',
        'appThumbnail': '',
        'extraInfo': extraInfo
      }
      try {
        this.deviceManager.authenticateDevice(device, authParam, (err, data) => {
          if (err) {
            Logger.info(TAG, `authenticateDevice error:${JSON.stringify(err)}`)
            return
          }
          Logger.info(TAG, `authenticateDevice succeed:${JSON.stringify(data)}`)
        })
      } catch (err) {
        Logger.info(JSON.stringify(err))
      }
    }
  }
}