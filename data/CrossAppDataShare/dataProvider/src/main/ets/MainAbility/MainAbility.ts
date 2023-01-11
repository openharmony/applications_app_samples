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

import Ability from '@ohos.app.ability.UIAbility'
import Window from '@ohos.window'
import { contactDataShareUtil, logger } from '@ohos/common'

const TAG: string = 'MainAbility'

export default class MainAbility extends Ability {
  onCreate(want, launchParam) {
    logger.info(TAG, 'onCreate')
  }

  onDestroy() {
    logger.info(TAG, 'onDestroy')
  }

  onWindowStageCreate(windowStage: Window.WindowStage) {
    // Main window is created, set main page for this ability
    logger.info(TAG, 'onWindowStageCreate')
    this.loadContent(windowStage)
  }

  loadContent = async (windowStage: Window.WindowStage) => {
    await contactDataShareUtil.createDataShareHelper(this.context)
    windowStage.loadContent('pages/Home', (err, data) => {
      if (err.code) {
        logger.info(TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '')
        return;
      }
      logger.info(TAG, 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '')
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    logger.info(TAG, 'onWindowStageDestroy')
  }

  onForeground() {
    // Ability has brought to foreground
    logger.info(TAG, 'onForeground')
  }

  onBackground() {
    // Ability has back to background
    logger.info(TAG, 'onBackground')
  }
}
