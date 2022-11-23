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
import { logger } from '../model/Logger'

var SUBSCRIBE_ID = 100
const TAG = 'RemoteDeviceModel'

export default class RemoteDeviceModel {
  deviceList = []
  discoverList = []
  callback
  authCallback = null
  #deviceManager

  constructor() {
  }

  registerDeviceListCallback(callback) {
    if (typeof (this.#deviceManager) === 'undefined') {
      logger.info(TAG, `deviceManager.createDeviceManager begin`)
      try {
        deviceManager.createDeviceManager('ohos.samples.distributedmusicplayer', (error, value) => {
          if (error) {
            logger.error(TAG, `createDeviceManager failed.`)
            return
          }
          this.#deviceManager = value
          this.registerDeviceListCallback_(callback)
          logger.info(TAG, `createDeviceManager callback returned, error=${error} value=${value}`)
        })
      } catch(error) {
        logger.info(TAG, `createDeviceManager throw error, error=${error} message=${error.message}`)
      }
      logger.info(TAG, `deviceManager.createDeviceManager end`)
    } else {
      this.registerDeviceListCallback_(callback)
    }
  }

  registerDeviceListCallback_(callback) {
    logger.info(TAG, `registerDeviceListCallback`)
    this.callback = callback
    if (this.#deviceManager == undefined) {
      logger.error(TAG, `deviceManager has not initialized`)
      this.callback()
      return
    }

    logger.info(TAG, `getTrustedDeviceListSync begin`)
    try {
      var list = this.#deviceManager.getTrustedDeviceListSync()
      logger.debug(TAG, `getTrustedDeviceListSync end, deviceList=${JSON.stringify(list)}`)
      if (typeof (list) != 'undefined' && typeof (list.length) != 'undefined') {
        this.deviceList = list
      }
    } catch(error) {
      logger.info(TAG, `getTrustedDeviceListSync throw error, error=${error} message=${error.message}`)
    }

    this.callback()
    logger.info(TAG, `callback finished`)
    try {
      this.#deviceManager.on('deviceStateChange', (data) => {
        logger.debug(TAG, `deviceStateChange data=${JSON.stringify(data)}`)
        switch (data.action) {
          case deviceManager.DeviceStateChangeAction.READY:
            this.discoverList = []
            this.deviceList.push(data.device)
            logger.debug(TAG, `ready, updated device list=${JSON.stringify(this.deviceList)}`)
            let list = this.deviceManager.getTrustedDeviceListSync()
            logger.debug(TAG, `getTrustedDeviceListSync end, deviceList=${JSON.stringify(list)}`)
            if (typeof (list) !== 'undefined' && typeof (list.length) !== 'undefined') {
              this.deviceList = list
            }
            this.callback()
            break
          case deviceManager.DeviceStateChangeAction.OFFLINE:
            if (this.deviceList.length > 0) {
              let list = []
              for (let j = 0; j < this.deviceList.length; j++) {
                if (this.deviceList[j].deviceId !== data.device.deviceId) {
                  list[j] = data.device
                }
              }
              this.deviceList = list
            }
            logger.debug(TAG, `offline, updated device list=${JSON.stringify(data.device)}`)
            this.callback()
            break
          default:
            break
        }
      })
      this.#deviceManager.on('deviceFound', (data) => {
        logger.debug(TAG, `deviceFound data=${JSON.stringify(data)} deviceList=${this.deviceList} length=${this.deviceList.length}`)
        for (var i = 0; i < this.discoverList.length; i++) {
          if (this.discoverList[i].deviceId === data.device.deviceId) {
            logger.info(TAG, `device founded, ignored`)
            return
          }
        }
        this.discoverList[this.discoverList.length] = data.device
        this.callback()
      })
      this.#deviceManager.on('discoverFail', (data) => {
        logger.debug(TAG, `discoverFail data=${JSON.stringify(data)}`)
      })
      this.#deviceManager.on('serviceDie', () => {
        logger.error(TAG, `serviceDie`)
      })
    } catch(error) {
      logger.info(TAG, `on throw error, error=${error} message=${error.message}`)
    }


    SUBSCRIBE_ID = Math.floor(65536 * Math.random())
    var info = {
      subscribeId: SUBSCRIBE_ID,
      mode: 0xAA,
      medium: 2,
      freq: 2,
      isSameAccount: false,
      isWakeRemote: true,
      capability: 0
    }
    logger.debug(`startDeviceDiscovery ${SUBSCRIBE_ID}`)
    try {
      this.#deviceManager.startDeviceDiscovery(info)
    } catch(error) {
      logger.info(TAG, `startDeviceDiscovery throw error, error=${error} message=${error.message}`)
    }
  }

  authDevice(deviceId, callback) {
    logger.debug(TAG, `authDevice ${deviceId}`)
    for (var i = 0; i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId === deviceId) {
        logger.info(TAG, `device founded, ignored`)
        let extraInfo = {
          "targetPkgName": 'ohos.samples.distributedmusicplayer',
          "appName": 'Music',
          "appDescription": 'Music player application',
          "business": '0'
        }
        let authParam = {
          "authType": 1,
          "appIcon": '',
          "appThumbnail": '',
          "extraInfo": extraInfo
        }
        logger.debug(TAG, `authenticateDevice ${JSON.stringify(this.discoverList[i])}`)
        try {
          this.#deviceManager.authenticateDevice(this.discoverList[i], authParam, (err, data) => {
            if (err) {
              logger.error(TAG, `authenticateDevice failed, err=${JSON.stringify(err)}`)
              this.authCallback = null
            } else {
              logger.debug(TAG, `authenticateDevice succeed, data=${JSON.stringify(data)}`)
              this.authCallback = callback
            }
          })
        } catch(error) {
          logger.info(TAG, `authenticateDevice throw error, error=${error} message=${error.message}`)
        }
      }
    }
  }

  unregisterDeviceListCallback() {
    logger.debug(TAG, `stopDeviceDiscovery ${SUBSCRIBE_ID}`)
    if (typeof (this.#deviceManager) === 'undefined') {
      return
    }
    try {
      this.#deviceManager.stopDeviceDiscovery(SUBSCRIBE_ID)
      this.#deviceManager.off('deviceStateChange')
      this.#deviceManager.off('deviceFound')
      this.#deviceManager.off('discoverFail')
      this.#deviceManager.off('serviceDie')
      this.deviceList = []
    } catch(error) {
      logger.info(TAG, `stopDeviceDiscovery throw error, error=${error} message=${error.message}`)
    }
  }
}