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

import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import { KeyCode } from '../../common/constants/KeyCode';
import { SettingItemTvModel } from '../model/SettingItemTvModel';
import lpx from '../../common/Lpx';
import { Ratio } from '../../common/Ratio';
import inputEventClient from '@ohos.multimodalInput.inputEventClient';
import remoteControl from '@ohos.multimodalInput.remoteControl';
import { commonEventDataFunc } from '../../MainAbility/MainAbility';

const NETWORK_MONITOR_BG: string = 'rgba(70,70,72,1)';
const TAG = 'Controller'

class InjectedKeyEventPayload {
}

@Component
export struct SettingItemTvComponent {
  @Prop isEnable: boolean = false
  title: string | Resource = '';
  @State model: SettingItemTvModel = new SettingItemTvModel()
  @Prop isFocus: boolean = false
  @Link isLeft?: boolean;
  @Link isTouchImg?: boolean;
  private sensitivityList: string[] = ['低', '中', '高']

  onToggleChangedHandle: Function = (item: SettingItemTvModel, isOn?: boolean) => {
  }
  singleChooseClick: Function = (item: SettingItemTvModel) => {
  }
  onKeyEventHandle: Function = (event: KeyEvent) => {
  }
  onValueChangeLeftHandle: Function = (item: SettingItemTvModel) => {
  }
  onValueChangeRightHandle: Function = (item: SettingItemTvModel) => {
  }

  // ip模块的方法
  private backEventCall() {
    try {
      let backKeyDown: inputEventClient.KeyEvent = {
        isPressed: true,
        keyCode: 2054,
        keyDownDuration: 0,
        isIntercepted: false
      }
      let backEventDown: InjectedKeyEventPayload = new InjectedKeyEventPayload()
      Reflect.set(backEventDown, 'KeyEvent', backKeyDown)

      inputEventClient.injectEvent(backEventDown as never);
      let backKeyUp: inputEventClient.KeyEvent = {
        isPressed: false,
        keyCode: 2054,
        keyDownDuration: 0,
        isIntercepted: false
      }
      let backEventUp: InjectedKeyEventPayload = new InjectedKeyEventPayload()
      Reflect.set(backEventUp, 'KeyEvent', backKeyUp)

      inputEventClient.injectEvent(backEventUp as never);
    } catch (error) {
    }
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
    if (this.title === '网络') {
      if (this.isEnable) {
        return '#FFFFFF'
      } else {
        return '#50FFFFFF'
      }
    }
    if (this.model.isEnable) {
      return '#FFFFFF'
    } else {
      return '#50FFFFFF'
    }
  }

  // 根据不同的场景给item设置背景色
  setBgc(name: string) {
    if (this.isNetworkMonitorBgc()) {
      return NETWORK_MONITOR_BG;
    }
    if (this.isFocus) {
      return 'rgba(255,255,255,0.86)'
    } else {
      if (!this.model.isNeedBg) {
        return Color.Transparent
      }
      return 'rgba(255,255,255,0.2)'
    }
  }

  // 根据不同的场景给item设置高度
  setHeight(): string {
    if (this.model.isNeedBg) {
      return lpx(98)
    } else {
      return lpx(76)
    }
  }

  isNetworkMonitorBgc(): boolean {
    return this.model.style == SettingItemStyle.loading || this.model.style == SettingItemStyle.finished ||
      this.model.style == SettingItemStyle.error;
  }

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
      if (this.model.style === SettingItemStyle.amplifying) {
        Column() {
          Text(this.model.name)
            .fontColor(this.setFontColor())
            .fontSize(this.model.isNeedBg ? lpx(36) : lpx(24))
            .fontWeight(FontWeight.Medium)
            .focusable(!this.model.isDisableFocus)
            .key(this.model.isSetFocusKey ? this.model.focusKeys[0] : '')
            .onFocus(() => {
              focusControl.requestFocus(this.model.focusKeys[0])
            })
            .stateStyles({
              focused: {
                .border({
                  color: Color.Transparent
                })
              }
            })
          Text(this.model.chooseDes)
            .fontColor(this.setFontColor())
            .fontSize(lpx(24))
        }
        .height(this.model.isNeedBg ? lpx(98) : lpx(28))
        .padding({ left: lpx(24) })
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)

        Text()
          .flexGrow(1)
        Image($r(Ratio.resName('icon_arrow_right')))
          .fillColor(this.setFontColor())
          .width(lpx(24))
          .height(lpx(48))
          .opacity(this.model.isEnable ? 1 : 0.25)
          .objectFit(ImageFit.Fill)
          .align(Alignment.Center)
          .margin({ right: lpx(24) })
          .visibility(this.model.arrowVisible)
      } else {
        if (this.model.name === '确定') {
          Text(this.model.name)
            .height(this.model.isNeedBg ? lpx(98) : lpx(28))
            .fontColor(this.setFontColor())
            .fontSize(this.model.isNeedBg ? lpx(36) : lpx(24))
            .textAlign(TextAlign.Center)
            .width('100%')
            .margin({
              left: lpx(24)
            })
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
        } else {
           if (this.model.name == '版本号') {
             Text(this.model.name)
               .width('175lpx')
               .height(this.model.isNeedBg ? lpx(98) : lpx(28))
               .fontColor(this.model.textColor == '' ? this.setFontColor() : this.model.textColor)
               .fontSize(this.model.isNeedBg ? lpx(36) : lpx(24))
               .align(Alignment.Center)
               .margin({
                 left: this.model.isNeedBg ? lpx(24) : lpx(0)
               })
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
          } else {
             Text(this.model.name)
               .height(this.model.isNeedBg ? lpx(98) : lpx(28))
               .fontColor(this.model.textColor == '' ? this.setFontColor() : this.model.textColor)
               .fontSize(this.model.isNeedBg ? lpx(36) : lpx(24))
               .align(Alignment.Center)
               .margin({
                 left: this.model.isNeedBg ? lpx(24) : lpx(0)
               })
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
           }
             Text()
               .flexGrow(1)
        }

      }
      if (this.model.style == SettingItemStyle.default) {
        Text(this.model.chooseDes)
          .fontColor(this.setFontColor())
          .height(lpx(98))
          .fontSize(lpx(36))
          .align(Alignment.Center)
          .margin({
            right: lpx(30),
            left: lpx(50)
          })

        Image($r(Ratio.resName('icon_arrow_right')))
          .fillColor(this.setFontColor())
          .width(lpx(24))
          .height(lpx(48))
          .opacity(this.model.isEnable ? 1 : 0.25)
          .objectFit(ImageFit.Fill)
          .align(Alignment.Center)
          .margin({ right: lpx(24) })
          .visibility(this.model.arrowVisible)

      } else if (this.model.style == SettingItemStyle.switch) {
        Toggle({ type: ToggleType.Switch, isOn: this.model.isOn })
          .width(lpx(83))
          .height(lpx(48))
          .selectedColor('#2056f7')
          .switchPointColor(0xe5ffffff)
          .align(Alignment.Center)
          .margin({ right: lpx(24) })
          .focusable(false)
          .stateStyles({
            focused: {
              .border({
                color: Color.Transparent
              })
            }
          })
          .onChange((isOn: boolean) => {
            if (this.model.name == '文件互传' || this.model.name == '按键音' || this.model.name === '开关' ||
              this.model.name == '开机默认进入输入源' || this.title == 'HDMI输入' ||
              this.title == 'HDMI输出' || this.model.name === '悬浮球开关') {
              this.onToggleChangedHandle(this.model, isOn)
            }
          })
          .onClick(() => {
            if (this.model.name == '护眼模式' || this.model.name == '蓝光过滤' ||
              this.model.name === '自动设置' || this.model.name === '动态背光' ||
              this.model.name === '屏幕旋转') {
              this.onToggleChangedHandle(this.model)
            }
          })
      } else if (this.model.style == SettingItemStyle.valueChange) {
        Image($r(Ratio.resName('icon_arrow_left')))
          .width(lpx(24))
          .height(lpx(48))
          .objectFit(ImageFit.Fill)
          .align(Alignment.Center)
          .fillColor(this.setFontColor())
          .onHover((isHover?: boolean) => {
            this.isTouchImg = isHover ?? false
          })
          .focusable(false)
          .stateStyles({
            focused: {
              .border({
                color: Color.Transparent
              })
            }
          })
          .onClick(()=>{
            this.isLeft = false
            this.onValueChangeLeftHandle(this.model)
          })

        Text(this.model.value)
          .height(lpx(98))
          .fontColor(this.setFontColor())
          .fontSize(lpx(36))
          .align(Alignment.Center)
          .margin({
            right: lpx(50),
            left: lpx(50)
          })

        Image($r(Ratio.resName('icon_arrow_right')))
          .width(lpx(24))
          .height(lpx(48))
          .objectFit(ImageFit.Fill)
          .align(Alignment.Center)
          .margin({ right: lpx(24) })
          .fillColor(this.setFontColor())
          .visibility(this.model.arrowVisible)
          .focusable(false)
          .onHover((isHover?: boolean) => {
            this.isTouchImg = isHover ?? false
          })
          .stateStyles({
            focused: {
              .border({
                color: Color.Transparent
              })
            }
          })
          .onClick(()=>{
            this.isLeft = true
            this.onValueChangeRightHandle(this.model)
          })

      } else if (this.model.style == SettingItemStyle.singleChoose) {
        Radio({ group: 'radioGroup', value: 'radio1' })
          .width(lpx(40))
          .height(lpx(40))
          .margin({ right: lpx(24) })
          .aspectRatio(1)
          .checked(this.model.isSelect)
          .focusable(false)
          .enabled(this.model.isEnable)
          .onClick(()=>{
            this.singleChooseClick(this.model)
          })
      } else if (this.model.style == SettingItemStyle.ip) {
        Row() {
          ForEach(this.model.ips, (item: string, index: number) => {
            TextInput({ text: item })
              .fontSize('36lpx')
              .maxLength(3)
              .type(InputType.Number)
              .caretColor(Color.White)
              .fontColor(Color.White)
              .border({
                radius: '5',
                width: '2lpx',
                color: Color.White
              })
              .key(this.model.focusKeys[index])
              .height(lpx(49))
              .width('22%')
              .margin({ right: '3%' })
              .focusable(true)
              .onFocus(() => {
                this.backEventCall();
              })
              .onKeyEvent((event?: KeyEvent) => {
                if (!event) {
                  return;
                }
                switch (event.keyCode) {
                  case KeyCode.KEY_0:
                  case KeyCode.KEY_1:
                  case KeyCode.KEY_2:
                  case KeyCode.KEY_3:
                  case KeyCode.KEY_4:
                  case KeyCode.KEY_5:
                  case KeyCode.KEY_6:
                  case KeyCode.KEY_7:
                  case KeyCode.KEY_8:
                  case KeyCode.KEY_9:
                    if (item.length < 3 && event.type == KeyType.Up) {
                      this.model.ips[index] += event.keyCode % 2000
                      this.model.ips = [...this.model.ips]
                    }
                    break;
                  case KeyCode.KEY_ENTER:
                    break;
                  case KeyCode.KEY_BACK:
                    if (item.length > 0) {
                      this.model.ips[index] = item.substring(0, item.length - 1)
                      this.model.ips = [...this.model.ips]
                      event.stopPropagation?.()
                    } else {
                      if (index > 0) {
                        focusControl.requestFocus(this.model.focusKeys[index - 1])
                        event.stopPropagation?.()
                      }
                    }
                    break;
                }
                // 回调
                if (this.onKeyEventHandle) {
                  this.onKeyEventHandle(event)
                }
              })
              .onChange((value) => {
                this.model.ips[index] = value.trim()
              })
          })
        }
        .height('40lpx')
        .width(ConfigData.WH_70_100)
      } else if (this.model.style == SettingItemStyle.info) {
        Text(this.model.chooseDes)
          .height(lpx(98))
          .fontColor(this.setFontColor())
          .fontSize(lpx(36))
          .align(Alignment.Center)
          .margin({
            right: lpx(24)
          })
      } else if (this.model.style == SettingItemStyle.loading) {
        LoadingProgress()
          .color(Color.White)
          .width(lpx(48)).height(lpx(48)).margin(lpx(24))
      } else if (this.model.style == SettingItemStyle.finished) {
        Image($r('sys.media.ohos_ic_public_ok'))
          .fillColor(Color.White)
          .width(lpx(48))
          .height(lpx(48))
          .objectFit(ImageFit.Fill)
          .align(Alignment.Center)
          .margin({ right: lpx(24) })
      } else if (this.model.style == SettingItemStyle.error) {
        Image($r('app.media.net_error'))
          .fillColor(Color.White)
          .width(lpx(30))
          .height(lpx(30))
          .objectFit(ImageFit.Fill)
          .align(Alignment.Center)
          .margin({ right: lpx(24) })
      }
    }
    .width(this.isFocus ? lpx(846) : lpx(840))
    .height(this.setHeight())
    .backgroundColor(this.setBgc(this.model.name))
    .borderRadius(lpx(18))
    .visibility(this.model.style == SettingItemStyle.hidden ? Visibility.None : Visibility.Visible)
  }
}
