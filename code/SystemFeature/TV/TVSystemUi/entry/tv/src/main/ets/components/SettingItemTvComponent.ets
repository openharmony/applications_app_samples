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
 

﻿import { SettingItemStyle } from '../utils/StyleConstants'
import { SettingItemTvModel } from '../model/SettingItemTvModel'
import lpx from '../utils/Lpx'
import { inputEventClient } from '@kit.InputKit';
import { KeyCode } from '@kit.InputKit';



const NETWORK_MONITOR_BG: string = 'rgba(70,70,72,1)';
const TAG = 'Controller'

@Component
export struct SettingItemTvComponent {
  @Prop isEnable: boolean = false
  title: string | Resource = '';
  @State model: SettingItemTvModel = new SettingItemTvModel()
  @Prop isFocus: boolean = false
  @Link isLeft?: boolean;
  @Link isTouchImg?: boolean;
  private sensitivityList: string[] = ['低', '中', '高']

  onToggleChangedHandle: Function = (item: SettingItemTvModel, isOn: boolean) => {
  }
  onKeyEventHandle: Function = (event: KeyEvent) => {
  }
  onValueChangeLeftHandle: Function = (item: SettingItemTvModel) => {
  }
  onValueChangeRightHandle: Function = (item: SettingItemTvModel) => {
  }
  aboutToAppear() {
    this.model.setIsOn = (value) => {
      this.model.isOn = value
    }
    this.model.setIsSelect = (isSelect) => {
      this.model.isSelect = isSelect
    }
    this.model.setValue = (value) => {
      this.model.value = value
    }
    this.model.setChooseDes = (value) => {
      this.model.chooseDes = value;
    }
    this.model.setStyle = (value: SettingItemStyle) => {
      this.model.style = value;
    }
    this.model.setIsDisableFocus = (value) => {
      this.model.isDisableFocus = value
    }
  }

  // 根据不同的场景给item设置字体样式
  setFontColor() {
    if (this.isFocus) {
      return 'rgba(0, 0, 0, 0.86)'
    }
    if (this.model.isEnable) {
      return '#FFFFFF'
    } else {
      return '#50FFFFFF'
    }
  }

  // 根据不同的场景给item设置背景色
  setBgc(name: string) {
    if (this.isFocus) {
      return 'rgba(255,255,255,0.86)'
    } else {
      if (!this.model.isNeedBg) {
        return null
      }
      return 'rgba(255,255,255,0.2)'
    }
  }


  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
        Text(this.model.name)
          .fontColor(this.model.textColor == '' ? this.setFontColor() : this.model.textColor)
          .fontSize('30lpx')
          .align(Alignment.Center)
          .margin(lpx(24))
          .stateStyles({
            focused: {
              .border({
                color: Color.Transparent
              })
            }
          })
          .focusable(!this.model.isDisableFocus)
          .key(this.model.isSetFocusKey ? this.model.focusKeys[0] : '')
          .onFocus(() => {
            focusControl.requestFocus(this.model.focusKeys[0])
          })
      Text()
        .flexGrow(1)

        Image($r('app.media.icon_arrow_left'))
          .width(lpx(24))
          .height(lpx(48))
          .objectFit(ImageFit.Fill)
          .align(Alignment.Center)
          .fillColor(this.setFontColor())
          .focusable(false)
          .onHover((isHover: boolean) => {
            this.isTouchImg = isHover
          })
          .onClick(()=>{
            this.isLeft = false
            this.onValueChangeLeftHandle(this.model)
          })
          .onTouch(((event) => {
            this.isLeft = true
          }))

        Text(this.model.value)
          .height(lpx(98))
          .fontColor(this.setFontColor())
          .fontSize('30lpx')
          .focusable(false)
          .align(Alignment.Center)
          .margin({
            right: lpx(50),
            left: lpx(50)
          })

        Image($r('app.media.icon_arrow_right'))
          .width(lpx(24))
          .height(lpx(48))
          .objectFit(ImageFit.Fill)
          .align(Alignment.Center)
          .margin({ right: lpx(24) })
          .fillColor(this.setFontColor())
          .focusable(false)
          .visibility(this.model.arrowVisible)
          .onHover((isHover: boolean) => {
            this.isTouchImg = isHover
          })
          .onClick(()=>{
            this.isLeft = false
            this.onValueChangeRightHandle(this.model)
          })
          .onTouch(((event) => {
            this.isLeft = false
          }))



    }
    .width('100%')
    .height(lpx(86))
    .backgroundColor(this.setBgc(this.model.name))
    .borderRadius(lpx(18))
    .visibility(this.model.style == SettingItemStyle.hidden ? Visibility.None : Visibility.Visible)
  }
}