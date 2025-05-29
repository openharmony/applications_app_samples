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

export function AnimateToTest() {
  describe('Animation_AnimateToTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.animation',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.animate_to_label'))));
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
     * @tc.number: Animation_AnimateToTest_001
     * @tc.name: Set animate
     * @tc.desc: Set animate
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'AnimateToTest_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_AnimateToTest_001_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.animate_to_temp_label1'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('change size'))
      await aimComponent.click();
      await driver.delayMs(5000);
      hilog.info(DOMAIN, TAG, 'Animation_AnimateToTest_001_end');
    })

    /*
     * @tc.number: Animation_AnimateToTest_002
     * @tc.name: component disappear in animate
     * @tc.desc: component disappear in animate
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'AnimateToTest_002', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_AnimateToTest_002_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.animate_to_temp_label2'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      let columns = await driver.findComponents(ON.type('Column'))
      await columns[1].click();
      await driver.delayMs(5000);
      hilog.info(DOMAIN, TAG, 'Animation_AnimateToTest_002_end');
    })

    /*
     * @tc.number: Animation_AnimateToTest_003
     * @tc.name: Set animate in componentV2
     * @tc.desc: Set animate in componentV2
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'AnimateToTest_003', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_AnimateToTest_003_begin');
      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r('app.string.animate_to_temp_label3'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('change size'))
      await aimComponent.click();
      await driver.delayMs(5000);
      hilog.info(DOMAIN, TAG, 'Animation_AnimateToTest_003_end');
    })

  })
}