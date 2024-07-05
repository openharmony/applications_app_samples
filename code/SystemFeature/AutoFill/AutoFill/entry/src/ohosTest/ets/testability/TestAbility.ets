/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import { Hypium } from '@ohos/hypium';
import testsuite from '../test/List.test';
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { abilityDelegatorRegistry } from '@kit.TestKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = 'testAbility';
const DOMAIN_NUMBER: number = 0xFF00;

export default class TestAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    hilog.info(DOMAIN_NUMBER, TAG, 'TestAbility onCreate');
    hilog.info(DOMAIN_NUMBER, TAG, 'want param:' + JSON.stringify(want) ?? '');
    hilog.info(DOMAIN_NUMBER, TAG, 'launchParam:' + JSON.stringify(launchParam) ?? '');
    let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator;
    abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
    let abilityDelegatorArguments: abilityDelegatorRegistry.AbilityDelegatorArgs;
    abilityDelegatorArguments = abilityDelegatorRegistry.getArguments();
    hilog.info(DOMAIN_NUMBER, TAG, 'start run testcase!!!');
    Hypium.hypiumTest(abilityDelegator, abilityDelegatorArguments, testsuite);
  }

  onDestroy() {
    hilog.info(DOMAIN_NUMBER, TAG, 'TestAbility onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    hilog.info(DOMAIN_NUMBER, TAG, 'TestAbility onWindowStageCreate');
    windowStage.loadContent('testability/pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(DOMAIN_NUMBER, TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    hilog.info(DOMAIN_NUMBER, TAG, 'TestAbility onWindowStageDestroy');
  }

  onForeground() {
    hilog.info(DOMAIN_NUMBER, TAG, 'TestAbility onForeground');
  }

  onBackground() {
    hilog.info(DOMAIN_NUMBER, TAG, 'TestAbility onBackground');
  }
}