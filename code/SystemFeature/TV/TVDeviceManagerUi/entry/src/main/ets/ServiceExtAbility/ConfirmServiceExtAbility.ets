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
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from '../common/Logger';
import { StyleConstants } from '../common/constants/StyleConstants';
import { DialogRect, ExtensionSessionStorage } from '../common/ExtensionWindowTypes';

const TAG = '[DeviceManagerUI:Confirm]==>';

export default class ServiceExtAbility extends UIExtensionAbility {
  private screenScale = 1;
  private dialogWidth = StyleConstants.DEFAULT_DIALOG_WIDTH;
  private dialogHeight = StyleConstants.DEFAULT_DIALOG_HEIGHT;

  onCreate(): void {
    globalThis.extensionContext = this.context;
    globalThis.windowNum = 0;
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession): void {
    globalThis.abilityWant = want;
    globalThis.session = session;
    const dis = display.getDefaultDisplaySync();
    this.screenScale = dis.width / StyleConstants.DEFAULT_DESIGN_WIDTH;
    this.dialogWidth = StyleConstants.DEFAULT_DIALOG_WIDTH * this.screenScale;
    this.dialogHeight = StyleConstants.DEFAULT_DIALOG_HEIGHT * this.screenScale;

    const dialogRect: DialogRect = {
      left: (dis.width - this.dialogWidth) / 2,
      top: (dis.height - this.dialogHeight) / 2,
      fullWidth: dis.width,
      width: dis.width / 3,
      height: dis.height / 3
    };
    const storageModel: ExtensionSessionStorage = {
      session: session,
      context: this.context
    };
    const storage: LocalStorage = new LocalStorage(storageModel);
    session.loadContent('pages/Transparent', storage);
    session.setWindowBackgroundColor('#00000000');
    globalThis.session = session;
    this.createWindow('picker Dialog:', window.WindowType.TYPE_FLOAT, dialogRect);
  }

  private async createWindow(name: string, windowType: number, rect: DialogRect): Promise<void> {
    Logger.info(TAG + 'createWindow execute');
    const config: window.Configuration = {
      name: name,
      windowType: windowType,
      ctx: this.context
    };
    try {
      const win = await window.createWindow(config);
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
      win.loadContent('pages/ConfirmDialog', storage, (err: BusinessError) => {
        const errCode: number = err.code;
        if (errCode) {
          Logger.error('Failed to load the content. Cause:' + JSON.stringify(err));
          return;
        }
        Logger.info('Succeeded in loading the content.');
      });

      win.showWindow((err: BusinessError) => {
        if (err.code) {
          Logger.error(`Failed to show the window. Cause: ${JSON.stringify(err)}`);
        }
      });

      win.setCornerRadius(20);
      win.setShadow(8.0, '#DCDCDC', 0, 4);
      globalThis.windowNum++;
      Logger.info(TAG + 'window create successfully');
    } catch {
      Logger.info(TAG + 'window create failed');
    }
  }
}
