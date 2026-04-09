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
import lpx from '../../common/Lpx';
import { SettingBackground } from '../../default/layout/SettingBackground';
import { KeyCode } from '../../common/constants/KeyCode';
import router from '@ohos.router';
import { Duration } from '../../common/constants/Duration';
import { EventUtil } from '../../common/EventUtil';
import { SourcetoolConstants } from '../../common/constants/StyleConstants';

const TAG = 'netMaskUpdate';

//子网掩码正则表达式
function isValidINetMask(ip: string): boolean {
  // 定义子网掩码的正则表达式
  const ipv4Regex: RegExp = new RegExp('^((128|192)|2(24|4[08]|5[245]))(\.(0|(128|192)|2((24)|(4[08])|(5[245])))){3}$')
  // 使用正则表达式测试输入的IP地址
  return ipv4Regex.test(ip);
}

@Entry
@Component
struct NetmaskUpdate {
  @State userInputs: string = '';
  @State des: string = '子网掩码';
  @State ipstr: string = '';
  @State focusIndex: number = -1;
  textInputController: TextInputController = new TextInputController();
  private readonly miniPassWordSize: number = 6;

  aboutToAppear(): void {
    interface IpParams {
      ips: string
    }

    let param = router.getParams() as IpParams
    this.userInputs = param.ips
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration })
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration })
  }

  onDone() {
    AppStorage.setOrCreate('maskStr', this.userInputs)
    getContext(this).eventHub.emit('updateIpRecord')
    router.back()
  }

  build() {
    Stack() {
      SettingBackground()
        .position({ x: 0, y: 0 })
        .height(ConfigData.WH_100_100)
        .width(ConfigData.WH_100_100)

      Column({ space: 20 }) {
        Text('修改子网掩码')
          .width(lpx(456))
          .height(lpx(75))
          .fontColor(Color.White)
          .fontSize(lpx(64))

        Row() {
          Text('  子网掩码    | ')
            .fontColor('#99e9e8e8')
            .fontSize(lpx(50))// .width('30%')
            .focusable(false)
            .backgroundColor('#666666')


          TextInput({ controller: this.textInputController, text: this.userInputs })
            .fontSize(lpx(50))
            .fontColor(Color.White)
            .focusable(true)
            .defaultFocus(true)
            .backgroundColor('#666666')
            .caretColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .width('60%')
            .height('100%')
            .maxLength(15)
            .type(InputType.Normal)
            .key('pinInput')
            .enterKeyType(EnterKeyType.NEW_LINE)
            .enableKeyboardOnFocus(true)
            .border({
              style: BorderStyle.Solid,
              radius: lpx(48),
            })
            .onFocus(() => {
              this.focusIndex = 0;
            })
            .onBlur(() => {
              this.focusIndex = -1;
            })
            .onChange((value) => {
              this.userInputs = value;
            })
            .onKeyEvent((event: KeyEvent) => {
              if (event.keyCode == KeyCode.KEY_DPAD_UP || event.keyCode == KeyCode.KEY_DPAD_LEFT ||
                event.keyCode == KeyCode.KEY_DPAD_RIGHT) {
                event.stopPropagation();
              }

              console.info(TAG + 'event===>:' + JSON.stringify(event.keyCode))
              switch (event.keyCode) {
                case KeyCode.KEY_ENTER:
                  if (event.type === KeyType.Down) {
                    focusControl.requestFocus('pinInput')
                  }
                  break;
                case KeyCode.KEY_BACK:
                  break;
                case KeyCode.KEY_DPAD_DOWN:
                  if (this.userInputs.length >= this.miniPassWordSize) {
                    focusControl.requestFocus('confirm');
                    event.stopPropagation();
                  }
                  break;
                default:
                  break;
              }
              return false
            })
            .onHover(() => {
              focusControl.requestFocus('pinInput')
            })
            .onTouch((event) => {
              if (!EventUtil.isTouchEvent(event)) {
                return;
              }
            })
        }
        .margin({ top: lpx(20) })
        .height('144lpx')
        .width('862lpx')
        .backgroundColor('#666666')
        .border(true ? {
          width: this.focusIndex == 0 ? 2 + 'lpx' : 0,
          color:Color.White,
          radius: lpx(48),
          style: BorderStyle.Solid
        } : {})
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)

        Column() {
          Text('保存')
            .fontSize('36lpx')
            .textAlign(TextAlign.Center)
            .backgroundColor(this.focusIndex == 2 ? Color.White : Color.Gray)
            .fontColor(this.focusIndex == 2 ? Color.Black : Color.White)
            .focusable(isValidINetMask(this.userInputs) === true)
            .opacity(isValidINetMask(this.userInputs) === false ? 0.35 : 1)
            .key('confirm')
            .height('100%')
            .width('100%')
            .borderRadius(50)
            .fontWeight(FontWeight.Normal)
            .stateStyles({
              focused: {
                .border({
                  color: Color.Transparent
                })
              }
            })
            .onFocus(() => {
              this.focusIndex = 2;
              console.info(TAG + 'confirm is focused');
            })
            .onBlur(() => {
              this.focusIndex = -1;
              console.info(TAG + 'confirm focus is moved');
            })
            .onKeyEvent((event) => {
              if (event.type == KeyType.Up) {
                if (event.keyCode == KeyCode.KEY_ENTER) {
                  this.onDone();
                  event.stopPropagation();
                } else if (event.keyCode == KeyCode.KEY_DPAD_UP) {
                  focusControl.requestFocus('pinInput');
                } else {
                  event.stopPropagation();
                }
              }
            })
            .onClick(()=>{
              this.onDone();
            })
            .onTouch((event) => {
              if (!EventUtil.isTouchEvent(event)) {
                return;
              }
              if (event.sourceTool !== SourceTool.Pen &&
                event.sourceTool !== SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK) {
                return;
              }
              if (!isValidINetMask(this.userInputs)) {
                return
              }
              this.onDone();
            })
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .height('72lpx')
        .width('248lpx')
        .focusable(true)
        .shadow({
          radius: this.focusIndex == 2 ? 10 : 0,
          color: '#FFFFFF',
          offsetX: 0,
          offsetY: this.focusIndex == 2 ? 0 : 1
        })
        .padding('8lpx')
        .border({
          width: this.focusIndex == 2 ? 1 : 0,
          color: Color.White,
          radius: 50
        })
        .backgroundColor(this.focusIndex == 2 ? '#404040' : '#666666')

      }
      .onAppear(() => {
        focusControl.requestFocus('pinInput');
      })
      .alignItems(HorizontalAlign.Center)
      .margin({
        top: lpx(97)
      })
      .alignItems(HorizontalAlign.Center)
      .width(ConfigData.WH_100_100)
      .height(ConfigData.WH_100_100)
    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
  }
}
