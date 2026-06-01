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
// [Start backgroundColor1_srart]
import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  // [StartExclude backgroundColor1_srart]
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
  // [EndExclude backgroundColor1_srart]
  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    AppStorage.setOrCreate<window.WindowStage>('mainWindowStage', windowStage);

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');

      windowStage.getMainWindow((err: BusinessError, data) => {
        if (err.code) {
          hilog.error(DOMAIN, 'testTag', 'Failed to obtain the main window. Cause: %{public}s', JSON.stringify(err));
          return;
        }

        const mainWindow: window.Window = data;
        AppStorage.setOrCreate<window.Window>('mainWindow', mainWindow);
        mainWindow.setWindowBackgroundColor('#00000000');
        // 设置自由窗口容器在激活态和非激活态下的颜色。
        const activeColor: string = '#00000000';
        const inactiveColor: string = '#FF000000';
        try {
          mainWindow.setWindowContainerModalColor(activeColor, inactiveColor);
          hilog.info(DOMAIN, 'testTag', 'Succeeded in setting window container color.');
        } catch (exception) {
          hilog.error(DOMAIN, 'testTag', 'Failed to set the window container color. Cause: %{public}s',
            JSON.stringify(exception));
        }
      });
    });
  }
  // [StartExclude backgroundColor1_srart]
  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    AppStorage.delete('mainWindow');
    AppStorage.delete('mainWindowStage');
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
  // [EndExclude backgroundColor1_srart]
}
  // [End backgroundColor1_srart]