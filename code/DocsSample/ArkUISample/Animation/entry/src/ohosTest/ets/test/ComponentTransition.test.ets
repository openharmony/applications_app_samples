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

export function ComponentTransitionTest() {
  describe('Animation_ComponentTransitionTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.animation',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.compTransition_label"))));
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
     * @tc.number: Animation_ComponentTransitionTest_001
     * @tc.name: Set image animate with one api
     * @tc.desc: Set image animate with one api
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ComponentTransitionTest_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ComponentTransitionTest_001_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.compTransition_temp_label1"))));
      await aimComponent.click();
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('show'));
      await aimComponent.click();
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('hide'));
      await aimComponent.click();
      await driver.delayMs(3000);
      hilog.info(DOMAIN, TAG, 'Animation_ComponentTransitionTest_001_end');
    })

    /*
     * @tc.number: Animation_ComponentTransitionTest_002
     * @tc.name: Set image animate with different api
     * @tc.desc: Set image animate with different api
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ComponentTransitionTest_002', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ComponentTransitionTest_002_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.compTransition_temp_label2"))));
      await aimComponent.click();
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('show'));
      await aimComponent.click();
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('hide'));
      await aimComponent.click();
      await driver.delayMs(3000);
      hilog.info(DOMAIN, TAG, 'Animation_ComponentTransitionTest_002_end');
    })

    /*
     * @tc.number: Animation_ComponentTransitionTest_003
     * @tc.name: Set Parent component transition
     * @tc.desc: Set Parent component transition
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ComponentTransitionTest_003', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ComponentTransitionTest_003_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.compTransition_temp_label3"))));
      await aimComponent.click();
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('show'));
      await aimComponent.click();
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('hide'));
      await aimComponent.click();
      await driver.delayMs(3000);
      hilog.info(DOMAIN, TAG, 'Animation_ComponentTransitionTest_003_end');
    })

    /*
     * @tc.number: Animation_ComponentTransitionTest_004
     * @tc.name: Transition in show and disappear
     * @tc.desc: Transition in show and disappear
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ComponentTransitionTest_004', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ComponentTransitionTest_004_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.compTransition_temp_label4"))));
      await aimComponent.click();
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('Click'));
      await aimComponent.click();
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('Click'));
      await aimComponent.click();
      await driver.delayMs(3000);
      hilog.info(DOMAIN, TAG, 'Animation_ComponentTransitionTest_004_end');
    })

    /*
     * @tc.number: Animation_ComponentTransitionTest_005
     * @tc.name: Show components and disappear
     * @tc.desc: Show components and disappear
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ComponentTransitionTest_005', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ComponentTransitionTest_005_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.compTransition_temp_label5"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('root'));
      await aimComponent.click();
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.type('root'));
      await aimComponent.click();
      await driver.delayMs(3000);
      hilog.info(DOMAIN, TAG, 'Animation_ComponentTransitionTest_005_end');
    })

  })
}