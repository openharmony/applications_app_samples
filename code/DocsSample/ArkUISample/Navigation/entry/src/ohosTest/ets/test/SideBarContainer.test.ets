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
import { hilog } from '@kit.PerformanceAnalysisKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator()
const BUNDLE = 'Navigation_'
const TAG = '[Sample_Navigation_]';
const DOMAIN = 0xF811
let resourceManager = delegator.getAppContext().resourceManager;
const driver = Driver.create();

let aimComponent : Component

export function SideBarContainerTest() {
  describe('Navigation_SideBarContainerTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.navigation',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('SideBarContainer'));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    afterEach(async () => {
      aimComponent = await driver.findComponent(ON.text('Index'));
      do {
        await driver.pressBack();
        aimComponent = await driver.findComponent(ON.text('Index'));
      } while (aimComponent == null)
    })

    /*
     * @tc.number: Navigation_SideBarContainerTest_001
     * @tc.name: example_one_SideBarContainer
     * @tc.desc: example_one_SideBarContainer
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'SideBarContainerTest_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_SideBarContainerTest_001_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.stepperIndex_text21'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('Button'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('Index01'))
      expect(aimComponent).assertNull();

      aimComponent = await driver.findComponent(ON.type('Button'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('Index01'))
      expect(aimComponent)

      aimComponent = await driver.findComponent(ON.text('Index02'))
      await aimComponent.click()
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('Index03'))
      await aimComponent.click()
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('Index01'))
      await aimComponent.click()
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Navigation_SideBarContainerTest_001_end');
    })

  })
}