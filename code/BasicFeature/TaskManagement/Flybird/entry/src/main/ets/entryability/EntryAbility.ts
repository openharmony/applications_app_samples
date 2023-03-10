/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import Window from '@ohos.window'
import backgroundTaskManager from '@ohos.backgroundTaskManager';
import Logger from '../model/Logger'

const TAG = "EntryAbility"

export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {
    Logger.info(TAG, 'Ability onCreate')
    Logger.info(TAG, `want param: ${JSON.stringify(want)}`)
    Logger.info(TAG, `launchParam:${JSON.stringify(launchParam)}`)
  }

  onDestroy() {
    Logger.info(TAG, 'Ability onDestroy')
  }

  onWindowStageCreate(windowStage: Window.WindowStage) {
    // Main window is created, set main page for this ability
    Logger.info(TAG, 'Ability onWindowStageCreate')

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`)
        return
      }
      Logger.info(TAG, `Succeeded in loading the content. Data: ${JSON.stringify(data)}`)
    })
  }

  onInactive() {
    Logger.info(TAG, ' Application onInactive')
    let myReason = 'test requestSuspendDelay'
    let delayInfo = backgroundTaskManager.requestSuspendDelay(myReason, () => {
      Logger.info(TAG, " Request suspension delay will time out.")
    });
    if (delayInfo && delayInfo.requestId) {
      Logger.info(TAG, `delayInfo: ${delayInfo.requestId}`)
    }
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, 'Ability onWindowStageDestroy')
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info(TAG, 'Ability onForeground')
  }

  onBackground() {
    // Ability has back to background
    Logger.info(TAG, 'Ability onBackground')
  }
}
