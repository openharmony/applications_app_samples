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

import Ability from '@ohos.application.Ability'
import Window from '@ohos.window'
import HiLog from '../common/HiLog'

const TAG = 'EntryAbility'

export default class EntryAbility extends Ability {
  onCreate(want, launchParam) {
    HiLog.info(TAG, 'Ability onCreate')
    HiLog.info(TAG, `want param: ${JSON.stringify(want)}`)
    HiLog.info(TAG, `launchParam:${JSON.stringify(launchParam)}`)
  }

  onDestroy() {
    HiLog.info(TAG, 'Ability onDestroy')
  }

  onWindowStageCreate(windowStage: Window.WindowStage) {
    // Main window is created, set main page for this ability
    HiLog.info(TAG, 'Ability onWindowStageCreate')

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        HiLog.error(TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`)
        return
      }
      HiLog.info(TAG, `Succeeded in loading the content. Data: ${JSON.stringify(data)}`)
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    HiLog.info(TAG, 'Ability onWindowStageDestroy')
  }

  onForeground() {
    // Ability has brought to foreground
    HiLog.info(TAG, 'Ability onForeground')
  }

  onBackground() {
    // Ability has back to background
    HiLog.info(TAG, 'Ability onBackground')
  }
}
