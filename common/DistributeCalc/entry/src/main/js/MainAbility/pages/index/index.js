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

import { calc, isOperator } from '../../common/calculator.js'
import app from '@system.app'
import RemoteDeviceModel from '../../common/RemoteDeviceModel.js'
import featureAbility from '@ohos.ability.featureAbility'
import { KvStoreModel } from '../../common/kvstoreModel.js'
import { logger } from '../../common/Logger'

let pressedEqual = false
let kvStoreModel = new KvStoreModel()
let remoteDeviceModel = new RemoteDeviceModel()
const TAG = 'Index'

export default {
  data: {
    title: '',
    expression: '',
    result: '',
    selectedIndex: 0,
    isFA: false,
    isPush: false,
    isShow: false,
    isDistributed: false,
    deviceList: []
  },
  onInit() {
    this.title = this.$t('strings.title')
    this.grantPermission()
  },
  onShow() {
    this.$watch('expression', (value) => {
      if (value !== '') {
        logger.debug(TAG, `value  ${value}`)
        this.result = calc(value)
        logger.debug(TAG, `result =  ${this.result}`)
        logger.info(TAG, `put key start`)
        this.dataChange('expression', value)
      }
    })
    this.initKVManager()
    featureAbility.getWant((error, want) => {
      logger.debug(TAG, `featureAbility.getWant =${JSON.stringify(want.parameters)}`)
      if (want.parameters.isFA === 'FA') {
        this.isFA = true
        this.isDistributed = true
      }
    })
  },
  grantPermission() {
    logger.info(TAG, `grantPermission`)
    let context = featureAbility.getContext()
    try {
      context.requestPermissionsFromUser(['ohos.permission.DISTRIBUTED_DATASYNC'], 666, function (result) {
        logger.debug(TAG, `grantPermission,requestPermissionsFromUser,result.requestCode=${result}`)
      })
    } catch (err) {
      logger.debug(TAG, `grantPermission,err=${err}`)
    }
  },
  dataChange(key, value) {
    logger.info(TAG, `dataChange isDistributed = ${this.isDistributed}`)
    if (this.isDistributed && kvStoreModel != null) {
      kvStoreModel.put(key, value)
    }
  },
  initKVManager() {
    if (kvStoreModel !== null) {
      kvStoreModel.setOnMessageReceivedListener('expression', (value) => {
        logger.info(TAG, `data changed:${value}`)
        if (value === 'exit') {
          logger.info('Calc[CalcPage] app exit!')
          app.terminate()
          return
        }
        if (value === 'clear') {
          logger.info(TAG, `data expression:clear`)
          this.expression = ''
          this.result = ''
          return
        }
        if (value === 'equal') {
          if (this.result !== '') {
            logger.info(TAG, `data expression:equal`)
            this.expression = this.result
            this.result = ''
            pressedEqual = true
          }
          return
        }
        this.expression = value
        pressedEqual = false
        logger.info(TAG, `data expression:${this.expression}`)
      })
    }
  },
  stopDataListener() {
    logger.info(TAG, `stopDataListener`)
    if (kvStoreModel === null || kvStoreModel === undefined) {
      return
    }
    kvStoreModel.off()
  },
  onDestroy() {
    if (remoteDeviceModel === undefined) {
      return
    }
    remoteDeviceModel.unregisterDeviceListCallback()
    if (this.isDistributed && kvStoreModel != null) {
      this.stopDataListener()
      this.isDistributed = false
    }
    kvStoreModel = null
    remoteDeviceModel = undefined
  },
  showDialog() {
    logger.info(TAG, `showDialog start`)
    this.isShow = true
    setTimeout(() => {
      this.deviceList = []
      if (remoteDeviceModel === undefined) {
        remoteDeviceModel = new RemoteDeviceModel()
      }
      logger.debug(TAG, `showdialog = ${typeof (this.$element('showDialog'))}`)
      logger.debug(TAG, `registerDeviceListCallback on remote device updated, count=${remoteDeviceModel.deviceList.length}`)
      remoteDeviceModel.registerDeviceListCallback(() => {
        let list = []
        list.push({
          deviceId: '0',
          deviceName: 'Local device',
          deviceType: 0,
          networkId: '',
          checked: this.selectedIndex === 0
        })
        let tempList = remoteDeviceModel.discoverList.length > 0 ? remoteDeviceModel.discoverList : remoteDeviceModel.deviceList
        for (let i = 0; i < tempList.length; i++) {
          logger.debug(`device ${i}/${tempList.length} deviceId=${tempList[i].deviceId} deviceName=${tempList[i].deviceName} deviceType=${tempList[i].deviceType}`)
          list.push({
            deviceId: tempList[i].deviceId,
            deviceName: tempList[i].deviceName,
            deviceType: tempList[i].deviceType,
            networkId: tempList[i].networkId,
            checked: this.selectedIndex === (i + 1)
          })
        }
        this.deviceList = list
        this.$element('showDialog').close()
        this.$element('showDialog').show()
      })
    }, 200)
  },
  cancelDialog() {
    this.$element('showDialog').close()
    if (remoteDeviceModel === undefined) {
      return
    }
    remoteDeviceModel.unregisterDeviceListCallback()
  },

  selectDevice(item) {
    let index = this.deviceList.indexOf(item)
    logger.info(TAG, `select index:${index}`)
    logger.info(TAG, `select selectedIndex:${this.selectedIndex}`)
    if (index === this.selectedIndex) {
      logger.info(TAG, `index === this.selectedIndex`)
      return
    }
    this.selectedIndex = index
    if (index === 0) {
      logger.info(TAG, `stop ability`)
      this.dataChange('expression', 'exit')
      this.isDistributed = false
      this.stopDataListener()
      this.clearSelectState()
      return
    }
    logger.info(TAG, `start ability ......`)
    this.isDistributed = true
    if (remoteDeviceModel === undefined || remoteDeviceModel.discoverList.length <= 0) {
      logger.info(TAG, `continue device:${JSON.stringify(this.deviceList)}`)
      this.startAbility(this.deviceList[index].deviceId)
      this.clearSelectState()
      return
    }
    logger.info(TAG, `start ability1, needAuth`)
    remoteDeviceModel.authenticateDevice(this.deviceList[index], () => {
      logger.info(TAG, ` auth and online finished`)
      this.startAbility(this.deviceList[index].deviceId)
    })
    this.clearSelectState()
    logger.info(TAG, ` start ability end....`)
  },
  clearSelectState() {
    this.deviceList = []
    this.$element('showDialog').close()
  },
  async startAbility(deviceId) {
    logger.debug(TAG, ` startAbility deviceId: ${deviceId}`)
    await featureAbility.startAbility({
      want: {
        bundleName: 'ohos.samples.distributedcalc',
        abilityName: 'ohos.samples.distributedcalc.MainAbility',
        deviceId: deviceId,
        parameters: {
          isFA: 'FA'
        }
      }
    })
    logger.info(TAG, ` start ability finished`)
    this.dataChange('expression', this.expression)
    logger.info(TAG, ` startAbility end`)
  },
  handleClear() {
    this.expression = ''
    this.result = ''
    logger.info(TAG, ` handleClear`)
    this.dataChange('expression', 'clear')
  },
  handleInput(value) {
    logger.info(TAG, ` handle input value:${value}`)
    this.isPush = false
    if (isOperator(value)) {
      this.isPressedEqual()
      if (!this.expression && (value === '*' || value === '/')) {
        return
      }
      this.expression += value
    } else {
      if (pressedEqual) {
        pressedEqual = false
      }
      this.expression += value
    }
  },
  isPressedEqual() {
    if (pressedEqual) {
      pressedEqual = false
    } else {
      const size = this.expression.length
      if (size) {
        const last = this.expression.charAt(size - 1)
        if (isOperator(last)) {
          this.expression = this.expression.substring(0, this.expression.length - 1)
        }
      }
    }
  },
  handleBackspace() {
    if (pressedEqual) {
      this.expression = ''
      this.result = ''
      pressedEqual = false
      logger.info(TAG, `handleBackspace1`)
      this.dataChange('expression', 'clear')
    } else {
      this.isPush = false
      this.expression = this.expression.substring(0, this.expression.length - 1)
      if (!this.expression.length) {
        this.result = ''
        logger.info(TAG, ` handleBackspace2`)
        this.dataChange('expression', 'clear')
      }
    }
  },
  handleEqual() {
    if (this.result !== '') {
      this.isPush = true
      this.expression = this.result
      this.result = ''
      pressedEqual = true
      logger.info(TAG, ` handleEqual`)
      this.dataChange('expression', 'equal')
    }
  },
  handleExist() {
    logger.info(TAG, `handleExist`)
    app.terminate()
  }
}