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
import display from '@ohos.display'
import window from '@ohos.window'
import bluetoothViewModel from '../viewmodel/BluetoothViewModel'
import NavigationBar from '../uicomponents/NavigationBar'
import HeartRateGraph from '../uicomponents/HeartRateGraph'
import StyleConstants from '../constants/StyleConstants'
import Log from '../utils/Log'

const TAG = '[Sample_HeartRate]'

const HEIGHT_NAVIGATION_BAR = StyleConstants.HEIGHT_NAVIGATION_BAR
const HEIGHT_TOP_ROW = 40
const MARGIN_HORIZONTAL = 60
const HEART_RATE_TOO_LOW = 50
const HEART_RATE_TOO_HIGH = 100

@Entry
@Component
struct HeartRate {
  @StorageLink('heartRate') @Watch('onHeartRate') heartRate: number = 0
  @StorageLink('windowSize') @Watch('onWindowSizeChange') windowSize: window.Size = {
    width: display.getDefaultDisplaySync().width,
    height: display.getDefaultDisplaySync().height
  }
  @State heartRateTop: number = 0
  @State heartRateBottom: number = 0
  @State heartRateAverage: number = 0
  @State graphWidth: number = this.windowSize.width - vp2px(MARGIN_HORIZONTAL) * 2
  @State graphHeight: number = this.windowSize.height - vp2px(HEIGHT_NAVIGATION_BAR) - vp2px(HEIGHT_TOP_ROW)

  onHeartRate() {
    Log.showInfo(TAG, `onHeartRate: heartRate = ${this.heartRate}`)
    this.heartRateTop = this.heartRateTop < this.heartRate ? this.heartRate : this.heartRateTop
    this.heartRateBottom = this.heartRateBottom === 0 ? this.heartRate : this.heartRateBottom > this.heartRate ? this.heartRate : this.heartRateBottom
    this.heartRateAverage = (this.heartRateAverage + this.heartRate) / 2
  }

  onWindowSizeChange() {
    Log.showInfo(TAG, `onWindowSizeChange: windowSize = ${JSON.stringify(this.windowSize)}`)
    this.graphWidth = this.windowSize.width - vp2px(MARGIN_HORIZONTAL) * 2
    this.graphHeight = this.windowSize.height - vp2px(HEIGHT_NAVIGATION_BAR) - vp2px(HEIGHT_TOP_ROW)
  }

  showWarningReminder(): boolean {
    return this.tooHigh() || this.tooLow()
  }

  tooHigh(): boolean {
    return this.heartRate > HEART_RATE_TOO_HIGH
  }

  tooLow(): boolean {
    return this.heartRate < HEART_RATE_TOO_LOW
  }

  warningReminderIcon(): Resource {
    if (this.tooHigh()) {
      return $r('app.media.ic_red_arrow_up')
    }
    if (this.tooLow()) {
      return $r('app.media.ic_red_arrow_down')
    }
    return null
  }

  async aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear`)
    await globalThis.setOrientation(window.Orientation.AUTO_ROTATION_LANDSCAPE)
  }

  build() {
    Column() {
      NavigationBar({ title: $r('app.string.title_heart_rate'), actions: [{
        id: 'btn_disconnect',
        name: $r('app.string.btn_disconnect'),
        event: () => {
          bluetoothViewModel.disconnect()
          router.back()
        }
      }] })
        .height(HEIGHT_NAVIGATION_BAR)

      Row() {
        Text($r('app.string.tv_heart_rate_top_and_bottom', this.heartRateTop, this.heartRateBottom))
          .fontColor($r('app.color.text_color_primary'))
          .fontSize($r('app.float.text_size_medium'))

        Row() {
          Text($r('app.string.tv_heart_rate_average_current', this.heartRateAverage, this.heartRate))
            .fontColor($r('app.color.text_color_primary'))
            .fontSize($r('app.float.text_size_medium'))

          Image(this.warningReminderIcon())
            .width(16)
            .aspectRatio(1)
            .margin({ left: 8 })
            .visibility(this.showWarningReminder() ? Visibility.Visible : Visibility.Hidden)
        }
      }
      .width('100%')
      .height(HEIGHT_TOP_ROW)
      .padding({ left: MARGIN_HORIZONTAL, right: MARGIN_HORIZONTAL })
      .justifyContent(FlexAlign.SpaceBetween)

      HeartRateGraph({
        viewWidth: px2vp(this.graphWidth),
        viewHeight: px2vp(this.graphHeight)
      })
    }
    .backgroundColor($r('app.color.bg_white'))
  }
}