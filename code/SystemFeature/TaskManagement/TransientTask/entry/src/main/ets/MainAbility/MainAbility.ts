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
import backgroundTaskManager from '@ohos.backgroundTaskManager'
import quickFixManager from '@ohos.app.ability.quickFixManager'
import Logger from '../util/Logger'

const TAG: string = 'MainAbility'
const PATH: string = '/data/storage/el2/base/haps/entry-signed-release.hqf'

let demandId

// cancel suspend delay
function cancelSuspendDelay() {
  backgroundTaskManager.cancelSuspendDelay(demandId)
}

// quick fix
async function applyQuickFix() {
  try {
    await quickFixManager.applyQuickFix([PATH])
    Logger.info(TAG, `applyQuickFix success`)
  } catch (error) {
    Logger.info(TAG, `applyQuickFix err: + ${JSON.stringify(error)}`)
  }
}

export default class MainAbility extends UIAbility {
  onCreate(want, launchParam) {
    Logger.info(TAG, `onCreate`)
    let status = want.parameters
    AppStorage.SetOrCreate('status', status)
    AppStorage.SetOrCreate('filePath', this.context.filesDir)
  }

  onDestroy() {
    Logger.info(TAG, `onDestroy`)
  }

  onWindowStageCreate(windowStage: Window.WindowStage) {
    // Main window is created, set main page for this ability
    Logger.info(TAG, `onWindowStageCreate`)
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.info(TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`)
        return
      }
      Logger.info(TAG, `Succeeded in loading the content. Data:  ${JSON.stringify(data)}`)
    })
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, `onWindowStageDestroy`)
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info(TAG, `onForeground`)
  }

  onBackground() {
    // Ability has back to background
    Logger.info(TAG, `onBackground`)
    // quick fix
    Logger.info(TAG, `onBackground applyQuickFix`)
    applyQuickFix()
    // cancel suspend delay
    cancelSuspendDelay()
  }
}
