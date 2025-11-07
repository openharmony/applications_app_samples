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
import { emitter } from '@kit.BasicServicesKit';
import Logger from '../common/Logger';
import Constant from '../common/Constants';

const TAG = '[SingletonAbility]';
const eventId = Constant.DEFAULT_ONE;

interface Data {
  context: Context;
  launchWant: Want;
}

export default class SingletonAbility extends UIAbility {
  private getAbilityDataCallback: Function | undefined = undefined;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    const that = this;
    this.context.eventHub.on('getAbilityData', this.getAbilityDataCallback = (data: Data): void => {
      data.context = that.context;
      data.launchWant = want;
    });
  }

  onDestroy() {
    Logger.info(TAG, 'SingletonAbility onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    Logger.info(TAG, 'SingletonAbility onWindowStageCreate');

    windowStage.loadContent('pages/SingletonPage', (err, data) => {
      if (err.code) {
        Logger.info(TAG, 'Failed to load the content. Cause:' + JSON.stringify(err));
        return;
      }
      Logger.info(TAG, 'Succeeded in loading the content. Data: ' + JSON.stringify(data));
    })
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Logger.info(TAG, 'SingletonAbility onNewWant');
    if (want && want.parameters) {
      let eventData: emitter.EventData = {
        data: {
          'foodItemId': null
        }
      };
      let innerEvent: emitter.InnerEvent = {
        eventId,
        priority: emitter.EventPriority.HIGH
      };
      // If the obtained ID is equal to 0, it is assigned a value of 1 and passed to the front-end,
      // which retrieves the corresponding data based on this ID.
      if (want.parameters.foodItemId == 0) {
        want.parameters.foodItemId = 1;
        eventData.data!.foodItemId = want.parameters.foodItemId;
        emitter.emit(innerEvent, eventData);
      } else {
        want.parameters.foodItemId = 0;
        eventData.data!.foodItemId = want.parameters.foodItemId;
        emitter.emit(innerEvent, eventData);
      }
    }
  }

  onWindowStageDestroy() {
    Logger.info(TAG, 'SingletonAbility onWindowStageDestroy');
  }

  onForeground() {
    Logger.info(TAG, 'SingletonAbility onForeground');
  }

  onBackground() {
    // Ability has back to background
    Logger.info(TAG, 'SingletonAbility onBackground');
  }
}
