/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import hilog from '../model/Logger'
import UIAbility from '@ohos.app.ability.UIAbility';
import Window from '@ohos.window'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import type { Permissions } from '@ohos.abilityAccessCtrl';
import Want from '@ohos.app.ability.Want';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    hilog.info('Ability onCreate')
    const PERMISSIONS: Array<Permissions> = ['ohos.permission.LOCATION', 'ohos.permission.APPROXIMATELY_LOCATION'];
    try {
      abilityAccessCtrl.createAtManager().requestPermissionsFromUser(this.context, PERMISSIONS);
    } catch (err) {
      hilog.info(`catch err->${JSON.stringify(err)}`);
    }
  }

  onDestroy() {
    hilog.info('Ability onDestroy')
  }

  onWindowStageCreate(windowStage: Window.WindowStage) {
    hilog.info('Ability onWindowStageCreate')
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(`Failed to load the content. Cause: ${JSON.stringify(err)}`)
        return
      }
      hilog.info(`Succeeded in loading the content. Data: ${JSON.stringify(data)}`)
    })
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info('Ability onWindowStageDestroy')
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info('Ability onForeground')
  }

  onBackground() {
    // Ability has back to background
    hilog.info('Ability onBackground')
  }
}