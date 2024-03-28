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


import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import hilog from '@ohos.hilog';
import { Hypium } from '@ohos/hypium';
import window from '@ohos.window';
import testsuite from '../test/Ability.test';

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
let abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments();
const TAG = '[Sample_Notification]';
const DOMAIN = 0xF811

export default class TestAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    hilog.info(DOMAIN, TAG, 'TestAbility onCreate');
    hilog.info(DOMAIN, TAG, JSON.stringify(want));
    hilog.info(DOMAIN, TAG, JSON.stringify(launchParam));
    Hypium.hypiumTest(abilityDelegator, abilityDelegatorArguments, testsuite);
  }

  onDestroy() {
    hilog.info(DOMAIN, TAG, 'TestAbility onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    hilog.info(DOMAIN, TAG, 'TestAbility onWindowStageCreate');
    windowStage.loadContent('testability/pages/Index', (err) => {
      if (err.code) {
        return;
      }
    });
  }

  onWindowStageDestroy() {
    hilog.info(DOMAIN, TAG, 'TestAbility onWindowStageDestroy');
  }

  onForeground() {
    hilog.info(DOMAIN, TAG, 'TestAbility onForeground');
  }

  onBackground() {
    hilog.info(DOMAIN, TAG, 'TestAbility onBackground');
  }
}