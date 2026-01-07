/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { abilityAccessCtrl, AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { router, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from '../common/utils/Logger';
import { GlobalContext } from '../common/utils/GlobalContext';
import CameraService from '../model/CameraService';
import { Constants } from '../common/Constants';

const TAG = 'EntryAbility';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Logger.info(TAG, 'Ability onCreate');
    GlobalContext.get().setCameraSettingContext(this.context);
  }

  onDestroy(): void {
    Logger.info(TAG, 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability.
    Logger.info(TAG, 'Ability onWindowStageCreate');
    this.requestPermissionsFn();
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.info(TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      Logger.info(TAG, 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
    windowStage.getMainWindow().then((win: window.Window): void => {
      win.setWindowLayoutFullScreen(true).then((): void => {
        win.setWindowSystemBarEnable([]).then((): void => {
        });
      });
      win.setWindowSystemBarProperties({
        statusBarContentColor: '#ffffff',
        navigationBarContentColor: '#ffffff'
      })
      GlobalContext.get().setPromptAction(win.getUIContext().getPromptAction());
    });
    AppStorage.setOrCreate<boolean>('isFirstRecording', true);
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources.
    Logger.info(TAG, 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground.
    Logger.info(TAG, 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background.
    Logger.info(TAG, 'Ability onBackground');
    AppStorage.setOrCreate<boolean>('isOpenEditPage', false);
    Logger.info(TAG, `Ability onBackground ${router.getState().name}`);
    if (router.getState().name !== Constants.EDIT_PAGE_NAME) {
      CameraService.deleteVideoFile();
    }
  }

  /**
   * Get Permissions
   */
  requestPermissionsFn(): void {
    let atManager = abilityAccessCtrl.createAtManager();
    atManager.requestPermissionsFromUser(this.context, [
      'ohos.permission.CAMERA',
      'ohos.permission.MICROPHONE',
      'ohos.permission.WRITE_MEDIA'
    ]).then((): void => {
      AppStorage.setOrCreate<boolean>('isShow', true);
      Logger.info(TAG, 'request Permissions success!');
    }).catch((error: BusinessError): void => {
      Logger.info(TAG, `requestPermissionsFromUser call Failed! error: ${error.code}`);
    });
  }
}
