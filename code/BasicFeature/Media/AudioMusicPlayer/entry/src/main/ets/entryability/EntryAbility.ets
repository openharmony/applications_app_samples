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
import { display, window } from '@kit.ArkUI';
import { BreakpointConstants } from '../common/constants/BreakpointConstants';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  private windowObj?: window.Window;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      AppStorage.setOrCreate('context', this.context)
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  private updateBreakpoint(windowWidth: number): void {
    let windowWidthVp = windowWidth / display.getDefaultDisplaySync().densityPixels;
    let curBp: string = '';
    if (windowWidthVp < BreakpointConstants.BREAKPOINT_VALUE_NUMBER[1]) {
      curBp = BreakpointConstants.BREAKPOINT_SM;
    } else if (windowWidthVp < BreakpointConstants.BREAKPOINT_VALUE_NUMBER[2]) {
      curBp = BreakpointConstants.BREAKPOINT_MD;
    } else {
      curBp = BreakpointConstants.BREAKPOINT_LG;
    }
    AppStorage.setOrCreate('currentBreakpoint', curBp);
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      AppStorage.setOrCreate('windowStage', windowStage)
      windowStage.getMainWindow().then((data: window.Window) => {
        this.windowObj = data;
        AppStorage.setOrCreate<window.Window>('window', data);
        data.setWindowLayoutFullScreen(true);
        const uiContext = data.getUIContext();
        AppStorage.setOrCreate("uiContext", uiContext);
        let topArea = this.windowObj.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
        let bottomArea = this.windowObj.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
        let topHeight: number;
        let bottomHeight: number;
        if (!topArea) {
          topHeight = 0;
        } else {
          topHeight = uiContext.px2vp(topArea.topRect.height)
        }
        if (!bottomArea) {
          bottomHeight = 0;
        } else {
          bottomHeight = uiContext.px2vp(bottomArea.bottomRect.height)
        }
        AppStorage.setOrCreate('topHeight', topHeight)
        AppStorage.setOrCreate('bottomHeight', bottomHeight)
        this.updateBreakpoint(this.windowObj.getWindowProperties().windowRect.width);
        this.windowObj.on('windowSizeChange', (windowSize: window.Size) => {
          this.updateBreakpoint(windowSize.width);
        })
      })
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}