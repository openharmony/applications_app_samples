/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import display from '@ohos.display';
import Logger from '../utils/Logger';

const TAG = ' EntryAbility';
const DPI: number = 160;
const SMALL_SCREEN_WIDTH: number = 480;
const MIDDLE_SCREEN_WIDTH: number = 520;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    Logger.info('Ability onCreate');
  }

  onDestroy() {
    Logger.info('Ability onDestroy');
  }

  updateBreakpoint(windowWidth: number): void {
    let windowWidthVp: number = windowWidth / (display.getDefaultDisplaySync().densityDPI / DPI);
    let currentBreakpoint: string;
    Logger.info(`breakpoint windowWidthVp:${windowWidthVp}`);
    // 520以及840分别为小屏和中屏的最大宽度
    if (windowWidthVp < SMALL_SCREEN_WIDTH) {
      currentBreakpoint = 'sm';
    } else if (windowWidthVp < MIDDLE_SCREEN_WIDTH) {
      currentBreakpoint = 'md';
    } else {
      currentBreakpoint = 'lg';
    }
    Logger.info(TAG, `breakpoint: ${currentBreakpoint}`);
    AppStorage.setOrCreate('currentBreakpoint', currentBreakpoint);
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    Logger.info('Ability onWindowStageCreate');

    windowStage.loadContent('pages/AdvertisingPage', (err, data) => {
      if (err.code) {
        Logger.error(`Failed to load the content. Cause: ${JSON.stringify(err)}`);
        return;
      }
      Logger.info(`Succeeded in loading the content. Data:JSON.stringify(data)`);
    });
    windowStage.getMainWindow((err, windowClass) => {
      if (err.code) {
        Logger.error(`Failed to obtain the main window.Cause: ${JSON.stringify(err)}`);
        return;
      }
      let windowWidth: number = windowClass.getWindowProperties().windowRect.width;
      this.updateBreakpoint(windowWidth);
      // 设置监听键盘变化，用来设置inputView避让输入法
      try {
        windowClass.on('windowSizeChange', (currentWindowSize) => {
          let currentWindowWidth: number = currentWindowSize.width;
          this.updateBreakpoint(currentWindowWidth);

          if (windowClass.getWindowProperties().isFullScreen) {
            Logger.info(TAG, 'isFullScreen');
          }
          if (windowClass.getWindowProperties().isLayoutFullScreen) {
            Logger.info(TAG, 'isLayoutFullScreen');
          }
        });
        windowClass.on('keyboardHeightChange', (data) => {
          Logger.info(`keyboardHeightChange.Data: ${JSON.stringify(data)}`);
          AppStorage.setOrCreate('keyboardHeight', data);
        })
      } catch (exception) {
        Logger.error(`Failed to enable the listener for keyboard height changes.Cause: ${JSON.stringify(exception)}`);
      }
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info('Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info('Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    Logger.info('Ability onBackground');
  }
}
