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
import { KeyCode } from '../common/constants/KeyCode';
import { StyleConstants } from '../common/constants/StyleConstants';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from '../common/Logger';

let dmClass: distributedDeviceManager.DeviceManager | null = null;
let TAG = '[DeviceManagerUI:PinDialog]==>';
let win: window.Window | undefined = undefined;

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
  @State messageTips: string = '请在设备端输入连接码进行验证';
  @State pinCode: string = '';
  @State allow: string = '允许';
  @State cancel: string = '取消';
  @State isShow: boolean = true;
  @State ACTION_CANCEL_PINCODE_DISPLAY: number = 3;
  @State isCancelFocus: boolean = false;

  aboutToAppear() {
    this.initStatue();
    win = globalThis.extensionWin;
    this.pinCode = globalThis.abilityWant.parameters['pinCode'] || null;
    Logger.info(JSON.stringify(win), 'winwinwinw');
  }

  aboutToDisappear() {
    Logger.info(TAG + 'aboutToDisappear executed');
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
      return;
    }
    try {
      dmClass = distributedDeviceManager.createDeviceManager('com.ohos.devicemanagerui');
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.error(TAG + 'errCode:' + e.code + ',errMessage:' + e.message);
    }
    try {
      dmClass?.on('replyResult', (data: Data) => {
        let tmpStr: TmpStr = JSON.parse(data.param);
        this.isShow = tmpStr.verifyFailed;
        if (!this.isShow) {
          this.destruction();
        }
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      Logger.error('replyResultErrCode:' + e.code + ',errMessage:' + e.message);
    }
  }

  setUserOperation(operation: number) {
    if (dmClass == null) {
      Logger.info('setUserOperation: ' + 'dmClass null');
      return;
    }
    dmClass.replyUiAction(operation, 'extra');
  }

  async destruction() {
    await win?.destroyWindow();
    globalThis.session.terminateSelf();
    globalThis.extensionContext.terminateSelf();
  }

  build() {
    Row() {
      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Column() {
          Text(this.messageTitle)
            .fontSize('40lpx')
            .fontWeight(FontWeight.Bold)
            .fontColor(0xffffff)
            .margin({
              bottom: '5%'
            });
          Text(this.messageTips)
            .fontSize('24lpx')
            .fontColor(0xffffff)
            .fontWeight(FontWeight.Medium);
          Row() {
          }.height('5%');

          Text(this.pinCode)
            .fontSize('30lpx')
            .fontColor(0xffffff)
            .fontWeight(FontWeight.Bold);
          Row() {
          }.height('5%');

          Column() {
            Text(this.cancel)
              .textAlign(TextAlign.Center)
              .fontSize('36lpx')
              .fontWeight(FontWeight.Bold)
              .backgroundColor(this.isCancelFocus ? Color.White : StyleConstants.DEFAULT_BUTTON_COLOR)
              .fontColor(this.isCancelFocus ? Color.Black : Color.White)
              .focusable(true)
              .width('100%')
              .height('100%')
              .key('cancel')
              .borderRadius(50)
              .fontWeight(FontWeight.Normal)
              .onFocus(() => {
                this.isCancelFocus = true;
                Logger.info(TAG + 'confirm is focused');
              })
              .onBlur(() => {
                this.isCancelFocus = false;
                Logger.info(TAG + 'confirm focus is moved');
              })
              .onKeyEvent((event) => {
                if (event.keyCode == KeyCode.KEY_ENTER) {
                  if (event.type == KeyType.Up) {
                    this.setUserOperation(this.ACTION_CANCEL_PINCODE_DISPLAY);
                    this.destruction();
                    event.stopPropagation();
                  }
                }
              });
          }
          .shadow({
            radius: this.isCancelFocus ? 10 : 0,
            color: '#FFFFFF',
            offsetX: 0,
            offsetY: this.isCancelFocus ? 0 : 1
          })
          .padding('8lpx')
          .border({
            width: this.isCancelFocus ? 1 : 0,
            color: Color.White,
            radius: 50
          })
          .backgroundColor(this.isCancelFocus ? '#404040' : '#666666')
          .height('72lpx')
          .width('248lpx')
          .onClick(() => {
            this.setUserOperation(this.ACTION_CANCEL_PINCODE_DISPLAY);
            this.destruction();
          });
        }
        .onAppear(() => {
          focusControl.requestFocus('cancel');
        })
        .width('100%');
      }.width('100%')
      .height('100%');
    }
    .backgroundColor(StyleConstants.DEFAULT_BG_COLOR)
    .width('100%')
    .shadow({
      radius: 23,
      color: '#FFFFFF',
      offsetX: 1,
      offsetY: 1
    });
  }
}
