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
const DEVICE_DISCOVERY_RANGE: number = 1000

@Component
export struct TitleBar {
  private selectedIndex: number = 0
  private startAbilityCallBack: (key: string) => void = (key: string) => {};
  private remoteDeviceModel: RemoteDeviceModel | null = null;
  private dialogController: CustomDialogController | null = null;
  @State deviceList: Array<DeviceDataModel> = []
  @Link isDistributed: boolean
  @State dialogShow: boolean = false

  clearSelectState() {
    this.deviceList = []
    this.dialogShow = false
    this.dialogController!.close();
  }

  selectDevice() {
    Logger.info(TAG, 'start ability ......')
    this.isDistributed = true
    if (this.remoteDeviceModel === null || this.remoteDeviceModel.discoverList.length <= 0) {
      Logger.info(TAG, `continue unauthed device:${JSON.stringify(this.deviceList)}`)
      this.startAbility(this.deviceList[this.selectedIndex].networkId)
      this.clearSelectState()
      return
    }
    Logger.info(TAG, 'start ability1, needAuth：')
    this.remoteDeviceModel.authenticateDevice(this.deviceList[this.selectedIndex], () => {
      Logger.info(TAG, "auth and online finished")
      for (let i = 0; i < this.remoteDeviceModel!.deviceList.length; i++) {
        if (this.remoteDeviceModel!.deviceList[i].deviceName === this.deviceList[this.selectedIndex].deviceName) {
          this.startAbility(this.remoteDeviceModel!.deviceList[i].networkId as string);
        }
      }
    })
    Logger.info(TAG, 'start ability2 ......')
    this.clearSelectState()
  }

  handleSelectDevice = (index: number) => {
    Logger.info(TAG, 'selectedIndexChange')
    this.selectedIndex = index
    if (this.selectedIndex === 0) {
      Logger.info(TAG, "stop ability")
      this.dialogController!.close();
      this.startAbilityCallBack(EXIT)
      this.isDistributed = false
      this.deviceList = []
      this.dialogShow = false
      return
    }
    this.selectDevice()
  }

  startAbility(deviceId: string) {
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
    this.remoteDeviceModel!.registerDeviceListCallback(() => {
      this.deviceList = []
      Logger.info(TAG, 'registerDeviceListCallback, callback entered')
      this.deviceList.push(new DeviceDataModel('0', 'Local device', '0', false, '', DEVICE_DISCOVERY_RANGE));
      let deviceTempList = this.remoteDeviceModel!.discoverList.length > 0 ? this.remoteDeviceModel!.discoverList : this.remoteDeviceModel!.deviceList;
      for (let i = 0; i < deviceTempList.length; i++) {
        Logger.info(TAG, `device ${i}/${deviceTempList.length} deviceId=${deviceTempList[i].deviceId} deviceName=${deviceTempList[i].deviceName} deviceType=${deviceTempList[i].deviceType}`)
        this.deviceList.push(new DeviceDataModel(deviceTempList[i].deviceId, deviceTempList[i].deviceName, deviceTempList[i].deviceType, (this.selectedIndex === i), deviceTempList[i].networkId as string, DEVICE_DISCOVERY_RANGE));
      }
      if (this.dialogShow) {
        this.dialogController!.close();
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
      .id('rightBtn')
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