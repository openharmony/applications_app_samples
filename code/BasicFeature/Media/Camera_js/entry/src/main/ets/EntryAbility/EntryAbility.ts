/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import type window from '@ohos.window';
import deviceInfo from '@ohos.deviceInfo';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import type Want from '@ohos.app.ability.Want';
import type AbilityConstant from '@ohos.app.ability.AbilityConstant';
import { BusinessError } from '@ohos.base';
import Logger from '../model/Logger';
import { Constants } from '../common/Constants';
import UIAbility from '@ohos.app.ability.UIAbility';
import { GlobalContext } from '../common/GlobalContext';

const TAG: string = 'EntryAbility';

export default class EntryAbility extends UIAbility {

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Logger.info(TAG, 'Ability onCreate');
    Logger.debug(TAG, `want param: ${JSON.stringify(want)}`);
    Logger.debug(TAG, `launchParam: ${JSON.stringify(launchParam)}`);
    GlobalContext.get().setCameraSettingContext(this.context);
    GlobalContext.get().getCameraSettingContext();
  }

  onDestroy(): void {
    Logger.info(TAG, 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    Logger.info(TAG, 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/Index', (): void => {
      Logger.info(TAG, 'Succeeded in loading the content.');
    });
    this.requestPermissionsFn();
    AppStorage.setOrCreate<string>('deviceType', deviceInfo.deviceType);
    windowStage.getMainWindow().then((win: window.Window): void => {
      GlobalContext.get().setPromptAction(win.getUIContext().getPromptAction());
      Logger.debug(TAG, 'Succeeded get promptAction.');
      if (deviceInfo.deviceType === Constants.TABLET) {
        win.setWindowLayoutFullScreen(true).then((): void => {
          win.setWindowSystemBarEnable(['navigation']).then((): void => {
          });
        });
        win.setWindowSystemBarProperties({
          navigationBarColor: '#00000000',
          navigationBarContentColor: '#B3B3B3'
        })
          .then((): void => {
          });
      }
    });
  }

  /**
   * 获取权限
   */
  requestPermissionsFn(): void {
    let atManager = abilityAccessCtrl.createAtManager();
    atManager.requestPermissionsFromUser(this.context, [
      'ohos.permission.CAMERA',
      'ohos.permission.MICROPHONE',
      'ohos.permission.READ_MEDIA',
      'ohos.permission.WRITE_MEDIA',
      'ohos.permission.WRITE_IMAGEVIDEO',
      'ohos.permission.READ_IMAGEVIDEO'
    ]).then((): void => {
      AppStorage.setOrCreate<boolean>('isShow', true);
      Logger.info(TAG, 'request Permissions success!');
    }).catch((error: BusinessError): void => {
      Logger.info(TAG, `requestPermissionsFromUser call Failed! error: ${error.code}`);
    });
  }
}
