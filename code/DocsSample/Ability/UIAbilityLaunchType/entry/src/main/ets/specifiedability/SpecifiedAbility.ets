/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { UIAbility, AbilityConstant, Want, Context } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import Logger from '../common/Logger';

const TAG = '[SpecifiedAbility]';

interface Data {
  context: Context;
  launchWant: Want;
}

export default class SpecifiedAbility extends UIAbility {
  private want: Want | null = null;
  private getAbilityDataCallback: Function | undefined = undefined;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Logger.info(TAG, 'SpecifiedAbility onCreate');
    this.want = want;
    this.context.eventHub.on('getAbilityData', this.getAbilityDataCallback = (data: Data): void => {
      Logger.info(TAG, 'SpecifiedAbility' + JSON.stringify(data));
      data.context = this.context;
      data.launchWant = want;
    })
  }

  onDestroy() {
    Logger.info(TAG, 'SpecifiedAbility onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    Logger.info(TAG, 'SpecifiedAbility onWindowStageCreate');
    let target =
      this.want && this.want.parameters && this.want.parameters.target ? this.want.parameters.target : 'pages/Home';
    windowStage.loadContent('pages/SpecifiedPage', (err, data) => {
      if (err.code) {
        Logger.info(TAG, 'Failed to load the content. Cause:' + JSON.stringify(err));
        return;
      }
      Logger.info(TAG, 'Succeeded in loading the content. Data: ' + JSON.stringify(data));
    })
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, 'SpecifiedAbility onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info(TAG, 'SpecifiedAbility onForeground');
  }

  onBackground() {
    // Ability has back to background
    Logger.info(TAG, 'SpecifiedAbility onBackground');
  }
}
