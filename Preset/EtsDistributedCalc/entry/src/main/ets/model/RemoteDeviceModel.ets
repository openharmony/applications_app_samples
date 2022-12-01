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
import deviceManager from '@ohos.distributedHardware.deviceManager'
import Logger from '../model/Logger'

const TAG: string = 'RemoteDeviceModel'
let SUBSCRIBE_ID: number = 100

export const BUNDLE_NAME: string = 'ohos.samples.etsdistributedcalc'

export class RemoteDeviceModel {
  public deviceList: Array<deviceManager.DeviceInfo> = []
  public discoverList: Array<deviceManager.DeviceInfo> = []
  private callback: () => void = null
  private authCallback: () => void = null
  private deviceManager: deviceManager.DeviceManager = undefined

  registerDeviceListCallback(callback) {
    if (typeof (this.deviceManager) !== 'undefined') {
      this.registerDeviceListCallbackImplement(callback)
      return
    }
    Logger.info(TAG, 'deviceManager.createDeviceManager begin')
    try {
      deviceManager.createDeviceManager(BUNDLE_NAME, (error, value) => {
        if (error) {
          Logger.error(TAG, `createDeviceManager failed.${error}`)
          return
        }
        this.deviceManager = value
        this.registerDeviceListCallbackImplement(callback)
        Logger.info(TAG, `createDeviceManager callback returned, error= ${JSON.stringify(error)} value= ${JSON.stringify(value)}`)
      })
    } catch (error) {
      Logger.error(TAG, `createDeviceManager throw code:${error.code} message:${error.message}`)
    }
    Logger.info(TAG, 'deviceManager.createDeviceManager end')
  }

  changeStateOnline(device) {
    this.deviceList[this.deviceList.length] = device
    Logger.debug(TAG, `online, device list= ${JSON.stringify(this.deviceList)}`)
    this.callback()
    if (this.authCallback !== null) {
      this.authCallback()
      this.authCallback = null
    }
  }

  changeState(device, state) {
    if (this.deviceList.length <= 0) {
      this.callback()
      return
    }
    if (state === deviceManager.DeviceStateChangeAction.READY) {
      let list = new Array()
      for (let i = 0; i < this.deviceList.length; i++) {
        if (this.deviceList[i].deviceId !== device.deviceId) {
          list[i] = device
        }
      }
      this.deviceList = list
      Logger.debug(TAG, `ready, device list= ${JSON.stringify(device)}`)
      this.callback()
    } else {
      for (let j = 0; j < this.deviceList.length; j++) {
        if (this.deviceList[j ].deviceId === device.deviceId) {
          this.deviceList[j] = device
          break
        }
      }
      Logger.debug(TAG, `offline, device list= ${JSON.stringify(this.deviceList)}`)
      this.callback()
    }
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
    try {
      let list = this.deviceManager.getTrustedDeviceListSync()
      Logger.debug(TAG, `getTrustedDeviceListSync end, deviceList= ${JSON.stringify(list)}`)
      if (typeof (list) !== 'undefined' && typeof (list.length) !== 'undefined') {
        this.deviceList = list
      }
    } catch (error) {
      Logger.error(TAG, `getTrustedDeviceListSync throw code:${error.code} message:${error.message}`)
    }
    this.callback()
    Logger.info(TAG, 'callback finished')
    try {
      this.deviceManager.on('deviceStateChange', (data) => {
        if (data === null) {
          return
        }
        Logger.debug(TAG, `deviceStateChange data= ${JSON.stringify(data)}`)
        switch (data.action) {
          case deviceManager.DeviceStateChangeAction.ONLINE:
            this.changeStateOnline(data.device)
            break;
          case deviceManager.DeviceStateChangeAction.READY:
            this.changeState(data.device, deviceManager.DeviceStateChangeAction.READY)
            break;
          case deviceManager.DeviceStateChangeAction.CHANGE:
            this.changeState(data.device, deviceManager.DeviceStateChangeAction.CHANGE)
            break
          default:
            break
        }
      })
      this.deviceManager.on('deviceFound', (data) => {
        if (data === null) {
          return
        }
        Logger.info(TAG, `deviceFound data=${JSON.stringify(data)}`)
        this.deviceFound(data)
      })
      this.deviceManager.on('discoverFail', (data) => {
        Logger.info(TAG, `discoverFail data= ${JSON.stringify(data)}`)
      })
      this.deviceManager.on('serviceDie', () => {
        Logger.error(TAG, 'serviceDie')
      })
    } catch (error) {
      Logger.error(TAG, `on throw code:${error.code} message:${error.message}`)
    }
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
    Logger.debug(TAG, `deviceFound self.discoverList= ${this.discoverList}`)
    this.callback()
  }

  /**
   * 通过SUBSCRIBE_ID搜索分布式组网内的设备
   */
  startDeviceDiscovery() {
    SUBSCRIBE_ID = Math.floor(65536 * Math.random())
    let info = {
      subscribeId: SUBSCRIBE_ID,
      mode: 0xAA,
      medium: 2,
      freq: 2,
      isSameAccount: false,
      isWakeRemote: true,
      capability: 0
    }
    Logger.info(TAG, `startDeviceDiscovery${SUBSCRIBE_ID}`)
    try {
      this.deviceManager.startDeviceDiscovery(info)
    } catch (error) {
      Logger.error(TAG, `startDeviceDiscovery throw code:${error.code} message:${error.message}`)
    }
  }

  unregisterDeviceListCallback() {
    try {
      Logger.info(TAG, `stopDeviceDiscovery${SUBSCRIBE_ID}`)
      this.deviceManager.stopDeviceDiscovery(SUBSCRIBE_ID);
    } catch (error) {
      Logger.error(TAG, `stopDeviceDiscovery throw code:${JSON.stringify(error.code)} message:${error.message}`)
    }
    try {
      this.deviceManager.off('deviceStateChange')
      this.deviceManager.off('deviceFound')
      this.deviceManager.off('discoverFail')
      this.deviceManager.off('serviceDie')
    } catch (error) {
      Logger.error(TAG, `off throw code:${error.code} message:${error.message}`)
    }
    this.deviceList = []
    this.discoverList = []
  }

  authenticateDevice(device, callBack) {
    Logger.info(TAG, `authenticateDevice ${JSON.stringify(device)}`)
    for (let i = 0; i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId !== device.deviceId) {
        continue
      }
      let extraInfo = {
        'targetPkgName': BUNDLE_NAME,
        'appName': 'Distributed distributecalc',
        'appDescription': 'Distributed distributecalc',
        'business': '0'
      }
      let authParam = {
        'authType': 1,
        'appIcon': '',
        'appThumbnail': '',
        'extraInfo': extraInfo
      }
      try {
        this.deviceManager.authenticateDevice(device, authParam, (err, data) => {
          if (err) {
            Logger.error(TAG, `authenticateDevice error: ${JSON.stringify(err)}`)
            this.authCallback = null
            return
          }
          Logger.debug(TAG, `authenticateDevice succeed: ${JSON.stringify(data)}`)
          this.authCallback = callBack
        })
      } catch (error) {
        Logger.error(TAG, `authenticateDevice throw throw code:${error.code} message:${error.message}`)
      }
    }
  }
}