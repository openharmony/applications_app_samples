/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import testsuite from '../test/List.test';
import UIAbility from '@ohos.app.ability.UIAbility';
import type window from '@ohos.window';
import { Hypium } from '@ohos/hypium';
import { logger } from '../util/Logger';

const TAG: string = 'TestAbility';

export default class TestAbility extends UIAbility {
  onCreate(want, launchParam): void {
    logger.info(TAG, `TestAbility onCreate, want param: ${JSON.stringify(want)},launchParam: ${JSON.stringify(launchParam)}`);
    let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
    let abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments();
    logger.info(TAG, 'start run testcase!!!');
    Hypium.hypiumTest(abilityDelegator, abilityDelegatorArguments, testsuite);
  }

  onDestroy(): void {
    logger.info(TAG, 'TestAbility onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    logger.info(TAG, 'TestAbility onWindowStageCreate');
    windowStage.loadContent('testability/pages/Index', (err, data) => {
      if (err.code) {
        logger.error(TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`);
        return;
      }
      logger.info(TAG, `Succeeded in loading the content. Data: ${JSON.stringify(data) ?? ''}`);
    });
  }

  onWindowStageDestroy(): void {
    logger.info(TAG, 'TestAbility onWindowStageDestroy');
  }

  onForeground(): void {
    logger.info(TAG, 'TestAbility onForeground');
  }

  onBackground(): void {
    logger.info(TAG, 'TestAbility onBackground');
  }
}