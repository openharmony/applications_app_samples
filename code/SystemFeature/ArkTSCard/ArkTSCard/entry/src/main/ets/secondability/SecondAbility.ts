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

import UIAbility from '@ohos.app.ability.UIAbility';
import type window from '@ohos.window';
import type Want from '@ohos.app.ability.Want';
import type AbilityConstant from '@ohos.app.ability.AbilityConstant';
import Logger from '../util/Logger';

export default class FeaAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    if (want.parameters.data === 'static') {
      AppStorage.setOrCreate('isStatic', true);
    } else if (want.parameters.data === 'dynamic') {
      AppStorage.setOrCreate('isStatic', false);
    };
  }

  onDestroy(): void {
    Logger.info('second Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    Logger.info('second Ability onWindowStageCreate');
    windowStage.loadContent('pages/Music', (err, data) => {
      if (err.code) {
        Logger.error(JSON.stringify(err) ?? '');
        return;
      };
      Logger.info(JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Logger.info('Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info('Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info('Ability onBackground');
  }
}
