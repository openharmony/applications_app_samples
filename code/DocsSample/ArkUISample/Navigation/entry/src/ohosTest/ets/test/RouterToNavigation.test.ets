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
import { router } from '@kit.ArkUI';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator()
const BUNDLE = 'Navigation_'
const TAG = '[Sample_Navigation_]';
const DOMAIN = 0xF811
let resourceManager = delegator.getAppContext().resourceManager;
const driver = Driver.create();

let aimComponent : Component

export function Navigation_RouteToNavTest() {
  describe('Navigation_RouteToNavTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.navigation',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('RouterToNavigation'));
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
     * @tc.number: Navigation_RouteToNavTest_001
     * @tc.name: example_one_RouteToNav
     * @tc.desc: example_one_RouteToNav
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'RouteToNavTest_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_RouteToNavTest_001_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.routerToNavigation_text1'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('router to pageOne'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('router back to Index'));
      await aimComponent.click();
      await driver.delayMs(1000);

      hilog.info(DOMAIN, TAG, 'Navigation_RouteToNavTest_001_end');
    })

    /*
     * @tc.number: Navigation_RouteToNavTest_002
     * @tc.name: example_one_RouteToNav
     * @tc.desc: example_one_RouteToNav
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'RouteToNavTest_002', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_RouteToNavTest_002_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.routerToNavigation_text1'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.routerToNavigation_router_text1'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('Method 1: Navigation'));
      hilog.info(DOMAIN, TAG, 'Navigation_RouteToNavTest_002_end');

      router.back();
    })

    /*
     * @tc.number: Navigation_RouteToNavTest_003
     * @tc.name: example_one_RouteToNav
     * @tc.desc: example_one_RouteToNav
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'RouteToNavTest_003', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_RouteToNavTest_003_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.routerToNavigation_text1'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.routerToNavigation_router_text2'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('Method 2: PageOne'));
      hilog.info(DOMAIN, TAG, 'Navigation_RouteToNavTest_003_end');

      router.back();
    })

    /*
     * @tc.number: Navigation_RouteToNavTest_004
     * @tc.name: example_one_RouteToNav
     * @tc.desc: example_one_RouteToNav
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'RouteToNavTest_004', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_RouteToNavTest_004_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.routerToNavigation_text1'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.routerToNavigation_router_text3'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('Method 3: AppStorage'));
      hilog.info(DOMAIN, TAG, 'Navigation_RouteToNavTest_004_end');

      router.back();
    })

    /*
     * @tc.number: Navigation_RouteToNavTest_005
     * @tc.name: example_one_RouteToNav
     * @tc.desc: example_one_RouteToNav
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'RouteToNavTest_005', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_RouteToNavTest_005_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.routerToNavigation_text1'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.routerToNavigation_router_text4'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('Method 4: queryNavigationInfo'));
      hilog.info(DOMAIN, TAG, 'Navigation_RouteToNavTest_005_end');

      router.back();
    })

    /*
     * @tc.number: Navigation_RouteToNavTest_006
     * @tc.name: example_one_RouteToNav
     * @tc.desc: example_one_RouteToNav
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'RouteToNavTest_006', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_RouteToNavTest_006_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.routerToNavigation_text2'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('Push PageOne'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.routerToNavigation_nav_text1'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      hilog.info(DOMAIN, TAG, 'Navigation_RouteToNavTest_006_end');
    })

  })
}