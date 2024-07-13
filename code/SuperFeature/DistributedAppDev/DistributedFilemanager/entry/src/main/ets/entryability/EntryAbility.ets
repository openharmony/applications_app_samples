/*
 * Copyright (c) 2023-2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import DataObject from '../model/DataObject';
import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';
import Want from '@ohos.app.ability.Want';
import { Logger } from '@ohos/feature-file-manager';

let sessionId : string;

export default class EntryAbility extends UIAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    Logger.info('0x0000', 'testTag', '%{public}s', 'Ability onCreate');
    //user grant
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    try {
      let requestPermissionsResult = await atManager.requestPermissionsFromUser(this.context,
        ['ohos.permission.DISTRIBUTED_DATASYNC']);
      Logger.info(`requestPermissionsResult: ${JSON.stringify(requestPermissionsResult)}`);
    } catch (err) {
      Logger.error(`catch err: ${JSON.stringify(err)}`);
    }

    // 判断是否被拉起
    if (want.parameters && want.parameters.distributedSessionId) {
      sessionId = want.parameters.distributedSessionId as string;
      DataObject.createDataObject(this.context, sessionId);
    } else {
      DataObject.callRemote(this.context);
      DataObject.createDataObject(this.context);
    }
  }

  onDestroy() {
    Logger.info('0x0000', 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    Logger.info('0x0000', 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error('0x0000', 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      Logger.info('0x0000', 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info('0x0000', 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info('0x0000', 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    Logger.info('0x0000', 'testTag', '%{public}s', 'Ability onBackground');
  }
}
