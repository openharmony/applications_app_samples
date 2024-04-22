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

import deviceManager from '@ohos.distributedDeviceManager'
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
        let dmInstance = deviceManager.createDeviceManager('ohos.samples.distributedmusicplayer');
        logger.info(TAG, `dmInstance= ${JSON.stringify (dmInstance)}`)
        this.#deviceManager = dmInstance
        this.registerDeviceListCallback_(callback)
        logger.info(TAG, `createDeviceManager callback returned, value= ${JSON.stringify(this.#deviceManager)}`)
      } catch (error) {
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
      var list = this.#deviceManager.getAvailableDeviceListSync()
      logger.debug(TAG, `getTrustedDeviceListSync end, deviceList=${JSON.stringify(list)}`)
      if (typeof (list) != 'undefined' && typeof (list.length) != 'undefined') {
        this.deviceList = list
      }
    } catch (error) {
      logger.info(TAG, `getTrustedDeviceListSync throw error, error=${error} message=${error.message}`)
    }

    this.callback()
    logger.info(TAG, `callback finished`)
    try {
      this.#deviceManager.on('deviceStateChange', (data) => {
        logger.debug(TAG, `deviceStateChange data=${JSON.stringify(data)}`)
        switch (data.action) {
          case deviceManager.DeviceStateChange.AVAILABLE:
            this.discoverList = []
            this.deviceList.push(data.device)
            logger.debug(TAG, `ready, updated device list=${JSON.stringify(this.deviceList)}`)
            try {
              let list = this.deviceManager.getAvailableDeviceListSync()
              logger.debug(TAG, `getTrustedDeviceListSync end, deviceList=${JSON.stringify(list)}`)
              if (typeof (list) !== 'undefined' && typeof (list.length) !== 'undefined') {
                this.deviceList = list
              }
            } catch (error) {
              logger.error(TAG, `getTrustedDeviceListSync throw error,  error.code=${JSON.stringify(error)}`)
            }
            this.callback()
            break
          case deviceManager.DeviceStateChange.UNAVAILABLE:
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
      this.#deviceManager.on('discoverSuccess', (data) => {
        this.discoverList = [];
        logger.debug(TAG, `discoverSuccess data=${JSON.stringify(data)} deviceList=${this.deviceList} length=${this.deviceList.length}`)
        for (var i = 0; i < this.discoverList.length; i++) {
          if (this.discoverList[i].deviceId === data.device.deviceId) {
            logger.info(TAG, `device founded, ignored`)
            return
          }
        }
        this.discoverList[this.discoverList.length] = data.device
        this.callback()
      })
      this.#deviceManager.on('discoverFailure', (data) => {
        logger.debug(TAG, `discoverFailure data=${JSON.stringify(data)}`)
      })
      this.#deviceManager.on('serviceDie', () => {
        logger.error(TAG, `serviceDie`)
      })
    } catch (error) {
      logger.info(TAG, `on throw error, error=${error} message=${error.message}`)
    }


    let discoverParam = {
      'discoverTargetType': 1
    };
    let filterOptions = {
      'availableStatus': 0
    };
    logger.info(TAG, `startDiscovering${SUBSCRIBE_ID}`)
    try {
      if (this.deviceManager !== null) {
        this.#deviceManager.startDiscovering(discoverParam, filterOptions)
      }
    } catch (error) {
      logger.error(TAG, `startDiscovering throw code:${error.code} message:${error.message}`)
    }
  }

  authDevice(deviceId, callback) {
    logger.debug(TAG, `authDevice ${deviceId}`)
    for (let i = 0; i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId !== deviceId) {
        continue
      }
      if (this.#deviceManager === undefined) {
        logger.info(TAG, 'this.#deviceManager is undefinded')
        return
      }
      logger.debug(TAG, `authenticateDevice ${JSON.stringify(this.discoverList[i])}`)
      try {
        if (this.deviceManager !== null) {
          this.#deviceManager.bindTarget(deviceId, {
            bindLevel: 3,
            bindType: 1,
            targetPkgName: 'ohos.samples.distributedmusicplayer',
            appName: 'Music',
          }, (err, data) => {
            if (err) {
              logger.error(TAG, `authenticateDevice error: ${JSON.stringify(err)}`)
              this.authCallback = () => {
              }
              return
            }
            logger.debug(TAG, `authenticateDevice succeed: ${JSON.stringify(data)}`)
            this.authCallback = callback
          })
        }
      } catch (error) {
        logger.error(TAG, `authenticateDevice throw throw code:${error.code} message:${error.message}`)
      }
    }
  }

  unregisterDeviceListCallback() {
    logger.debug(TAG, `stopDeviceDiscovery ${SUBSCRIBE_ID}`)
    if (typeof (this.#deviceManager) === 'undefined') {
      return
    }
    try {
      this.#deviceManager.stopDiscovering(SUBSCRIBE_ID)
      this.#deviceManager.off('deviceStateChange')
      this.#deviceManager.off('discoverSuccess')
      this.#deviceManager.off('discoverFailure')
      this.#deviceManager.off('serviceDie')
      this.deviceList = []
    } catch (error) {
      logger.info(TAG, `stopDeviceDiscovery throw error, error=${error} message=${error.message}`)
    }
  }
}