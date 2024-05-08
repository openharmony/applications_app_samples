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
import Logger from '../../common/Logger';

PersistentStorage.PersistProp('processConditionID', '000000');

export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {
    Logger.info('[EntryAbility]', `Ability onCreate. want: ${JSON.stringify(want)}`);
  }

  onDestroy() {
    Logger.info('[EntryAbility]', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    Logger.info('[EntryAbility]', 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error('[EntryAbility]', `Failed to load the content. Cause: ${JSON.stringify(err)}`);
        return;
      }
      Logger.info('[EntryAbility]', `Succeeded in loading the content. Data: ${JSON.stringify(data)}`);
    });
  }

  onWindowStageDestroy() {
    Logger.info('[EntryAbility]', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    Logger.info('[EntryAbility]', 'Ability onForeground');
  }

  onBackground() {
    Logger.info('[EntryAbility]', 'Ability onBackground');
  }
};
