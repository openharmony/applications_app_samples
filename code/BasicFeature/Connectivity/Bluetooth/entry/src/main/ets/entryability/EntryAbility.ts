/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import type { Permissions } from '@ohos.abilityAccessCtrl';
import Log from '../utils/Log';

const TAG = '[Sample_EntryAbility]';

const PERMISSION_LIST: Array<Permissions> = [
  'ohos.permission.APPROXIMATELY_LOCATION',
  'ohos.permission.LOCATION'
];

export default class EntryAbility extends UIAbility {
  private mWindow: window.Window;

  onCreate(want, launchParam) {
    Log.showInfo(TAG, 'onCreate');
    globalThis.context = this.context;
  }

  onDestroy() {
    Log.showInfo(TAG, 'onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // Main window is created, set main page for this ability
    Log.showInfo(TAG, 'onWindowStageCreate');

    this.mWindow = windowStage.getMainWindowSync();

    windowStage.loadContent('pages/Main', (err, data) => {
      if (err.code) {
        Log.showInfo(TAG, `onWindowStageCreate: Failed to load the content. Cause: ${JSON.stringify(err) ?? ''}`);
        return;
      }
      Log.showInfo(TAG, `onWindowStageCreate: Succeeded in loading the content. Data: ${JSON.stringify(data) ?? ''}`);
    });

    globalThis.setOrientation = async (orientation: window.Orientation): Promise<void> => {
      await this.mWindow.setWindowSystemBarEnable(['status', 'navigation']);
      await this.mWindow.setPreferredOrientation(orientation);
    };

    this.mWindow.on('windowSizeChange', (size: window.Size) => {
      Log.showInfo(TAG, `onWindowSizeChange: size = ${JSON.stringify(size)}`);
      AppStorage.SetOrCreate('windowSize', size);
    });

    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    await atManager.requestPermissionsFromUser(globalThis.context, PERMISSION_LIST);
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Log.showInfo(TAG, 'onWindowStageDestroy');
    if (this.mWindow) {
      this.mWindow.off('windowSizeChange');
    }
  }

  onForeground() {
    // Ability has brought to foreground
    Log.showInfo(TAG, 'onForeground');
  }

  onBackground() {
    // Ability has back to background
    Log.showInfo(TAG, 'onBackground');
  }
}
