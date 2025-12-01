/*
 * Copyright (c) 2022-2025 Huawei Device Co., Ltd.
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

import { abilityDelegatorRegistry } from '@kit.TestKit';
import { UIAbility, Want, AbilityConstant } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI'
import { Hypium } from '@ohos/hypium';
import testsuite from '../test/List.test';
import { Logger } from '../utils/Logger';
import { WorkSchedulerSystem } from '../../../main/ets/feature/WorkSchedulerSystem'

const VERSION: string = '1.0'

export default class TestAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    Logger.info('TestAbility onCreate');
    Logger.info('want param:' + JSON.stringify(want));
    Logger.info('launchParam:' + JSON.stringify(launchParam));
    let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator;
    abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
    let abilityDelegatorArguments: abilityDelegatorRegistry.AbilityDelegatorArgs;
    abilityDelegatorArguments = abilityDelegatorRegistry.getArguments();
    Logger.info('start run testcase!!!');
    Hypium.hypiumTest(abilityDelegator, abilityDelegatorArguments, testsuite);
  }

  onDestroy() {
    Logger.info('TestAbility onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    Logger.info('TestAbility onWindowStageCreate');
    WorkSchedulerSystem.handleNotification()
    let filePath = `${this.context.filesDir.split('/haps')[0]}/files`
    WorkSchedulerSystem.startUpdateSample(VERSION, filePath)
    windowStage.loadContent('testability/pages/Index', (err, data) => {
      if (err.code) {
        Logger.error('Failed to load the content. Cause: ' + JSON.stringify(err));
        return;
      }
      Logger.info('Succeeded in loading the content. Data: ' + JSON.stringify(data));
    });
  }

  onWindowStageDestroy() {
    Logger.info('TestAbility onWindowStageDestroy');
  }

  onForeground() {
    Logger.info('TestAbility onForeground');
  }

  onBackground() {
    Logger.info('TestAbility onBackground');
  }
}