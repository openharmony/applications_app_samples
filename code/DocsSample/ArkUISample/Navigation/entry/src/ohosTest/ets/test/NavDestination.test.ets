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

const driver = Driver.create();
const BUNDLE = 'Navigation_'
const TAG = '[Sample_Navigation_]';
const DOMAIN = 0xF811
let resourceManager = delegator.getAppContext().resourceManager;
let aimComponent : Component

export function NavDestinationTest() {
  describe('Navigation_NavDestinationTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.navigation',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('NavDestination'));
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
     * @tc.number: Navigation_NavDestinationTest_001
     * @tc.name: example_one_NavDestination
     * @tc.desc: example_one_NavDestination
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'NavDestinationTest_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_NavDestinationTest_001_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.stepperIndex_text14'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('push PageTwo'))
      await aimComponent.click();
      await driver.delayMs(1000);

      let size = await driver.getDisplaySize()
      let startX = Math.floor(size.x * 0.5)
      let startY = Math.floor(size.y * 0.6356)
      let endX = Math.floor(size.x * 0.5)
      let endY = Math.floor(size.y * 0.459)
      let startY2 = Math.floor(size.y * 0.883)
      let endY2 = Math.floor(size.y * 0.353)


      await driver.swipe(startX, startY, endX, endY);
      await driver.delayMs(1000);
      await driver.swipe(endX, endY, startX, startY);
      await driver.delayMs(1000);
      await driver.swipe(startX, startY, endX, endY);
      await driver.delayMs(1000);
      await driver.swipe(endX, endY, startX, startY);
      await driver.delayMs(1000);

      await driver.pressBack();

      aimComponent = await driver.findComponent(ON.text('push PageOne'))
      await aimComponent.click();
      await driver.delayMs(1000);

      await driver.swipe(startX, startY, endX, endY);
      await driver.delayMs(1000);
      await driver.swipe(endX, endY, startX, startY);
      await driver.delayMs(1000);
      await driver.swipe(startX, startY, endX, endY);
      await driver.delayMs(1000);
      await driver.swipe(startX, startY2, endX, endY2);
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Navigation_NavDestinationTest_001_end');
    })

    /*
     * @tc.number: Navigation_NavDestinationTest_002
     * @tc.name: example_two_NavDestination
     * @tc.desc: example_two_NavDestination
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'NavDestinationTest_002', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_NavDestinationTest_002_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.stepperIndex_text15'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('push next page'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('push next page'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Navigation_NavDestinationTest_002_end');
    })

    /*
     * @tc.number: Navigation_NavDestinationTest_003
     * @tc.name: example_three_NavDestination
     * @tc.desc: example_three_NavDestination
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'NavDestinationTest_003', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_NavDestinationTest_003_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.stepperIndex_text16'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('fade'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('explode'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('slide right'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('slide bottom'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Navigation_NavDestinationTest_003_end');
    })

    /*
     * @tc.number: Navigation_NavDestinationTest_004
     * @tc.name: example_four_NavDestination
     * @tc.desc: example_four_NavDestination
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'NavDestinationTest_004', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_NavDestinationTest_004_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.stepperIndex_text17'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('push LANDSCAPE page'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('push PORTRAIT page'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('push LANDSCAPE page'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('push PORTRAIT page'))
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Navigation_NavDestinationTest_004_end');
    })

  })
}