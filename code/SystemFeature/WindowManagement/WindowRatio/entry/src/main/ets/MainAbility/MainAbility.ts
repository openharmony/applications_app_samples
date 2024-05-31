/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import window from '@ohos.window';

export default class MainAbility extends UIAbility {
  onCreate(want, launchParam): void {
    console.log('[Demo] MainAbility onCreate');
    globalThis.abilityWant = want;
  }

  onDestroy(): void {
    console.log('[Demo] MainAbility onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    console.log('[Demo] MainAbility onWindowStageCreate');
    windowStage.loadContent('pages/index', (err, data) => {
      if (err.code) {
        console.error('Failed to load the content. Cause:' + JSON.stringify(err));
        return;
      }
      this.getMainWindow(windowStage);
      console.info('Succeeded in loading the content. Data: ' + JSON.stringify(data));
    });
  }

  async getMainWindow(windowStage: window.WindowStage): Promise<void> {
    let windows = await windowStage.getMainWindow();
    if (windows === null) {
      console.info('MyApplicationDemo getMainWindow fail');
    } else {
      console.info('MyApplicationDemo getMainWindow success');
    }
    AppStorage.setOrCreate<window.Window>('windows', windows);
    let mode = window.WindowMode.FLOATING;
    try {
      let promise = windows.setWindowMode(mode);
      promise.then(() => {
        console.info('MyApplicationDemo Succeeded in setting the window mode.');
      }).catch((err) => {
        console.error('MyApplicationDemo Failed to set the window mode. Cause: ' + JSON.stringify(err));
      });
    } catch (exception) {
      console.error('MyApplicationDemo Failed to set the window mode. Cause: ' + JSON.stringify(exception));
    }

    try {
      windows.on('windowSizeChange', (data) => {
        console.info('MyApplicationDemo ' + 'Succeeded in enabling the listener for window size changes. Data: ' + JSON.stringify(data));
        let width = data.width;
        let height = data.height;
        AppStorage.setOrCreate('windowWidth', JSON.stringify(width));
        AppStorage.setOrCreate('windowHeight', JSON.stringify(height));
      });
    } catch (exception) {
      console.error('MyApplicationDemo ' + 'Failed to enable the listener for window size changes. Cause: ' + JSON.stringify(exception));
    }
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    console.log('[Demo] MainAbility onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    console.log('[Demo] MainAbility onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    console.log('[Demo] MainAbility onBackground');
  }
};
