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
import WifiModel from '../../model/wifiImpl/WifiModel';
import { WifiScanInfo, ApScanResult } from '../../model/wifiImpl/WifiModel';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import ImageAnimatorComponent from '../../../../../../../common/component/src/main/ets/default/ImageAnimatorComponent';
import lpx from '../../common/Lpx';
import promptAction from '@ohos.promptAction';
import wifiManager from '@ohos.wifiManager';
import { SettingBackground } from '../../default/layout/SettingBackground';
import { LengthMetrics } from '@kit.ArkUI';
import { Duration } from '../../common/constants/Duration';
import { EventUtil } from '../../common/EventUtil';
import { settings } from '@kit.BasicServicesKit';
import { SourcetoolConstants } from '../../common/constants/StyleConstants';
const EYE_FOCUS = 3 //密码是否显示
const wificonnectPromption: string = getContext(this).resourceManager.getStringByNameSync('wificonnectPromption')
// Miracast相关
const MIRACAST_QUICK_PLAY_KEY = 'settings.wifi.miracast.quickplay';
const FALSE = '0';
const TRUE = '1';

@Entry
@Component
struct WifiPsd {
  textInputController: TextInputController = new TextInputController();
  @State tobeConnectedSSID: string = '';
  @State focusIndex: number = -1;
  @State count:number=0
  private isConnectedBefore: boolean = false;
  private tobeConnectedAp: WifiScanInfo = {
    ssid: '',
    bssid: '',
    rssi: 0,
    band: 0,
    frequency: 0,
    timestamp: 0,
    securityType: 0
  };
  private toConnected: boolean = false;
  private isDialogOpenBack: boolean = false; //判断是否是在弹窗打开时点击返回按钮
  @State isShowPsd: boolean = false;
  @State darkPsd: string = '';
  @State userInputs: string = '';
  @State inputType:InputType=InputType.Password

  private readonly miniPassWordSize: number = 8;
  private connectDialog: CustomDialogController = new CustomDialogController({
    builder: ConnectProgressDialog({
      ssid: this.tobeConnectedSSID,
    }),
    alignment: DialogAlignment.Center,
    offset: ({ dx: 0, dy: 0 }),
    autoCancel: false,
    customStyle: true
  });
  private taskId: number = -1;

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration })
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration })
  }


  setDiscoverableFalse() {
    settings.setValue(getContext(this), MIRACAST_QUICK_PLAY_KEY, FALSE);
    console.info(`Wifi: set discoverable false`)
  }

  setDiscoverableTrue() {
    settings.setValue(getContext(this), MIRACAST_QUICK_PLAY_KEY, TRUE);
    console.info(`Wifi: set discoverable true`)
  }


  build() {
    Stack() {
      SettingBackground()
        .position({ x: 0, y: 0 })
        .height(ConfigData.WH_100_100)
        .width(ConfigData.WH_100_100)

      Column({ space: 10 }) {
        Text(this.tobeConnectedSSID + '网络密码')
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
              placeholder: $r('app.string.placeholderPassword')
            })
              .inputFilter('^[^\u4e00-\u9fa5]*$', (invalid) => {
                if (invalid) {
                  console.log('Filter Chinese characters：', invalid);
                }
              })
              .placeholderFont({size:'36lpx',weight:FontWeight.Bold})
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
              .onEditChange((isEdit)=>{
                if(isEdit){
                  if(this.userInputs.length===this.textInputController.getCaretOffset().index){
                    this.count=1
                  }
                }

              })
              .showPasswordIcon(false)
              .enableKeyboardOnFocus(true)
              .onKeyEvent((event) => {

                if (event.keyCode === KeyCode.KEY_ENTER && event.type === KeyType.Down) {
                  focusControl.requestFocus('pinInput')
                }
                if (event.keyCode === KeyCode.KEY_DPAD_LEFT && event.type === KeyType.Down) {
                  this.count=0
                }
                if (this.userInputs.length === this.textInputController.getCaretOffset().index) {
                  if (event.keyCode === KeyCode.KEY_DPAD_RIGHT && event.type === KeyType.Down) {
                    this.count++
                    if (this.count >= 2) {
                      focusControl.requestFocus('passwordState')
                    }
                  }
                }
                if (event.keyCode == KeyCode.KEY_DPAD_UP || event.keyCode == KeyCode.KEY_DPAD_LEFT ||
                  event.keyCode == KeyCode.KEY_DPAD_RIGHT) {
                  event.stopPropagation();
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
                      event.stopPropagation();
                    }
                    break;
                  case KeyCode.KEY_DPAD_DOWN:
                    if (this.userInputs.length >= this.miniPassWordSize) {
                      focusControl.requestFocus('confirm');
                      event.stopPropagation();
                    } else {
                      focusControl.requestFocus('back');
                      event.stopPropagation();
                    }
                    break;
                }
              })

          }.padding('5lpx')
          .border({
            width: '2lpx',
            color:this.focusIndex == 0 ?  Color.White : '#00ffffff',
            radius: '100lpx',
            style: BorderStyle.Solid
          })

          Image(this.inputType === InputType.Password
            ? (this.focusIndex === EYE_FOCUS ? $r('app.media.onfocus_eyeclose') : $r('app.media.onblur_eyeclose'))
            : (this.focusIndex === EYE_FOCUS ? $r('app.media.onfocus_eyeopen') : $r('app.media.onblur_eyeopen')))
            .width('98lpx')
            .height('98lpx')
            .focusable(true)
            .key('passwordState')
            .zIndex(1)
            .onClick(()=>{
              if (this.inputType === InputType.Password) {
                this.inputType = InputType.Normal;
              } else if (this.inputType === InputType.Normal) {
                this.inputType = InputType.Password;
              }
            })
            .onKeyEvent((event: KeyEvent) => {
              if (event.keyCode === KeyCode.KEY_DPAD_DOWN && event.type === KeyType.Down) {
                if (this.userInputs.length >= this.miniPassWordSize) {
                  focusControl.requestFocus('confirm');
                  event.stopPropagation();
                } else {
                  focusControl.requestFocus('back');
                  event.stopPropagation();
                }
              } else if (event.keyCode === KeyCode.KEY_DPAD_LEFT && event.type === KeyType.Down) {
                focusControl.requestFocus('pinInput')
                event.stopPropagation();

              }
            })
            .onTouch((event) => {
              if (!EventUtil.isTouchEvent(event)) {
                return;
              }
              if (event.sourceTool !== SourceTool.Pen &&
                event.sourceTool !== SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK) {
                return;
              }
              if (this.inputType === InputType.Password) {
                this.inputType = InputType.Normal;
              } else if (this.inputType === InputType.Normal) {
                this.inputType = InputType.Password;
              }
            })
            .onFocus(() => {
              this.focusIndex = EYE_FOCUS
              this.count=0
            })
            .onBlur(() => {
              this.focusIndex = -1
            })
            .focusBox({
              strokeWidth: LengthMetrics.px(0)
            })
            .border({
              width: this.focusIndex == EYE_FOCUS ? 2 : 0,
              color: Color.White,
              radius: '49lpx'
            })
            .padding('2lpx')
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
                  if (event.keyCode === KeyCode.KEY_ENTER) {
                    router.back()
                  }
                  if (event.keyCode === KeyCode.KEY_DPAD_UP) {
                    focusControl.requestFocus('pinInput');
                    event.stopPropagation();
                  }
                  if (event.keyCode === KeyCode.KEY_DPAD_RIGHT) {
                    if (this.userInputs.length >= this.miniPassWordSize) {
                      focusControl.requestFocus('confirm');
                      event.stopPropagation();
                    }
                  }
                }
              })
              .onTouch((event) => {
                if (!EventUtil.isTouchEvent(event)) {
                  return;
                }
                if (event.sourceTool !== SourceTool.Pen &&
                  event.sourceTool !== SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK) {
                  return;
                }
              })
              .onClick(()=>{
                router.back()
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
            Text('连接')
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
              .opacity(this.userInputs.length < this.miniPassWordSize ? 0.35 : 1)
              .key('confirm')
              .focusable(this.userInputs.length < this.miniPassWordSize ? false : true)
              .onFocus(() => {
                this.focusIndex = 2;
              })
              .onBlur(() => {
                this.focusIndex = -1;
              })
              .onKeyEvent((event) => {
                if (event.type === KeyType.Down) {
                  if (event.keyCode === KeyCode.KEY_DPAD_UP) {
                    focusControl.requestFocus('pinInput');
                    event.stopPropagation();
                  }
                  if (event.keyCode === KeyCode.KEY_DPAD_LEFT) {
                    focusControl.requestFocus('back');
                    event.stopPropagation();
                  }
                }
              })
              .onTouch((event) => {
                if (!EventUtil.isTouchEvent(event)) {
                  return;
                }
                if (event.sourceTool !== SourceTool.Pen &&
                  event.sourceTool !== SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK) {
                  return;
                }
              })
              .onClick(()=>{
                if (this.userInputs.length >= this.miniPassWordSize) {
                  WifiModel.setUserSelectedAp(this.tobeConnectedAp);
                  // 每次都先重置
                  this.toConnected = false;
                  let connectWiFi:boolean= WifiModel.connectWiFi(this.userInputs,this.tobeConnectedSSID);
                  if(connectWiFi){
                    this.toConnected = true;
                    this.isDialogOpenBack = true;
                    this.connectDialog.open();
                  } else {
                    this.toConnected =true;
                    this.isDialogOpenBack = true;
                    this.connectDialog.open();
                  }
                  this.startLinkedInfoTask();
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

  async aboutToAppear() {
    let params = router.getParams() as Record<string, WifiScanInfo | boolean>;
    console.info('Wifi: aboutToAppear params'+JSON.stringify(params))
    if (typeof params === 'undefined' || params === null) {
      router.back()
    }
    this.tobeConnectedAp = params.apInfo as WifiScanInfo;
    this.tobeConnectedSSID = this.tobeConnectedAp.ssid;
  }

  onPageShow() {
    this.isConnectedBefore = wifiManager.isConnected();
    console.info('Wifi: onPageShow isConnectedBefore'+JSON.stringify(this.isConnectedBefore))
    this.setDiscoverableFalse()
  }

  onPageHide(): void {
    this.setDiscoverableTrue()
    this.isDialogOpenBack = false;
    this.connectDialog.close();
    this.clearLinkedInfoTask();
  }

  startLinkedInfoTask() {
    let count:number=0
    this.taskId = setInterval(() => {
      count++
      console.info('Wifi: startLinkedInfoTask count='+count)
      wifiManager.getLinkedInfo((err, result) => {
        console.info('Wifi: startLinkedInfoTask result=' + JSON.stringify(result) +
          'tobeConnectedSSID=' + this.tobeConnectedSSID)
        if (err) {
          console.info('Wifi: startLinkedInfoTask getLinkedInfoError='+JSON.stringify(err))
        } // 1: Connecting, 4: Connected, 6: Disconnected
        if (result.ssid == this.tobeConnectedSSID && result.connState === 4) {
          this.isDialogOpenBack = false
          this.connectDialog.close();
          router.back()
          WifiModel.refreshApScanResults();
          this.toConnected = false;
          AppStorage.setOrCreate('slConnectedWifi', new ApScanResult(this.tobeConnectedAp).renderToListModel());
        }
        if (result.ssid !== this.tobeConnectedSSID && result.connState === 4) {
          // 重置count，让其重新记时
          count=0
          WifiModel.connectWiFi(this.userInputs,this.tobeConnectedSSID)
        }
        console.info('Wifi: startLinkedInfoTask toConnected='+this.toConnected)
        if (count>20) {
          this.isDialogOpenBack = false
          this.connectDialog.close();
          console.info('Wifi: startLinkedInfoTask pwdError')
          promptAction.showToast({
            message: $r('app.string.wifiTipsConnectAuthFailed'),
            duration: 2000,
            bottom: globalThis.screenHeight / 4
          });
          this.toConnected = false;
          WifiModel.removeDeviceConfig(this.tobeConnectedAp);
          this.clearLinkedInfoTask();
          WifiModel.refreshApScanResults();
        }
      });
    }, 500);
  }
  clearLinkedInfoTask() {
    if (this.taskId !== -1) {
      clearInterval(this.taskId);
      this.taskId = -1;
    }
  }
  onBackPress() {
    if (this.isDialogOpenBack) {
      if (WifiModel.isWiFiConnected()) {
        WifiModel.disconnectWiFi()
      }
      WifiModel.removeDeviceConfig(this.tobeConnectedAp);
      WifiModel.refreshApScanResults();
      this.connectDialog.close()
    }
  }
}

@CustomDialog
struct ConnectProgressDialog {
  controller: CustomDialogController;
  @Prop ssid: string;
  @State message: string = ''
  aboutToAppear() {
    this.message = wificonnectPromption + this.ssid;
  }
  build() {
    Column() {
      Row() {
        Text(this.message)
          .fontSize('40lpx')
          .fontColor(Color.White)
          .fontWeight(500)
          .align(Alignment.Start)
          .maxLines(1)
          .textOverflow({overflow:TextOverflow.Ellipsis})
          .maxFontSize(10)
          .height('47lpx')
          .width('373lpx')
        ImageAnimatorComponent({
          imageWidth: lpx(48),
          imageHeight: lpx(48),
        })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .height('100%')
    }
    .height('96lpx')
    .width('527lpx')
    .border({
      style: BorderStyle.Solid,
      width: lpx(2),
      radius: lpx(24),
      color: Color.White
    })
    .stateStyles({
      focused: {
        .border({
          color: Color.Transparent
        })
      }
    })
    .backgroundColor('#666666')
  }
}
