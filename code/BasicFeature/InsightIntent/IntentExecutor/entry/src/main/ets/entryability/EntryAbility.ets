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
import Base from '@ohos.base';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import { logger } from '../util/Logger';
import PlayMusicIntentExecutorImpl from '../intents/PlayMusicIntentExecutorImpl';

const TAG: string = '[EntryAbility]';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    logger.info(TAG, `Ability onCreate want: ${JSON.stringify(want)}, launchParam: ${JSON.stringify(launchParam)}`);
    PlayMusicIntentExecutorImpl.length;
  }

  onDestroy() {
    logger.info(TAG, 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    logger.info(TAG, 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/Index', (err: Base.BusinessError) => {
      if (err.code) {
        logger.info(TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    logger.info(TAG, 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    logger.info(TAG, 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    logger.info(TAG, 'Ability onBackground');
  }
}
