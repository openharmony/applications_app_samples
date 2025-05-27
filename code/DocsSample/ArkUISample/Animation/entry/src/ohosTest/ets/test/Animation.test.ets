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

export function AnimationTest() {
  describe('Animation_AnimationTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.animation',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.animation_label"))));
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
     * @tc.number: Animation_AnimationTest_001
     * @tc.name: Set attribute animate use animation
     * @tc.desc: Set attribute animate use animation
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'AnimationTest_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_AnimationTest_001_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.temp1"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('change size'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('change rotate angle'))
      await aimComponent.click();
      await driver.delayMs(5000);
      hilog.info(DOMAIN, TAG, 'Animation_AnimationTest_001_end');
    })

    /*
    * @tc.number: Animation_AnimationTest_002
    * @tc.name: Set attribute animate use animationTo
    * @tc.desc: Set attribute animate use animationTo
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it(BUNDLE + 'AnimationTest_002', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_AnimationTest_002_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.animation_temp_label2"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('Column'))
      await aimComponent.click();
      await driver.delayMs(5000);
      hilog.info(DOMAIN, TAG, 'Animation_AnimationTest_002_end');
    })

    /*
    * @tc.number: Animation_AnimationTest_003
    * @tc.name: Set attribute animate use animation
    * @tc.desc: Set attribute animate use animation
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it(BUNDLE + 'AnimationTest_003', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_AnimationTest_003_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.animation_temp_label3"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('Column'))
      await aimComponent.click();
      await driver.delayMs(5000);
      hilog.info(DOMAIN, TAG, 'Animation_AnimationTest_003_end');
    })

    /*
    * @tc.number: Animation_AnimationTest_004
    * @tc.name: Set attribute animate use keyframeAnimateTo
    * @tc.desc: Set attribute animate use keyframeAnimateTo
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it(BUNDLE + 'AnimationTest_004', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_AnimationTest_004_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.animation_temp_label4"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('Column'))
      await aimComponent.click();
      await driver.delayMs(5000);
      hilog.info(DOMAIN, TAG, 'Animation_AnimationTest_004_end');
    })

  })
}