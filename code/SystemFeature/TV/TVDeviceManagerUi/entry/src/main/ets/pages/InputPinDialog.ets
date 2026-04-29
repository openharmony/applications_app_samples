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
import { distributedDeviceManager } from '@kit.DistributedServiceKit';
import { StyleConstants } from '../common/constants/StyleConstants';
import { KeyCode } from '../common/constants/KeyCode';
import { KeyCode as InputKeyCode } from '@kit.InputKit';
import { window, ColorMetrics } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { inputEventClient } from '@kit.InputKit';
import Logger from '../common/Logger';

let dmClass: distributedDeviceManager.DeviceManager | null = null;
let TAG = '[DeviceManagerUI:InputPinDialog]==>';

class Data {
  public param: string = '';
}

interface TmpStr {
  verifyFailed: boolean;
}

@Entry
@Component
struct dialogPlusPage {
  @State messageTitle: string = 'PIN码连接';
  @State messageTips: string = '请输入另一个设备显示的PIN码进行验证';
  @State isTimes: number = 3;
  @State isShow: boolean = true;
  @State errorTips: string = 'PIN码输入错误，请重新输入(3次：还有' + this.isTimes + '次机会)';
  @State errorTipsVisible: number = Visibility.Hidden;
  @State inputPinCode: string = '';
  @State ok: string = '确定';
  @State cancel: string = '取消';
  @State win: window.Window | undefined = undefined;
  @State ACTION_CANCEL_PINCODE_INPUT: number = 4;
  @State ACTION_DONE_PINCODE_INPUT: number = 5;
  @State focusIndex: number = -1;

  aboutToAppear() {
    this.enterClick();
    this.initStatue();
    this.win = globalThis.extensionWin;
  }

  aboutToDisappear() {
    if (dmClass != null) {
      dmClass.off('replyResult');
      distributedDeviceManager.releaseDeviceManager(dmClass);
      dmClass = null;
    }
  }

  initStatue() {
    Logger.info(TAG + 'initStatueSuccess');
    if (dmClass) {
      Logger.info('deviceManager exist');
      return
    }
    dmClass = distributedDeviceManager.createDeviceManager('com.ohos.devicemanagerui');
    try {
      dmClass.on('replyResult', (data: Data) => {
        let tmpStr: TmpStr = JSON.parse(data.param);
        this.isShow = tmpStr.verifyFailed;
        Logger.info('replyResult executed, dialog closed' + this.isShow);
        if (!this.isShow) {
          this.destruction();
        } else {
          if (this.isTimes > 0) {
            this.isTimes--;
            this.errorTips = 'PIN码输入错误，请重新输入(3次：还有' + this.isTimes + '次机会)';
            this.inputPinCode = '';
            this.errorTipsVisible = Visibility.Visible;
          } else {
            this.setUserOperation(this.ACTION_CANCEL_PINCODE_INPUT, 'extra');
            this.destruction();
          }
        }
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.error('inputPinReplyResult errCode:' + e.code + ',errMessage:' + e.message);
    }
  }

  isDmClass() {
    if (dmClass) {
      Logger.info(TAG + 'deviceManager exist');
    } else {
      Logger.info(TAG + 'createDeviceManager is null');
      return
    }
  }

  onDone() {
    if (this.inputPinCode == null || this.inputPinCode == '') {
      return
    }
    Logger.info(this.inputPinCode + 'inputPinCode');
    this.isDmClass();
    this.setUserOperation(this.ACTION_DONE_PINCODE_INPUT, this.inputPinCode);
    this.destruction();
  }

  onCancel() {
    this.isDmClass();
    Logger.info(TAG + 'cancelPinCode1');
    this.setUserOperation(this.ACTION_CANCEL_PINCODE_INPUT, 'extra');
    Logger.info(TAG + 'cancelPinCode2');
    this.destruction();
    Logger.info(TAG + 'cancelPinCode3');
  }

  enterClick() {
    let keyEnterDownOpt: inputEventClient.KeyEvent = {
      isPressed: true,
      keyCode: KeyCode.KEY_ENTER,
      keyDownDuration: 0,
      isIntercepted: false
    };
    let keyEnterUpOpt: inputEventClient.KeyEvent = {
      isPressed: false,
      keyCode: KeyCode.KEY_ENTER,
      keyDownDuration: 0,
      isIntercepted: false
    };

    interface KeyEvent {
      keyEvent: inputEventClient.KeyEvent | null
    }

    let eventEnterDown: KeyEvent = {
      keyEvent: keyEnterDownOpt
    }
    let eventEnterUp: KeyEvent = {
      keyEvent: keyEnterUpOpt
    }

    try {
      // 触发enter点击，使默认焦点组件多态样式生效
      inputEventClient.injectEvent({KeyEvent: eventEnterDown.keyEvent});
      inputEventClient.injectEvent({KeyEvent: eventEnterUp.keyEvent});
      Logger.info('EnterSuccess')
    } catch (err) {
      Logger.error('Entererr: ', JSON.stringify(err));
    }
  }

  setUserOperation(operation: number, extra: string) {
    if (dmClass == null) {
      Logger.info('setUserOperation: ' + 'dmClass null');
      return
    }
    dmClass.replyUiAction(operation, extra);
  }

  async destruction() {
    Logger.info(TAG + 'destructionSTART');
    this.win?.destroyWindow((err: BusinessError) => {
      let errCode: number = err.code;
      if (errCode) {
        console.error(TAG + 'Failed to destroy the subwindow. Cause:' + JSON.stringify(err));
        return
      }
      console.info('Succeeded in destroying the subwindow.');
    });
    Logger.info(TAG + 'destructionSuccess');
    globalThis.session.terminateSelf();
    globalThis.extensionContext.terminateSelf((err: BusinessError) => {
      if (err) {
        Logger.error(TAG + `Failed to terminate self, code: ${err.code}, msg: ${err.message}`);
        return
      }
      Logger.info(TAG + `Successed in terminating self.`);
    });
  }

  onBackPress() {
    return true;
  }

  build() {
    Row() {
      Column() {
        Text(this.messageTitle)
          .fontSize('40lpx')
          .fontColor(0xffffff)
          .fontWeight(FontWeight.Bold)
          .height('20%');
        Text(this.messageTips)
          .fontSize('24lpx')
          .fontColor(0xffffff)
          .fontWeight(FontWeight.Medium)
          .height('15%');
        Row() {
        }.height('5%');

        Row() {
          TextInput()
            .fontSize('30lpx')
            .fontColor(Color.White)
            .focusable(true)
            .defaultFocus(true)
            .backgroundColor('#666666')
            .fontWeight(FontWeight.Bold)
            .width('100%')
            .height('100%')
            .maxLength(6)
            .type(InputType.Number)
            .key('pinInput')
            .border({
              style: BorderStyle.Solid,
              radius: 8
            })
            .onFocus(() => {
              this.focusIndex = 0;
            })
            .onBlur(() => {
              this.focusIndex = -1;
            })
            .onChange((value: string) => {
              this.inputPinCode = value;
            })
            .onKeyEvent((event) => {
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
                    if (this.inputPinCode.length == 6) {
                      return
                    }
                    this.inputPinCode += event.keyCode % 2000;
                  }
                  break;
                case KeyCode.KEY_ENTER:
                  focusControl.requestFocus('pinInput');
                  break;
                case KeyCode.KEY_BACK:
                  if (event.type == KeyType.Down) {
                    let newStr = this.inputPinCode.substring(0, this.inputPinCode.length - 1);
                    this.inputPinCode = newStr;
                    event.stopPropagation();
                  }
                  break;
                case KeyCode.KEY_DPAD_DOWN:
                  focusControl.requestFocus('confirm');
                  event.stopPropagation();
                  break;
                default:
                  break;
              }
            });
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .height('72lpx')
        .width('532lpx');

        Text(this.errorTips)
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .fontColor(0xffffff)
          .visibility(this.errorTipsVisible)
          .height('10%');
        Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Row() {
            Column() {
              Text(this.cancel)
                .fontSize('36lpx')
                .textAlign(TextAlign.Center)
                .height('100%')
                .width('100%')
                .backgroundColor(this.focusIndex == 1 ? Color.White : StyleConstants.DEFAULT_BUTTON_COLOR)
                .fontColor(this.focusIndex == 1 ? Color.Black : Color.White)
                .focusable(true)
                .borderRadius(50)
                .fontWeight(FontWeight.Normal)
                .key('cancle')
                .focusBox({
                  strokeColor: ColorMetrics.rgba(64, 64, 64)
                })
                .onFocus(() => {
                  this.focusIndex = 1;
                })
                .onBlur(() => {
                  this.focusIndex = -1;
                })
                .onKeyEvent((event) => {
                  Logger.info(JSON.stringify(event.keyCode));
                  if (event.keyCode === 2015) {
                    focusControl.requestFocus('confirm');
                  }
                  if (event.keyCode === 2012) {
                    focusControl.requestFocus('pinInput');
                  }
                  if (event.type == KeyType.Up) {
                    if (event.keyCode == KeyCode.KEY_ENTER) {
                      this.onCancel();
                      event.stopPropagation();
                    }
                  }
                });
            }
            .padding('8lpx')
            .border({
              width: this.focusIndex == 1 ? 1 : 0,
              color: Color.White,
              radius: 50
            })
            .backgroundColor(this.focusIndex == 1 ? '#404040' : '#666666')
            .height('72lpx')
            .width('248lpx')
            .focusable(true)
            .shadow({
              radius: this.focusIndex == 1 ? 10 : 0,
              color: '#FFFFFF',
              offsetX: 0,
              offsetY: this.focusIndex == 1 ? 0 : 1
            })
            .onClick(() => {
              focusControl.requestFocus('cancle');
              this.onCancel();
            });

            Column() {
              Text(this.ok)
                .fontSize('36lpx')
                .textAlign(TextAlign.Center)
                .backgroundColor(this.focusIndex == 2 ? Color.White : StyleConstants.DEFAULT_BUTTON_COLOR)
                .fontColor(this.focusIndex == 2 ? Color.Black : Color.White)
                .focusable(true)
                .height('100%')
                .width('100%')
                .borderRadius(50)
                .fontWeight(FontWeight.Normal)
                .key('confirm')
                .focusBox({
                  strokeColor: ColorMetrics.rgba(64, 64, 64)
                })
                .onFocus(() => {
                  this.focusIndex = 2;
                })
                .onBlur(() => {
                  this.focusIndex = -1;
                })
                .onKeyEvent((event) => {
                  Logger.info(JSON.stringify(event.keyCode) + ' keyCode');
                  if (event.keyCode === 2014) {
                    focusControl.requestFocus('cancle');
                  }
                  if (event.keyCode === 2012) {
                    focusControl.requestFocus('pinInput');
                  }
                  if (event.type == KeyType.Up) {
                    if (event.keyCode == KeyCode.KEY_ENTER) {
                      this.onDone();
                      event.stopPropagation();
                    }
                  }
                });
            }
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
            .onClick(() => {
              focusControl.requestFocus('confirm');
              this.onDone();
            });
          }
          .width('560lpx')
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .width('100%')

        Row() {
        }.height('3%')
      }
      .onAppear(() => {
        focusControl.requestFocus('pinInput');
      })
      .width('100%')
    }
    .backgroundColor(StyleConstants.DEFAULT_BG_COLOR)
    .width('100%')
    .height('100%')
    .shadow({
      radius: 23,
      color: '#FFFFFF',
      offsetX: 1,
      offsetY: 1
    });
  }
}