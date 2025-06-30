/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { window } from '@kit.ArkUI'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
import Logger from '../common/utils/Logger'
import { hilog } from '@kit.PerformanceAnalysisKit'

const TAG: string = 'EntryAbility'

function requestPre() {
  let atManager = abilityAccessCtrl.createAtManager();
  try {
    atManager.requestPermissionsFromUser(globalThis.context,
      ['ohos.permission.CAMERA',])
      .then((data) => {
        Logger.info('requestPre() data: ' + JSON.stringify(data));
      }).catch((err: BusinessError) => {
      Logger.info('requestPre() data: ' + JSON.stringify(err));
    })
  } catch (err) {
    Logger.error('requestPre() data: ' + JSON.stringify(err));
  }
}

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    Logger.info('Ability onCreate');
    globalThis.context = this.context;
    requestPre();
  }

  onDestroy() {
    Logger.info('Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    Logger.info('Ability onWindowStageCreate');

    windowStage.getMainWindowSync().setWindowKeepScreenOn(true);
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error('Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      AppStorage.setOrCreate('context', windowStage.getMainWindowSync().getUIContext());
      Logger.info('Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    })
    let windowClass: window.Window = windowStage.getMainWindowSync(); // 获取应用主窗口
    // Set the window to full screen
    let isLayoutFullScreen = true;
    windowClass.setWindowLayoutFullScreen(isLayoutFullScreen)
      .then(() => {
        hilog.info(0x0000, TAG, 'Succeeded in setting the window layout to full-screen mode. Data: %{public}s');
      })
      .catch((err: BusinessError) => {
        hilog.error(0x0000, TAG, 'Failed to set the window layout to full-screen mode. Cause: %{public}s',
          JSON.stringify(err) ?? '');
      })
    // Set the font color of the status bar.
    let systemBarProperties: window.SystemBarProperties = {
      statusBarContentColor: '#FFFFFF'
    };
    windowStage.getMainWindowSync().setWindowSystemBarProperties(systemBarProperties);
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
