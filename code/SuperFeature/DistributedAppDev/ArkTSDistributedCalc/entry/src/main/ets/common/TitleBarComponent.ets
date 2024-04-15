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
import deviceManager from '@ohos.distributedDeviceManager';
import Logger from '../model/Logger'
import { DeviceDialog } from '../common/DeviceDialog'
import { RemoteDeviceModel, BUNDLE_NAME } from '../model/RemoteDeviceModel'
import common from '@ohos.app.ability.common'
import Want from '@ohos.app.ability.Want';

const TAG: string = 'TitleBar'
const DATA_CHANGE: string = 'dataChange'
const EXIT: string = 'exit'
const DEVICE_DISCOVERY_RANGE: number = 1000

@Component
export struct TitleBarComponent {
  @Prop isLand: boolean | null = null
  @State selectedIndex: number | undefined = 0
  @StorageLink('deviceList') deviceList: Array<deviceManager.DeviceBasicInfo> = []
  @Link isDistributed: boolean
  private isShow: boolean = false
  private startAbilityCallBack: (key: string) => void = () => {
  }
  private dialogController: CustomDialogController | null = null
  private remoteDeviceModel: RemoteDeviceModel = new RemoteDeviceModel()
  onSelectedIndexChange = async (index: number | undefined) => {
    Logger.info(TAG, `selectedIndexChange`)
    this.selectedIndex = index
    if (this.selectedIndex === 0) {
      Logger.info(TAG, `stop ability`)
      await this.startAbilityCallBack(EXIT)
      this.isDistributed = false
      this.deviceList = []
      if (this.dialogController !== null) {
        this.dialogController.close()
      }
      return
    }
    this.selectDevice()
  }

  aboutToAppear() {
    AppStorage.setOrCreate('deviceList', this.deviceList)
  }

  clearSelectState() {
    this.deviceList = []
    if (this.dialogController !== null) {
      this.dialogController.close()
    }
    Logger.info(TAG, `cancelDialog`)
    if (this.remoteDeviceModel === undefined) {
      return
    }
    this.remoteDeviceModel.unregisterDeviceListCallback()
  }

  selectDevice() {
    Logger.info(TAG, `start ability ......`)
    this.isDistributed = true
    if (this.selectedIndex !== undefined && (this.remoteDeviceModel === null || this.remoteDeviceModel.discoverList.length <= 0)) {
      Logger.info(TAG, `continue unauthed device: ${JSON.stringify(this.deviceList)}`)
      this.startAbility(this.deviceList[this.selectedIndex].networkId)
      this.clearSelectState()
      return
    }
    Logger.info(TAG, `start ability1, needAuth：`)
    if (this.selectedIndex !== undefined) {
      this.remoteDeviceModel.authenticateDevice(this.deviceList[this.selectedIndex], () => {
        Logger.info(TAG, `auth and online finished`);
        if (this.remoteDeviceModel !== null && this.remoteDeviceModel.deviceList !== null && this.selectedIndex !== undefined) {
          for (let i = 0; i < this.remoteDeviceModel.deviceList!.length; i++) {
            if (this.remoteDeviceModel.deviceList![i].deviceName === this.deviceList[this.selectedIndex].deviceName) {
              this.startAbility(this.remoteDeviceModel.deviceList![i].networkId);
            }
          }
        }
      })
    }
    Logger.info(TAG, `start ability2 ......`)
    this.clearSelectState()
  }

  async startAbility(deviceId: string | undefined) {
    Logger.debug(TAG, `startAbility deviceId: ${deviceId}`)
    let context = getContext(this) as common.UIAbilityContext
    let want: Want = {
      bundleName: BUNDLE_NAME,
      abilityName: 'MainAbility',
      deviceId: deviceId,
      parameters: {
        isRemote: 'isRemote'
      }
    }
    context.startAbility(want).then((data) => {
      Logger.info(TAG, `start ability finished: ${JSON.stringify(data)}`)
      this.startAbilityCallBack(DATA_CHANGE)
    })
  }

  showDiainfo() {
    this.deviceList = []
    // 注册监听回调，发现设备或查找到已认证设备会弹窗显示
    this.remoteDeviceModel.registerDeviceListCallback(() => {
      this.deviceList = []
      Logger.info(TAG, `registerDeviceListCallback, callback entered`)
      let context: common.UIAbilityContext | undefined = AppStorage.get('UIAbilityContext')
      if (context !== undefined) {
        this.deviceList.push({
          deviceId: '0',
          deviceName: context.resourceManager.getStringSync($r('app.string.localhost').id),
          deviceType: '0',
          networkId: ''
        })
      }
      let deviceTempList = this.remoteDeviceModel.discoverList.length > 0 ? this.remoteDeviceModel.discoverList : this.remoteDeviceModel.deviceList;
      if (deviceTempList !== null) {
        for (let i = 0; i < deviceTempList!.length; i++) {
          Logger.debug(TAG, `device ${i}/${deviceTempList!.length} deviceId= ${deviceTempList![i].deviceId},
        deviceName= ${deviceTempList![i].deviceName}, deviceType= ${deviceTempList![i].deviceType}`);
          if (deviceTempList !== null) {
            this.deviceList.push({
              deviceId: deviceTempList![i].deviceId,
              deviceName: deviceTempList![i].deviceName,
              deviceType: deviceTempList![i].deviceType,
              networkId: deviceTempList![i].networkId,
            })
            AppStorage.set('deviceList', this.deviceList)
          }
        }
      }
    })
    if (this.dialogController === null) {
      this.dialogController = new CustomDialogController({
        builder: DeviceDialog({
          selectedIndex: this.selectedIndex,
          onSelectedIndexChange: this.onSelectedIndexChange
        }),
        cancel: () => {
          this.clearSelectState()
        },
        autoCancel: true,
        alignment: this.isLand ? DialogAlignment.Center : DialogAlignment.Bottom,
        customStyle: false
      })
    }
    if (this.dialogController !== null) {
      this.dialogController.open()
    }
  }

  build() {
    Row() {
      Image($r('app.media.ic_back'))
        .height('60%')
        .margin({ left: '5%' })
        .width('50px')
        .objectFit(ImageFit.Contain)
        .onClick(async () => {
          let context = getContext(this) as common.UIAbilityContext
          context.terminateSelf()
        })
      Text($r('app.string.distributed_calculator'))
        .height('60%')
        .fontSize('28px')
        .margin({ left: 12 })
      Blank().layoutWeight(1)
      if (!this.isShow) {
        Image($r("app.media.ic_hop_normal1"))
          .id('selectDevice')
          .margin({ right: 32 })
          .width('9%')
          .margin({ right: '12%' })
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.showDiainfo()
          })
      }
    }
    .width('100%')
    .height(this.isLand ? '10%' : '6%')
    .constraintSize({ minHeight: 50 })
    .alignItems(VerticalAlign.Center)
  }
}