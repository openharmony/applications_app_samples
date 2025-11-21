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

import { describe, it, expect, beforeAll, Level } from '@ohos/hypium';
// 导入测试依赖kit
import { abilityDelegatorRegistry, Driver, ON, MatchPattern, Component } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let want: Want;
const TAG = '[Sample_Textcomponent]';
const DOMAIN = 0xF811;
const BUNDLE = 'Textcomponent_';

async function getResourceString(resource: string): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let textString: string = await manage.getStringByName(resource);
  return textString;
}

export default function Index2Test() {
  describe('Index2Test', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(500);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(DOMAIN, TAG, BUNDLE + "get top ability");
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number UiTest_006
     * @tc.name testAIMenu
     * @tc.desc 测试设置AI菜单场景示例
     * @tc.level: Level 1
     */
    it('testAIMenu', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "uitest: testAIMenu begin");
      let driver = Driver.create();
      await driver.delayMs(500);
      let buttonComponent = await driver.findComponent(ON.text('Text', MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();

      let str = await getResourceString('SetUpAIMenu_title');
      await driver.delayMs(500);
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      str = await getResourceString('AIMenu_Text_One');
      await driver.delayMs(500);
      let aiMenuText = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(aiMenuText === null).assertFalse();

      await driver.pressBack();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + "uitest: testAIMenu end");
      done();
    })

    /**
     * @tc.number UiTest_007
     * @tc.name testHotSearch
     * @tc.desc 测试热搜榜场景示例
     * @tc.level: Level 1
     */
    it('testHotSearch', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "uitest: testHotSearch begin");
      let driver = Driver.create();
      await driver.delayMs(500);
      let buttonComponent = await driver.findComponent(ON.text('Text', MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString('TextHotSearch_title');
      await driver.delayMs(500);
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.delayMs(500);
      let textHotSearch1 = await driver.findComponent(ON.text('1'));
      let textHotSearch2 = await driver.findComponent(ON.text('2'));
      let textHotSearch3 = await driver.findComponent(ON.text('3'));
      let textHotSearch4 = await driver.findComponent(ON.text('4'));
      await driver.delayMs(500);
      expect(textHotSearch1 === null).assertFalse();
      expect(textHotSearch2 === null).assertFalse();
      expect(textHotSearch3 === null).assertFalse();
      expect(textHotSearch4 === null).assertFalse();

      str = await getResourceString('TextHotSearch_textContent_one');
      let hotText1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString('TextHotSearch_textContent_two');
      let hotText2 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString('TextHotSearch_textContent_three');
      let hotText3 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString('TextHotSearch_textContent_four');
      let hotText4 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString('TextHotSearch_textContent_five');
      let hotText5 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString('TextHotSearch_textContent_six');
      let hotText6 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(hotText1 === null).assertFalse();
      expect(hotText2 === null).assertFalse();
      expect(hotText3 === null).assertFalse();
      expect(hotText4 === null).assertFalse();
      expect(hotText5 === null).assertFalse();
      expect(hotText6 === null).assertFalse();

      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + "uitest: testHotSearch end");
      done();
    })

    /**
     * @tc.number UiTest_053
     * @tc.name testDisableMenuItems
     * @tc.desc 测试屏蔽系统服务类菜单(disableMenuItems)示例
     * @tc.level: Level 1
     */
    it('testDisableMenuItems', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "uitest: testDisableMenuItems begin");
      let driver = Driver.create();
      await driver.delayMs(500);
      let buttonComponent = await driver.findComponent(ON.text('Text', MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await driver.delayMs(500);
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      await driver.delayMs(500);
      expect(scrollComponent === null).assertFalse();
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + `[XYING6] (scrollCenter.x, scrollCenter.y): (${scrollCenter.x}, ${scrollCenter.y})`);
      await driver.swipe(scrollCenter.x, scrollCenter.y, scrollCenter.x, scrollCenter.y - 1300, 8000);
      await driver.waitForIdle(500, 500);

      let str = await getResourceString('Disable_MenuItems');
      await driver.delayMs(500);
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      str = await getResourceString('Service_MenuItems_Text');
      await driver.delayMs(500);
      let disableMenuItemsText = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(disableMenuItemsText === null).assertFalse();

      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + "uitest: testDisableMenuItems end");
      done();
    })

    /**
     * @tc.number UiTest_054
     * @tc.name testPrepareMenu
     * @tc.desc 测试默认菜单支持自定义刷新能力(onPrepareMenu)示例
     * @tc.level: Level 1
     */
    it('testPrepareMenu', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "uitest: testPrepareMenu begin");
      let driver = Driver.create();
      await driver.delayMs(500);
      let buttonComponent = await driver.findComponent(ON.text('Text', MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();

      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      await driver.delayMs(500);
      expect(scrollComponent === null).assertFalse();
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + `[XYING6] (scrollCenter.x, scrollCenter.y): (${scrollCenter.x}, ${scrollCenter.y})`);
      await driver.swipe(scrollCenter.x, scrollCenter.y, scrollCenter.x, scrollCenter.y - 1300, 8000);
      await driver.waitForIdle(500, 500);

      let str = await getResourceString('Prepare_Menu');
      await driver.delayMs(500);
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.delayMs(500);
      let prepareMenuText = await driver.findComponent(ON.text('Text editMenuOptions'));
      await driver.delayMs(500);
      expect(prepareMenuText === null).assertFalse();

      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + "uitest: testPrepareMenu end");
      done();
    })

    /**
     * @tc.number UiTest_055
     * @tc.name testWordBreakd
     * @tc.desc 测试Text组件尾部省略号后为什么还有一段空白，没有占满组件宽度解决措施示例
     * @tc.level: Level 1
     */
    it('testWordBreakd', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "uitest: testWordBreakd begin");
      let driver = Driver.create();
      await driver.delayMs(500);
      let buttonComponent = await driver.findComponent(ON.text('Text', MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();

      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      await driver.delayMs(500);
      expect(scrollComponent === null).assertFalse();
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + `[XYING6] (scrollCenter.x, scrollCenter.y): (${scrollCenter.x}, ${scrollCenter.y})`);
      await driver.swipe(scrollCenter.x, scrollCenter.y, scrollCenter.x, scrollCenter.y - 1300, 10000);
      await driver.waitForIdle(500, 500);

      let str = await getResourceString('Word_Break');
      await driver.delayMs(500);
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.delayMs(500);
      str = await getResourceString('Text_WordBreak');
      let wordBreakdText = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(wordBreakdText === null).assertFalse();

      await driver.pressBack();
      await driver.delayMs(500)
      await driver.pressBack();
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + "uitest: testWordBreakd end");
      done();
    })

    /**
     * @tc.number UiTest_056
     * @tc.name testHeightAdaptivePolicy
     * @tc.desc 测试Text组件如何实现不设置maxLines在固定布局约束下内容超出仍显示省略样式示例
     * @tc.level: Level 1
     */
    it('testHeightAdaptivePolicy', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "uitest: testHeightAdaptivePolicy begin");
      let driver = Driver.create();
      await driver.delayMs(500);
      let buttonComponent = await driver.findComponent(ON.text('Text', MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await driver.delayMs(500);
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      await driver.delayMs(500);
      expect(scrollComponent === null).assertFalse();
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + `[XYING6] (scrollCenter.x, scrollCenter.y): (${scrollCenter.x}, ${scrollCenter.y})`);
      await driver.swipe(scrollCenter.x, scrollCenter.y, scrollCenter.x, scrollCenter.y - 1300, 8000);
      await driver.swipe(100, 1000, 100, 6000);
      await driver.delayMs(500);
      await driver.swipe(100, 1000, 100, 6000);
      await driver.delayMs(500);
      await driver.waitForIdle(500, 500);
      await driver.delayMs(500);
      let str = await getResourceString('Height_AdaptivePolicy');
      await driver.delayMs(500);
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.delayMs(500);
      str = await getResourceString('Text_Adaptive_Layout');
      await driver.delayMs(500);
      let heightAdaptivePolicyText = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(heightAdaptivePolicyText === null).assertFalse();

      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + "uitest: testHeightAdaptivePolicy end");
      done();
    })

    /**
     * @tc.number UiTest_057
     * @tc.name testLengthMetric
     * @tc.desc 测试在文本前后添加自定义标签示例二
     * @tc.level: Level 1
     */
    it('testLengthMetric', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "uitest: testLengthMetric begin");
      let driver = Driver.create();
      await driver.delayMs(500);
      let buttonComponent = await driver.findComponent(ON.text('Text', MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await driver.delayMs(500);
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      await driver.delayMs(500);
      expect(scrollComponent === null).assertFalse();
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + `[XYING6] (scrollCenter.x, scrollCenter.y): (${scrollCenter.x}, ${scrollCenter.y})`);
      await driver.swipe(scrollCenter.x, scrollCenter.y, scrollCenter.x, scrollCenter.y - 1300, 12000);
      await driver.waitForIdle(500, 500);
      let str = await getResourceString('Length_Metric');
      await driver.delayMs(500);
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.delayMs(500);
      str = await getResourceString('Text_Add_Tags_Front_and_Post');
      let middleText = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString('Text_Add_Tags_Front');
      let frontText = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString('Text_Add_Tags_Post');
      let backText = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(middleText === null).assertFalse();
      expect(frontText === null).assertFalse();
      expect(backText === null).assertFalse();
      await driver.pressBack();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + "uitest: testLengthMetric end");
      done();
    })


    /**
     * @tc.number UiTest_058
     * @tc.name testDisplayedTogether
     * @tc.desc 测试Text组件如何实现表情与文字一起显示(Span,ImageSpan)示例
     * @tc.level: Level 1
     */
    it('testDisplayedTogether', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "uitest: testDisplayedTogether begin");
      let driver = Driver.create();
      await driver.delayMs(500);
      let buttonComponent = await driver.findComponent(ON.text('Text', MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await driver.delayMs(500);
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      await driver.delayMs(500);
      expect(scrollComponent === null).assertFalse();
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + `[XYING6] (scrollCenter.x, scrollCenter.y): (${scrollCenter.x}, ${scrollCenter.y})`);
      await driver.swipe(scrollCenter.x, scrollCenter.y, scrollCenter.x, scrollCenter.y - 1300, 13000);
      await driver.waitForIdle(500, 500);
      await driver.delayMs(500);
      let str = await getResourceString('Displayed_Together');
      await driver.delayMs(500);
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.delayMs(500);
      let textInput = await driver.findComponent(ON.type('TextInput'));
      await driver.delayMs(500);
      str = await getResourceString('Text_Full_Text');
      await textInput.inputText(str)
      await driver.delayMs(500);

      await driver.pressBack();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + "uitest: testDisplayedTogether end");
      done();
    })


    /**
     * @tc.number UiTest_059
     * @tc.name testLengthMetric
     * @tc.desc 测试文本超长时如何展示(maxLines,textOverflow)示例一
     * @tc.level: Level 1
     */
    it('testTextLong', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "uitest: testTextLong begin");
      let driver = Driver.create();
      await driver.delayMs(500);
      let buttonComponent = await driver.findComponent(ON.text('Text', MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await driver.delayMs(500);
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      await driver.delayMs(500);
      expect(scrollComponent === null).assertFalse();
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + `[XYING6] (scrollCenter.x, scrollCenter.y): (${scrollCenter.x}, ${scrollCenter.y})`);
      await driver.swipe(scrollCenter.x, scrollCenter.y, scrollCenter.x, scrollCenter.y - 1300, 14000);
      await driver.waitForIdle(500, 500);
      await driver.delayMs(500);
      let str = await getResourceString('Text_Long');
      await driver.delayMs(500);
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.delayMs(500);
      str = await getResourceString('Text_Long_String');
      let textLongText = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(textLongText === null).assertFalse();

      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + "uitest: testTextLong end");
      done();
    })


    /**
     * @tc.number UiTest_060
     * @tc.name testLengthMetric
     * @tc.desc 测试文本超长时如何展示(Scroll)示例二
     * @tc.level: Level 1
     */
    it('testTextLongTow', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "uitest: testTextLongTow begin");
      let driver = Driver.create();
      await driver.delayMs(500);
      let buttonComponent = await driver.findComponent(ON.text('Text', MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await driver.delayMs(500);
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      await driver.delayMs(500);
      expect(scrollComponent === null).assertFalse();
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + `[XYING6] (scrollCenter.x, scrollCenter.y): (${scrollCenter.x}, ${scrollCenter.y})`);
      await driver.swipe(scrollCenter.x, scrollCenter.y, scrollCenter.x, scrollCenter.y - 1300, 14000);
      await driver.waitForIdle(500, 500);
      await driver.delayMs(500);
      let str = await getResourceString('Text_Long_Tow');
      await driver.delayMs(500);
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.delayMs(500);
      str = await getResourceString('Text_Long_String');
      let textLongTowText = await driver.findComponent(ON.text(str,  MatchPattern.CONTAINS));
      await driver.delayMs(500);
      expect(textLongTowText === null).assertFalse();

      await driver.pressBack();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + "uitest: testTextLongTow end");
      done();
    })

  })
}
