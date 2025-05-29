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

export function NavigationTest() {
  describe('Navigation_NavigationTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.navigation',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('Navigation'));
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
     * @tc.number: Navigation_NavigationTest_001
     * @tc.name: example_one_Navigation
     * @tc.desc: example_one_Navigation
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'NavigationTest_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_001_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.stepperIndex_text1'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('TitleBar'))
      expect(aimComponent)

      aimComponent = await driver.findComponent(ON.type('ToolBar'))
      expect(aimComponent)

      aimComponent = await driver.findComponent(ON.type('NavBarContent'))
      expect(aimComponent)
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_001_end');
    })

    /*
     * @tc.number: Navigation_NavigationTest_002
     * @tc.name: example_two_Navigation
     * @tc.desc: example_two_Navigation
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'NavigationTest_002', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_002_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.stepperIndex_text2'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPathByName'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('NavIndex'))
      expect(aimComponent)
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_002_end');
    })

    /*
     * @tc.number: Navigation_NavigationTest_003
     * @tc.name: example_three_Navigation
     * @tc.desc: example_three_Navigation
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'NavigationTest_003', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_003_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.stepperIndex_text3'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPathByName'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPathByName'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPathByName'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(2000);
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_003_end');
    })

    /*
     * @tc.number: Navigation_NavigationTest_004
     * @tc.name: example_four_Navigation
     * @tc.desc: example_four_Navigation
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'NavigationTest_004', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_004_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.stepperIndex_text4'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('StartTest'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pop'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_004_end');
    })

    /*
     * @tc.number: Navigation_NavigationTest_005
     * @tc.name: example_five_Navigation
     * @tc.desc: example_five_Navigation
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'NavigationTest_005', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_005_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.stepperIndex_text5'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('switch color'))
      await aimComponent.click();
      await driver.delayMs(1000);
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('switch blur'))
      await aimComponent.click();
      await driver.delayMs(1000);
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('switch blurOption'))
      await aimComponent.click();
      await driver.delayMs(1000);
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('push page'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('switch color'))
      await aimComponent.click();
      await driver.delayMs(1000);
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('switch blur'))
      await aimComponent.click();
      await driver.delayMs(1000);
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('switch effect'))
      await aimComponent.click();
      await driver.delayMs(1000);
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_005_end');
    })

    /*
     * @tc.number: Navigation_NavigationTest_006
     * @tc.name: example_six_Navigation
     * @tc.desc: example_six_Navigation
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'NavigationTest_006', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_006_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.stepperIndex_text6'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('Button'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_006_end');
    })

    /*
     * @tc.number: Navigation_NavigationTest_007
     * @tc.name: example_seven_Navigation
     * @tc.desc: example_seven_Navigation
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'NavigationTest_007', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_007_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.stepperIndex_text7'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_007_end');
    })

    /*
     * @tc.number: Navigation_NavigationTest_008
     * @tc.name: example_eight_Navigation
     * @tc.desc: example_eight_Navigation
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'NavigationTest_008', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_008_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.stepperIndex_text8'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_008_end');
    })

    /*
     * @tc.number: Navigation_NavigationTest_009
     * @tc.name: example_nine_Navigation
     * @tc.desc: example_nine_Navigation
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'NavigationTest_009', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_009_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.stepperIndex_text9'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      let size = await driver.getDisplaySize()
      let startX = Math.floor(size.x * 0.5)
      let startY = Math.floor(size.y * 0.565)
      let endX = Math.floor(size.x * 0.5)
      let endY = Math.floor(size.y * 0.21186)

      await driver.swipe(startX, startY, endX, endY);
      await driver.delayMs(1000);
      await driver.swipe(endX, endY, startX, startY);
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('BarStyle.STACK'));
      await aimComponent.click();
      await driver.delayMs(1000);

      await driver.swipe(startX, startY, endX, endY);
      await driver.delayMs(1000);
      await driver.swipe(endX, endY, startX, startY);
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_009_end');
    })

    /*
     * @tc.number: Navigation_NavigationTest_010
     * @tc.name: example_ten_Navigation
     * @tc.desc: example_ten_Navigation
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'NavigationTest_010', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_010_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.stepperIndex_text10'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('to Page One'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('to Page One'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('to Page One'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_010_end');
    })

    /*
     * @tc.number: Navigation_NavigationTest_011
     * @tc.name: example_eleven_Navigation
     * @tc.desc: example_eleven_Navigation
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'NavigationTest_011', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_011_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.stepperIndex_text11'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('跳转'));
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_011_end');
    })

    /*
     * @tc.number: Navigation_NavigationTest_012
     * @tc.name: example_twelve_Navigation
     * @tc.desc: example_twelve_Navigation
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'NavigationTest_012', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_012_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.stepperIndex_text12'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('apply padding 20vp'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('apply padding 32vp'));
      await aimComponent.click();
      await driver.delayMs(1000);

      let Toggles = await driver.findComponents(ON.type('Toggle'));
      await Toggles[0].click();
      await driver.delayMs(1000);
      await Toggles[1].click();
      await driver.delayMs(1000);
      await Toggles[1].click();
      await driver.delayMs(1000);
      await Toggles[0].click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPage'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('apply padding 20vp'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('apply padding 32vp'));
      await aimComponent.click();
      await driver.delayMs(1000);

      Toggles = await driver.findComponents(ON.type('Toggle'));
      await Toggles[0].click();
      await driver.delayMs(1000);
      await Toggles[1].click();
      await driver.delayMs(1000);
      await Toggles[1].click();
      await driver.delayMs(1000);
      await Toggles[0].click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_012_end');
    })

    /*
     * @tc.number: Navigation_NavigationTest_013
     * @tc.name: example_thirteen_Navigation
     * @tc.desc: example_thirteen_Navigation
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'NavigationTest_013', 0, async () => {
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_013_begin');
      aimComponent = await driver.findComponent(ON.text(resourceManager.getStringSync($r('app.string.stepperIndex_text13'))));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('push next page'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('push next page'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_013_end');
    })

  })
}