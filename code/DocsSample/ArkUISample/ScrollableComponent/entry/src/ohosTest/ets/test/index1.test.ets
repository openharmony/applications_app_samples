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

const DOMAIN = 0x0000;
const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let want: Want;

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let textString: string = await manage.getStringValue(resource);
  return textString;
}

export default function Index1Test() {
  describe('Index1Test', () => {
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
      let list = await driver.findComponent(ON.type('List'));
      expect(list === null).assertFalse();
      await list.scrollToBottom(2400);
      let str = await getResourceString($r('app.string.ArcLongList_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      let arclist = await driver.findComponent(ON.type('ArcList'));
      expect(arclist === null).assertFalse();
      await arclist.scrollToBottom(30000);
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
     * @tc.desc 测试弧形列表迭代弧形列表内容示例
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
     * @tc.number UiTest_042
     * @tc.name testArcListSideSlip
     * @tc.desc 测试弧形列表侧滑示例
     */
    it('ArcListSideSlip', 0, async (done: Function) => {
      console.info('uitest: testArcListSideSlip begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('ArcList', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.ArcListSideSlip_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let testText = await driver.findComponent(ON.text('Alice', MatchPattern.CONTAINS));
      expect(testText === null).assertFalse();
      let arclist = await driver.findComponent(ON.type('ArcList'));
      expect(arclist === null).assertFalse();
      await arclist.scrollToBottom(5000);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testArcListSideSlip end');
      done();
    })

    /**
     * @tc.number UiTest_047
     * @tc.name testArcListCrown
     * @tc.desc 测试弧形列表响应旋转表冠示例
     */
    it('ArcListCrown', 0, async (done: Function) => {
      console.info('=====>uitest: testArcListCrown begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('ArcList', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      await driver.swipe(100, 1000, 500, 400);
      let str = await getResourceString($r('app.string.ArcListCrown_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      let arclist = await driver.findComponent(ON.type('ArcList'));
      expect(arclist === null).assertFalse();
      await arclist.scrollToBottom();
      await driver.pressBack();
      await driver.pressBack();
      console.info('=====>uitest: testArcListCrown end');
      done();
    })

    /**
     * @tc.number UiTest_048
     * @tc.name testArcListCreate
     * @tc.desc 测试弧形列表创建弧形列表示例
     */
    it('ArcListCreate', 0, async (done: Function) => {
      console.info('=====>uitest: testArcListCreate begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('ArcList', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let list = await driver.findComponent(ON.type('List'));
      expect(list === null).assertFalse();
      await list.scrollToBottom(1000);
      let str = await getResourceString($r('app.string.ArcListCreate_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      let arclist = await driver.findComponent(ON.type('ArcList'));
      expect(arclist === null).assertFalse();
      await arclist.scrollToBottom();
      await driver.pressBack();
      await driver.pressBack();
      console.info('=====>uitest: testArcListCreate end');
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
      if (arclist === null) {
        console.log("=====> arclist is null");
      }
      expect(arclist === null).assertFalse();
      let flowItemText = await driver.findComponent(ON.text('FlowItem0', MatchPattern.CONTAINS));
      if (flowItemText === null) {
        console.log("=====> flowItemText is null");
      }
      expect(flowItemText === null).assertFalse();
      let scrollPoint: Point = { x: 350, y: 1100 };
      let scrollPoint2: Point = { x: 350, y: 550 };
      await driver.fling(scrollPoint, scrollPoint2, 1, 2000);
      let button = await driver.findComponent(ON.type('Button'));
      if (button === null) {
        console.log("=====> button is null");
      }
      expect(button === null).assertFalse();
      await button.click();

      let testText = await driver.findComponent(ON.text('N9', MatchPattern.CONTAINS));
      if (testText === null) {
        console.log("=====> testText is null");
      }
      expect(testText === null).assertFalse();
      await driver.fling(scrollPoint, scrollPoint2, 1, 1200);
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
      let scrollPoint: Point = { x: 350, y: 1100 };
      let scrollPoint2: Point = { x: 350, y: 550 };
      await driver.fling(scrollPoint, scrollPoint2, 1, 1200);
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
      let scrollPoint: Point = { x: 350, y: 1100 };
      let scrollPoint2: Point = { x: 350, y: 550 };
      await driver.fling(scrollPoint, scrollPoint2, 1, 1200);
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
      let scrollPoint: Point = { x: 350, y: 1100 };
      let scrollPoint2: Point = { x: 350, y: 550 };
      await driver.fling(scrollPoint, scrollPoint2, 1, 1200);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testWaterFlowInfiniteScrollingEarly end');
      done();
    })
  })
}