/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Hypium } from '@ohos/hypium';
import testsuite from '../test/List.test';
import Window from '@ohos.window';

const DOMAIN = 0x0001;
const TAG = 'testTag';
export default class TestAbility extends UIAbility {
  onCreate() {
    hilog.isLoggable(DOMAIN, TAG, hilog.LogLevel.INFO);
    hilog.info(DOMAIN, TAG, '%{public}s', 'TestAbility onCreate');
    let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
    let abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments();
    hilog.isLoggable(DOMAIN, TAG, hilog.LogLevel.INFO);
    hilog.info(DOMAIN, TAG, '%{public}s', 'start run testcase!!!');
    Hypium.hypiumTest(abilityDelegator, abilityDelegatorArguments, testsuite);
  }

  onDestroy() {
    hilog.isLoggable(DOMAIN, TAG, hilog.LogLevel.INFO);
    hilog.info(DOMAIN, TAG, '%{public}s', 'TestAbility onDestroy');
  }

  onWindowStageCreate(windowStage: Window.WindowStage) {
    hilog.isLoggable(DOMAIN, TAG, hilog.LogLevel.INFO);
    hilog.info(DOMAIN, TAG, '%{public}s', 'TestAbility onWindowStageCreate');
    windowStage.loadContent('testability/pages/Index', (err, data) => {
      if (err.code) {
        hilog.isLoggable(DOMAIN, TAG, hilog.LogLevel.ERROR);
        hilog.error(DOMAIN, TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.isLoggable(DOMAIN, TAG, hilog.LogLevel.INFO);
      hilog.info(DOMAIN, TAG, 'Succeeded in loading the content. Data: %{public}s',
          JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    hilog.isLoggable(DOMAIN, TAG, hilog.LogLevel.INFO);
    hilog.info(DOMAIN, TAG, '%{public}s', 'TestAbility onWindowStageDestroy');
  }

  onForeground() {
    hilog.isLoggable(DOMAIN, TAG, hilog.LogLevel.INFO);
    hilog.info(DOMAIN, TAG, '%{public}s', 'TestAbility onForeground');
  }

  onBackground() {
    hilog.isLoggable(DOMAIN, TAG, hilog.LogLevel.INFO);
    hilog.info(DOMAIN, TAG, '%{public}s', 'TestAbility onBackground');
  }
}