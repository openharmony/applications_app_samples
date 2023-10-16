/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import deviceManager from '@ohos.distributedDeviceManager'
import Logger from '../model/Logger'
import { BUNDLE } from '../model/RdbConst'

let SUBSCRIBE_ID = 100
const TAG: string = 'RemoteDeviceModel'

class RemoteDeviceModel {
  public deviceList: Array<deviceManager.DeviceBasicInfo> = []
  public discoverList: Array<deviceManager.DeviceBasicInfo> = []
  private callback: () => void = null
  private authCallback: (device: deviceManager.DeviceBasicInfo) => void = null
  private deviceManager: deviceManager.DeviceManager = undefined

  registerDeviceListCallback(callback) {
    if (typeof (this.deviceManager) !== 'undefined') {
      this.registerDeviceListCallbackImplement(callback)
      return
    }
    Logger.info(TAG, 'deviceManager.createDeviceManager begin')
    try {
      let dmInstance = deviceManager.createDeviceManager(BUNDLE);
      Logger.info(TAG, `dmInstance= ${JSON.stringify (dmInstance)}`)
      this.deviceManager = dmInstance
      this.registerDeviceListCallbackImplement(callback)
      Logger.info(TAG, `createDeviceManager callback returned, value= ${JSON.stringify(this.deviceManager)}`)
    } catch (error) {
      Logger.error(TAG, `createDeviceManager throw error, code=${error.code} message=${error.message}`)
    }
    Logger.info(TAG, 'deviceManager.createDeviceManager end')
  }

  deviceStateChangeActionOnline(device) {
    this.deviceList[this.deviceList.length] = device
    Logger.info(TAG, `online, device list=${JSON.stringify(this.deviceList)}`)
    if (this.authCallback !== null) {
      this.authCallback(device)
      this.authCallback = null
    }
  }

  deviceStateChangeActionReady(device) {
    if (this.deviceList.length <= 0) {
      this.callback()
      return
    }
    let list = new Array()
    for (let i = 0; i < this.deviceList.length; i++) {
      if (this.deviceList[i].deviceId !== device.deviceId) {
        list[i] = device
      }
    }
    this.deviceList = list
    Logger.info(TAG, `ready, device list=${JSON.stringify(this.deviceList)}`)
    this.callback()
  }

  deviceStateChangeActionOffline(device) {
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
  }

  getLocalDevice() {
    Logger.info(TAG, `getLocalDevice`)
    let deviceId: string = this.deviceManager.getLocalDeviceId();
    Logger.info(TAG, `local deviceInfo=${JSON.stringify(deviceId)}`)
    return deviceId
  }

  registerDeviceListCallbackImplement(callback) {
    Logger.info(TAG, 'registerDeviceListCallback' + JSON.stringify(this.deviceManager))
    this.callback = callback
    if (this.deviceManager === undefined) {
      Logger.error(TAG, 'deviceManager has not initialized')
      this.callback()
      return
    }
    Logger.info(TAG, 'getTrustedDeviceListSync begin' + JSON.stringify(this.deviceManager))
    let list = this.deviceManager.getAvailableDeviceListSync()
    Logger.info(TAG, `getTrustedDeviceListSync end, deviceList=${JSON.stringify(list)}`)
    if (typeof (list) !== 'undefined' && typeof (list.length) !== 'undefined') {
      this.deviceList = list
    }
    this.callback()
    Logger.info(TAG, 'callback finished')
    this.deviceManager.on('deviceStateChange', (data) => {
      Logger.info(TAG, 'deviceStateChange on:' + JSON.stringify(data))
      if (data === null) {
        return
      }
      switch (data.action) {
        case deviceManager.DeviceStateChange.UNKNOWN:
          this.deviceStateChangeActionOnline(data.device)
          break
        case deviceManager.DeviceStateChange.AVAILABLE:
          this.deviceStateChangeActionReady(data.device)
          break
        case deviceManager.DeviceStateChange.UNAVAILABLE:
          this.deviceStateChangeActionOffline(data.device)
          break
        default:
          break
      }
    })
    this.deviceManager.on('discoverSuccess', (data) => {
      if (data === null) {
        return
      }
      Logger.info(TAG, `discoverSuccess data=${JSON.stringify(data)}`)
      this.deviceFound(data)
    })
    this.deviceManager.on('discoverFailure', (data) => {
      Logger.info(TAG, `discoverFailure data=${JSON.stringify(data)}`)
    })
    this.deviceManager.on('serviceDie', () => {
      Logger.info(TAG, 'serviceDie')
    })
    this.startDeviceDiscovery()
  }

  deviceFound(data) {
    for (let i = 0;i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId === data.device.deviceId) {
        Logger.info(TAG, 'device founded ignored')
        return
      }
    }
    this.discoverList[this.discoverList.length] = data.device
    Logger.info(TAG, `deviceFound self.discoverList=${JSON.stringify(this.discoverList)}`)
    this.callback()
  }

  startDeviceDiscovery() {
    let discoverParam: Record<string, number> = {
      'discoverTargetType': 1
    };
    let filterOptions: Record<string, number> = {
      'availableStatus': 0
    };
    Logger.info(TAG, `startDeviceDiscovery${SUBSCRIBE_ID}`)
    try {
      if (this.deviceManager !== null) {
        this.deviceManager.startDiscovering(discoverParam, filterOptions)
      }
    } catch (error) {
      Logger.error(TAG, `startDeviceDiscovery throw code:${error.code} message:${error.message}`)
    }
  }

  unregisterDeviceListCallback() {
    Logger.info(TAG, `stopDeviceDiscovery${SUBSCRIBE_ID}`)
    this.deviceManager.stopDiscovering()
    this.deviceManager.off('deviceStateChange')
    this.deviceManager.off('discoverSuccess')
    this.deviceManager.off('discoverFailure')
    this.deviceManager.off('serviceDie')
    this.deviceList = []
    this.discoverList = []
  }

  authenticateDevice(device, callBack) {
    Logger.info(TAG, `bindTarget${JSON.stringify(device)}`)
    for (let i = 0; i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId !== device.deviceId) {
        continue
      }
      if (this.deviceManager === undefined) {
        return
      }
      try {
        if (this.deviceManager !== null) {
          this.deviceManager.bindTarget(device.deviceId, {
            bindType: 1,
            targetPkgName: BUNDLE,
            appName: 'Distributed distributedrdb',
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

export default new RemoteDeviceModel()