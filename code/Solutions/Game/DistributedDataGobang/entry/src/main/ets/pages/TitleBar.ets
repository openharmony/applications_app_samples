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

import deviceManager from '@ohos.distributedHardware.deviceManager'
import Logger from '../util/Logger'
import { GobangConst } from '../util/GobangConst'
import { RemoteDeviceModel } from '../Model/RemoteDeviceModel'
import { DeviceDialog } from './DeviceDialog'

const TAG: string = 'TitleBar'

@Component
export struct TitleBar {
  @State @Watch('selectedIndexChange') selectedIndex: number = 0
  @State devices: Array<deviceManager.DeviceInfo> = []
  @Link isDistributed: boolean
  @Link dialogShow: boolean
  @StorageLink('deviceFlag') deviceFlag: string = 'A'
  private startAbilityCallBack: (key: string) => void
  private remoteDeviceModel: RemoteDeviceModel | null = null
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: DeviceDialog({ deviceList: this.devices, selectedIndex: $selectedIndex }),
    autoCancel: true,
    alignment: DialogAlignment.Center
  })

  clearSelectState() {
    this.devices = []
    this.dialogShow = false
    this.dialogController.close()
  }

  selectDevice() {
    Logger.info(TAG, `start ability`)
    this.isDistributed = true
    if (this.remoteDeviceModel === null || this.remoteDeviceModel.discoverList.length <= 0) {
      Logger.info(TAG, `continue unauthed device: ${JSON.stringify(this.devices)}`)
      this.startAbility(this.devices[this.selectedIndex].deviceId)
      this.clearSelectState()
      return
    }
    Logger.info(TAG, `start ability, needAuth`)
    this.remoteDeviceModel.authenticateDevice(this.devices[this.selectedIndex], () => {
      Logger.info(TAG, `auth and online finished`)
      for (let i = 0; i < this.remoteDeviceModel.deviceList.length; i++) {
        if (this.remoteDeviceModel.deviceList[i].deviceName === this.devices[this.selectedIndex].deviceName) {
          this.startAbility(this.remoteDeviceModel.deviceList[i].deviceId)
        }
      }
    })
    this.clearSelectState()
  }

  selectedIndexChange() {
    Logger.info(TAG, `selectedIndexChange`)
    if (this.selectedIndex === 0) {
      Logger.info(TAG, `stop ability`)
      this.startAbilityCallBack(GobangConst.EXIT)
      this.isDistributed = false
      this.devices = []
      this.dialogController.close()
      this.dialogShow = false
      return
    }
    this.selectDevice()
  }

  startAbility(deviceId) {
    Logger.info(TAG, `startAbility deviceId: ${deviceId}`)
    let context = getContext(this) as any
    context.startAbility({
      bundleName: 'ohos.samples.distributeddatagobang',
      abilityName: 'MainAbility',
      deviceId: deviceId,
      parameters: {
        isB: 'B'
      }
    }).then((data) => {
      Logger.info(TAG, `start ability finished: ${JSON.stringify(data)}`)
      this.startAbilityCallBack(GobangConst.DEVICE_A)
    })
  }

  showDialog() {
    this.dialogShow = true
    this.devices = []
    this.remoteDeviceModel.registerDeviceListCallback(() => {
      Logger.info(TAG, `registerDeviceListCallback, callback entered`)
      this.devices.push({
        deviceId: '0',
        deviceName: 'Local device',
        deviceType: GobangConst.DEVICE_TYPE_NUMBER,
        networkId: '',
        range: GobangConst.RANGE_NUMBER,
        authForm: 2
      })
      let deviceTemps = this.remoteDeviceModel.discoverList.length > 0 ? this.remoteDeviceModel.discoverList : this.remoteDeviceModel.deviceList
      for (let i = 0; i < deviceTemps.length; i++) {
        this.devices.push(deviceTemps[i])
      }
    })
    this.dialogController.open()
  }

  build() {
    Row() {
      Image($r('app.media.ic_back'))
        .width(40)
        .height(30)
        .margin({ left: 15 })
        .objectFit(ImageFit.Contain)
        .onClick(() => {
          let context = getContext(this) as any
          context.terminateSelf()
        })
      Blank()
        .layoutWeight(1)
      if (this.deviceFlag === 'A') {
        Image($r('app.media.ic_hop'))
          .width(40)
          .height(40)
          .margin({ right: 15 })
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.showDialog()
          })
      }
    }
    .width('100%')
    .height(50)
    .constraintSize({ minHeight: 50 })
    .alignItems(VerticalAlign.Center)
    .position({ x: 0, y: 0 })
  }
}
