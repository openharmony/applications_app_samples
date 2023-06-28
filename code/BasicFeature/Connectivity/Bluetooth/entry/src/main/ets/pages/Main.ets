/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import router from '@ohos.router'
import window from '@ohos.window'
import promptAction from '@ohos.promptAction'
import NavigationBar from '../uicomponents/NavigationBar'
import EmptyPage from '../uicomponents/EmptyPage'
import bluetoothViewModel, { ConnectionState } from '../viewmodel/BluetoothViewModel'
import BluetoothDevice from '../model/BluetoothDevice'
import StyleConstants from '../constants/StyleConstants'
import Log from '../utils/Log'

const TAG = '[Sample_Main]'

@Entry
@Component
struct Main {
  @StorageLink('availableDevices') @Watch('onAvailableDevicesChange') availableDevices: Array<BluetoothDevice> = []
  @StorageLink('connectBluetoothDevice') @Watch('onConnectBluetoothDeviceChange') connectBluetoothDevice: BluetoothDevice = {
  }
  @State connectBluetoothDevice1: BluetoothDevice = {}

  onAvailableDevicesChange() {
    Log.showInfo(TAG, `onAvailableDevicesChange: availableDevices = ${JSON.stringify(this.availableDevices)}`)
  }

  onConnectBluetoothDeviceChange() {
    Log.showInfo(TAG, `onConnectBluetoothDeviceChange: connectBluetoothDevice = ${JSON.stringify(this.connectBluetoothDevice)}`)
    this.connectBluetoothDevice1 = this.connectBluetoothDevice
  }

  async onPageShow() {
    Log.showInfo(TAG, `onPageShow`)
    await globalThis.setOrientation(window.Orientation.AUTO_ROTATION_LANDSCAPE)
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`)
    bluetoothViewModel.close()
  }

  build() {
    Column() {
      NavigationBar({ title: $r('app.string.title_main'), showIndicator: false })
        .height(StyleConstants.HEIGHT_NAVIGATION_BAR)

      if (this.availableDevices && this.availableDevices.length > 0) {
        List({ space: 20, initialIndex: 0 }) {
          ForEach(this.availableDevices, (item: BluetoothDevice, index: number) => {
            ListItem() {
              if (item.deviceId === this.connectBluetoothDevice1.deviceId) {
                Item({
                  bluetoothDevice: this.connectBluetoothDevice1,
                  index: index
                })
              } else {
                Item({
                  bluetoothDevice: item,
                  index: index
                })
              }
            }
            .width('100%')
            .height(76)
            .borderRadius(16)
            .backgroundColor($r('app.color.bg_white'))
          }, item => item)
        }
        .scrollBar(BarState.Auto)
        .width('100%')
        .height('100%')
        .layoutWeight(1)
        .padding({ left: 16, top: 16, right: 16, bottom: 0 })
      } else {
        EmptyPage({ img: $r('app.media.bg_empty_page'), message: $r('app.string.tv_no_device') })
          .width('100%')
          .height('100%')
          .layoutWeight(1)
      }

      Row() {
        Button($r('app.string.btn_start_scan_be'))
          .id('btn_start_scan')
          .fontSize($r('app.float.text_size_medium'))
          .onClick(() => {
            let ret = bluetoothViewModel.startBLEScan()
            if (!ret) {
              Log.showError(TAG, `startBLEScan: ret = ${ret}`)
            }
          })
          .width(180)
      }
      .width('100%')
      .height(40)
      .margin({ bottom: 24 })
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_main'))
  }
}

@Component
struct Item {
  @ObjectLink bluetoothDevice: BluetoothDevice
  private index: number

  getConnectionStateDescription(): ResourceStr {
    let description = $r('app.string.btn_connect')
    switch (this.bluetoothDevice.connectionState) {
      case ConnectionState.STATE_CONNECTING:
        description = $r('app.string.btn_connecting')
        break
      case ConnectionState.STATE_DISCONNECTING:
        description = $r('app.string.btn_disconnecting')
        break
      case ConnectionState.STATE_DISCONNECTED:
        description = $r('app.string.btn_connect')
        break
    }
    return description
  }

  async aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear: bluetoothDevice = ${JSON.stringify(this.bluetoothDevice)}`)
    await globalThis.setOrientation(window.Orientation.AUTO_ROTATION_LANDSCAPE)
  }

  build() {
    Row() {
      Column() {
        Text(this.bluetoothDevice.deviceName)
          .fontSize($r('app.float.text_size_big'))
          .fontColor($r('app.color.text_color_primary'))
        Text(this.bluetoothDevice.deviceId)
          .fontSize($r('app.float.text_size_normal'))
          .fontColor($r('app.color.text_color_tertiary'))
          .margin({ top: 8 })
      }
      .margin({ left: 16 })
      .alignItems(HorizontalAlign.Start)

      Button(this.getConnectionStateDescription())
        .id(`btn_connect${this.index}`)
        .fontSize($r('app.float.text_size_medium'))
        .fontColor($r('app.color.color_accent'))
        .backgroundColor(this.bluetoothDevice.connectionState === ConnectionState.STATE_CONNECTED ? $r('app.color.bg_transparent') : $r('app.color.btn_grey'))
        .padding({ left: 20, right: 20 })
        .margin({ right: 16 })
        .visibility(this.bluetoothDevice.connectionState === ConnectionState.STATE_CONNECTED ? Visibility.None : Visibility.Visible)
        .onClick(() => {
          if (this.bluetoothDevice.connectionState === ConnectionState.STATE_DISCONNECTED) {
            let ret: boolean = bluetoothViewModel.connect(this.bluetoothDevice)
            if (ret) {
              promptAction.showToast({ message: $r('app.string.toast_connecting'), duration: 2000 })
            }
          } else if (this.bluetoothDevice.connectionState === ConnectionState.STATE_CONNECTED) {
            bluetoothViewModel.disconnect()
          }
        })

      Row() {
        Text($r('app.string.btn_connected'))
          .fontSize($r('app.float.text_size_medium'))
          .fontColor($r('app.color.text_color_tertiary'))
          .margin({ right: 8 })

        Image($r('app.media.ic_public_arrow_right'))
          .objectFit(ImageFit.Contain)
          .width(24)
          .height(24)
      }
      .margin({ right: 16 })
      .visibility(this.bluetoothDevice.connectionState === ConnectionState.STATE_CONNECTED ? Visibility.Visible : Visibility.None)
    }
    .id(`list_item${this.index}`)
    .width('100%')
    .height('100%')
    .padding({ left: 12, top: 4, right: 12, bottom: 4 })
    .justifyContent(FlexAlign.SpaceBetween)
    .onClick(async () => {
      if (this.bluetoothDevice.connectionState === ConnectionState.STATE_CONNECTED) {
        await router.pushUrl({ url: 'pages/HeartRate' })
      }
    })
  }
}