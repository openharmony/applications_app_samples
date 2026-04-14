/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
 

import { emitter } from '@kit.BasicServicesKit';
import BrightnessModel from '../controlPanelModel/BrightnessModel'
import { BrightnessComponent } from './BrightnessComponent'

@CustomDialog
@Component
export struct BrightnessDialog {
  controller: CustomDialogController
  @Link isShowBrightness: boolean // 亮度条是否显示
  @State brightnessDialogTimer: number | null = null //亮度定时器
  @State brightValue: number = 100 // 亮度条的值

  async aboutToAppear() {
    const value = await BrightnessModel.getOutputBrightness()
    if (value !== undefined) {
      this.brightValue = value
    }

    if (this.brightnessDialogTimer) {
      clearTimeout(this.brightnessDialogTimer)
    }
    // 亮度条展示三秒钟后发通知关闭亮度调
    this.brightnessDialogTimer = setTimeout(() => {
      emitter.emit('BRIGHTNESS_DIALOG_TIMER_EVENT')
    }, 3000)
  }

  aboutToDisappear(): void {
    clearTimeout(this.brightnessDialogTimer)
  }

  // 向下绑定事件
  downEvent() {
    if (this.brightValue <= 0) {
      this.brightValue = 0
    } else {
      this.brightValue--
    }
    // 设置屏幕亮度
    BrightnessModel.setOutputBrightness(this.brightValue)

    if (this.brightnessDialogTimer) {
      clearTimeout(this.brightnessDialogTimer)
    }
    this.brightnessDialogTimer = setTimeout(() => {
      emitter.emit('BRIGHTNESS_DIALOG_TIMER_EVENT')
    }, 3000)
  }

  // 向上绑定事件
  upEvent() {
    if (this.brightValue >= 100) {
      this.brightValue = 100
    } else {
      this.brightValue++
    }
    // 设置屏幕亮度
    BrightnessModel.setOutputBrightness(this.brightValue)

    if (this.brightnessDialogTimer) {
      clearTimeout(this.brightnessDialogTimer)
    }
    this.brightnessDialogTimer = setTimeout(() => {
      emitter.emit('BRIGHTNESS_DIALOG_TIMER_EVENT')
    }, 3000)
  }

  // 接收子元素的点击事件
  receiveFromChild(value: number) {
    this.brightValue = value * 2;
    // 设置屏幕亮度
    BrightnessModel.setOutputBrightness(this.brightValue)

    if (this.brightnessDialogTimer) {
      clearTimeout(this.brightnessDialogTimer)
    }
    this.brightnessDialogTimer = setTimeout(() => {
      emitter.emit('BRIGHTNESS_DIALOG_TIMER_EVENT')
    }, 3000)
  }

  build() {
    Column() {
      BrightnessComponent({
        sliderMaxValue: 100,
        brightValue: this.brightValue,
        onReceive: this.receiveFromChild.bind(this)
      })
    }
    .margin({ left: '100lpx' })
    .padding({ top: '48lpx', bottom: '48lpx' })
    .width('100lpx')
    .height('50%')
    .borderRadius('18lpx')
    .backgroundColor('#000000')
    .opacity(0.85)
    .visibility(this.isShowBrightness ? Visibility.Visible : Visibility.Hidden)
    .onKeyEvent((event) => {
      if (event.keyCode === 2012 && event.type === KeyType.Down) {
        this.upEvent()
      } else if (event.keyCode === 2013 && event.type === KeyType.Down) {
        this.downEvent()
      }
    })
    .stateStyles({
      focused: {
        .outline({
          color: Color.Transparent
        })
      }
    })
  }
}