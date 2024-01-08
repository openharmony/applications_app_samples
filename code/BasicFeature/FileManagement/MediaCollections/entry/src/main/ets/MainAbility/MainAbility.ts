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

import UIAbility from '@ohos.app.ability.UIAbility';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import type { Permissions } from '@ohos.abilityAccessCtrl';
import Logger from '../model/Logger';

const TAG: string = 'MainAbility';

export default class MainAbility extends UIAbility {
  async onCreate(want, launchParam) {
    Logger.info(TAG, '[Demo] MainAbility onCreate');
  }

  onDestroy() {
    Logger.info(TAG, '[Demo] MainAbility onDestroy');
  }

  async onWindowStageCreate(windowStage) {
    Logger.info(TAG, '[Demo] MainAbility onWindowStageCreate');
    let context = this.context;
    let permissionNames: Permissions[] = ['ohos.permission.MEDIA_LOCATION', 'ohos.permission.READ_MEDIA',
      'ohos.permission.WRITE_MEDIA'];
    let atManager = abilityAccessCtrl.createAtManager();
    await atManager.requestPermissionsFromUser(context, permissionNames).then((data) => {
      Logger.info(TAG, 'getPermission success');
    });
    windowStage.loadContent('pages/HomePage', (err, data) => {
      if (err.code) {
        Logger.info(TAG, 'Failed to load the content. Cause:' + JSON.stringify(err));
        return;
      }
      Logger.info(TAG, 'Succeeded in loading the content. index: ' + JSON.stringify(data));
    });
  }

  onWindowStageDestroy() {
    Logger.info(TAG, '[Demo] MainAbility onWindowStageDestroy');
  }

  onForeground() {
    Logger.info(TAG, '[Demo] MainAbility onForeground');
  }

  onBackground() {
    Logger.info(TAG, '[Demo] MainAbility onBackground');
  }
}
