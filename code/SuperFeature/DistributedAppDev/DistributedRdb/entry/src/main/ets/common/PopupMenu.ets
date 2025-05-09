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

import deviceManager from '@ohos.distributedDeviceManager';
import common from '@ohos.app.ability.common'
import router from '@ohos.router'
import Logger from '../model/Logger'
import RemoteDeviceModel from '../model/RemoteDeviceModel'
import { BUNDLE, ABILITY } from '../model/RdbConst'
import { DeviceDialog } from '../common/DeviceDialog'
import { stateType } from '../pages/Index';

const TAG: string = 'PopupMenu'


interface menuResourceItem {
  text: Resource,
  icon: Resource
}
@Component
export struct PopupMenu {
  private menuResource: Array<menuResourceItem> = [
    { icon: $r('app.media.setting'), text: $r('app.string.setting') },
    { icon: $r('app.media.connect'), text: $r('app.string.connect') }]
  private handleStartAbility: () => void = () => {};
  private deviceList: Array<deviceManager.DeviceBasicInfo> = [];
  private dialogController: CustomDialogController | null = null;
  @Link state: stateType;

  selectDevice() {
    Logger.info(TAG, 'start ability ......')
    if (RemoteDeviceModel === null || RemoteDeviceModel.discoverList.length <= 0) {
      Logger.info(TAG, `start ability device:${JSON.stringify(this.deviceList)}`)
      if (this.deviceList[this.state.selectedIndex].networkId != undefined) {
        this.startAbility(this.deviceList[this.state.selectedIndex].networkId as string)
        this.clearSelectState()
      }
      return
    }
    Logger.info(TAG, 'start ability, needAuth')
    RemoteDeviceModel.authenticateDevice(this.deviceList[this.state.selectedIndex], (device: deviceManager.DeviceBasicInfo) => {
      Logger.info(TAG, 'auth and online finished')
      if (device.networkId != undefined) {
        this.startAbility(device.networkId)
      }
    })
    Logger.info(TAG, 'start ability2 ......')
    this.clearSelectState()
    this.state.popupMenu = false;
    this.state.opacityValue = 1;
  }

  onSelectedIndexChange = (selectedIndex: number) => {
    Logger.info(TAG, `selectedIndexChange,selectedIndex=${selectedIndex}`)
    if (selectedIndex === 0) {
      Logger.info(TAG, 'stop sync')
      let context = getContext(this) as common.UIAbilityContext
      context.startAbility({
        bundleName: BUNDLE,
        abilityName: ABILITY,
        deviceId: this.deviceList[this.state.selectedIndex].deviceId,
        parameters: {
          isStage: 'EXIT'
        }
      })
      this.state.isDistributed = false
      this.state.selectedIndex = 0
      this.state.distributedDevice = ''
      if(this.dialogController != undefined) {
        this.dialogController.close()
      }
      this.deviceList = []
      return
    }
    this.state.selectedIndex = selectedIndex
    this.selectDevice()
  }

  async startAbility(deviceId: string) {
    Logger.info(TAG, `startAbility deviceId:${deviceId}`)
    let localDevice = RemoteDeviceModel.getLocalDevice()
    Logger.info(TAG, `startAbility localDevice:${localDevice}`)
    let context = getContext(this) as common.UIAbilityContext
    await context.startAbility({
      bundleName: BUNDLE,
      abilityName: ABILITY,
      deviceId: deviceId,
      parameters: {
        isStage: 'Stage',
        dmsSrcNetworkId: localDevice
      }
    })
    setTimeout(() => {
      this.state.isDistributed = true
      this.state.distributedDevice = deviceId
      this.handleStartAbility()
    }, 1500)
  }

  showDialog() {
    RemoteDeviceModel.registerDeviceListCallback(() => {
      Logger.info(TAG, 'registerDeviceListCallback, callback entered' + JSON.stringify(RemoteDeviceModel.discoverList));
      this.deviceList = []
      this.deviceList.push({
        deviceId: '0',
        deviceName: 'Local device',
        deviceType: '0',
        networkId: '0'
      })
      let deviceTempList = RemoteDeviceModel.discoverList.length > 0 ? RemoteDeviceModel.discoverList : RemoteDeviceModel.deviceList
      for (let i = 0; i < deviceTempList.length; i++) {
        Logger.info(TAG, `device[${i}]=${JSON.stringify(deviceTempList[i])}`)
        this.deviceList.push(deviceTempList[i])
      }

      if (this.dialogController !== null) {
        this.dialogController.close()
        this.dialogController = null
      }
      this.dialogController = new CustomDialogController({
        builder: DeviceDialog({
          deviceList: this.deviceList,
          selectedIndex: this.state.selectedIndex,
          onSelectedIndexChange: this.onSelectedIndexChange
        }),
        autoCancel: true
      })
      this.dialogController.open()
    })
  }

  clearSelectState() {
    this.deviceList = []
    if (this.dialogController !== null) {
      this.dialogController.close()
      this.dialogController = null
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Column() {
        ForEach(this.menuResource, (item: menuResourceItem, index: number) => {
          Row() {
            Image(item.icon)
              .size({ width: 40, height: 40 })
              .objectFit(ImageFit.Contain)

            Text(item.text)
              .fontSize(20)
              .fontColor(Color.Black)
              .margin({ left: 10 })
          }
          .width('100%')
          .margin({ top: 6, bottom: 6 })
          .onClick(() => {
            if (index === 0) {
              this.state.popupMenu = false;
              router.pushUrl({
                url: 'pages/Settings'
              })
            } else {
              this.state.opacityValue = 0;
              this.showDialog()
            }
          })

          if (index === 0) {
            Divider().color(Color.Black).height(1)
          }
        }, (item: menuResourceItem) => JSON.stringify(item))
      }
      .width('40%')
      .border({ width: 1, color: Color.Black, radius: 10 })
      .margin({ right: 16 })
      .backgroundColor(Color.White)
      .padding(6)
      .opacity(this.state.opacityValue)
    }
    .size({ width: '100%', height: '92%' })
    .margin({ right: 16 })
    .onClick(() => {
      if (this.state.popupMenu) {
        this.state.popupMenu = false
      }
    })
  }
}