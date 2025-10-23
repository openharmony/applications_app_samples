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

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();

const driver = Driver.create();
const BUNDLE = 'Animation_';
const TAG = '[Sample_Animation]';
const DOMAIN = 0xF811;

let aimComponent: Component;

export function ComponentTest() {
  describe('Animation_ComponentTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.animation',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.component_label"))));
      await aimComponent.click();
      await driver.delayMs(1000);
    });

    afterEach(async () => {
      aimComponent = await driver.findComponent(ON.text('AnimateIndex'));
      do {
        await driver.pressBack();
        aimComponent = await driver.findComponent(ON.text('AnimateIndex'));
      } while (aimComponent == null);
      await driver.delayMs(1000);
    });

    /*
     * @tc.number: Animation_ComponentTest_001
     * @tc.name: Animation_ComponentTest_001
     * @tc.desc: Test TaskSwitchMainPage component animation
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ComponentTest_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ComponentTest_001_begin');

      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.component_temp_label1"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      const switchButton = await driver.findComponent(ON.text('Move to first/last'));

      await switchButton.click();
      await driver.delayMs(1500);

      await switchButton.click();
      await driver.delayMs(1500);

      const displaySize = await driver.getDisplaySize();
      const screenWidth = displaySize.x;
      const centerY = Math.floor(displaySize.y * 0.5);

      await driver.swipe(
        Math.floor(screenWidth * 0.7),
        centerY,
        Math.floor(screenWidth * 0.3),
        centerY,
        500
      );
      await driver.delayMs(1000);

      await driver.swipe(
        Math.floor(screenWidth * 0.3),
        centerY,
        Math.floor(screenWidth * 0.7),
        centerY,
        500
      );
      await driver.delayMs(1000);

      hilog.info(DOMAIN, TAG, 'Animation_ComponentTest_001_end');
    });

    /*
     * @tc.number: Animation_ComponentTest_002
     * @tc.name: Animation_ComponentTest_002
     * @tc.desc: Test ListAutoSortExample component animation
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'ComponentTest_002', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Animation_ComponentTest_002_begin');

      aimComponent = await driver.findComponent(ON.text(resource.resourceToString($r("app.string.component"))));
      await aimComponent.click();
      await driver.delayMs(1000);

      const firstGroup = await driver.findComponent(ON.text('first ListItemGroup'));
      const secondGroup = await driver.findComponent(ON.text('second ListItemGroup'));

      const displaySize = await driver.getDisplaySize();
      const itemWidth = displaySize.x;
      const itemHeight = 100;
      const targetItemY = Math.floor(displaySize.y * 0.4);

      await driver.swipe(
        Math.floor(itemWidth * 0.9),
        targetItemY,
        Math.floor(itemWidth * 0.1),
        targetItemY,
        300
      );
      await driver.delayMs(500);

      const toTopButton = await driver.findComponent(ON.text('To TOP'));
      await toTopButton.click();
      await driver.delayMs(1500);

      const firstItem = await driver.findComponent(ON.text('3'));

      hilog.info(DOMAIN, TAG, 'Animation_ComponentTest_002_end');
    });

  });
}