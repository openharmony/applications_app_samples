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

import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  private mainWindow?: window.Window;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        return;
      }
      void this.initializeMainWindow(windowStage);
    });
  }

  onWindowStageDestroy(): void {
    this.mainWindow?.off('avoidAreaChange');
    AppStorage.delete('mainWindow');
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }

  private async initializeMainWindow(windowStage: window.WindowStage): Promise<void> {
    try {
      this.mainWindow = windowStage.getMainWindowSync();
      AppStorage.setOrCreate('mainWindow', this.mainWindow);
      await this.mainWindow.setWindowLayoutFullScreen(true);
      this.initSafeArea(this.mainWindow);
      this.mainWindow.on('avoidAreaChange', (option) => {
        switch (option.type) {
          // 监听状态栏避让区域
          case window.AvoidAreaType.TYPE_SYSTEM: {
            const topHeight = Math.max(option.area.topRect.height, AppStorage.get<number>('topAvoidHeight') ?? 0);
            AppStorage.setOrCreate('topAvoidHeight', topHeight);
            break;
          }
          // 监听挖孔区避让区域
          case window.AvoidAreaType.TYPE_CUTOUT: {
            this.handleCutoutAvoidArea(option.area);
            break;
          }
          // 监听底部导航区避让区域
          case window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR: {
            const bottomHeight = Math.max(option.area.bottomRect.height, AppStorage.get<number>('bottomAvoidHeight') ?? 0);
            AppStorage.setOrCreate('bottomAvoidHeight', bottomHeight);
            break;
          }
          default: {
            break;
          }
        }
      });
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to initialize avoid area listener. Cause: %{public}s', JSON.stringify(err));
    }
  }

  private initSafeArea(win: window.Window): void {
    try {
      // 获取状态栏避让区域
      const systemAvoidArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      // 获取底部导航区避让区域
      const navigationAvoidArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      // 获取挖孔区避让区域
      const cutoutAvoidArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_CUTOUT);

      AppStorage.setOrCreate('topAvoidHeight', systemAvoidArea.topRect.height);
      AppStorage.setOrCreate('bottomAvoidHeight', navigationAvoidArea.bottomRect.height);
      AppStorage.setOrCreate('leftAvoidWidth', 0);
      AppStorage.setOrCreate('rightAvoidWidth', 0);
      this.handleCutoutAvoidArea(cutoutAvoidArea);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to init safe area. Cause: %{public}s', JSON.stringify(err));
    }
  }

  private handleCutoutAvoidArea(cutoutAvoidArea: window.AvoidArea): void {
    if (cutoutAvoidArea.topRect.height > 0) {
      const topHeight = Math.max(AppStorage.get<number>('topAvoidHeight') ?? 0, cutoutAvoidArea.topRect.height);
      AppStorage.setOrCreate('topAvoidHeight', topHeight);
    }
    if (cutoutAvoidArea.bottomRect.height > 0) {
      const bottomHeight = Math.max(AppStorage.get<number>('bottomAvoidHeight') ?? 0, cutoutAvoidArea.bottomRect.height);
      AppStorage.setOrCreate('bottomAvoidHeight', bottomHeight);
    }
    if (cutoutAvoidArea.leftRect.width > 0) {
      AppStorage.setOrCreate('leftAvoidWidth', cutoutAvoidArea.leftRect.width);
    }
    if (cutoutAvoidArea.rightRect.width > 0) {
      AppStorage.setOrCreate('rightAvoidWidth', cutoutAvoidArea.rightRect.width);
    }
  }
}
