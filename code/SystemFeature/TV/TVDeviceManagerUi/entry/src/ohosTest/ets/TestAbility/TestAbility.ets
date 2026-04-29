/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { hilog } from '@kit.PerformanceAnalysisKit';
import Ability from '@ohos.application.Ability';
import { abilityDelegatorRegistry } from '@kit.TestKit';
import { Hypium } from '@ohos/hypium';
import { window } from '@kit.ArkUI';
import { Want } from '@kit.AbilityKit';
import { AbilityConstant } from '@kit.AbilityKit';
import testsuite from '../test/List.test';

export default class TestAbility extends Ability {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    hilog.info(0x0000, 'TVLauncherTest', 'TestAbility onCreate want %{public}s', JSON.stringify(want) ?? '');
    hilog.info(0x0000, 'TVLauncherTest', 'TestAbility launchParam %{public}s', JSON.stringify(launchParam) ?? '');

    let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator;
    abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
    let abilityDelegatorArguments: abilityDelegatorRegistry.AbilityDelegatorArgs;
    abilityDelegatorArguments = abilityDelegatorRegistry.getArguments();

    globalThis.testAppContext = this.context;
    Hypium.hypiumTest(abilityDelegator, abilityDelegatorArguments, testsuite);
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    windowStage.loadContent('TestAbility/pages/index', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'TVLauncherTest', 'load test page failed %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'TVLauncherTest', 'load test page success %{public}s', JSON.stringify(data) ?? '');
    });
  }
}
