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

import Logger from '../model/Logger'
import UIAbility from '@ohos.app.ability.UIAbility'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
import type { Permissions } from '@ohos.abilityAccessCtrl'

const TAG: string = '[MainAbility]'

export default class MainAbility extends UIAbility {
  async onCreate(want, launchParam) {
    Logger.info(TAG, `[Demo] MainAbility onCreate`)
    const PERMISSIONS: Array<Permissions> = ['ohos.permission.GET_NETWORK_INFO']

    let atManager = abilityAccessCtrl.createAtManager()
    try {
      atManager.requestPermissionsFromUser(this.context, PERMISSIONS).then((data) => {
        Logger.info(TAG, `data: ${JSON.stringify(data)}`)
      }).catch((err) => {
        Logger.info(TAG, `err: ${JSON.stringify(err)}`)
      })
    } catch (err) {
      Logger.info(TAG, `catch err->${JSON.stringify(err)}`);
    }
  }

  onDestroy() {
    Logger.info(TAG, `[Demo] MainAbility onDestroy`)
  }

  onWindowStageCreate(windowStage) {
    // Main window is created, set main page for this ability
    Logger.info(TAG, `[Demo] MainAbility onWindowStageCreate`)

    windowStage.setUIContent(this.context, 'pages/Index', null)
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, `[Demo] MainAbility onWindowStageDestroy`)
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info(TAG, `[Demo] MainAbility onForeground`)
  }

  onBackground() {
    // Ability has back to background
    Logger.info(TAG, `[Demo] MainAbility onBackground`)
  }
};
