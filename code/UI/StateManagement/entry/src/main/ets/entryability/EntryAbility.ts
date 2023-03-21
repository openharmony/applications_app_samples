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

import UIAbility from '@ohos.app.ability.UIAbility';
import type window from '@ohos.window';
import Logger from '../utils/Logger';
import display from '@ohos.display';

const TAG: string = 'EntryAbility';
const FONT_SIZE: number = 18;
const DPI: number = 160;
const SMALL_SCREEN_WIDTH: number = 520;
const MIDDLE_SCREEN_WIDTH: number = 520;

export default class EntryAbility extends UIAbility {
  private storage: LocalStorage;

  onCreate(want, launchParam): void {
    this.storage = new LocalStorage();
    this.storage.setOrCreate<boolean>('currentModelStatus', true);
    // 设置当前内容字体为18
    this.storage.setOrCreate<number>('contentFontSize', FONT_SIZE);
    Logger.info(TAG, 'Ability onCreate');
  }

  onDestroy(): void {
    Logger.info(TAG, 'Ability onDestroy');
  }

  updateBreakpoint(windowWidth: number): void {
    let windowWidthVp: number = windowWidth / (display.getDefaultDisplaySync().densityDPI / DPI);
    let curBp: string;
    // 520以及840分别为小屏和中屏的最大宽度
    if (windowWidthVp < SMALL_SCREEN_WIDTH) {
      curBp = 'sm';
    } else if (windowWidthVp < MIDDLE_SCREEN_WIDTH) {
      curBp = 'md';
    } else {
      curBp = 'lg';
    }
    Logger.info(TAG, `breakpoint: ${curBp}`);
    AppStorage.SetOrCreate('currentBreakpoint', curBp);
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    Logger.info(TAG, 'Ability onWindowStageCreate');
    windowStage.getMainWindow().then((windowObj) => {
      let windowWidth: number = windowObj.getWindowProperties().windowRect.width;
      this.updateBreakpoint(windowWidth);
      windowObj.on('windowSizeChange', (currentWindowSize) => {
        let currentWindowWidth: number = currentWindowSize.width;
        this.updateBreakpoint(currentWindowWidth);

        if (windowObj.getWindowProperties().isFullScreen) {
          Logger.info(TAG, 'isFullScreen');
        }
        if (windowObj.getWindowProperties().isLayoutFullScreen) {
          Logger.info(TAG, 'isLayoutFullScreen');
        }
      });
    });
    windowStage.loadContent('pages/home/Home', this.storage);
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info(TAG, 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info(TAG, 'Ability onBackground');
  }
}
