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

import { KeyCode } from '../../common/constants/KeyCode';
import router from '@ohos.router';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import lpx from '../../common/Lpx';
import { SettingBackground } from '../../default/layout/SettingBackground';
import wifiManager from '@ohos.wifiManager';
import { EventUtil } from '../../common/EventUtil';

@Entry
@Component
struct hotspotPWD {
  textInputController: TextInputController = new TextInputController();
  @State focusIndex: number = -1;
  //显示输入的文本内容
  @State isShowPsd: boolean = true;
  @State userInputs: string = '';
  @State inputType:InputType=InputType.Normal
  private readonly miniDeviceNameSize: number = 8;

  onPageShow() {
    this.userInputs = ''
  }

  build() {
    Stack() {
      SettingBackground()
        .position({ x: 0, y: 0 })
        .height(ConfigData.WH_100_100)
        .width(ConfigData.WH_100_100)
      Column({ space: 10 }) {
        Text('输入密码')
          .width(lpx(256))
          .height(lpx(75))
          .fontColor(Color.White)
          .fontSize(lpx(64))
          .fontWeight(lpx(500))
          .margin({ top: '48lpx' })
        Row() {
          Row(){
            TextInput({
              controller: this.textInputController,
              text: this.userInputs,
              placeholder: wifiManager.getHotspotConfig().preSharedKey
            })
              .inputFilter('^[^\u4e00-\u9fa5]*$', (invalid) => {
                if (invalid) {
                  console.log('Filter Chinese characters：', invalid);
                }
              })
              .fontSize('36lpx')
              .fontColor(this.focusIndex == 0 ? 'rgba(0, 0, 0, 0.86)' : 'rgba(255, 255, 255, 0.6)')
              .focusable(true)
              .defaultFocus(true)
              .backgroundColor(this.focusIndex == 0 ? 'rgba(255, 255, 255, 0.86)' : 'rgba(255, 255, 255, 0.2)')
              .caretColor(this.focusIndex==0 ? Color.Black:Color.White)
              .fontWeight(FontWeight.Bold)
              .height('98lpx')
              .width('840lpx')
              .maxLength(30)
              .type(this.inputType)
              .key('pinInput')
              .borderRadius('100lpx')
              .onFocus(() => {
                this.focusIndex = 0;
              })
              .onBlur(() => {
                this.focusIndex = -1;
              })
              .onChange((value) => {
                this.userInputs = value;
              })
              .onHover((isHover: boolean) => {
                this.focusIndex = 0;
              })
              .showPasswordIcon(false)
              .enableKeyboardOnFocus(true)
              .onKeyEvent((event:KeyEvent) => {
                if (event.keyCode === KeyCode.KEY_ENTER && event.type === KeyType.Down) {
                  focusControl.requestFocus('pinInput')
                }
                if (event.keyCode === KeyCode.KEY_DPAD_RIGHT && event.type === KeyType.Down) {
                  focusControl.requestFocus('passwordState')
                }
                if (event.keyCode == KeyCode.KEY_DPAD_UP || event.keyCode == KeyCode.KEY_DPAD_LEFT ||
                  event.keyCode == KeyCode.KEY_DPAD_RIGHT) {
                  event.stopPropagation
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
                    if (event.type == KeyType.Up) {
                      this.userInputs += event.keyCode % 2000;
                    }
                    break;
                  case KeyCode.KEY_BACK:
                    if (event.type == KeyType.Down) {
                      event.stopPropagation;
                    }
                    break;
                  case KeyCode.KEY_DPAD_DOWN:
                    if (this.userInputs.length >= this.miniDeviceNameSize) {
                      focusControl.requestFocus('confirm');
                      event.stopPropagation;
                    } else {
                      focusControl.requestFocus('back');
                      event.stopPropagation;
                    }
                    break;
                }
              })
          }.padding('5lpx')
          .border({
            width: '2lpx',
            color: this.focusIndex == 0 ? Color.White : '#00ffffff',
            radius: '100lpx',
            style: BorderStyle.Solid
          })
        }
        .margin({ top: '48lpx' })
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        Row({ space: '72lpx' }) {
          Column() {
            Text('取消')
              .fontSize('36lpx')
              .textAlign(TextAlign.Center)
              .backgroundColor(this.focusIndex == 1 ? 'rgba(255, 255, 255, 0.86)' : 'rgba(255, 255, 255, 0.2)')
              .fontColor(this.focusIndex == 1 ? 'rgba(0, 0, 0, 0.86)' : 'rgba(255, 255, 255, 0.6)')
              .width('248lpx')
              .height('72lpx')
              .stateStyles({
                focused: {
                  .border({
                    color: Color.Transparent
                  })
                }
              })
              .borderRadius('200lpx')
              .key('back')
              .focusable(true)
              .onFocus(() => {
                this.focusIndex = 1;
              })
              .onBlur(() => {
                this.focusIndex = -1;
              })
              .onKeyEvent((event: KeyEvent) => {
                if (event.type === KeyType.Up) {
                  if (event.keyCode === KeyCode.KEY_DPAD_UP) {
                    focusControl.requestFocus('pinInput');
                    event.stopPropagation;
                  }
                  if (event.keyCode === KeyCode.KEY_DPAD_RIGHT) {
                    if (this.userInputs.length >= this.miniDeviceNameSize) {
                      focusControl.requestFocus('confirm');
                      event.stopPropagation;
                    }
                  }
                }
              })
              .onHover((isHover: boolean) => {
                this.focusIndex = 1;
              })
              .onTouch((event: TouchEvent) => {
                if (!EventUtil.isTouchEvent(event)) {
                  return;
                }
              })
              .onClick(() => {
                router.back();
              })
          }
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .padding('5lpx')
          .focusable(true)
          .border({
            width: this.focusIndex === 1 ? '2lpx' : '0lpx',
            radius: '200lpx',
            color: Color.White,
            style: BorderStyle.Solid
          })
          Column() {
            Text('确认')
              .fontSize('36lpx')
              .textAlign(TextAlign.Center)
              .backgroundColor(this.focusIndex == 2 ? 'rgba(255, 255, 255, 0.86)' : 'rgba(255, 255, 255, 0.2)')
              .fontColor(this.focusIndex == 2 ? 'rgba(0, 0, 0, 0.86)' : 'rgba(255, 255, 255, 0.6)')
              .width(lpx(248))
              .height(lpx(72))
              .stateStyles({
                focused: {
                  .border({
                    color: Color.Transparent
                  })
                }
              })
              .borderRadius('200lpx')
              .opacity(this.userInputs.length < this.miniDeviceNameSize ? 0.35 : 1)
              .key('confirm')
              .focusable(this.userInputs.length < this.miniDeviceNameSize ? false : true)
              .onFocus(() => {
                this.focusIndex = 2;
              })
              .onBlur(() => {
                this.focusIndex = -1;
              })
              .onHover((isHover: boolean) => {
                this.focusIndex = 2;
              })
              .onKeyEvent((event:KeyEvent) => {
                if (event.type === KeyType.Down) {
                  if (event.keyCode === KeyCode.KEY_DPAD_UP) {
                    focusControl.requestFocus('pinInput');
                    event.stopPropagation;
                  }
                  if (event.keyCode === KeyCode.KEY_DPAD_LEFT) {
                    focusControl.requestFocus('back');
                    event.stopPropagation;
                  }
                }
              })
              .onTouch((event: TouchEvent) => {
                if (!EventUtil.isTouchEvent(event)) {
                  return;
                }
              })
              .onClick(() => {
                if (this.userInputs.length >= this.miniDeviceNameSize) {
                  let hotspotConfig = wifiManager.getHotspotConfig()
                  hotspotConfig.preSharedKey = this.userInputs
                  //调方法修改热点密码
                  try {
                    wifiManager.setHotspotConfig(hotspotConfig)
                    //重启hotspot开关，使修改的密码马上生效
                    wifiManager.disableHotspot()
                    wifiManager.enableHotspot()
                    console.log('热点密码修改成功 ')
                  }catch (e) {
                    console.log('热点密码修改失败 ',e)
                  }
                  router.back()
                }
              })
          }
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .padding('5lpx')
          .focusable(true)
          .border({
            width: this.focusIndex === 2 ? '2lpx' : '0lpx',
            radius: '200lpx',
            color: Color.White,
            style: BorderStyle.Solid
          })
        }
        .margin({
          top: '36lpx'
        })
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
      }
      .onAppear(() => {
        focusControl.requestFocus('pinInput');
      })
      .alignItems(HorizontalAlign.Center)
      .width(ConfigData.WH_100_100)
      .height(ConfigData.WH_100_100)
    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
  }
}
