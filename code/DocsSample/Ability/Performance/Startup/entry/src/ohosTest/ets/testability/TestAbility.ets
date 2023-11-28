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
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Hypium } from '@ohos/hypium';
import testsuite from '../test/List.test';
import window from '@ohos.window';
import Want from '@ohos.app.ability.Want';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import { logger } from '../util/Logger';

export default class TestAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    logger.info('TestAbility onCreate');
    logger.info('want param:' + JSON.stringify(want) ?? '');
    logger.info('launchParam:' + JSON.stringify(launchParam) ?? '');
    let abilityDelegator: AbilityDelegatorRegistry.AbilityDelegator;
    abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
    let abilityDelegatorArguments: AbilityDelegatorRegistry.AbilityDelegatorArgs;
    abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments();
    logger.info('start run testcase!!!');
    Hypium.hypiumTest(abilityDelegator, abilityDelegatorArguments, testsuite);
  }

  onDestroy() {
    logger.info('TestAbility onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    logger.info('TestAbility onWindowStageCreate');
    windowStage.loadContent('testability/pages/Index', (err, data) => {
      if (err.code) {
        logger.error('Failed to load the content. Cause: ' + JSON.stringify(err) ?? '');
        return;
      }
      logger.info('Succeeded in loading the content. Data: ' + JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    logger.info('TestAbility onWindowStageDestroy');
  }

  onForeground() {
    logger.info('TestAbility onForeground');
  }

  onBackground() {
    logger.info('TestAbility onBackground');
  }
}