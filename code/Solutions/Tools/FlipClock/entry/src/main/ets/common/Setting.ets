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

import window from '@ohos.window'
import brightness from '@ohos.brightness'
import { LockSwitch } from '../common/LockSwitch'
import Logger from '../model/Logger'

@Component
export struct Setting {
  @State isFullScreen: boolean = false
  @State inSetValue: number = 40

  setBrightness(): void {
    brightness.setValue(this.inSetValue)
  }

  build() {
    Column({ space: 10 }) {
      Divider()
        .strokeWidth(5)
        .color($r('app.color.divider_bg'))

      Row() {
        Text($r("app.string.fullScreen")).fontSize(18)

        Blank()

        Toggle({ type: ToggleType.Switch, isOn: this.isFullScreen })
          .switchPointColor(0xe5ffffff)
          .onChange(async () => {
            this.isFullScreen = !this.isFullScreen
            try {
              const win = await window.getLastWindow(getContext(this))
              let names = this.isFullScreen ? [] : ['status', 'navigation']
              await win.setWindowSystemBarEnable(names as Array<'status' | 'navigation'>)
            } catch (err) {
              Logger.info(`setFullScreen fail, code = ${err.code}`)
            }
          })
      }
      .width('98%')
      .height(62)
      .borderRadius(24)
      .margin({ top: 10 })
      .backgroundColor(Color.White)
      .padding({ left: '3%', right: '3%' })

      Divider()
        .strokeWidth(5)
        .color($r('app.color.divider_bg'))

      Row() {
        Lock()
      }
      .width('98%')
      .height(62)
      .borderRadius(24)
      .margin({ top: 10 })
      .backgroundColor(Color.White)
      .padding({ left: '3%', right: '3%' })

      Divider()
        .strokeWidth(5)
        .color($r('app.color.divider_bg'))

      Row() {
        Text($r("app.string.brightness"))
          .fontSize(18)

        Slider({
          value: this.inSetValue,
          min: 0,
          max: 255,
          step: 5,
          style: SliderStyle.OutSet
        })
          .key('brightness')
          .width('90%')
          .showTips(false)
          .showSteps(false)
          .blockColor(0xCCCCCC)
          .trackColor(Color.Black)
          .selectedColor(0xCCCCCC)
          .onChange((value: number, mode: SliderChangeMode) => {
            this.inSetValue = value
            this.setBrightness()
          })
      }
      .width('98%')
      .height(62)
      .borderRadius(24)
      .margin({ top: 10 })
      .backgroundColor(Color.White)
      .padding({ left: '3%', right: '3%' })

      Divider()
        .strokeWidth(5)
        .color($r('app.color.divider_bg'))
    }
    .height('100%')
  }
}

@Component
struct Lock {
  @State isComTime: boolean = true

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Column() {
        LockSwitch({ isComTime: $isComTime })
      }
      .width('100%')
    }
  }
}