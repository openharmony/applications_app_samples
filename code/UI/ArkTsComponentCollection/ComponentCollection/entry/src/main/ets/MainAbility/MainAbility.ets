/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import UIAbility from '@ohos.app.ability.UIAbility'
import Logger from '../util/Logger'
import window from '@ohos.window';
import { KeyboardAvoidMode } from '@ohos.arkui.UIContext';
import { AbilityConstant } from '@kit.AbilityKit';

const TAG: string = 'MainAbility'

export default class MainAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    Logger.info(TAG, 'onCreate');
    AppStorage.setOrCreate('context', this.context);
  }

  onDestroy() {
    Logger.info(TAG, 'onDestroy')
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    Logger.info(TAG, 'onWindowStageCreate')
    try {
      let windowClass: window.Window | undefined = undefined;
      window.getLastWindow(this.context, (err, data) => {
        if (err.code) {
          Logger.error('Failed to obtain the top window. Cause: ' + JSON.stringify(err));
          return;
        }
        Logger.info('Succeeded in obtaining the top window. Data: ' + JSON.stringify(data));
        windowClass = data;
        let systemBarProperties: window.SystemBarProperties = {};
        windowClass.setWindowSystemBarProperties(systemBarProperties, (err) => {
          if (err.code) {
            Logger.error('Failed to set the system bar properties. Cause: ' + JSON.stringify(err));
            return;
          }
          Logger.info('Succeeded in setting the system bar properties.');
        })
        windowClass.on('keyboardHeightChange', (data: number) => {
          AppStorage.setOrCreate('keyboardHeight', data);
        })
      })
    } catch (exception) {
      Logger.error('Failed to obtain the top window. Cause: ' + JSON.stringify(exception));
    }
    windowStage.loadContent('pages/Index', (err, data) => {
      let a = windowStage.getMainWindowSync().getUIContext().getKeyboardAvoidMode();
      windowStage.getMainWindowSync().getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.OFFSET);
      if (err) {
        Logger.error(TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`)
        return
      }
      Logger.info(TAG, `Succeeded in loading the content. Data: ${JSON.stringify(data)}`)
    })
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, 'onWindowStageDestroy')
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info(TAG, 'onForeground')
  }

  onBackground() {
    // Ability has back to background
    Logger.info(TAG, 'onBackground')
  }
}