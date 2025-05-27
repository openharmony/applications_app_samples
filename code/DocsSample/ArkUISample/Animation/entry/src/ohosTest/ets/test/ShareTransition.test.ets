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
import { abilityDelegatorRegistry, Component, Driver } from '@kit.TestKit';
import { afterEach, beforeAll, describe, expect, it } from '@ohos/hypium';
import { ON } from '@ohos.UiTest';
import resource from '../../../main/ets/common/resource';
import { hilog } from '@kit.PerformanceAnalysisKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator()

const driver = Driver.create();
const BUNDLE = 'Animation_'
const TAG = '[Sample_Animation]';
const DOMAIN = 0xF811

let aimComponent : Component

export function ShareTransitionTest() {
  describe('Animation_ShareTransitionTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.animation',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.shareTransition_label"))));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    afterEach(async () => {
      aimComponent = await driver.findComponent(ON.text('AnimateIndex'));
      do {
        await driver.pressBack();
        aimComponent = await driver.findComponent(ON.text('AnimateIndex'));
      } while (aimComponent == null)
    })

    /*
      * @tc.number: Animation_ShareTransitionTest_001
      * @tc.name: Set share transition animate
      * @tc.desc: Set share transition animate
      * @tc.size: MediumTest
      * @tc.type: Function
      * @tc.level Level 1
      */
    it(BUNDLE + 'ShareTransitionTest_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ShareTransitionTest_001_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.temp1"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('root'));
      await aimComponent.click();
      await driver.delayMs(3000);
      hilog.info(DOMAIN, TAG, 'Animation_ShareTransitionTest_001_end');
    })

  })
}