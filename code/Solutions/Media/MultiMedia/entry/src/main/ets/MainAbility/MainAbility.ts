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
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
import type { Permissions } from '@ohos.abilityAccessCtrl'
import Logger from '../model/Logger'

const TAG: string = 'MainAbility'
const PERMISSIONS: Array<Permissions> = [
  'ohos.permission.CAMERA',
  'ohos.permission.MICROPHONE',
  'ohos.permission.READ_MEDIA',
  'ohos.permission.WRITE_MEDIA',
  'ohos.permission.MEDIA_LOCATION'];

export default class MainAbility extends UIAbility {
  onCreate(want, launchParam) {
    Logger.info(TAG, 'MainAbility onCreate');
    AppStorage.SetOrCreate('context', this.context);
  }

  onDestroy() {
    Logger.info(TAG, 'MainAbility onDestroy')
  }

  async onWindowStageCreate(windowStage): Promise<void> {
    // Main window is created, set main page for this ability
    Logger.info(TAG, 'MainAbility onWindowStageCreate');
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    await atManager.requestPermissionsFromUser(this.context, PERMISSIONS);
    windowStage.setUIContent(this.context, 'pages/Index', null);
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, 'MainAbility onWindowStageDestroy')
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info(TAG, 'MainAbility onForeground')
  }

  onBackground() {
    // Ability has back to background
    Logger.info(TAG, 'MainAbility onBackground')
  }
}
