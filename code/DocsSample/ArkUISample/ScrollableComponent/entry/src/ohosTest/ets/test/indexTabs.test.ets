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

import { describe, it, expect, beforeAll } from '@ohos/hypium';

// 导入测试依赖kit
import { abilityDelegatorRegistry, Driver, ON, MouseButton, MatchPattern, UiDirection, Component } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { Point } from '@ohos.UiTest';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN_NUMBER: number = 0xFF00;
const TAG: string = '[EventAbility]';
const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let want: Want;

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let textString: string = await manage.getStringValue(resource);
  return textString;
}

export default function IndexTest() {
  describe('IndexTestTabs', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(DOMAIN_NUMBER, TAG, 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number UiTest_001
     * @tc.name testTabCacheCount
     * @tc.desc Test Tab component cache quantity
     * @tc.level: Level1
     * @tc.size: MediumTest
     * @tc.type: Function
     */
    it('testCacheCount', 0, async (done: Function) => {
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Tabs', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();

      await driver.delayMs(2000);
      let size = await driver.getDisplaySize()
      let x = Math.floor(size.x * 0.3)
      await driver.swipe(x, Math.floor(size.y * 0.9), x, Math.floor(size.y * 0.1), 5000);
      await driver.delayMs(500);

      let str = await getResourceString($r('app.string.Cache_count'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let tabs = await driver.findComponent(ON.type('Tabs'));
      expect(tabs === null).assertFalse();
      let scrollPoint: Point = { x: 400, y: 400 };
      await driver.mouseScroll(scrollPoint, true, 2);
      await driver.pressBack();
      await driver.pressBack();
      done();
    })

    /**
     * @tc.number UiTest_002
     * @tc.name testAgeFriendlyTabs
     * @tc.desc Test Tab component's support for age-friendly features
     * @tc.level: Level1
     * @tc.size: MediumTest
     * @tc.type: Function
     */
    it('testAgeFriendlyTabs', 0, async (done: Function) => {
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Tabs', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();

      await driver.delayMs(2000);
      let size = await driver.getDisplaySize()
      let x = Math.floor(size.x * 0.3)
      await driver.swipe(x, Math.floor(size.y * 0.9), x, Math.floor(size.y * 0.1), 5000);
      await driver.delayMs(500);

      let str = await getResourceString($r('app.string.AgeFriendlyTabs_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let tabs = await driver.findComponent(ON.type('Tabs'));
      expect(tabs === null).assertFalse();
      let scrollPoint: Point = { x: 400, y: 400 };
      await driver.mouseScroll(scrollPoint, true, 2);
      await driver.pressBack();
      await driver.pressBack();
      done();
    })

    /**
     * @tc.number UiTest_003
     * @tc.name testContentWillChange
     * @tc.desc Test switching the Tab component to a specified tab
     * @tc.level: Level1
     * @tc.size: MediumTest
     * @tc.type: Function
     */
    it('testContentWillChange', 0, async (done: Function) => {
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Tabs', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();

      await driver.delayMs(2000);
      let size = await driver.getDisplaySize()
      let x = Math.floor(size.x * 0.3)
      await driver.swipe(x, Math.floor(size.y * 0.9), x, Math.floor(size.y * 0.1), 5000);
      await driver.delayMs(500);

      let str = await getResourceString($r('app.string.ContentWillChange_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let tabs = await driver.findComponent(ON.type('Tabs'));
      expect(tabs === null).assertFalse();
      let scrollPoint: Point = { x: 400, y: 400 };
      await driver.mouseScroll(scrollPoint, true, 2);
      await driver.pressBack();
      await driver.pressBack();
      done();
    })

    /**
     * @tc.number UiTest_004
     * @tc.name testCustomTabBar
     * @tc.desc Test Tab component custom navigation bar
     * @tc.level: Level1
     * @tc.size: MediumTest
     * @tc.type: Function
     */
    it('testCustomTabBar', 0, async (done: Function) => {
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Tabs', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();

      await driver.delayMs(2000);
      let size = await driver.getDisplaySize()
      let x = Math.floor(size.x * 0.3)
      await driver.swipe(x, Math.floor(size.y * 0.9), x, Math.floor(size.y * 0.1), 5000);
      await driver.delayMs(500);

      let str = await getResourceString($r('app.string.CustomTabBar_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let tabs = await driver.findComponent(ON.type('Tabs'));
      expect(tabs === null).assertFalse();
      let scrollPoint: Point = { x: 400, y: 400 };
      await driver.mouseScroll(scrollPoint, true, 2);
      await driver.pressBack();
      await driver.pressBack();
      done();
    })

    /**
     * @tc.number UiTest_005
     * @tc.name testScrollableTabBar
     * @tc.desc Test tabs component scroll navigation bar
     * @tc.level: Level1
     * @tc.size: MediumTest
     * @tc.type: Function
     */
    it('testScrollableTabBar', 0, async (done: Function) => {
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Tabs', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();

      await driver.delayMs(2000);
      let size = await driver.getDisplaySize()
      let x = Math.floor(size.x * 0.3)
      await driver.swipe(x, Math.floor(size.y * 0.9), x, Math.floor(size.y * 0.1), 5000);
      await driver.delayMs(500);

      let str = await getResourceString($r('app.string.ScrollableTabBar_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let tabs = await driver.findComponent(ON.type('Tabs'));
      expect(tabs === null).assertFalse();
      let scrollPoint: Point = { x: 400, y: 400 };
      await driver.mouseScroll(scrollPoint, true, 2);
      await driver.pressBack();
      await driver.pressBack();
      done();
    })

    /**
     * @tc.number UiTest_006
     * @tc.name testFixedTabBar
     * @tc.desc Test tabs component with fixed navigation bar
     * @tc.level: Level1
     * @tc.size: MediumTest
     * @tc.type: Function
     */
    it('testFixedTabBar', 0, async (done: Function) => {
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Tabs', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();

      await driver.delayMs(2000);
      let size = await driver.getDisplaySize()
      let x = Math.floor(size.x * 0.3)
      await driver.swipe(x, Math.floor(size.y * 0.9), x, Math.floor(size.y * 0.1), 5000);
      await driver.delayMs(500);

      let str = await getResourceString($r('app.string.FixedTabBar_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let tabs = await driver.findComponent(ON.type('Tabs'));
      expect(tabs === null).assertFalse();
      let scrollPoint: Point = { x: 400, y: 400 };
      await driver.mouseScroll(scrollPoint, true, 2);
      await driver.pressBack();
      await driver.pressBack();
      done();
    })

    /**
     * @tc.number UiTest_007
     * @tc.name testSwipeLockedTabBar
     * @tc.desc Test the tabs component limiting the navigation bar's swipe switching
     * @tc.level: Level1
     * @tc.size: MediumTest
     * @tc.type: Function
     */
    it('testSwipeLockedTabBar', 0, async (done: Function) => {
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Tabs', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();

      await driver.delayMs(2000);
      let size = await driver.getDisplaySize()
      let x = Math.floor(size.x * 0.3)
      await driver.swipe(x, Math.floor(size.y * 0.9), x, Math.floor(size.y * 0.1), 5000);
      await driver.delayMs(500);

      let str = await getResourceString($r('app.string.SwipeLockedTabBar_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let tabs = await driver.findComponent(ON.type('Tabs'));
      expect(tabs === null).assertFalse();
      let scrollPoint: Point = { x: 400, y: 400 };
      await driver.mouseScroll(scrollPoint, true, 2);
      await driver.pressBack();
      await driver.pressBack();
      done();
    })

    /**
     * @tc.number UiTest_008
     * @tc.name testSideTabBar
     * @tc.desc Test tabs component side navigation
     * @tc.level: Level1
     * @tc.size: MediumTest
     * @tc.type: Function
     */
    it('testSideTabBar', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(500);
      let componentButton = await driver.findComponent(ON.text('Tabs', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();

      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.SideTabBar_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let tabs = await driver.findComponent(ON.type('Tabs'));
      expect(tabs === null).assertFalse();
      let scrollPoint: Point = { x: 400, y: 400 };
      await driver.mouseScroll(scrollPoint, true, 2);
      await driver.pressBack();
      await driver.pressBack();
      done();
    })

    /**
     * @tc.number UiTest_009
     * @tc.name testTopTabBar
     * @tc.desc Test tabs component top navigation
     * @tc.level: Level1
     * @tc.size: MediumTest
     * @tc.type: Function
     */
    it('testTopTabBar', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(500);
      let componentButton = await driver.findComponent(ON.text('Tabs', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();

      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.TopTabBar_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let tabs = await driver.findComponent(ON.type('Tabs'));
      expect(tabs === null).assertFalse();
      let scrollPoint: Point = { x: 400, y: 400 };
      await driver.mouseScroll(scrollPoint, true, 2);
      await driver.pressBack();
      await driver.pressBack();
      done();
    })

    /**
     * @tc.number UiTest_010
     * @tc.name testBottomTabBar
     * @tc.desc Test tabs component bottom navigation
     * @tc.level: Level1
     * @tc.size: MediumTest
     * @tc.type: Function
     */
    it('testBottomTabBar', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(500);
      let componentButton = await driver.findComponent(ON.text('Tabs', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();

      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.BottomTabBar_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let tabs = await driver.findComponent(ON.type('Tabs'));
      expect(tabs === null).assertFalse();
      let scrollPoint: Point = { x: 400, y: 400 };
      await driver.mouseScroll(scrollPoint, true, 2);
      await driver.pressBack();
      await driver.pressBack();
      done();
    })

    /**
     * @tc.number UiTest_011
     * @tc.name testTabsLayout
     * @tc.desc Test the basic layout of the tabs component
     * @tc.level: Level1
     * @tc.size: MediumTest
     * @tc.type: Function
     */
    it('testTabsLayout', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(500);
      let componentButton = await driver.findComponent(ON.text('Tabs', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();

      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.TabsLayout_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let tabs = await driver.findComponent(ON.type('Tabs'));
      expect(tabs === null).assertFalse();
      let scrollPoint: Point = { x: 400, y: 400 };
      await driver.mouseScroll(scrollPoint, true, 2);
      await driver.pressBack();
      await driver.pressBack();
      done();
    })
  })
}