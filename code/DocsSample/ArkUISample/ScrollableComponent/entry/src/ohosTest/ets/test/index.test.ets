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

    /**
     * @tc.number UiTest_023
     * @tc.name testArcSwiperAction
     * @tc.desc 测试弧形轮播动画示例
     */
    it('ArcSwiperAction', 0, async (done: Function) => {
      console.info('uitest: testSwiperCustomAnimation begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('ArcSwiper', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.ArcSwiperAction_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let swiper = await driver.findComponent(ON.type('Swiper'));
      expect(swiper === null).assertFalse();
      let scrollPoint:Point = {x:300,y:300};
      await driver.mouseScroll(scrollPoint,true,2);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testArcSwiperAction end');
      done();
    })

    /**
     * @tc.number UiTest_024
     * @tc.name testArcSwiperVertical
     * @tc.desc 测试弧形轮播垂直方向示例
     */
    it('ArcSwiperVertical   ', 0, async (done: Function) => {
      console.info('uitest: testArcSwiperVertical begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('ArcSwiper', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.ArcSwiperVertical_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let swiper = await driver.findComponent(ON.type('Swiper'));
      expect(swiper === null).assertFalse();
      let scrollPoint:Point = {x:300,y:300};
      await driver.mouseScroll(scrollPoint,true,2);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testArcSwiperVertical end');
      done();
    })

    /**
     * @tc.number UiTest_025
     * @tc.name testArcSwiperHorizontal
     * @tc.desc 测试弧形轮播水平方向示例
     */
    it('ArcSwiperHorizontal', 0, async (done: Function) => {
      console.info('uitest: testArcSwiperHorizontal begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('ArcSwiper', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.ArcSwiperHorizontal_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let swiper = await driver.findComponent(ON.type('Swiper'));
      expect(swiper === null).assertFalse();
      let scrollPoint:Point = {x:300,y:300};
      await driver.mouseScroll(scrollPoint,true,2);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testArcSwiperHorizontal end');
      done();
    })

    /**
     * @tc.number UiTest_026
     * @tc.name testArcSwiperSideSlip
     * @tc.desc 测试弧形轮播侧滑返回示例
     */
    it('ArcSwiperSideSlip', 0, async (done: Function) => {
      console.info('uitest: testArcSwiperSideSlip begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('ArcSwiper', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.ArcSwiperSideSlip_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let swiper = await driver.findComponent(ON.type('Swiper'));
      expect(swiper === null).assertFalse();
      let scrollPoint:Point = {x:300,y:300};
      await driver.mouseScroll(scrollPoint,true,2);
      await driver.mouseScroll(scrollPoint,false,2);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testArcSwiperSideSlip end');
      done();
    })

    /**
     * @tc.number UiTest_027
     * @tc.name testArcSwiperToggle
     * @tc.desc 测试弧形轮播页面切换方式示例
     */
    it('ArcSwiperToggle', 0, async (done: Function) => {
      console.info('uitest: testArcSwiperToggle begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('ArcSwiper', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.ArcSwiperToggle_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let preArcButton = await driver.findComponent(ON.text('previous', MatchPattern.CONTAINS));
      let nextArcButton = await driver.findComponent(ON.text('next', MatchPattern.CONTAINS));
      expect(preArcButton === null).assertFalse();
      expect(nextArcButton === null).assertFalse();
      await nextArcButton.click();
      await preArcButton.click();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testArcSwiperToggle end');
      done();
    })

    /**
     * @tc.number UiTest_028
     * @tc.name testArcSwiperStyles
     * @tc.desc 测试弧形轮播设置导航点样式示例
     */
    it('ArcSwiperStyles', 0, async (done: Function) => {
      console.info('uitest: testArcSwiperToggle begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('ArcSwiper', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.ArcSwiperStyles_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let swiper = await driver.findComponent(ON.type('Swiper'));
      expect(swiper === null).assertFalse();
      let scrollPoint:Point = {x:300,y:300};
      let scrollPoint2:Point = {x:300,y:600};
      await driver.mouseScroll(scrollPoint,true,2);
      await driver.mouseScroll(scrollPoint2,true,2);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testArcSwiperStyles end');
      done();
    })

    /**
     * @tc.number UiTest_029
     * @tc.name testSwiperAndTabsLinkage
     * @tc.desc 测试轮播与选项卡联动示例
     */
    it('SwiperAndTabsLinkage', 0, async (done: Function) => {
      console.info('uitest: testSwiperAndTabsLinkage begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Swiper', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.SwiperAndTabsLinkage_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let swiper = await driver.findComponent(ON.type('Swiper'));
      expect(swiper === null).assertFalse();
      let scrollPoint:Point = {x:400,y:500};
      await driver.mouseScroll(scrollPoint,true,2);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testSwiperAndTabsLinkage end');
      done();
    })

    /**
     * @tc.number UiTest_030
     * @tc.name testLongGrid
     * @tc.desc 测试网格性能优化示例
     */
    it('LongGrid', 0, async (done: Function) => {
      console.info('uitest: testLongGrid begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Grid', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.LongGrid_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let scrollableGrid = await driver.findComponent(ON.type('Grid'));
      expect(scrollableGrid === null).assertFalse();
      await scrollableGrid.scrollToBottom();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testLongGrid end');
      done();
    })

    /**
     * @tc.number UiTest_031
     * @tc.name testGridScrollbar
     * @tc.desc 测试网格添加外置滚动条示例
     */
    it('GridScrollbar', 0, async (done: Function) => {
      console.info('uitest: testGridScrollbar begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Grid', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.GridScrollbar_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let scrollableGrid = await driver.findComponent(ON.type('Grid'));
      expect(scrollableGrid === null).assertFalse();
      await scrollableGrid.scrollToBottom();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testGridScrollbar end');
      done();
    })

    /**
     * @tc.number UiTest_032
     * @tc.name testGridSideToSide
     * @tc.desc 测试网格控制滚动位置示例
     */
    it('GridSideToSide', 0, async (done: Function) => {
      console.info('uitest: testGridSideToSide begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Grid', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.GridSideToSide_description'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let preArcButton = await driver.findComponent(ON.text('上一页', MatchPattern.CONTAINS));
      let nextArcButton = await driver.findComponent(ON.text('下一页', MatchPattern.CONTAINS));
      expect(preArcButton === null).assertFalse();
      expect(nextArcButton === null).assertFalse();
      await nextArcButton.click();
      await preArcButton.click();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testGridSideToSide end');
      done();
    })

    /**
     * @tc.number UiTest_033
     * @tc.name testLongList
     * @tc.desc 测试长列表示例
     */
    it('LongList', 0, async (done: Function) => {
      console.info('uitest: testLongList begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('List', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let list = await driver.findComponent(ON.type('List'));
      expect(list === null).assertFalse();
      await list.scrollToBottom(1000);
      let str = await getResourceString($r('app.string.LongList_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let scrollableList = await driver.findComponent(ON.type('List'));
      expect(scrollableList === null).assertFalse();
      await scrollableList.scrollToBottom();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testLongList end');
      done();
    })

    /**
     * @tc.number UiTest_033
     * @tc.name testCollapseAndExpand
     * @tc.desc 测试列表折叠与展开示例
     */
    it('CollapseAndExpand', 0, async (done: Function) => {
      console.info('uitest: testCollapseAndExpand begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('List', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let list = await driver.findComponent(ON.type('List'));
      expect(list === null).assertFalse();
      await list.scrollToBottom(1000);
      let str = await getResourceString($r('app.string.CollapseAndExpand_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let text = await driver.findComponent(ON.text('个人基本资料', MatchPattern.CONTAINS));
      expect(text === null).assertFalse();
      await text.click();
      let nameText = await driver.findComponent(ON.text('昵称', MatchPattern.CONTAINS));
      expect(nameText === null).assertFalse();
      await text.click();
      nameText = await driver.findComponent(ON.text('昵称', MatchPattern.CONTAINS));
      expect(nameText === null).assertTrue();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testCollapseAndExpand end');
      done();
    })

    /**
     * @tc.number UiTest_035
     * @tc.name testArcLongList
     * @tc.desc 测试弧形长列表示例
     */
    it('ArcLongList', 0, async (done: Function) => {
      console.info('uitest: testArcLongList begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('ArcList', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.ArcLongList_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let arclist = await driver.findComponent(ON.type('ArcList'));
      expect(arclist === null).assertFalse();
      await arclist.scrollToBottom(15000);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testArcLongList end');
      done();
    })

    /**
     * @tc.number UiTest_036
     * @tc.name testArcListAcrScrollBar
     * @tc.desc 测试弧形列表外置滚动条示例
     */
    it('ArcListAcrScrollBar', 0, async (done: Function) => {
      console.info('uitest: testArcListAcrScrollBar begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('ArcList', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.ArcListAcrScrollBar_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let arclist = await driver.findComponent(ON.type('ArcList'));
      expect(arclist === null).assertFalse();
      await arclist.scrollToBottom();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testArcListAcrScrollBar end');
      done();
    })

    /**
     * @tc.number UiTest_037
     * @tc.name testArcListBuiltInScrollerBar
     * @tc.desc 测试弧形列表内置滚动条示例
     */
    it('arcListBuiltInScrollerBar', 0, async (done: Function) => {
      console.info('uitest: testArcListBuiltInScrollerBar begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('ArcList', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.arcListBuiltInScrollerBar_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let arclist = await driver.findComponent(ON.type('ArcList'));
      expect(arclist === null).assertFalse();
      await arclist.scrollToBottom();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testArcListBuiltInScrollerBar end');
      done();
    })

    /**
     * @tc.number UiTest_038
     * @tc.name testArcListContents
     * @tc.desc 测试弧形列表内置滚动条示例
     */
    it('ArcListContents', 0, async (done: Function) => {
      console.info('uitest: testArcListContents begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('ArcList', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.ArcListContents_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let arclist = await driver.findComponent(ON.type('ArcList'));
      expect(arclist === null).assertFalse();
      await arclist.scrollToBottom();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testArcListContents end');
      done();
    })

    /**
     * @tc.number UiTest_039
     * @tc.name testArcListShow
     * @tc.desc 测试弧形列表展示数据示例
     */
    it('ArcListShow', 0, async (done: Function) => {
      console.info('uitest: testArcListShow begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('ArcList', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.ArcListShow_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let arclist = await driver.findComponent(ON.type('ArcList'));
      expect(arclist === null).assertFalse();
      await arclist.scrollToBottom();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testArcListShow end');
      done();
    })

    /**
     * @tc.number UiTest_040
     * @tc.name testArcListStyles
     * @tc.desc 测试弧形列表设置样式示例
     */
    it('ArcListStyles', 0, async (done: Function) => {
      console.info('uitest: testArcListStyles begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('ArcList', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.ArcListStyles_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let arclist = await driver.findComponent(ON.type('List'));
      expect(arclist === null).assertFalse();
      await arclist.scrollToBottom();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testArcListStyles end');
      done();
    })

    /**
     * @tc.number UiTest_041
     * @tc.name testArcListArcIndexerBar
     * @tc.desc 测试弧形列表联动indexer示例
     */
    it('ArcListArcIndexerBar', 0, async (done: Function) => {
      console.info('uitest: testArcListArcIndexerBar begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('ArcList', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.ArcListArcIndexerBar_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let button = await driver.findComponent(ON.type('Button'));
      expect(button === null).assertFalse();
      await button.click();
      let testText = await driver.findComponent(ON.text('F', MatchPattern.CONTAINS));
      expect(testText === null).assertFalse();
      let arclist = await driver.findComponent(ON.type('ArcList'));
      expect(arclist === null).assertFalse();
      await arclist.scrollToBottom(5000);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number UiTest_042
     * @tc.name testArcListSideSlip
     * @tc.desc 测试弧形列表侧滑示例
     */
    it('ArcListSideSlip', 0,    async (done: Function) => {
      console.info('uitest: testArcListSideSlip begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('ArcList', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.ArcListSideSlip_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let arclist = await driver.findComponent(ON.type('ArcList'));
      expect(arclist === null).assertFalse();
      let scrollPoint:Point = {x:200,y:500};
      let scrollPoint2:Point = {x:500,y:500};

      await driver.fling(scrollPoint2,scrollPoint,1,600);
      let button = await driver.findComponent(ON.type('Button'));
      expect(button === null).assertFalse();
      await button.click();
      let testText = await driver.findComponent(ON.text('Alice', MatchPattern.CONTAINS));
      expect(testText === null).assertTrue();
      await arclist.scrollToBottom(5000);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testArcListSideSlip end');
      done();
    })

    /**
     * @tc.number UiTest_043
     * @tc.name testWaterFlowDynamicSwitchover
     * @tc.desc 测试瀑布流动态切换列数示例
     */
    it('WaterFlowDynamicSwitchover', 0, async (done: Function) => {
      console.info('uitest: testWaterFlowDynamicSwitchover begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('WaterFlow', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.WaterFlowDynamicSwitchover_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let arclist = await driver.findComponent(ON.type('WaterFlow'));
      expect(arclist === null).assertFalse();
      let flowItemText = await driver.findComponent(ON.text('FlowItem0', MatchPattern.CONTAINS));
      expect(flowItemText === null).assertFalse();
      let scrollPoint:Point = {x:350,y:1100};
      let scrollPoint2:Point = {x:350,y:550};
      await driver.fling(scrollPoint,scrollPoint2,1,1200);
      let button = await driver.findComponent(ON.type('Button'));
      expect(button === null).assertFalse();
      await button.click();
      let testText = await driver.findComponent(ON.text('N9', MatchPattern.CONTAINS));
      expect(testText === null).assertFalse();
      await driver.fling(scrollPoint,scrollPoint2,1,1200);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testWaterFlowDynamicSwitchover end');
      done();
    })

    /**
     * @tc.number UiTest_044
     * @tc.name testWaterFlowGroupingMixing
     * @tc.desc 测试瀑布流混合布局示例
     */
    it('WaterFlowGroupingMixing', 0, async (done: Function) => {
      console.info('uitest: testWaterFlowGroupingMixing begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('WaterFlow', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.WaterFlowGroupingMixing_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let arclist = await driver.findComponent(ON.type('WaterFlow'));
      expect(arclist === null).assertFalse();
      let scrollPoint:Point = {x:350,y:1100};
      let scrollPoint2:Point = {x:350,y:550};
      await driver.fling(scrollPoint,scrollPoint2,1,1200);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testWaterFlowGroupingMixing end');
      done();
    })

    /**
     * @tc.number UiTest_045
     * @tc.name testWaterFlowInfiniteScrolling
     * @tc.desc 测试瀑布流无限滑动触底增加示例
     */
    it('WaterFlowInfiniteScrolling', 0, async (done: Function) => {
      console.info('uitest: testWaterFlowInfiniteScrolling begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('WaterFlow', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.WaterFlowInfiniteScrolling_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let arclist = await driver.findComponent(ON.type('WaterFlow'));
      expect(arclist === null).assertFalse();
      let scrollPoint:Point = {x:350,y:1100};
      let scrollPoint2:Point = {x:350,y:550};
      await driver.fling(scrollPoint,scrollPoint2,1,1200);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testWaterFlowInfiniteScrolling end');
      done();
    })

    /**
     * @tc.number UiTest_046
     * @tc.name testWaterFlowInfiniteScrollingEarly
     * @tc.desc 测试瀑布流无限滑动提前增加示例
     */
    it('WaterFlowInfiniteScrollingEarly', 0, async (done: Function) => {
      console.info('uitest: testWaterFlowInfiniteScrollingEarly begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('WaterFlow', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.WaterFlowInfiniteScrollingEarly_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let arclist = await driver.findComponent(ON.type('WaterFlow'));
      expect(arclist === null).assertFalse();
      let scrollPoint:Point = {x:350,y:1100};
      let scrollPoint2:Point = {x:350,y:550};
      await driver.fling(scrollPoint,scrollPoint2,1,1200);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testWaterFlowInfiniteScrollingEarly end');
      done();
    })

    /**
     * @tc.number UiTest_034
     * @tc.name testListChatRoom
     * @tc.desc 测试列表切换布局方向示例
     */
    it('ListChatRoom', 0, async (done: Function) => {
      console.info('uitest: testListChatRoom begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('List', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let list = await driver.findComponent(ON.type('List'));
      expect(list === null).assertFalse();
      await list.scrollToBottom(1000);
      let str = await getResourceString($r('app.string.ListChatRoom_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let textInput = await driver.findComponent(ON.type('TextInput'));
      expect(textInput === null).assertFalse();
      await textInput.inputText("message test")
      let testButton = await driver.findComponent(ON.text('发送', MatchPattern.CONTAINS));
      expect(testButton === null).assertFalse();
      await testButton.click();
      await driver.mouseClick({x: 670, y: 700}, MouseButton.MOUSE_BUTTON_LEFT, 0, 0);
      let nameText = await driver.findComponent(ON.text('message test', MatchPattern.CONTAINS));
      expect(nameText === null).assertFalse();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testListChatRoom end');
      done();
    })

  })
}