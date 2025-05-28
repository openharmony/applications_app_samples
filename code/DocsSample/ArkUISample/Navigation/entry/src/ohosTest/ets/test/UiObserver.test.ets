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

export function UiObserverTest() {
  describe('Navigation_UiObserverTest', () => {
    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.navigation',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.stepperIndex_text18'))));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    afterEach(async () => {
      aimComponent = await driver.findComponent(ON.text('Index'));
      do {
        await driver.pressBack();
        await driver.delayMs(1000);
        aimComponent = await driver.findComponent(ON.text('Index'));
      } while (aimComponent == null)
    })

    /*
     * @tc.number: Navigation_UiObserverTest_001
     * @tc.name: example_one_UiObserver
     * @tc.desc: example_one_UiObserver
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'UiObserverTest_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_UiObserverTest_001_begin');
      aimComponent = await driver.findComponent(ON.text("uiObserver.on('navDestinationUpdate')"));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('push'));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Navigation_UiObserverTest_001_end');
    })

    /*
     * @tc.number: Navigation_UiObserverTest_002
     * @tc.name: example_two_UiObserver
     * @tc.desc: example_two_UiObserver
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'UiObserverTest_002', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_UiObserverTest_002_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.stepperIndex_text19'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('push'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'Navigation_UiObserverTest_002_end');
    })

    /*
     * @tc.number: Navigation_UiObserverTest_003
     * @tc.name: example_three_UiObserver
     * @tc.desc: example_three_UiObserver
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'UiObserverTest_003', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_UiObserverTest_003_begin');
      aimComponent = await driver.findComponent(ON.text("uiObserver.on('navDestinationSwitch')"));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('push'));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Navigation_UiObserverTest_003_end');
    })

    /*
     * @tc.number: Navigation_UiObserverTest_004
     * @tc.name: example_four_UiObserver
     * @tc.desc: example_four_UiObserver
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'UiObserverTest_004', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_UiObserverTest_004_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.stepperIndex_text20'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('push'));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Navigation_UiObserverTest_004_end');
    })
  })
}