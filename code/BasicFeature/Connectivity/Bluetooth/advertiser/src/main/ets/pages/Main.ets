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

import advertiserBluetoothViewModel from '../viewmodel/AdvertiserBluetoothViewModel'
import Log from '../utils/Log'
import MathUtils from '../utils/MathUtils'

const TAG = '[Sample_Main]'

@Entry
@Component
struct Main {
  @StorageLink('deviceId') @Watch('onDeviceIdChange') deviceId: string = ''
  @StorageLink('bluetoothEnable') @Watch('onBluetoothEnableChange') bluetoothEnable: boolean = false
  @State localName: string = ''
  @State heartRate: number = -1
  @State startAdvertiserState: boolean = false
  private mIntervalId: number

  onDeviceIdChange() {
    Log.showInfo(TAG, `onDeviceIdChange: deviceId = ${this.deviceId}`)
  }

  onBluetoothEnableChange() {
    Log.showInfo(TAG, `onBluetoothEnableChange: bluetoothEnable = ${this.bluetoothEnable}`)
    if (this.bluetoothEnable) {
      this.toggleAdvertiser()
    }
  }

  toggleAdvertiser() {
    Log.showInfo(TAG, `toggleAdvertiser: startAdvertiserState = ${this.startAdvertiserState}`)
    if (this.startAdvertiserState) {
      advertiserBluetoothViewModel.stopAdvertiser()
      this.toggleHeartRate(false)
      this.startAdvertiserState = false
    } else {
      let ret = advertiserBluetoothViewModel.startAdvertiser()
      if (ret) {
        this.localName = advertiserBluetoothViewModel.getLocalName()
        this.toggleHeartRate(true)
        this.startAdvertiserState = true
      } else {
        Log.showError(TAG, `toggleAdvertiser: ret = ${ret}`)
      }
    }
  }

  toggleHeartRate(open: boolean) {
    Log.showInfo(TAG, `toggleHeartRate: open = ${open}, deviceId = ${this.deviceId}`)

    clearInterval(this.mIntervalId)

    if (open) {
      this.mIntervalId = setInterval(() => {
        this.heartRate = MathUtils.getRandomInt(40, 200)
        if (this.deviceId) {
          advertiserBluetoothViewModel.notifyCharacteristicChanged(this.deviceId, this.heartRate)
        } else {
          Log.showWarn(TAG, `toggleHeartRate: deviceId is null`)
        }
      }, 1000)
    }
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`)
    advertiserBluetoothViewModel.stopAdvertiser()
  }

  build() {
    Column() {
      Row() {
        Button(this.startAdvertiserState ? $r('app.string.btn_stop_advertiser') : $r('app.string.btn_start_advertiser'))
          .onClick(() => {
            this.toggleAdvertiser()
          })
      }
      .justifyContent(FlexAlign.SpaceAround)

      Text($r('app.string.text_bluetooth_name', this.localName === '' ? '-' : this.localName))
        .fontSize(32)
        .fontWeight(FontWeight.Bold)

      Text($r('app.string.text_heart_rate_current', this.heartRate === -1 ? '-' : this.heartRate.toString()))
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.SpaceAround)
  }
}