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

import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';
import Want from '@ohos.app.ability.Want';
import { logger } from '../util/Logger';

export default class NewAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    windowStage.loadContent('pages/New', () => {
    });
    windowStage.getMainWindow((err, windowClass) => {
      if (err.code) {
        return;
      }
      windowClass.setWindowLayoutFullScreen(true);
    })
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    AppStorage.setOrCreate('want', want);
    AppStorage.setOrCreate('launchParam', launchParam);
    logger.info(`NewAbility onCreate ${want.bundleName},${launchParam.launchReason}`);
  }

  onDestroy() {
    logger.info(`NewAbility onDestroy`);
  }

  onWindowStageDestroy() {
    logger.info(`NewAbility onWindowStageDestroy`);
    // Main window is destroyed, release UI related resources
  }

  onForeground() {
    logger.info(`NewAbility onForeground`);
    // Ability has brought to foreground
  }

  onBackground() {
    logger.info(`NewAbility onBackground`);
    // Ability has back to background
  }
}
