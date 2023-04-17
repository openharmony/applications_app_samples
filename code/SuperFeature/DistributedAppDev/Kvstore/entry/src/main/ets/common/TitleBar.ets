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

import common from '@ohos.app.ability.common'
import { DeviceDialog } from '../common/Dialog'
import { RemoteDeviceModel } from '../model/RemoteDeviceModel'
import { DeviceDataModel } from '../model/DeviceDataModel'
import Logger from '../util/Logger'

const NOTES_CHANGE = 'notesChange'
const EXIT = 'exit'
const TAG = 'TitleBar'

@Component
export struct TitleBar {
  private selectedIndex: number = 0
  private startAbilityCallBack: (key: string) => void
  private remoteDeviceModel: RemoteDeviceModel = null
  private dialogController: CustomDialogController = null
  @State deviceList: Array<DeviceDataModel> = []
  @Link isDistributed: boolean
  @State dialogShow: boolean = false

  clearSelectState() {
    this.deviceList = []
    this.dialogShow = false
    this.dialogController.close()
  }

  selectDevice() {
    Logger.info(TAG, 'start ability ......')
    this.isDistributed = true
    if (this.remoteDeviceModel === null || this.remoteDeviceModel.discoverList.length <= 0) {
      Logger.info(TAG, `continue unauthed device:${JSON.stringify(this.deviceList)}`)
      this.startAbility(this.deviceList[this.selectedIndex].deviceId)
      this.clearSelectState()
      return
    }
    Logger.info(TAG, 'start ability1, needAuth：')
    this.remoteDeviceModel.authenticateDevice(this.deviceList[this.selectedIndex], () => {
      Logger.info(TAG, "auth and online finished")
      for (var i = 0; i < this.remoteDeviceModel.deviceList.length; i++) {
        if (this.remoteDeviceModel.deviceList[i].deviceName === this.deviceList[this.selectedIndex].deviceName) {
          this.startAbility(this.remoteDeviceModel.deviceList[i].deviceId)
        }
      }
    })
    Logger.info(TAG, 'start ability2 ......')
    this.clearSelectState()
  }

  handleSelectDevice = (index) => {
    Logger.info(TAG, 'selectedIndexChange')
    this.selectedIndex = index
    if (this.selectedIndex === 0) {
      Logger.info(TAG, "stop ability")
      this.dialogController.close()
      this.startAbilityCallBack(EXIT)
      this.isDistributed = false
      this.deviceList = []
      this.dialogShow = false
      return
    }
    this.selectDevice()
  }

  startAbility(deviceId) {
    Logger.info(TAG, `startAbility deviceId:${deviceId}`)
    let context = getContext(this) as common.UIAbilityContext
    context.startAbility({
      bundleName: 'ohos.samples.kvstore',
      abilityName: 'EntryAbility',
      deviceId: deviceId,
      parameters: {
        isStage: 'Stage'
      }
    }).then((data) => {
      Logger.info(TAG, `start ability finished:${JSON.stringify(data)}`)
    })
    setTimeout(() => {
      this.startAbilityCallBack(NOTES_CHANGE)
    }, 1000)
  }

  showDialog() {
    this.dialogShow = true
    this.remoteDeviceModel.registerDeviceListCallback(() => {
      this.deviceList = []
      Logger.info(TAG, 'registerDeviceListCallback, callback entered')
      this.deviceList.push({
        deviceId: '0',
        deviceName: 'Local device',
        deviceType: 0,
        checked: false
      })
      var deviceTempList = this.remoteDeviceModel.discoverList.length > 0 ? this.remoteDeviceModel.discoverList : this.remoteDeviceModel.deviceList;
      for (var i = 0; i < deviceTempList.length; i++) {
        Logger.info(TAG, `device ${i}/${deviceTempList.length} deviceId=${deviceTempList[i].deviceId} deviceName=${deviceTempList[i].deviceName} deviceType=${deviceTempList[i].deviceType}`)
        this.deviceList.push({
          deviceId: deviceTempList[i].deviceId,
          deviceName: deviceTempList[i].deviceName,
          deviceType: deviceTempList[i].deviceType,
          checked: (this.selectedIndex === i)
        })
      }
      if (this.dialogShow) {
        this.dialogController.close()
        this.dialogController = new CustomDialogController({
          builder: DeviceDialog({
            deviceList: this.deviceList,
            selectedIndex: this.selectedIndex,
            handleSelectDevice: this.handleSelectDevice
          }),
          autoCancel: true
        })
        this.dialogController.open()
      }
    })
    if (this.dialogController === null) {
      this.dialogController = new CustomDialogController({
        builder: DeviceDialog({
          deviceList: this.deviceList,
          selectedIndex: this.selectedIndex,
          handleSelectDevice: this.handleSelectDevice
        }),
        autoCancel: true
      })
      this.dialogController.open()
    }
  }

  build() {
    Row() {
      Text($r("app.string.title"))
        .width('82%')
        .fontColor(Color.White)
        .fontSize(20)
      Blank()
      Button() {
        Image($r('app.media.ic_hop_normal'))
          .width(70).height(40)
          .objectFit(ImageFit.Contain)
      }
      .key('rightBtn')
      .type(ButtonType.Normal)
      .backgroundColor($r('app.color.title_btn_background'))
      .onClick(() => {
        Logger.info(TAG, 'showDialog start')
        this.showDialog()
      })
    }
    .height('8%')
    .width('100%')
    .constraintSize({ minHeight: 70 })
    .backgroundColor($r('app.color.title_background'))
    .padding({ left: 15, right: 15 })
  }
}