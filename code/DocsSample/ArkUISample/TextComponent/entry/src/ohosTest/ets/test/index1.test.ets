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
import { abilityDelegatorRegistry, Driver, ON, MatchPattern, On, Component } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let want: Want;
const TAG = '[Sample_Textcomponent]';
const DOMAIN = 0xF811;
const BUNDLE = 'Textcomponent_';

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let textString: string = await manage.getStringValue(resource);
  return textString;
}

export default function IndexTest1() {

  describe('IndexTest1', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(DOMAIN, TAG, BUNDLE + "get top ability");
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number UiTest_033
     * @tc.name testCreateApply
     * @tc.desc 测试创建并应用属性字符串场景示例
     * @tc.level: Level 1
     */
    it('testCreateApply', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testCreateApply begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('StyledString', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await driver.delayMs(1000);

      let str = await getResourceString($r('app.string.Create_Apply_StyledString_MutableStyledString_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.delayMs(1000);

      str = await getResourceString($r('app.string.CreateApply_Text_Forty_Five'));
      let styledString = await driver.findComponent(ON.text(str));
      expect(styledString === null).assertFalse();
      str = await getResourceString($r('app.string.CreateApply_Text_Third_Five'));
      let mutableStyledString = await driver.findComponent(ON.text(str));
      expect(mutableStyledString === null).assertFalse();

      await driver.pressBack();
      await driver.waitForIdle(2000, 2000);
      await driver.pressBack();
      console.info('uitest: testCreateApply end');
      done();
    })

    /**
     * @tc.number UiTest_034
     * @tc.name testStyledStringImageAttachment
     * @tc.desc 测试使用图片场景示例
     * @tc.level: Level 1
     */
    it('testStyledStringImageAttachment', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testStyledStringImageAttachment begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('StyledString', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await driver.delayMs(1000);

      await driver.swipe(100, 1000, 100, 300);
      await driver.delayMs(1000);

      let str = await getResourceString($r('app.string.StyledStringImageAttachment_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      str = await getResourceString($r('app.string.StyledStringImageAttachment_Button_1'));
      let button = await driver.findComponent(ON.text(str));
      expect(button === null).assertFalse();
      await button.click();
      await driver.waitForIdle(500, 500);
      let text1 = await driver.findComponent(ON.id('text1'));
      expect(text1 === null).assertFalse();

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testStyledStringImageAttachment end');
      done();
    })

    /**
     * @tc.number UiTest_035
     * @tc.name testStyledStringGestureStyle
     * @tc.desc 测试设置事件场景示例
     * @tc.level: Level 1
     */
    it('testStyledStringGestureStyle', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testStyledStringGestureStyle begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('StyledString', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await driver.delayMs(1000);

      await driver.swipe(100, 1100, 100, 100);
      await driver.delayMs(1000);

      let str = await getResourceString($r('app.string.TStyledStringGestureStyle_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.delayMs(1000);

      let text1 = await driver.findComponent(ON.id('text1'));
      expect(text1 === null).assertFalse();

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testStyledStringGestureStyle end');
      done();
    })

    /**
     * @tc.number UiTest_036
     * @tc.name testStyledStringHtml
     * @tc.desc 测试格式转换场景示例
     * @tc.level: Level 1
     */
    it('testStyledStringHtml', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testStyledStringHtml begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('StyledString', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await driver.delayMs(1000);

      await driver.swipe(100, 1500, 100, 100);
      await driver.delayMs(1000);

      let str = await getResourceString($r('app.string.StyledStringHtml_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.delayMs(1000);

      str = await getResourceString($r('app.string.StyledStringHtml_Button_1'));
      let addButton = await driver.findComponent(ON.text(str));
      expect(addButton === null).assertFalse();
      await addButton.click();
      await driver.waitForIdle(500, 500);

      let toHtmlButton = await driver.findComponent(ON.text('toHtml'));
      expect(toHtmlButton === null).assertFalse();
      await toHtmlButton.click();
      await driver.waitForIdle(500, 500);

      let fromHtmlButton = await driver.findComponent(ON.text('fromHtml'));
      expect(fromHtmlButton === null).assertFalse();
      await fromHtmlButton.click();
      await driver.waitForIdle(500, 500);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testStyledStringHtml end');
      done();
    })

    /**
     * @tc.number UiTest_037
     * @tc.name testStyledStringSceneExample
     * @tc.desc 测试会员过期提示场景示例
     * @tc.level: Level 1
     */
    it('testStyledStringSceneExample', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testStyledStringSceneExample begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('StyledString', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await driver.delayMs(1000);

      await driver.swipe(100, 2500, 100, 100);
      await driver.delayMs(1000);
      let str = await getResourceString($r('app.string.StyledStringSceneExample_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let text1 = await driver.findComponent(ON.id('text1'));
      expect(text1 === null).assertFalse();
      str = await getResourceString($r('app.string.StyledStringSceneExample_Button_1'));
      let button = await driver.findComponent(ON.text(str));
      expect(button === null).assertFalse();

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testStyledStringSceneExample end');
      done();
    })

    /**
     * @tc.number UiTest_038
     * @tc.name testStyledStringTextStyle
     * @tc.desc 测试创建及应用文本字体样式对象（TextStyle）示例
     * @tc.level: Level 1
     */
    it('testStyledStringTextStyle', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testStyledStringTextStyle begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('StyledString', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await driver.delayMs(1000);

      let str = await getResourceString($r('app.string.StyledStringStyle_title_1'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testStyledStringTextStyle end');
      done();
    })

    /**
     * @tc.number UiTest_039
     * @tc.name testStyledStringTextShadowStyle
     * @tc.desc 测试创建及应用文本阴影对象（TextShadowStyle）示例
     * @tc.level: Level 1
     */
    it('testStyledStringTextShadowStyle', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testStyledStringTextShadowStyle begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('StyledString', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await driver.delayMs(1000);

      let str = await getResourceString($r('app.string.StyledStringStyle_title_2'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testStyledStringTextShadowStyle end');
      done();
    })

    /**
     * @tc.number UiTest_042
     * @tc.name testStyledStringDecorationStyle
     * @tc.desc 测试创建及应用文本装饰线对象（DecorationStyle）示例
     * @tc.level: Level 1
     */
    it('testStyledStringDecorationStyle', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testStyledStringDecorationStyle begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('StyledString', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await driver.delayMs(1000);

      let str = await getResourceString($r('app.string.StyledStringStyle_title_3'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testStyledStringDecorationStyle end');
      done();
    })

    /**
     * @tc.number UiTest_043
     * @tc.name testStyledStringBaselineOffsetStyle
     * @tc.desc 测试创建及应用文本基线偏移量对象（BaselineOffsetStyle）示例
     * @tc.level: Level 1
     */
    it('testStyledStringBaselineOffsetStyle', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testStyledStringBaselineOffsetStyle begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('StyledString', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await driver.delayMs(1000);

      let str = await getResourceString($r('app.string.StyledStringStyle_title_4'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testStyledStringBaselineOffsetStyle end');
      done();
    })

    /**
     * @tc.number UiTest_047
     * @tc.name testStyledStringReplaceParagraphStyle
     * @tc.desc 测试设置段落样式方法二示例
     * @tc.level: Level 1
     */
    it('testStyledStringReplaceParagraphStyle', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testStyledStringReplaceParagraphStyle begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('StyledString', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await driver.delayMs(1000);

      await driver.swipe(100, 1300, 100, 100);

      let str = await getResourceString($r('app.string.StyledStringReplaceParagraphStyle_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.delayMs(1000);

      let str1 = await getResourceString($r('app.string.Replace_paragraph_style'));
      let button = await driver.findComponent(ON.text(str1, MatchPattern.CONTAINS));
      expect(button === null).assertFalse();
      await button.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testStyledStringReplaceParagraphStyle end');
      done();
    })

    /**
     * @tc.number UiTest_048
     * @tc.name testStyledStringConvertedToParagraph
     * @tc.desc 测试支持将属性字符串转换成Paragraph示例
     * @tc.level: Level 1
     */
    it('testStyledStringConvertedToParagraph', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testStyledStringConvertedToParagraph begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('StyledString', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await driver.delayMs(1000);

      await driver.swipe(100, 800, 100, 300);
      await driver.delayMs(1000);

      let str = await getResourceString($r('app.string.StyledStringConvertedToParagraph_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testStyledStringConvertedToParagraph end');
      done();
    })

    /**
     * @tc.number UiTest_049
     * @tc.name testStyledStringHtmlOne
     * @tc.desc 测试格式转换场景二示例
     * @tc.level: Level 1
     */
    it('testStyledStringHtmlOne', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testStyledStringHtmlOne begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('StyledString', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await driver.delayMs(1000);

      await driver.swipe(100, 2500, 100, 100);
      await driver.delayMs(1000);

      let str = await getResourceString($r('app.string.StyledStringHtmlOne_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.delayMs(1000);

      str = await getResourceString($r('app.string.Converted_HTML_to_SpanString'));
      let htmlConvertedSpanStringButton = await driver.findComponent(ON.text(str));
      expect(htmlConvertedSpanStringButton === null).assertFalse();
      await htmlConvertedSpanStringButton.click();
      await driver.waitForIdle(500, 500);

      str = await getResourceString($r('app.string.Converted_SpanString_to_HTML'));
      let SpanStringConvertedHtmlButton = await driver.findComponent(ON.text(str));
      expect(SpanStringConvertedHtmlButton === null).assertFalse();
      await SpanStringConvertedHtmlButton.click();
      await driver.waitForIdle(500, 500);

      str = await getResourceString($r('app.string.Converted_HTML_back_to_SpanString'));
      let htmlConvertedBackSpanStringButton = await driver.findComponent(ON.text(str));
      expect(htmlConvertedBackSpanStringButton === null).assertFalse();
      await htmlConvertedBackSpanStringButton.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testStyledStringHtmlOne end');
      done();
    })

    /**
     * @tc.number UiTest_050
     * @tc.name testStyledStringLineHeightStyle
     * @tc.desc 测试创建及应用文本行高对象（LineHeightStyle）示例
     * @tc.level: Level 1
     */
    it('testStyledStringLineHeightStyle', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testStyledStringLineHeightStyle begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('StyledString', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await driver.delayMs(1000);

      let str = await getResourceString($r('app.string.StyledStringStyle_title_5'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testStyledStringLineHeightStyle end');
      done();
    })

    /**
     * @tc.number UiTest_051
     * @tc.name testStyledStringLetterSpacingStyle
     * @tc.desc 测试创建及应用文本字符间距对象（LetterSpacingStyle）示例
     * @tc.level: Level 1
     */
    it('testStyledStringLetterSpacingStyle', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testStyledStringLetterSpacingStyle begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('StyledString', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await driver.delayMs(1000);

      let str = await getResourceString($r('app.string.StyledStringStyle_title_6'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testStyledStringLetterSpacingStyle end');
      done();
    })

    /**
     * @tc.number UiTest_052
     * @tc.name testStyledStringParagraphStyleOne
     * @tc.desc 测试设置段落样式方法一示例
     * @tc.level: Level 1
     */
    it('testStyledStringParagraphStyleOne', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testStyledStringParagraphStyleOne begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('StyledString', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await driver.delayMs(1000);

      let str = await getResourceString($r('app.string.StyledStringParagraphStyleOne_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testStyledStringParagraphStyleOne end');
      done();
    })
  })
}