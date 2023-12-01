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
import window from '@ohos.window';
import Logger from '../logger/Logger';

const TAG = 'EntryAbility';

export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {
    Logger.info(TAG, `Ability onCreate want: ${JSON.stringify(want)}`, `launchParam: ${JSON.stringify(launchParam)}`);
  }

  onDestroy() {
    Logger.info(TAG, 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    Logger.info(TAG, 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`);
        return;
      }
      Logger.info(TAG, `Succeeded in loading the content. Data: ${JSON.stringify(data)}`);
    });
  }

  onWindowStageDestroy() {
    Logger.info(TAG, 'Ability onWindowStageDestroy');
  }

  onForeground() {
    Logger.info(TAG, 'Ability onForeground');
  }

  onBackground() {
    Logger.info(TAG, 'Ability onBackground');
  }
}
