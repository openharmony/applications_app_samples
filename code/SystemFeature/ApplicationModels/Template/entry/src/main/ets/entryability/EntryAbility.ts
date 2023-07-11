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
import Logger from '../model/Logger';

const TAG = '[Sample_EntryAbility]';

export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {
    Logger.info(TAG, `onCreate, want: ${JSON.stringify(want)},`, `launchParam: ${JSON.stringify(launchParam)}`);
    let flag = (typeof(want.parameters.sharedFlag) === 'boolean') ? want.parameters.sharedFlag : false;
    AppStorage.SetOrCreate('messages', want.parameters.shareMessages);
    AppStorage.SetOrCreate('sharedFlag', flag);
  }

  onNewWant(want, launchParam) {
    Logger.info(TAG, `onNewWant, want: ${JSON.stringify(want)},`, `launchParam: ${JSON.stringify(launchParam)}`);
    let flag = (typeof(want.parameters.sharedFlag) === 'boolean') ? want.parameters.sharedFlag : false;
    AppStorage.SetOrCreate('messages', want.parameters.shareMessages);
    AppStorage.SetOrCreate('sharedFlag', flag);
  }

  onDestroy() {
    Logger.info(TAG, 'onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    Logger.info(TAG, `onWindowStageCreate, windowStage: ${JSON.stringify(windowStage)}`);

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content, Cause: ${JSON.stringify(err)}`);
        return;
      }
      Logger.info(TAG, `Succeeded in loading the content, Data: ${JSON.stringify(data)}`);
    });
  }

  onWindowStageDestroy() {
    Logger.info(TAG, 'onWindowStageDestroy');
  }

  onForeground() {
    Logger.info(TAG, 'onForeground');
  }

  onBackground() {
    Logger.info(TAG, 'onBackground');
  }
}
