/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import { logger } from '@ohos/notification'

const TAG: string = 'MainAbility'

export default class MainAbility extends Ability {
  onCreate(want, launchParam) {
    logger.info(TAG, 'Ability onCreate')
  }

  onDestroy() {
    logger.info(TAG, 'Ability onDestroy')
  }

  onWindowStageCreate(windowStage: Window.WindowStage) {
    // Main window is created, set main page for this ability
    logger.info(TAG, 'Ability onWindowStageCreate')
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        logger.info(TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '')
        return;
      }
      logger.info(TAG, 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '')
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    logger.info(TAG, 'Ability onWindowStageDestroy')
  }

  onForeground() {
    // Ability has brought to foreground
    logger.info(TAG, 'Ability onForeground')
  }

  onBackground() {
    // Ability has back to background
    logger.info(TAG, 'Ability onBackground')
  }
}
