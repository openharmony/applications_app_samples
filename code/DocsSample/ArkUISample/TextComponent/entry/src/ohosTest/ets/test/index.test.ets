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
import { abilityDelegatorRegistry, Driver, ON, MatchPattern, On, Component, Point, Rect } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let want: Want;
const TAG = '[Sample_Textcomponent]';
const DOMAIN = 0xF811;
const BUNDLE = 'Textcomponent_';
const SCROLL_DISTANCE_THREE_HUNDRED: number = 300;
const SCROLL_DISTANCE_FOUR_HUNDRED: number = 400;
const SCROLL_DISTANCE_ONE_THOUSAND: number = 1000;
const SCROLL_DISTANCE_TWO_THOUSAND: number = 2000;
const SCROLL_DISTANCE_THREE_THOUSAND: number = 3000;
const SCROLL_RATE_ONE_THOUSAND: number = 1000;
const SLEEP_ONE_HUNDRED: number = 100;
const SLEEP_FIVE_HANDRED: number = 500;
const SLEEP_ONE_THOUSAND: number = 1000;
const IDLE_FIVE_HUNDRED: number = 500;
const IDLE_TWO_THOUSAND: number = 2000;
const IDLE_THREE_THOUSAND: number = 3000;
const IDLE_FOUR_THOUSAND: number = 4000;

async function getResourceString(resource: string): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let textString: string = await manage.getStringByName(resource);
  return textString;
}

async function searchInSwipe(condition: On): Promise<Component> {
  let driver = Driver.create();
  let list = await driver.findComponent(ON.type('List'));
  let scroll = await driver.findComponent(ON.id('scroll_'));
  let fatherComponent: Component;
  if (list === null && scroll === null) {
    throw Error('[TextComponent]: No scrollable components.')
  } else if (scroll) {
    fatherComponent = scroll;
  } else {
    fatherComponent = list;
  }
  return fatherComponent.scrollSearch(condition);
}

async function searchTo(scrollRect: Rect, scrollCenter: Point, id: string) {
  let driver = Driver.create();
  let scrollTo: Point = {
    x: scrollCenter.x,
    y: scrollRect.top
  };
  let scrollToComponent = await driver.findComponent(ON.id(id));
  let scrollToComponentRect = await scrollToComponent.getBounds();
  let scrollFrom: Point = {
    x: scrollCenter.x,
    y: scrollToComponentRect.bottom
  };

  await driver.swipeBetween(scrollFrom, scrollTo);
}

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
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
      await driver.delayMs(SLEEP_FIVE_HANDRED);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(DOMAIN, TAG, BUNDLE + 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number UiTest_001
     * @tc.name testCreateText
     * @tc.desc 测试文本创建场景示例
     * @tc.level: Level 1
     */
    it('testCreateText', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testCreateText begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('Text', MatchPattern.CONTAINS));
      await buttonComponent.click();
      let str = await getResourceString('CreatText_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      str = await getResourceString('CreateText_Text_new');
      let textString = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString('module_desc');
      let textResource = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(SLEEP_FIVE_HANDRED);
      await driver.pressBack();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testCreateText end');
      done();
    })

    /**
     * @tc.number UiTest_002
     * @tc.name testTextSpan
     * @tc.desc 测试文本段创建场景示例
     * @tc.level: Level 1
     */
    it('testTextSpan', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testTextSpan begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Text', MatchPattern.CONTAINS));
      await componentButton.click();
      await driver.delayMs(SLEEP_FIVE_HANDRED);
      let str = await getResourceString('TextSpan_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(SLEEP_FIVE_HANDRED);
      str = await getResourceString('TextSpan_textContent_span');
      let textSpan = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString('TextSpan_textContent_span_one');
      let textColorSpan1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString('TextSpan_textContent_span_two');
      let textColorSpan2 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString('TextSpan_textContent_span_three');
      let textColorSpan3 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));

      let uppercase = await driver.findComponent(ON.text('I am Upper-span', MatchPattern.CONTAINS));

      let textBeforeClick = await driver.findComponent(ON.text('I am Upper-span2', MatchPattern.CONTAINS));
      await textBeforeClick.click();
      str = await getResourceString('TextSpan_textContent_6');
      let textAfterClick = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await textAfterClick.click();
      await driver.delayMs(SLEEP_FIVE_HANDRED);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(SLEEP_FIVE_HANDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testTextSpan end');
      done();
    })

    /**
     * @tc.number UiTest_003
     * @tc.name testCustomTextStyle
     * @tc.desc 测试自定义文本样式场景示例
     * @tc.level: Level 1
     */
    it('testCustomTextStyle', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testCustomTextStyle begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('Text', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString('CustomTextStyle_title');
      await sleep(SLEEP_FIVE_HANDRED);
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      str = await getResourceString('TextAlign_Start');
      let textLeft = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(textLeft === null).assertFalse();
      str = await getResourceString('TextAlign_Center');
      let textCenter = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(textCenter === null).assertFalse();
      str = await getResourceString('TextAlign_End');
      let textRight = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(textRight === null).assertFalse();

      let scroll = await driver.findComponent(ON.id('scroll_'));
      let scrollRect = await scroll.getBounds();
      let scrollCenter = await scroll.getBoundsCenter();
      await searchTo(scrollRect, scrollCenter, 'custom_text_style_sample_part1');

      let longText1 = await driver.findComponent(ON.text(
        'This is the setting of textOverflow to Clip text content This is the setting of textOverflow ' +
          'to None text content. This is the setting of textOverflow to Clip text content This is the setting ' +
          'of textOverflow to None text content.', MatchPattern.CONTAINS));
      expect(longText1 === null).assertFalse();
      str = await getResourceString('CustomTextStyle_textContent_epsis');
      let longText2 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(longText2 === null).assertFalse();
      str = await getResourceString('CustomTextStyle_textContent_marq');
      let longText3 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(longText3 === null).assertFalse();
      str = await getResourceString('CustomTextStyle_textContent_marq_def');
      let longText4 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(longText4 === null).assertFalse();

      await searchTo(scrollRect, scrollCenter, 'custom_text_style_sample_part2');

      let customLineHeight = await driver.findComponents(ON.text(
        'This is the text with the line height set. This is the text with the line height set.',
        MatchPattern.CONTAINS));
      expect(customLineHeight.length === 2).assertTrue();

      await searchTo(scrollRect, scrollCenter, 'custom_text_style_sample_part3');

      let customTextLineAndColor = await driver.findComponents(ON.text('This is the text', MatchPattern.EQUALS));
      console.log('this is:' + customTextLineAndColor.length)
      expect(customTextLineAndColor.length === 7).assertTrue();

      await searchTo(scrollRect, scrollCenter, 'custom_text_style_sample_part4');

      let customTextBaselineOffset1 =
        await driver.findComponent(ON.text('This is the text content with baselineOffset 0.', MatchPattern.CONTAINS));
      let customTextBaselineOffset2 =
        await driver.findComponent(ON.text('This is the text content with baselineOffset 30.', MatchPattern.CONTAINS));
      let customTextBaselineOffset3 =
        await driver.findComponent(ON.text('This is the text content with baselineOffset -20.', MatchPattern.CONTAINS));

      expect(customTextBaselineOffset1 === null).assertFalse();
      expect(customTextBaselineOffset2 === null).assertFalse();
      expect(customTextBaselineOffset3 === null).assertFalse();

      await searchTo(scrollRect, scrollCenter, 'custom_text_style_sample_part5');

      let customTextLetterSpace1 =
        await driver.findComponent(ON.text('This is the text content with letterSpacing 0.', MatchPattern.CONTAINS));
      expect(customTextLetterSpace1 === null).assertFalse();
      let customTextLetterSpace2 =
        await driver.findComponent(ON.text('This is the text content with letterSpacing 3.', MatchPattern.CONTAINS));
      expect(customTextLetterSpace2 === null).assertFalse();
      let customTextLetterSpace3 =
        await driver.findComponent(ON.text('This is the text content with letterSpacing -1.', MatchPattern.CONTAINS));
      expect(customTextLetterSpace3 === null).assertFalse();

      await searchTo(scrollRect, scrollCenter, 'custom_text_style_sample_part6');

      str = await getResourceString('CustomTextStyle_textContent_one_style');
      let customTheSizeOfText1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(customTheSizeOfText1 === null).assertFalse();
      str = await getResourceString('CustomTextStyle_textContent_two_style');
      let customTheSizeOfText2 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(customTheSizeOfText2 === null).assertFalse();

      str = await getResourceString('CustomTextStyle_textContent_no_max');
      let customTheSizeOfText3 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(customTheSizeOfText3 === null).assertFalse();

      str = await getResourceString('CustomTextStyle_textContent_high');
      let customTheSizeOfText4 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(customTheSizeOfText4 === null).assertFalse();

      await searchTo(scrollRect, scrollCenter, 'custom_text_style_sample_part7');

      let textCase1 = await driver.findComponent(ON.text('This is the text content with textCase set to Normal.',
        MatchPattern.CONTAINS));
      let textCase2 = await driver.findComponent(ON.text('This is the text content with textCase set to LowerCase.',
        MatchPattern.CONTAINS));
      let textCase3 = await driver.findComponent(ON.text('This is the text content with textCase set to UpperCase.',
        MatchPattern.CONTAINS));
      expect(textCase1 === null).assertFalse();
      expect(textCase2 === null).assertFalse();
      expect(textCase3 === null).assertFalse();

      await searchTo(scrollRect, scrollCenter, 'custom_text_style_sample_part8');

      str = await getResourceString('CustomTextStyle_textContent_incopy');
      let copyOption = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));

      expect(copyOption === null).assertFalse();

      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(SLEEP_FIVE_HANDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testCustomTextStyle end');
      done();
    })

    /**
     * @tc.number UiTest_004
     * @tc.name testTextAddEvent
     * @tc.desc 测试文本增加事件场景示例
     * @tc.level: Level 1
     */
    it('testTextAddEvent', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testTextAddEvent begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('Text', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(SLEEP_FIVE_HANDRED);
      let str = await getResourceString('TextAddEvent_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(SLEEP_FIVE_HANDRED);
      let textClick = await driver.findComponent(ON.id('Click'));
      await textClick.click();
      await driver.delayMs(SLEEP_FIVE_HANDRED);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(SLEEP_FIVE_HANDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testTextAddEvent end');
      done();
    })

    /**
     * @tc.number UiTest_005
     * @tc.name testSelectMenu
     * @tc.desc 测试设置选中菜单场景示例
     * @tc.level: Level 1
     */
    it('testSelectMenu', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSelectMenu begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('Text', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let str = await getResourceString('SetSelectionMenu_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      str = await getResourceString('show_selected_menu');
      let selectMenuText = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSelectMenu end');
      done();
    })

    /**
     * @tc.number UiTest_008
     * @tc.name testCreateTextInput
     * @tc.desc 测试创建文本输入框场景示例
     * @tc.level: Level 1
     */
    it('testCreateTextInput', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testCreateTextInput begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let str = await getResourceString('CreatTextInput_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let textInput = await driver.findComponent(ON.type('TextInput'));
      let textArea = await driver.findComponent(ON.type('TextArea'));
      await driver.delayMs(SLEEP_FIVE_HANDRED);
      str = await getResourceString('CreatTextInput_textContent');
      let textArea2 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await textInput.inputText('textInput');
      await textArea.inputText('textArea');
      await textArea2.inputText('textArea2');
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testCreateTextInput end');
      done();
    })

    /**
     * @tc.number UiTest_009-1
     * @tc.name testSetTextInputType
     * @tc.desc 测试设置文本输入框类型场景示例
     * @tc.level: Level 1
     */
    it('testSetTextInputType1', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSetTextInputType1 begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let str = await getResourceString('SetTextInputType_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let textInput1 = await driver.findComponent(ON.id('Normal'));
      let textInput2 = await driver.findComponent(ON.id('Password'));
      let textInput3 = await driver.findComponent(ON.id('Email'));
      let textInput4 = await driver.findComponent(ON.id('Number'));
      await textInput1.inputText('aaa');
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      await textInput2.inputText('123');
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      await textInput3.inputText('123456@example.com');
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      await textInput4.inputText('123456789');
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      await driver.pressBack();
      await driver.pressBack();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSetTextInputType1 end');
      done();
    })

    /**
     * @tc.number UiTest_009-2
     * @tc.name testSetTextInputType
     * @tc.desc 测试设置文本输入框类型场景示例
     * @tc.level: Level 1
     */
    it('testSetTextInputType2', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSetTextInputType2 begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      await buttonComponent.click();
      let str = await getResourceString('SetTextInputType_title');
      await sleep(SLEEP_ONE_THOUSAND);
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await sleep(SLEEP_FIVE_HANDRED);
      let textInput5 = await driver.findComponent(ON.id('PhoneNumber'));
      await textInput5.inputText('+86 123-0123-0456');
      await driver.pressBack();
      await sleep(SLEEP_FIVE_HANDRED);
      let textInput6 = await driver.findComponent(ON.id('NUMBER_DECIMAL'));
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      await textInput6.inputText('9.15');
      await driver.pressBack();
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSetTextInputType2 end');
      done();
    })

    /**
     * @tc.number UiTest_009-3
     * @tc.name testSetTextInputType
     * @tc.desc 测试设置文本输入框类型场景示例
     * @tc.level: Level 1
     */
    it('testSetTextInputType3', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSetTextInputType3 begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(SLEEP_FIVE_HANDRED);
      let str = await getResourceString('SetTextInputType_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let textInput7 = await driver.findComponent(ON.id('URL'));
      await textInput7.inputText('http://www.example.com');
      await driver.pressBack();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSetTextInputType3 end');
      done();
    })

    /**
     * @tc.number UiTest_010
     * @tc.name testCustomTextInputStyle
     * @tc.desc 测试自定义文本输入框样式场景示例
     * @tc.level: Level 1
     */
    it('testCustomTextInputStyle', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testCustomTextInputStyle begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(SLEEP_FIVE_HANDRED);
      let str = await getResourceString('CustomTextInputStyle_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(SLEEP_FIVE_HANDRED);
      str = await getResourceString('i_am_current_text_content');
      let textInput = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await textInput.inputText('textInput');
      await driver.delayMs(SLEEP_FIVE_HANDRED);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testCustomTextInputStyle end');
      done();
    })

    /**
     * @tc.number UiTest_011
     * @tc.name testTextInputAddEvent
     * @tc.desc 测试文本输入框增加事件场景示例
     * @tc.level: Level 1
     */
    it('testTextInputAddEvent', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testTextInputAddEvent begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      await buttonComponent.click();
      let str = await getResourceString('TextInputAddEvent_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      str = await getResourceString('TextInputAddEvent_textContent_2');
      let textInput = await driver.findComponent(ON.type('TextInput'));
      await textInput.inputText('textInput');
      await textInput.clearText()
      await driver.waitForIdle(IDLE_TWO_THOUSAND, IDLE_TWO_THOUSAND);
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testTextInputAddEvent end');
      done();
    })

    /**
     * @tc.number UiTest_012
     * @tc.name testTextInputSelectMenu
     * @tc.desc 测试设置选中菜单场景示例
     * @tc.level: Level 1
     */
    it('testTextInputSelectMenu', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testTextInputSelectMenu begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      await buttonComponent.click();
      let str = await getResourceString('SelectionMenu_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      str = await getResourceString('show_selected_menu');
      let selectMenuText = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testTextInputSelectMenu end');
      done();
    })

    /**
     * @tc.number UiTest_013
     * @tc.name testTextInputAutoFill
     * @tc.desc 自动填充
     * @tc.level: Level 1
     */
    it('testTextInputAutoFill', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testTextInputAutoFill begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      await buttonComponent.click();
      let str = await getResourceString('Auto_Fill');
      let sampleButton = await searchInSwipe(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testTextInputAutoFill end');
      done();
    })

    /**
     * @tc.number UiTest_014
     * @tc.name testSetProperty
     * @tc.desc 设置省略属性
     * @tc.level: Level 1
     */
    it('testSetProperty', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSetProperty begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      await buttonComponent.click();
      let list = await driver.findComponent(ON.type('List'));
      await list.scrollToBottom(50);
      let str = await getResourceString('Set_Property');
      let sampleButton = await searchInSwipe(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      str = await getResourceString('Set_Omission_Property_textContent');
      let textInput = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await textInput.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let selectMenuText = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString('Set_stroke_Property_textContent');
      textInput = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await textInput.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      selectMenuText = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSetProperty end');
      done();
    })

    /**
     * @tc.number UiTest_015
     * @tc.name testKeyboardAvoidance
     * @tc.desc 测试键盘避让场景示例
     * @tc.level: Level 1
     */
    it('testKeyboardAvoidance', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testKeyboardAvoidance begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      await buttonComponent.click();

      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), SCROLL_RATE_ONE_THOUSAND);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + SCROLL_DISTANCE_FOUR_HUNDRED, scrollCenter.x,
        scrollCenter.y - SCROLL_DISTANCE_FOUR_HUNDRED, SCROLL_DISTANCE_THREE_THOUSAND);
      await driver.waitForIdle(IDLE_FIVE_HUNDRED, IDLE_FIVE_HUNDRED);

      let str = await getResourceString('KeyboardAvoidance_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      let symbolSpan1 = await driver.findComponent(ON.id('7'));
      await symbolSpan1.inputText('textInput');
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testKeyboardAvoidance end');
      done();
    })

    /**
     * @tc.number UiTest_016
     * @tc.name testCursorAvoidance
     * @tc.desc 光标避让
     * @tc.level: Level 1
     */
    it('testCursorAvoidance', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testCursorAvoidance begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.waitForIdle(IDLE_TWO_THOUSAND, IDLE_TWO_THOUSAND);
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), SCROLL_RATE_ONE_THOUSAND);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + SCROLL_DISTANCE_FOUR_HUNDRED, scrollCenter.x,
        scrollCenter.y - SCROLL_DISTANCE_FOUR_HUNDRED, SCROLL_DISTANCE_THREE_THOUSAND);
      await driver.waitForIdle(IDLE_FIVE_HUNDRED, IDLE_FIVE_HUNDRED);
      let str = await getResourceString('CursorAvoidance_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let TextArea = await driver.findComponent(ON.type('TextArea'));
      await TextArea.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testCursorAvoidance end');
      done();
    })

    /**
     * @tc.number UiTest_018
     * @tc.name testCreateRichEditor
     * @tc.desc 创建RichEditor组件
     * @tc.level: Level 1
     */
    it('testCreateRichEditor', Level.LEVEL1, async (done: Function) => {
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('RichEditor', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let str = await getResourceString('Create_RichEditor_Component_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      str = await getResourceString('Create_RichEditor_Component_title_1');
      let richEditor1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString('Create_RichEditor_Component_title_2');
      let richEditor2 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      done();
    })

    /**
     * @tc.number UiTest_019
     * @tc.name testSetAttributes
     * @tc.desc 设置属性
     * @tc.level: Level 1
     */
    it('testSetAttributes', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSetAttributes begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('RichEditor', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let str = await getResourceString('Set_Attributes_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), SCROLL_RATE_ONE_THOUSAND);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      str = await getResourceString('Set_Attributes_title_1');
      let richEditor1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString('Set_Attributes_title_2');
      let richEditor2 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.swipe(scrollCenter.x, scrollCenter.y + SCROLL_DISTANCE_FOUR_HUNDRED, scrollCenter.x,
        scrollCenter.y - SCROLL_DISTANCE_FOUR_HUNDRED, SCROLL_DISTANCE_THREE_THOUSAND);
      await driver.waitForIdle(IDLE_FIVE_HUNDRED, IDLE_FIVE_HUNDRED);
      str = await getResourceString('Set_Attributes_title_3');
      let richEditor3 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString('Set_Attributes_title_4');
      let richEditor4 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString('Set_Attributes_title_5');
      let richEditor5 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString('Set_Attributes_title_6');
      let richEditor6 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString('Set_Attributes_title_9');
      let richEditor9 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString('Set_Attributes_title_10');
      let richEditor10 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));

      await driver.swipe(scrollCenter.x, scrollCenter.y + SCROLL_DISTANCE_FOUR_HUNDRED, scrollCenter.x,
        scrollCenter.y - SCROLL_DISTANCE_FOUR_HUNDRED, SCROLL_DISTANCE_THREE_THOUSAND);
      await driver.waitForIdle(IDLE_FIVE_HUNDRED, IDLE_FIVE_HUNDRED);
      str = await getResourceString('Set_Attributes_title_11');
      let richEditor11 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString('Set_Attributes_title_12');
      let richEditor12 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString('Set_Attributes_title_13');
      let richEditor13 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.waitForIdle(IDLE_FIVE_HUNDRED, IDLE_FIVE_HUNDRED);
      await driver.pressBack();
      await driver.delayMs(SLEEP_FIVE_HANDRED);
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSetAttributes end');
      done();
    })

    /**
     * @tc.number UiTest_020
     * @tc.name testAddEvent
     * @tc.desc 添加事件
     * @tc.level: Level 1
     */
    it('testAddEvent', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testAddEvent begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('RichEditor', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let str = await getResourceString('Add_Event_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testAddEvent end');
      done();
    })

    /**
     * @tc.number UiTest_021
     * @tc.name testSetUserPresetTextStyles
     * @tc.desc 通过setTypingStyle设置用户预设的文本样式
     * @tc.level: Level 1
     */
    it('testSetUserPresetTextStyles', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSetUserPresetTextStyles begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('RichEditor', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let str = await getResourceString('Set_User_PresetText_Styles_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      await driver.pressBack();
      await driver.waitForIdle(IDLE_TWO_THOUSAND, IDLE_TWO_THOUSAND);
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSetUserPresetTextStyles end');
      done();
    })

    /**
     * @tc.number UiTest_022
     * @tc.name testBackplaneHighlighting
     * @tc.desc 通过setSelection设置组件内的内容选中时部分背板高亮
     * @tc.level: Level 1
     */
    it('testBackplaneHighlighting', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testBackplaneHighlighting begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('RichEditor', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let str = await getResourceString('Backplane_Highlighting_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      await driver.pressBack();
      await driver.waitForIdle(IDLE_TWO_THOUSAND, IDLE_TWO_THOUSAND);
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testBackplaneHighlighting end');
      done();
    })

    /**
     * @tc.number UiTest_023
     * @tc.name testAddTextContent
     * @tc.desc 添加文本内容
     * @tc.level: Level 1
     */
    it('testAddTextContent', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testAddTextContent begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('RichEditor', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let str = await getResourceString('Add_TextContent_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let button = await driver.findComponent(ON.text('addTextSpan'));
      await button.click();
      str = await getResourceString('AddTextContent_Text_2');
      let richEditor1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.pressBack();
      await driver.waitForIdle(IDLE_TWO_THOUSAND, IDLE_TWO_THOUSAND);
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testAddTextContent end');
      done();
    })

    /**
     * @tc.number UiTest_024
     * @tc.name testAddImageContent
     * @tc.desc 添加图片内容
     * @tc.level: Level 1
     */
    it('testAddImageContent', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testAddImageContent begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('RichEditor', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let str = await getResourceString('Add_ImageContent_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let button = await driver.findComponent(ON.text('addImageSpan'));
      await button.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      str = await getResourceString('AddImageContent_Text_1');
      let richEditor1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      await driver.pressBack();
      await driver.waitForIdle(IDLE_TWO_THOUSAND, IDLE_TWO_THOUSAND);
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testAddImageContent end');
      done();
    })

    /**
     * @tc.number UiTest_025
     * @tc.name testAddBuilderDecoratorContent
     * @tc.desc 添加@Builder装饰器修饰的内容
     * @tc.level: Level 1
     */
    it('testAddBuilderDecoratorContent', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testAddBuilderDecoratorContent begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('RichEditor', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let str = await getResourceString('Add_Builder_DecoratorContent_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let button = await driver.findComponent(ON.text('addBuilderSpan'));
      await button.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      str = await getResourceString('AddBuilderDecoratorContent_Text_3');
      let richEditor1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      await driver.pressBack();
      await driver.waitForIdle(IDLE_TWO_THOUSAND, IDLE_TWO_THOUSAND);
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testAddBuilderDecoratorContent end');
      done();
    })

    /**
     * @tc.number UiTest_026
     * @tc.name testAddSymbolSpanContent
     * @tc.desc 添加SymbolSpan内容
     * @tc.level: Level 1
     */
    it('testAddSymbolSpanContent', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testAddSymbolSpanContent begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('RichEditor', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), SCROLL_RATE_ONE_THOUSAND);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + SCROLL_DISTANCE_FOUR_HUNDRED, scrollCenter.x,
        scrollCenter.y - SCROLL_DISTANCE_FOUR_HUNDRED, SCROLL_DISTANCE_THREE_THOUSAND);
      await driver.waitForIdle(IDLE_FIVE_HUNDRED, IDLE_FIVE_HUNDRED);
      let str = await getResourceString('Add_SymbolSpanContent_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let button = await driver.findComponent(ON.text('addSymbolSpan'));
      await button.click();
      str = await getResourceString('AddSymbolSpanContent_Text_1');
      let richEditor1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(richEditor1 === null).assertFalse();
      await driver.pressBack();
      await driver.waitForIdle(IDLE_TWO_THOUSAND, IDLE_TWO_THOUSAND);
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testAddSymbolSpanContent end');
      done();
    })

    /**
     * @tc.number UiTest_027
     * @tc.name testGetGraphicInfoInComponent
     * @tc.desc 获取组件内图文信息
     * @tc.level: Level 1
     */
    it('testGetGraphicInfoInComponent', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testGetGraphicInfoInComponent begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('RichEditor', MatchPattern.CONTAINS));
      await buttonComponent.click();
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), SCROLL_RATE_ONE_THOUSAND);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + SCROLL_DISTANCE_FOUR_HUNDRED, scrollCenter.x,
        scrollCenter.y - SCROLL_DISTANCE_FOUR_HUNDRED, SCROLL_DISTANCE_THREE_THOUSAND);
      await driver.waitForIdle(IDLE_FIVE_HUNDRED, IDLE_FIVE_HUNDRED);
      let str = await getResourceString('Get_GraphicInfo_In_Component_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let button = await driver.findComponent(ON.text('getSpans'));
      await button.click();
      str = await getResourceString('GetGraphicInfoInComponent_Text_1');
      let richEditor1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      await driver.pressBack();
      await driver.waitForIdle(IDLE_TWO_THOUSAND, IDLE_TWO_THOUSAND);
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testGetGraphicInfoInComponent end');
      done();
    })

    /**
     * @tc.number UiTest_028
     * @tc.name testCreatSymbolGlyph
     * @tc.desc 测试创建图标场景示例
     * @tc.level: Level 1
     */
    it('testCreatSymbolGlyph', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testCreatSymbolGlyph begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('SymbolGlyph', MatchPattern.CONTAINS));
      await buttonComponent.click();
      let str = await getResourceString('CreatSymbolGlyph_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      let symbolGlyph = await driver.findComponent(ON.type('SymbolGlyph'));
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      await driver.pressBack();
      await driver.waitForIdle(IDLE_TWO_THOUSAND, IDLE_TWO_THOUSAND);
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testCreatSymbolGlyph end');
      done();
    })

    /**
     * @tc.number UiTest_029
     * @tc.name testSymbolGlyphSpanAddToText
     * @tc.desc 测试添加到文本场景示例
     * @tc.level: Level 1
     */
    it('testSymbolGlyphSpanAddToText', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSymbolGlyphSpanAddToText begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('SymbolGlyph', MatchPattern.CONTAINS));
      await buttonComponent.click();
      let str = await getResourceString('SymbolGlyphSpanAddToText_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      let symbolSpan1 = await driver.findComponent(ON.id('1'));
      let text2 = await driver.findComponent(ON.text('48'));
      let text3 = await driver.findComponent(ON.text('72'));
      let text4 = await driver.findComponent(ON.text('96'));
      let symbolSpan2 = await driver.findComponent(ON.id('2'));
      let symbolSpan3 = await driver.findComponent(ON.id('3'));
      let symbolSpan4 = await driver.findComponent(ON.id('4'));
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), SCROLL_RATE_ONE_THOUSAND);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + SCROLL_DISTANCE_FOUR_HUNDRED, scrollCenter.x,
        scrollCenter.y - SCROLL_DISTANCE_FOUR_HUNDRED, SCROLL_DISTANCE_THREE_THOUSAND);
      await driver.waitForIdle(IDLE_FIVE_HUNDRED, IDLE_FIVE_HUNDRED);
      let text5 = await driver.findComponent(ON.text('Light'));
      let text6 = await driver.findComponent(ON.text('Normal'));
      let text7 = await driver.findComponent(ON.text('Bold'));
      let text8 = await driver.findComponent(ON.text('Black'));
      let text9 = await driver.findComponent(ON.text('Green'));
      let text10 = await driver.findComponent(ON.text('Pink'));
      str = await getResourceString('single_color');
      let text11 = await driver.findComponent(ON.text(str));
      str = await getResourceString('multi_color');
      let text12 = await driver.findComponent(ON.text(str));
      str = await getResourceString('hierarchical');
      let text13 = await driver.findComponent(ON.text(str));
      str = await getResourceString('no_action');
      let text14 = await driver.findComponent(ON.text(str));
      str = await getResourceString('overall_scaling_animation_effect');
      let text15 = await driver.findComponent(ON.text(str));
      str = await getResourceString('hierarchical_animation');
      let text16 = await driver.findComponent(ON.text(str));
      let symbolSpan5 = await driver.findComponent(ON.id('5'));
      let symbolSpan6 = await driver.findComponent(ON.id('6'));
      let symbolSpan7 = await driver.findComponent(ON.id('7'));
      let symbolSpan8 = await driver.findComponent(ON.id('8'));
      let symbolSpan9 = await driver.findComponent(ON.id('9'));
      let symbolSpan10 = await driver.findComponent(ON.id('10'));
      let symbolSpan11 = await driver.findComponent(ON.id('11'));
      let symbolSpan12 = await driver.findComponent(ON.id('12'));
      let symbolSpan13 = await driver.findComponent(ON.id('13'));
      let symbolSpan14 = await driver.findComponent(ON.id('14'));
      let symbolSpan15 = await driver.findComponent(ON.id('15'));
      let symbolSpan16 = await driver.findComponent(ON.id('16'));
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSymbolGlyphSpanAddToText end');
      done();
    })

    /**
     * @tc.number UiTest_030
     * @tc.name testSymbolGlyphSpanCustomIconAnimation
     * @tc.desc 测试自定义图标动效场景示例
     * @tc.level: Level 1
     */
    it('testSymbolGlyphSpanCustomIconAnimation', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSymbolGlyphSpanCustomIconAnimation begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('SymbolGlyph', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let str = await getResourceString('SymbolGlyphSpanCustomIconAnimation_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      str = await getResourceString('variable_color_animation');
      let text1 = await driver.findComponent(ON.text(str));
      let symbolGlyph1 = await driver.findComponent(ON.id('1'));
      str = await getResourceString('off');
      let button1 = await driver.findComponent(ON.text(str));
      await button1.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      str = await getResourceString('on');
      str = await getResourceString('bounce_animation');
      let text2 = await driver.findComponent(ON.text(str));
      let symbolGlyph2 = await driver.findComponent(ON.id('2'));
      let button2 = await driver.findComponent(ON.text('trigger'));
      await button2.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      str = await getResourceString('disable_animation');
      let text3 = await driver.findComponent(ON.text(str));
      let symbolGlyph3 = await driver.findComponent(ON.id('3'));
      let button3 = await driver.findComponent(ON.text('trigger'));
      await button3.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), SCROLL_RATE_ONE_THOUSAND);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + SCROLL_DISTANCE_FOUR_HUNDRED, scrollCenter.x,
        scrollCenter.y - SCROLL_DISTANCE_FOUR_HUNDRED, SCROLL_DISTANCE_THREE_THOUSAND);
      await driver.waitForIdle(IDLE_FIVE_HUNDRED, IDLE_FIVE_HUNDRED);
      str = await getResourceString('quick_replacement_animation');
      let text4 = await driver.findComponent(ON.text(str));
      let symbolGlyph4 = await driver.findComponent(ON.id('4'));
      let button4 = await driver.findComponent(ON.text('trigger'));
      await button4.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      await driver.pressBack();
      await driver.delayMs(SLEEP_FIVE_HANDRED);
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSymbolGlyphSpanCustomIconAnimation end');
      done();
    })

    /**
     * @tc.number UiTest_031
     * @tc.name testSymbolGlyphSpanAddEvent
     * @tc.desc 测试添加事件场景示例
     * @tc.level: Level 1
     */
    it('testSymbolGlyphSpanAddEvent', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSymbolGlyphSpanAddEvent begin');
      let driver = Driver.create();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let buttonComponent = await driver.findComponent(ON.text('SymbolGlyph', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let str = await getResourceString('SymbolGlyphSpanAddEvent_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let symbolGlyph = await driver.findComponent(ON.id('symbolGlyph1'));
      await symbolGlyph.click();
      await driver.waitForIdle(IDLE_FIVE_HUNDRED, IDLE_FIVE_HUNDRED);
      await driver.delayMs(SLEEP_FIVE_HANDRED);
      await driver.pressBack();
      await driver.waitForIdle(IDLE_TWO_THOUSAND, IDLE_TWO_THOUSAND);
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSymbolGlyphSpanAddEvent end');
      done();
    })

    /**
     * @tc.number UiTest_032
     * @tc.name testSymbolGlyphSpanSceneExample
     * @tc.desc 测试播放列表场景示例
     * @tc.level: Level 1
     */
    it('testSymbolGlyphSpanSceneExample', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSymbolGlyphSpanSceneExample begin');
      let driver = Driver.create();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let buttonComponent = await driver.findComponent(ON.text('SymbolGlyph', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let str = await getResourceString('SymbolGlyphSpanSceneExample_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      str = await getResourceString('current_playlist');
      let text1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString('play_in_order');
      let text = await driver.findComponent(ON.text(str));
      let symbolGlyph1 = await driver.findComponent(ON.type('SymbolGlyph').isBefore(ON.text(str)));
      await text.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      str = await getResourceString('play_in_single_repeat');
      symbolGlyph1 = await driver.findComponent(ON.type('SymbolGlyph').isBefore(ON.text(str)));
      await text.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      str = await getResourceString('shuffle_play');
      symbolGlyph1 = await driver.findComponent(ON.type('SymbolGlyph').isBefore(ON.text(str)));
      let str1 = await getResourceString('song');
      let Condition = ON.type('Text').isAfter(ON.text(str)).isBefore(ON.text(str1));
      let text2 = await driver.findComponents(Condition);
      str = str1;
      let text5 = await driver.findComponent(ON.text(str));
      str1 = await getResourceString('song_again');
      Condition = ON.type('SymbolGlyph').isAfter(ON.text(str)).isBefore(ON.text(str1));
      let symbolGlyph2 = await driver.findComponent(Condition);
      str = str1;
      let text6 = await driver.findComponent(ON.text(str));
      str1 = await getResourceString('again_song');
      Condition = ON.type('SymbolGlyph').isAfter(ON.text(str)).isBefore(ON.text(str1));
      let symbolGlyph4 = await driver.findComponent(Condition);
      str = str1;
      let text7 = await driver.findComponent(ON.text(str));
      str1 = await getResourceString('song_repeat');
      Condition = ON.type('SymbolGlyph').isAfter(ON.text(str)).isBefore(ON.text(str1));
      let symbolGlyph6 = await driver.findComponent(Condition);
      str = str1;
      let text8 = await driver.findComponent(ON.text(str));
      str1 = await getResourceString('repeat_song');
      Condition = ON.type('SymbolGlyph').isAfter(ON.text(str)).isBefore(ON.text(str1));
      let symbolGlyph8 = await driver.findComponent(Condition);
      str = str1;
      let text9 = await driver.findComponent(ON.text(str));
      str1 = await getResourceString('song_play');
      Condition = ON.type('SymbolGlyph').isAfter(ON.text(str)).isBefore(ON.text(str1));
      let symbolGlyph10 = await driver.findComponent(Condition);
      str = str1;
      let text10 = await driver.findComponent(ON.text(str));
      str1 = await getResourceString('play_song');
      Condition = ON.type('SymbolGlyph').isAfter(ON.text(str)).isBefore(ON.text(str1));
      let symbolGlyph12 = await driver.findComponent(Condition);
      str = str1;
      let text11 = await driver.findComponent(ON.text(str));
      str1 = await getResourceString('off');
      Condition = ON.type('SymbolGlyph').isAfter(ON.text(str)).isBefore(ON.text(str1));
      let symbolGlyph14 = await driver.findComponent(Condition);
      str = str1;
      let text12 = await driver.findComponent(ON.text(str));
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      await driver.pressBack();
      await driver.waitForIdle(IDLE_TWO_THOUSAND, IDLE_TWO_THOUSAND);
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSymbolGlyphSpanSceneExample end');
      done();
    })

    /**
     * @tc.number UiTest_040
     * @tc.name testTextDrawingDisplay
     * @tc.desc 测试Text组件的文本绘制与显示场景示例
     * @tc.level: Level 1
     */
    it('testTextDrawingDisplay', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testTextDrawingDisplay begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('NDK', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let str = await getResourceString('TextDrawingDisplay_NDK_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let text = await driver.findComponent(ON.type('Text'));
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testTextDrawingDisplay end');
      done();
    })

    /**
     * @tc.number UiTest_041
     * @tc.name testListenTextBoxEvents
     * @tc.desc 测试输入框文本事件监听场景示例
     * @tc.level: Level 1
     */
    it('testListenTextBoxEvents', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testListenTextBoxEvents begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('NDK', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let str = await getResourceString('ListenTextBoxEvents_NDK_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let textArea = await driver.findComponent(ON.type('TextArea'));
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testListenTextBoxEvents end');
      done();
    })

    /**
     * @tc.number UiTest_044
     * @tc.name testSymbolShadowAndColor
     * @tc.desc 测试设置阴影和渐变色
     * @tc.level: Level 1
     */
    it('testSymbolShadowAndColor', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSymbolShadowAndColor begin');
      let driver = Driver.create();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let buttonComponent = await driver.findComponent(ON.text('SymbolGlyph', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let str = await getResourceString('SymbolShadowAndColor_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      str = await getResourceString('SymbolShadowAndColor_title_1');
      let text1 = await driver.findComponent(ON.text(str));
      let symbolGlyph1 = await driver.findComponent(ON.id('1'));
      str = await getResourceString('on');
      let button1 = await driver.findComponent(ON.text(str));
      await button1.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      str = await getResourceString('off');
      str = await getResourceString('SymbolShadowAndColor_title_2');
      let text2 = await driver.findComponent(ON.text(str));
      await driver.pressBack();
      await driver.waitForIdle(IDLE_TWO_THOUSAND, IDLE_TWO_THOUSAND);
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSymbolShadowAndColor end');
      done();
    })

    /**
     * @tc.number UiTest_045
     * @tc.name testSetTextMargin
     * @tc.desc 设置文本行间距
     * @tc.level: Level 1
     */
    it('testSetTextMargin', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSetTextMargin begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await sleep(SLEEP_ONE_THOUSAND);
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), SCROLL_DISTANCE_ONE_THOUSAND);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + SCROLL_DISTANCE_FOUR_HUNDRED, scrollCenter.x,
        scrollCenter.y - SCROLL_DISTANCE_FOUR_HUNDRED, SCROLL_DISTANCE_THREE_THOUSAND);
      await driver.waitForIdle(IDLE_FIVE_HUNDRED, IDLE_FIVE_HUNDRED);
      let str = await getResourceString('Set_Text_Margin');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await sleep(SLEEP_ONE_THOUSAND);
      str = await getResourceString('SetTextMargin_Content');
      let textInput = await driver.findComponent(ON.type('TextArea', MatchPattern.CONTAINS));
      await textInput.click();
      await sleep(SLEEP_ONE_THOUSAND);
      let selectMenuText = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testSetTextMargin end');
      done();
    })

    /**
     * @tc.number UiTest_046
     * @tc.name testProhibitSelectMenu
     * @tc.desc 禁用系统服务类菜单
     * @tc.level: Level 1
     */
    it('testProhibitSelectMenu', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testProhibitSelectMenu begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      let str = await getResourceString('ProhibitSelectionMenu_title');
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.waitForIdle(IDLE_TWO_THOUSAND, IDLE_TWO_THOUSAND);
      str = await getResourceString('ProhibitSelectMenu_title_1');
      await sleep(SLEEP_ONE_THOUSAND);
      sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.waitForIdle(IDLE_TWO_THOUSAND, IDLE_TWO_THOUSAND);
      str = await getResourceString('ProhibitSelectMenu_content');
      await sleep(SLEEP_ONE_THOUSAND);
      let selectMenuText = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(SLEEP_ONE_HUNDRED);
      await driver.pressBack();
      await driver.waitForIdle(IDLE_THREE_THOUSAND, IDLE_FOUR_THOUSAND);
      await driver.pressBack();
      await driver.waitForIdle(IDLE_FOUR_THOUSAND, IDLE_FOUR_THOUSAND);
      await driver.pressBack();
      await driver.waitForIdle(IDLE_FOUR_THOUSAND, IDLE_FOUR_THOUSAND);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testProhibitSelectMenu end');
      done();
    })
  })
}