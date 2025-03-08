/*
* Copyright (c) 2023-2025 Hunan OpenValley Digital Industry Development Co., Ltd.
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
import abilityAccessCtrl, { Context } from '@ohos.abilityAccessCtrl';
import type { Permissions } from '@ohos.abilityAccessCtrl';
import Log from '../utils/Log';
import Want from '@ohos.app.ability.Want';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import { GlobalContext } from '../utils/GlobalContext';

const TAG = '[Sample_EntryAbility]';

const PERMISSION_LIST: Permissions[] = [
  'ohos.permission.APPROXIMATELY_LOCATION',
  'ohos.permission.LOCATION',
  'ohos.permission.ACCESS_BLUETOOTH'
];

export default class EntryAbility extends UIAbility {
  private mWindow: window.Window | null = null;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    Log.showInfo(TAG, 'onCreate');
    GlobalContext.getContext().setObject('context', this.context);
    GlobalContext.getContext().setObject('orientation', window.Orientation.AUTO_ROTATION_LANDSCAPE);
  }

  onDestroy() {
    Log.showInfo(TAG, 'onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // Main window is created, set main page for this ability
    Log.showInfo(TAG, 'onWindowStageCreate');

    // 获取窗口实例
    try {
      this.mWindow = windowStage.getMainWindowSync();
    } catch (exception) {
      Log.showError(TAG, `Failed to obtain the main window. Cause code: ${exception.code}, message: ${exception.message}`);
    }
    if (!this.mWindow) {
      Log.showError(TAG, 'onWindowStageCreate: Main window is not available');
      return;
    }

    // 存入 GlobalContext
    GlobalContext.getContext().setMainWindow(this.mWindow);

    windowStage.loadContent('pages/Main', (err, data) => {
      if (err.code) {
        Log.showInfo(TAG, `onWindowStageCreate: Failed to load the content. Cause: ${JSON.stringify(err) ?? ''}`);
        return;
      }
      Log.showInfo(TAG, `onWindowStageCreate: Succeeded in loading the content. Data: ${JSON.stringify(data) ?? ''}`);
    });

    // 监听窗口大小变化
    this.mWindow.on('windowSizeChange', (size: window.Size) => {
      Log.showInfo(TAG, `onWindowSizeChange: size = ${JSON.stringify(size)}`);
      AppStorage.SetOrCreate('windowSize', size);
    });

    // 获取context
    let context = GlobalContext.getContext().getObject('context') as Context
    if (!context) {
      Log.showError(TAG, 'aboutToAppear: context is undefined, cannot request permissions');
      return;
    }

    // 请求权限
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    try {
      let permissionResult = await atManager.requestPermissionsFromUser(context, PERMISSION_LIST);
      Log.showInfo(TAG, `onWindowStageCreate: Permission request result: ${JSON.stringify(permissionResult)}`);
    } catch (err) {
      Log.showError(TAG, `onWindowStageCreate: Failed to request permissions, error: ${err.message}`);
    }

    // 设置屏幕方向
    let orientation = GlobalContext.getContext().getObject('orientation') as number;
    if (orientation !== undefined) {
      await GlobalContext.getContext().setOrientation(orientation);
    } else {
      Log.showError(TAG, 'onWindowStageCreate: Orientation is undefined');
    }
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Log.showInfo(TAG, 'onWindowStageDestroy');
    if (this.mWindow) {
      try {
        this.mWindow.off('windowSizeChange');
      } catch (err) {
        Log.showError(TAG, 'windowSizeChange destroy failed');
      }
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
