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

import Ability from '@ohos.app.ability.UIAbility';
import type Window from '@ohos.window';
import vibrator from '@ohos.vibrator';
import Logger from '../module/Logger';

const TAG = '[EntryAbility]';

export default class EntryAbility extends Ability {
  onCreate(want, launchParam) {
    Logger.info(TAG, 'Ability onCreate, want param: %{public}s, launchParam: %{public}s',
      JSON.stringify(want) ?? '', JSON.stringify(launchParam) ?? '');

    vibrator.isSupportEffect('haptic.clock.timer', (error, data) => {
      if (data) {
        vibrator.startVibration({
          type: 'preset',
          effectId: 'haptic.clock.timer',
          count: 1,
        }, {
          usage: 'notification'
        });
      } else {
        Logger.info(TAG, 'Failed to vibrate onCreate');
      }
    });
  }

  onDestroy() {
    Logger.info(TAG, 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: Window.WindowStage) {
    // Main window is created, set main page for this ability
    Logger.info(TAG, 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error(TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      Logger.info(TAG, 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info(TAG, '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    Logger.info(TAG, '%{public}s', 'Ability onBackground');
  }
}
