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

import Ability from '@ohos.application.Ability'
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry'
import { Hypium } from '@ohos/hypium'
import testsuite from '../test/List.test'
import Window from '@ohos.window'
import HiLog from '../../../main/ets/common/HiLog'

const TAG = 'TestAbility'

export default class TestAbility extends Ability {
  onCreate(want, launchParam) {
    HiLog.info(TAG, 'TestAbility onCreate');
    HiLog.info(TAG, 'want param:' + JSON.stringify(want) ?? '');
    HiLog.info(TAG, 'launchParam:' + JSON.stringify(launchParam) ?? '');
    var abilityDelegator: any
    abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
    var abilityDelegatorArguments: any
    abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments()
    HiLog.info(TAG, 'start run testcase!!!');
    Hypium.hypiumTest(abilityDelegator, abilityDelegatorArguments, testsuite)
  }

  onDestroy() {
    HiLog.info(TAG, 'TestAbility onDestroy');
  }

  onWindowStageCreate(windowStage: Window.WindowStage) {
    HiLog.info(TAG, 'TestAbility onWindowStageCreate');
    windowStage.loadContent('testability/pages/Index', (err, data) => {
      if (err.code) {
        HiLog.error(TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      HiLog.info(TAG, 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    HiLog.info(TAG, 'TestAbility onWindowStageDestroy');
  }

  onForeground() {
    HiLog.info(TAG, 'TestAbility onForeground');
  }

  onBackground() {
    HiLog.info(TAG, 'TestAbility onBackground');
  }
}