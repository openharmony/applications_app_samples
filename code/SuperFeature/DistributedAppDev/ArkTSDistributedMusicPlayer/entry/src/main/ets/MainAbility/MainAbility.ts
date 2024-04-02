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
import UIAbility from '@ohos.app.ability.UIAbility'
import Logger from '../model/Logger'
import window from '@ohos.window'

const TAG: string = 'MainAbility'

export default class MainAbility extends UIAbility {
  onCreate(want, launchParam) {
    Logger.info(TAG, '[Demo] MainAbility onCreate')
    let status = want.parameters
    AppStorage.setOrCreate('status', status)
    AppStorage.setOrCreate('exitMusicApp', false);
    AppStorage.setOrCreate('remoteServiceExtensionConnectEvent', false);
    AppStorage.setOrCreate('musicPlay', false);
    AppStorage.setOrCreate('musicPause', false);
  }

  onDestroy() {
    Logger.info(TAG, '[Demo] MainAbility onDestroy')
    let exitMusicApp = AppStorage.get('exitMusicApp');
    if (exitMusicApp !== undefined) {
      AppStorage.setOrCreate('exitMusicApp',!exitMusicApp);
    }
  }

  onWindowStageCreate(windowStage) {
    // Main window is created, set main page for this ability
    Logger.info(TAG, '[Demo] MainAbility onWindowStageCreate');
    try {
      let promise = window.getLastWindow(this.context);
      promise.then((data) => {
        let isLayoutFullScreen = true;
        try {
          data.setWindowLayoutFullScreen(isLayoutFullScreen, (err) => {
            if (err.code) {
              Logger.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err));
              return;
            }
            Logger.info('Succeeded in setting the window layout to full-screen mode.');
          });
        } catch (exception) {
          Logger.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(exception));
        }
        Logger.info('Succeeded in obtaining the top window. Data: ' + JSON.stringify(data));
      }).catch((err) => {
        Logger.error('Failed to obtain the top window. Cause: ' + JSON.stringify(err));
      });
    } catch (exception) {
      Logger.error('Failed to obtain the top window. Cause: ' + JSON.stringify(exception));
    }
    windowStage.setUIContent(this.context, 'pages/Index', null);
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, '[Demo] MainAbility onWindowStageDestroy')
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info(TAG, '[Demo] MainAbility onForeground')
  }

  onBackground() {
    // Ability has back to background
    Logger.info(TAG, '[Demo] MainAbility onBackground')
  }

  onBackPressed() {
    Logger.info(TAG, '[Demo] MainAbility onBackPressed');
    return false;
  }
};
