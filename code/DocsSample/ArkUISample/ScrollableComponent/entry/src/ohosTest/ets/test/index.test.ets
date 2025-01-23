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
import { abilityDelegatorRegistry, Driver, ON, MouseButton,MatchPattern, UiDirection } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { Point } from '@ohos.UiTest';


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
  describe('IndexTest', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number UiTest_001
     * @tc.name testControlledScrollPositionList
     * @tc.desc 测试控制滚动位置示例
     */
    it('testControlledScrollPositionList', 0, async (done: Function) => {
      console.info('uitest: testControlledScrollPositionList begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('List', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.ControlledScrollPositionList_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let stackList = await driver.findComponent(ON.type('Stack'));
      expect(stackList === null).assertFalse();
      let button = await driver.findComponent(ON.type('Button'));
      expect(button === null).assertFalse();
      await stackList.scrollToBottom(2400);
      await button.click();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testControlledScrollPositionList end');
      done();
    })

    /**
     * @tc.number UiTest_002
     * @tc.name testResponsiveScrollPositionList
     * @tc.desc 测试响应滚动位置示例
     */
    it('testResponsiveScrollPositionList', 0, async (done: Function) => {
      console.info('uitest: testResponsiveScrollPositionList begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('List', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.ResponsiveScrollPositionList_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let stackList = await driver.findComponent(ON.type('Stack'));
      expect(stackList === null).assertFalse();
      await stackList.scrollToBottom(2400);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testResponsiveScrollPositionList end');
      done();
    })

    /**
     * @tc.number UiTest_003
     * @tc.name testDataInList
     * @tc.desc 测试列表显示数据示例
     */
    it('testDataInList', 0, async (done: Function) => {
      console.info('uitest: testDataInList begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('List', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.DataInList_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      str = await getResourceString($r('app.string.peopleOne'));
      let dataListText = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(dataListText === null).assertFalse();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testDataInList end');
      done();
    })

    /**
     * @tc.number UiTest_004
     * @tc.name testStickyHeaderList
     * @tc.desc 测试添加粘性标题示例
     */
    it('testStickyHeaderList', 0, async (done: Function) => {
      console.info('uitest: testStickyHeaderList begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('List', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.StickyHeaderList_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let stickyList = await driver.findComponent(ON.type('List'));
      expect(stickyList === null).assertFalse();
      await stickyList.scrollToBottom();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testStickyHeaderList end');
      done();
    })

    /**
     * @tc.number UiTest_005
     * @tc.name testAddListItem
     * @tc.desc 测试新增列表项示例
     */
    it('testAddListItem', 0, async (done: Function) => {
      console.info('uitest: testAddListItem begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('List', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let scrollPoint:Point = {x:400,y:400};
      await driver.mouseScroll(scrollPoint,true,17);
      let str = await getResourceString($r('app.string.AddListItem_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let addButton = await driver.findComponent(ON.text('+', MatchPattern.CONTAINS));
      expect(addButton === null).assertFalse();
      await addButton.click();
      await driver.mouseClick({x: 580, y: 770}, MouseButton.MOUSE_BUTTON_LEFT, 0, 0);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testAddListItem end');
      done();
    })

    /**
     * @tc.number UiTest_006
     * @tc.name testDeleteListItem
     * @tc.desc 测试删除列表项示例
     */
    it('testDeleteListItem', 0, async (done: Function) => {
      console.info('uitest: testDeleteListItem begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('List', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let scrollPoint:Point = {x:400,y:400};
      await driver.mouseScroll(scrollPoint,true,17);
      let str = await getResourceString($r('app.string.DeleteListItem_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let addButton = await driver.findComponent(ON.text('+', MatchPattern.CONTAINS));
      expect(addButton === null).assertFalse();
      await addButton.click();
      await driver.mouseClick({x: 580, y: 770}, MouseButton.MOUSE_BUTTON_LEFT, 0, 0);
      let listContent = await driver.findComponent(ON.text('Reading', MatchPattern.CONTAINS));
      expect(listContent === null).assertFalse();
      await listContent.longClick();
      let deleteButton = await driver.findComponent(ON.text('delete', MatchPattern.CONTAINS));
      expect(deleteButton === null).assertFalse();
      await deleteButton.click();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testDeleteListItem end');
      done();
    })

    /**
     * @tc.number UiTest_007
     * @tc.name testListLayout
     * @tc.desc 测试列表开发布局示例
     */
    it('testListLayout', 0, async (done: Function) => {
      console.info('uitest: testListLayout begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('List', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.ListLayout_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let dataListText = await driver.findComponent(ON.text('ListItem one', MatchPattern.CONTAINS));
      expect(dataListText === null).assertFalse();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testListLayout end');
      done();
    })

    /**
     * @tc.number UiTest_008
     * @tc.name testGridScrollPosition
     * @tc.desc 测试控制滚动位置的网格布局示例
     */
    it('testGridScrollPosition', 0, async (done: Function) => {
      console.info('uitest: testGridScrollPosition begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Grid', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.ScrollPosition_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let buttonPrevious = await driver.findComponent(ON.text('Previous', MatchPattern.CONTAINS));
      let buttonNext = await driver.findComponent(ON.text('Next', MatchPattern.CONTAINS));
      expect(buttonPrevious === null).assertFalse();
      expect(buttonNext === null).assertFalse();
      await buttonNext.click();
      await buttonPrevious.click();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testGridScrollPosition end');
      done();
    })

    /**
     * @tc.number UiTest_009
     * @tc.name testGridScrollableGrid
     * @tc.desc 测试可滚动的网格布局示例
     */
    it('testGridScrollableGrid', 0, async (done: Function) => {
      console.info('uitest: testGridScrollableGrid begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Grid', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.ScrollableGrid_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let scrollableGrid = await driver.findComponent(ON.type('Grid'));
      expect(scrollableGrid === null).assertFalse();
      await scrollableGrid.scrollToBottom();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testGridScrollableGrid end');
      done();
    })

    /**
     * @tc.number UiTest_010
     * @tc.name testSwiperAutoPlay
     * @tc.desc 测试自动轮播示例
     */
    it('testSwiperAutoPlay', 0, async (done: Function) => {
      console.info('uitest: testSwiperAutoPlay begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Swiper', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.SwiperAutoPlay_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let swiper = await driver.findComponent(ON.type('Swiper'));
      expect(swiper === null).assertFalse();
      let scrollPoint:Point = {x:400,y:400};
      await driver.mouseScroll(scrollPoint,true,2);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testSwiperAutoPlay end');
      done();
    })

    /**
     * @tc.number UiTest_011
     * @tc.name testSwiperDirection
     * @tc.desc 测试轮播方向示例
     */
    it('testSwiperDirection', 0, async (done: Function) => {
      console.info('uitest: testSwiperCustomAnimation begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Swiper', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.SwiperDirection_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let swiper = await driver.findComponent(ON.type('Swiper'));
      expect(swiper === null).assertFalse();
      let scrollPoint:Point = {x:400,y:400};
      let scrollPoint2:Point = {x:400,y:800};
      await driver.mouseScroll(scrollPoint,true,2);
      await driver.mouseScroll(scrollPoint2,true,2);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testSwiperCustomAnimation end');
      done();
    })

    /**
     * @tc.number UiTest_012
     * @tc.name testSwiperMultiPage
     * @tc.desc 测试每页显示多个子页面示例
     */
    it('testSwiperMultiPage', 0, async (done: Function) => {
      console.info('uitest: testSwiperMultiPage begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Swiper', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.SwiperMultiPage_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let swiper = await driver.findComponent(ON.type('Swiper'));
      expect(swiper === null).assertFalse();
      let scrollPoint:Point = {x:400,y:400};
      await driver.mouseScroll(scrollPoint,true,2);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testSwiperMultiPage end');
      done();
    })

    /**
     * @tc.number UiTest_013
     * @tc.name testSwiperCustomAnimation
     * @tc.desc 测试自定义切换动画示例
     */
    it('testSwiperCustomAnimation', 0, async (done: Function) => {
      console.info('uitest: testSwiperCustomAnimation begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Swiper', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.SwiperCustomAnimation_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let swiper = await driver.findComponent(ON.type('Swiper'));
      expect(swiper === null).assertFalse();
      let scrollPoint:Point = {x:400,y:400};
      await driver.mouseScroll(scrollPoint,true,2);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testSwiperCustomAnimation end');
      done();
    })

    /**
     * @tc.number UiTest_014
     * @tc.name testSwiperPageSwitchMethod
     * @tc.desc 测试页面切换方式示例
     */
    it('testSwiperPageSwitchMethod', 0, async (done: Function) => {
      console.info('uitest: testSwiperPageSwitchMethod begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Swiper', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.SwiperPageSwitchMethod_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let buttonPrevious = await driver.findComponent(ON.text('showPrevious', MatchPattern.CONTAINS));
      let buttonNext = await driver.findComponent(ON.text('showNext', MatchPattern.CONTAINS));
      expect(buttonPrevious === null).assertFalse();
      expect(buttonNext === null).assertFalse();
      await buttonNext.click();
      await buttonPrevious.click();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testSwiperPageSwitchMethod end');
      done();
    })

    /**
     * @tc.number UiTest_015
     * @tc.name testTabsLayout
     * @tc.desc 测试基本布局示例
     */
    it('testTabsLayout', 0, async (done: Function) => {
      console.info('uitest: testTabsLayout begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Tabs', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.TabsLayout_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let tabs = await driver.findComponent(ON.type('Tabs'));
      expect(tabs === null).assertFalse();
      let scrollPoint:Point = {x:400,y:400};
      await driver.mouseScroll(scrollPoint,true,2);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testTabsLayout end');
      done();
    })

    /**
     * @tc.number UiTest_016
     * @tc.name testBottomTabBar
     * @tc.desc 测试底部导航示例
     */
    it('testBottomTabBar', 0, async (done: Function) => {
      console.info('uitest: testBottomTabBar begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Tabs', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.BottomTabBar_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let tabs = await driver.findComponent(ON.type('Tabs'));
      expect(tabs === null).assertFalse();
      let scrollPoint:Point = {x:400,y:400};
      await driver.mouseScroll(scrollPoint,true,2);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testBottomTabBar end');
      done();
    })

    /**
     * @tc.number UiTest_017
     * @tc.name testTopTabBar
     * @tc.desc 测试顶部导航示例
     */
    it('testTopTabBar', 0, async (done: Function) => {
      console.info('uitest: testBottomTabBar begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Tabs', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.TopTabBar_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let tabs = await driver.findComponent(ON.type('Tabs'));
      expect(tabs === null).assertFalse();
      let scrollPoint:Point = {x:400,y:400};
      await driver.mouseScroll(scrollPoint,true,2);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testBottomTabBar end');
      done();
    })

    /**
     * @tc.number UiTest_018
     * @tc.name testSideTabBar
     * @tc.desc 测试侧边导航示例
     */
    it('testSideTabBar', 0, async (done: Function) => {
      console.info('uitest: tesSideTabBar begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Tabs', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.SideTabBar_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let tabs = await driver.findComponent(ON.type('Tabs'));
      expect(tabs === null).assertFalse();
      let scrollPoint:Point = {x:400,y:400};
      await driver.mouseScroll(scrollPoint,true,4);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: tesSideTabBar end');
      done();
    })

    /**
     * @tc.number UiTest_019
     * @tc.name testSwipeLockedTabBar
     * @tc.desc 测试限制导航栏的滑动切换示例
     */
    it('testSwipeLockedTabBar', 0, async (done: Function) => {
      console.info('uitest: testSwipeLockedTabBar begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Tabs', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.SwipeLockedTabBar_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let tabs = await driver.findComponent(ON.type('Tabs'));
      expect(tabs === null).assertFalse();
      let scrollPoint:Point = {x:400,y:400};
      await driver.mouseScroll(scrollPoint,true,4);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testSwipeLockedTabBar end');
      done();
    })

    /**
     * @tc.number UiTest_020
     * @tc.name testFixedTabBar
     * @tc.desc 测试固定导航栏示例
     */
    it('testFixedTabBar', 0, async (done: Function) => {
      console.info('uitest: testFixedTabBar begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Tabs', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.FixedTabBar_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let tabs = await driver.findComponent(ON.type('Tabs'));
      expect(tabs === null).assertFalse();
      let scrollPoint:Point = {x:400,y:400};
      await driver.mouseScroll(scrollPoint,true,4);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testFixedTabBar end');
      done();
    })

    /**
     * @tc.number UiTest_021
     * @tc.name testScrollableTabBar
     * @tc.desc 测试滚动导航栏示例
     */
    it('testScrollableTabBar', 0, async (done: Function) => {
      console.info('uitest: testScrollableTabBar begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Tabs', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.ScrollableTabBar_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let tabs = await driver.findComponent(ON.type('Tabs'));
      expect(tabs === null).assertFalse();
      let scrollPoint:Point = {x:400,y:400};
      await driver.mouseScroll(scrollPoint,true,12);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testScrollableTabBar end');
      done();
    })

    /**
     * @tc.number UiTest_022
     * @tc.name testCustomTabBar
     * @tc.desc 测试自定义导航栏示例
     */
    it('testCustomTabBar', 0, async (done: Function) => {
      console.info('uitest: testCustomTabBar begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Tabs', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.CustomTabBar_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let tabs = await driver.findComponent(ON.type('Tabs'));
      expect(tabs === null).assertFalse();
      let scrollPoint:Point = {x:400,y:400};
      await driver.mouseScroll(scrollPoint,true,4);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testCustomTabBar end');
      done();
    })
  })
}