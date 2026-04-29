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
import { window } from '@kit.ArkUI';
import Logger from '../common/Logger';
import { FaultLogger } from '@kit.PerformanceAnalysisKit';

let dmClass: distributedDeviceManager.DeviceManager | null = null;
let TAG = '[DeviceManagerUI:ConfirmDialog]==>';
let win: window.Window | undefined = undefined;
const CANCEL_KEY: string = 'cancel';
const ALLOW_KEY: string = 'confirm';
const ALLOW_ALWAYS_KEY: string = 'always';
const DEFAULT_FOCUS_INDEX: number = 1;

@ObservedV2
class ButtonInfo {
  @Trace public key: string = '';
  @Trace public message: string = '';
  @Trace public seconds?: number = 0;
  public onClick: () => void = () => {};
  @Trace public isFocus: boolean = false;

  constructor(key: string, message: string, onClick: () => void, isFocus: boolean, seconds?: number) {
    this.key = key;
    this.message = message;
    this.onClick = onClick;
    this.isFocus = isFocus;
    this.seconds = seconds;
  }
}


@Entry
@Component
struct dialogPlusPage {
  message: string = '是否允许对端连接本机';
  times: number = 0;
  ACTION_ALLOW_AUTH: number = 0;
  ACTION_CANCEL_AUTH: number = 1;
  ACTION_AUTH_CONFIRM_TIMEOUT: number = 2;
  ACTION_ALLOW_ALWAYS_AUTH: number = 6;
  @State buttonInfos: ButtonInfo[] = [
    new ButtonInfo(
      CANCEL_KEY,
      '取消(60秒)',
      () => {
        this.onCancel();
      },
      false,
      60
    ),
    new ButtonInfo(
      ALLOW_KEY,
      '本次允许',
      () => {
        this.onAllow();
      },
      false
    ),
    new ButtonInfo(
      ALLOW_ALWAYS_KEY,
      '始终允许',
      () => {
        this.onAllowAlways();
      },
      false
    )
  ];

  initStatue() {
    Logger.info(TAG + 'initStatueSuccess');
    if (dmClass) {
      Logger.info('deviceManager exist');
      return;
    }
    dmClass = distributedDeviceManager.createDeviceManager('com.ohos.devicemanagerui');
  }

  onAllow() {
    this.setUserOperation(this.ACTION_ALLOW_AUTH);
    this.destruction();
  }

  onAllowAlways() {
    this.setUserOperation(this.ACTION_ALLOW_ALWAYS_AUTH);
    this.destruction();
  }

  onCancel() {
    this.setUserOperation(this.ACTION_CANCEL_AUTH);
    this.destruction();
  }

  setUserOperation(operation: number) {
    Logger.info('setUserOperation: ' + operation);
    if (dmClass == null) {
      Logger.info('setUserOperation: dmClass null');
      return;
    }
    dmClass.replyUiAction(operation, 'extra');
  }

  run() {
    if (!this.buttonInfos[0].seconds) {
      return;
    }
    this.buttonInfos[0].seconds--;
    this.buttonInfos[0].message = `取消(${this.buttonInfos[0].seconds}秒)`;
    if (this.buttonInfos[0].seconds == 0) {
      clearInterval(this.times);
      this.times = 0;
      this.setUserOperation(this.ACTION_AUTH_CONFIRM_TIMEOUT);
      this.destruction();
    }
  }

  onPageShow() {
    this.initStatue();
    win = globalThis.extensionWin;
    if (this.times) {
      return;
    }
    this.times = setInterval(() => {
      this.run();
    }, 1000);
    this.getUIContext().getFocusController().activate(true);
    this.getUIContext().getFocusController().requestFocus(ALLOW_KEY);
  }

  async destruction() {
    if (dmClass != null) {
      distributedDeviceManager.releaseDeviceManager(dmClass);
      dmClass = null;
    }
    await win?.destroyWindow();
    globalThis.windowNum--;
    if (globalThis.windowNum == 0) {
      globalThis.session.terminateSelf();
      globalThis.extensionContext.terminateSelf();
    }
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize('24lpx')
          .fontColor(0xffffff)
          .fontWeight(FontWeight.Bold);

        Row() {
        }.height('15%');

        Flex({ justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
          ForEach(this.buttonInfos, (item: ButtonInfo) => {
            Column() {
              Text(item.message)
                .key(item.key)
                .fontSize('36lpx')
                .backgroundColor(item.isFocus ? Color.White : StyleConstants.DEFAULT_BUTTON_COLOR)
                .fontColor(item.isFocus ? Color.Black : Color.White)
                .height('100%')
                .width('100%')
                .textAlign(TextAlign.Center)
                .borderRadius(50)
                .fontWeight(FontWeight.Normal)
                .stateStyles({
                  focused: {
                    .borderWidth(0)
                  }
                })
                .focusable(true);
            }
            .onHover(() => {
              this.getUIContext().getFocusController().requestFocus(item.key);
            })
            .onFocus(() => {
              console.log(`${item.key} onFocus`);
              item.isFocus = true;
            })
            .onBlur(() => {
              console.log(`${item.key} onBlur`);
              item.isFocus = false;
            })
            .onKeyEvent((event) => {
              if (event.type == KeyType.Up && event.keyCode == KeyCode.KEY_ENTER) {
                item.onClick();
              }
            })
            .onClick(() => {
              item.onClick();
            })
            .shadow({
              radius: item.isFocus ? 10 : 0,
              color: '#FFFFFF',
              offsetX: 0,
              offsetY: item.isFocus ? 0 : 1
            })
            .padding('8lpx')
            .border({
              width: item.isFocus ? 1 : 0,
              color: Color.White,
              radius: 50
            })
            .backgroundColor(item.isFocus ? '#404040' : '#666666')
            .height('72lpx')
            .width('248lpx');
          }, (item: ButtonInfo) => {
            return `${item.key}`;
          });
        }.width('100%');
      }
      .width('100%');
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
