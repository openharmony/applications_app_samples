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

import { UIExtensionAbility, Want, UIExtensionContentSession } from '@kit.AbilityKit';
import { window, display } from '@kit.ArkUI';
import { deviceInfo, BusinessError } from '@kit.BasicServicesKit';
import Logger from '../common/Logger';
import { StyleConstants } from '../common/constants/StyleConstants';
import { DialogRect, ExtensionSessionStorage } from '../common/ExtensionWindowTypes';

const TAG = '[DeviceManagerUI:PinCode]==>';

export default class ServiceExtAbility extends UIExtensionAbility {
  private lineNums = 0
  private screenScale = 1
  private dialogWidth = StyleConstants.DEFAULT_DIALOG_WIDTH
  private dialogHeight = StyleConstants.DEFAULT_DIALOG_HEIGHT

  onCreate(): void {
    globalThis.extensionContext = this.context
    globalThis.windowNum = 0
    this.getShareStyle()
  }


  onSessionCreate(want: Want, session: UIExtensionContentSession): void {
    globalThis.abilityWant = want
    globalThis.session = session
    const dis = display.getDefaultDisplaySync()
    this.screenScale = dis.width / StyleConstants.DEFAULT_DESIGN_WIDTH;
    this.dialogWidth = StyleConstants.DEFAULT_DIALOG_WIDTH * this.screenScale;
    this.dialogHeight = StyleConstants.DEFAULT_DIALOG_HEIGHT * this.screenScale;

    const dialogRect: DialogRect = {
      left: (dis.width - this.dialogWidth) / 2,
      top: (dis.height - this.dialogHeight) / 2,
      width: dis.width / 3,
      fullWidth: dis.width,
      height: dis.height / 3
    };
    const storageModel: ExtensionSessionStorage = {
      session: session,
      context: this.context
    };
    const storage: LocalStorage = new LocalStorage(storageModel);
    session.loadContent('pages/Transparent', storage)
    session.setWindowBackgroundColor('#00000000');
    globalThis.session = session
    this.createWindow('picker Dialog:', window.WindowType.TYPE_FLOAT, dialogRect);
  }

  getShareStyle(): void {
    globalThis.style = {}
    if (deviceInfo.deviceType == 'phone' || deviceInfo.deviceType == 'default') {
      this.lineNums = 8
      globalThis.style['shareWidth'] = 520
      globalThis.style['shareHeight'] = 365
      globalThis.style['shareCardWidth'] = 336
      globalThis.style['shareCardHeight'] = 97
      globalThis.style['shareCardRadius'] = 16
      globalThis.style['shareContentMargin'] = {
        top: 16,
        right: 43.5,
        bottom: 6,
        left: 16
      }
      globalThis.style['shareCardTextLeft'] = 12
      globalThis.style['shareCardTextTop'] = 6
      globalThis.style['shareBackTop'] = 0
      globalThis.style['shareCardTextWidth'] = 236
      globalThis.style['shareCardSubTop'] = 3
      globalThis.style['shareCardBtnLeft'] = 238
      globalThis.style['swiperHeight'] = 200
      globalThis.style['swiperSelectMarginTop'] = 8
    } else {
      this.lineNums = 6
      globalThis.style['shareWidth'] = 519
      globalThis.style['shareHeight'] = 256
      globalThis.style['shareCardWidth'] = 495
      globalThis.style['shareCardHeight'] = 87
      globalThis.style['shareCardRadius'] = 24
      globalThis.style['shareContentMargin'] = {
        top: 16,
        right: 24,
        bottom: 8,
        left: 16
      }
      globalThis.style['shareCardTextLeft'] = 16
      globalThis.style['shareCardTextTop'] = 3
      globalThis.style['shareBackTop'] = 6
      globalThis.style['shareCardTextWidth'] = 380
      globalThis.style['shareCardSubTop'] = 2
      globalThis.style['shareCardBtnLeft'] = 368
      globalThis.style['swiperHeight'] = 115
      globalThis.style['swiperSelectMarginTop'] = 16
    }
  }


  private async createWindow(name: string, windowType: number, rect: DialogRect): Promise<void> {
    Logger.info(TAG + 'createWindow execute');
    const config: window.Configuration = {
      name: name,
      windowType: windowType,
      ctx: this.context
    }
    try {
      const win = await window.createWindow(config)
      globalThis.extensionWin = win;
      win.moveWindowTo(rect.left, rect.top, (err: BusinessError) => {
        const errCode: number = err.code;
        if (errCode) {
          Logger.error('Failed to move the window. Cause:' + JSON.stringify(err));
          return;
        }
        Logger.info('Succeeded in moving the window.');
      });
      win.resize(this.dialogWidth, this.dialogHeight, (err: BusinessError) => {
        const errCode: number = err.code;
        if (errCode) {
          Logger.error('Failed to change the window size. Cause:' + JSON.stringify(err));
          return;
        }
        Logger.info('Succeeded in changing the window size.');
      });
      const storage: LocalStorage = new LocalStorage();
      win.loadContent('pages/PinDialog', storage, (err: BusinessError) => {
        const errCode: number = err.code;
        if (errCode) {
          Logger.error('Failed to load the content. Cause:' + JSON.stringify(err));
          return;
        }
        Logger.info('Succeeded in loading the content.');
      });

      await win.showWindow((err: BusinessError) => {
        if (err.code) {
          Logger.error(`Failed to show the window. Cause: ${JSON.stringify(err)}`);
        }
      });

      globalThis.windowNum++;
      win.setCornerRadius(20);
      win.setShadow(8.0, '#DCDCDC', 0, 4);
      Logger.info(TAG + 'window create successfully');
    } catch {
      Logger.info(TAG + 'window create failed');
    }
  }
}
