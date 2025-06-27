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
     * @tc.name testCreateText
     * @tc.desc 测试文本创建场景示例
     * @tc.level: Level 1
     */
    it('testCreateText', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testCreateText begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('Text', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.CreatText_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      str = await getResourceString($r('app.string.CreateText_Text_1'));
      let textString = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.module_desc'));
      let textResource = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(textString === null).assertFalse();
      expect(textResource === null).assertFalse();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testCreateText end');
      done();
    })

    /**
     * @tc.number UiTest_002
     * @tc.name testTextSpan
     * @tc.desc 测试文本段创建场景示例
     * @tc.level: Level 1
     */
    it('testTextSpan', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testTextSpan begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('Text', MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let str = await getResourceString($r('app.string.TextSpan_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      str = await getResourceString($r('app.string.TextSpan_textContent_2'));
      let textSpan = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.TextSpan_textContent_3'));
      let textColorSpan1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.TextSpan_textContent_4'));
      let textColorSpan2 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.TextSpan_textContent_5'));
      let textColorSpan3 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));

      let uppercase = await driver.findComponent(ON.text('I am Upper-span', MatchPattern.CONTAINS));
      expect(uppercase === null).assertFalse();

      let textBeforeClick = await driver.findComponent(ON.text('I am Upper-span2', MatchPattern.CONTAINS));
      expect(textBeforeClick === null).assertFalse();
      await textBeforeClick.click();
      str = await getResourceString($r('app.string.TextSpan_textContent_6'));
      let textAfterClick = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));

      expect(textSpan === null).assertFalse();
      expect(textColorSpan1 === null).assertFalse();
      expect(textColorSpan2 === null).assertFalse();
      expect(textColorSpan3 === null).assertFalse();
      expect(textColorSpan3 === null).assertFalse();
      expect(textAfterClick === null).assertFalse();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testTextSpan end');
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
      let str = await getResourceString($r('app.string.CustomTextStyle_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      str = await getResourceString($r('app.string.TextAlign_Start'));
      let textLeft = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.TextAlign_Center'));
      let textCenter = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.TextAlign_End'));
      let textRight = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));

      let longText1 = await driver.findComponent(ON.text(
        'This is the setting of textOverflow to Clip text content This is the setting of textOverflow ' +
          'to None text content. This is the setting of textOverflow to Clip text content This is the setting ' +
          'of textOverflow to None text content.', MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.CustomTextStyle_textContent_1'));
      let longText2 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.CustomTextStyle_textContent_2'));
      let longText3 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.CustomTextStyle_textContent_8'));
      let longText4 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));

      let customLineHeight = await driver.findComponent(ON.text(
        'This is the text with the line height set. This is the text with the line height set.',
        MatchPattern.CONTAINS));
      let customTextLineAndColor = await driver.findComponent(ON.text('This is the text', MatchPattern.CONTAINS));

      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);

      let customTextBaselineOffset1 =
        await driver.findComponent(ON.text('This is the text content with baselineOffset 0.', MatchPattern.CONTAINS));
      let customTextBaselineOffset2 =
        await driver.findComponent(ON.text('This is the text content with baselineOffset 30.', MatchPattern.CONTAINS));
      let customTextBaselineOffset3 =
        await driver.findComponent(ON.text('This is the text content with baselineOffset -20.', MatchPattern.CONTAINS));
      let customTextLetterSpace1 =
        await driver.findComponent(ON.text('This is the text content with letterSpacing 0.', MatchPattern.CONTAINS));
      let customTextLetterSpace2 =
        await driver.findComponent(ON.text('This is the text content with letterSpacing 3.', MatchPattern.CONTAINS));
      let customTextLetterSpace3 =
        await driver.findComponent(ON.text('This is the text content with letterSpacing -1.', MatchPattern.CONTAINS));

      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);

      str = await getResourceString($r('app.string.CustomTextStyle_textContent_3'));
      let customTheSizeOfText1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.CustomTextStyle_textContent_4'));
      let customTheSizeOfText2 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.CustomTextStyle_textContent_5'));
      let customTheSizeOfText3 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.CustomTextStyle_textContent_6'));
      let customTheSizeOfText4 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      let textCase1 = await driver.findComponent(ON.text('This is the text content with textCase set to Normal.',
        MatchPattern.CONTAINS));
      let textCase2 = await driver.findComponent(ON.text('This is the text content with textCase set to LowerCase.',
        MatchPattern.CONTAINS));
      let textCase3 = await driver.findComponent(ON.text('This is the text content with textCase set to UpperCase.',
        MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.CustomTextStyle_textContent_7'));
      let copyOption = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));

      expect(textLeft === null).assertFalse();
      expect(textCenter === null).assertFalse();
      expect(textRight === null).assertFalse();
      expect(longText1 === null).assertFalse();
      expect(longText2 === null).assertFalse();
      expect(longText3 === null).assertFalse();
      expect(longText4 === null).assertFalse();
      expect(customLineHeight === null).assertFalse();
      expect(customTextLineAndColor === null).assertFalse();
      expect(customTextBaselineOffset1 === null).assertFalse();
      expect(customTextBaselineOffset2 === null).assertFalse();
      expect(customTextBaselineOffset3 === null).assertFalse();
      expect(customTextLetterSpace1 === null).assertFalse();
      expect(customTextLetterSpace2 === null).assertFalse();
      expect(customTextLetterSpace3 === null).assertFalse();
      expect(customTheSizeOfText1 === null).assertFalse();
      expect(customTheSizeOfText2 === null).assertFalse();
      expect(customTheSizeOfText3 === null).assertFalse();
      expect(customTheSizeOfText4 === null).assertFalse();
      expect(textCase1 === null).assertFalse();
      expect(textCase2 === null).assertFalse();
      expect(textCase3 === null).assertFalse();
      expect(copyOption === null).assertFalse();

      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testCustomTextStyle end');
      done();
    })

    /**
     * @tc.number UiTest_004
     * @tc.name testTextAddEvent
     * @tc.desc 测试文本增加事件场景示例
     * @tc.level: Level 1
     */
    it('testTextAddEvent', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testTextAddEvent begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('Text', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.TextAddEvent_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let textClick = await driver.findComponent(ON.id('Click'));
      expect(textClick === null).assertFalse();
      await textClick.click();
      str = await getResourceString($r('app.string.TextAddEvent_textContent_2'));
      expect(await textClick.getText() === str).assertTrue();

      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testTextAddEvent end');
      done();
    })

    /**
     * @tc.number UiTest_005
     * @tc.name testSelectMenu
     * @tc.desc 测试设置选中菜单场景示例
     * @tc.level: Level 1
     */
    it('testSelectMenu', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testSelectMenu begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('Text', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.SetSelectionMenu_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      str = await getResourceString($r('app.string.SelectMenu_textContent_1'));
      let selectMenuText = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(selectMenuText === null).assertFalse();

      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testSelectMenu end');
      done();
    })

    /**
     * @tc.number UiTest_006
     * @tc.name testAIMenu
     * @tc.desc 测试设置AI菜单场景示例
     * @tc.level: Level 1
     */
    it('testAIMenu', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testAIMenu begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('Text', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.SetUpAIMenu_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      str = await getResourceString($r('app.string.AIMenu_Text_1'));
      let aiMenuText = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(aiMenuText === null).assertFalse();

      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testAIMenu end');
      done();
    })

    /**
     * @tc.number UiTest_007
     * @tc.name testHotSearch
     * @tc.desc 测试热搜榜场景示例
     * @tc.level: Level 1
     */
    it('testHotSearch', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testHotSearch begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('Text', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.TextHotSearch_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let textHotSearch1 = await driver.findComponent(ON.text('1'));
      let textHotSearch2 = await driver.findComponent(ON.text('2'));
      let textHotSearch3 = await driver.findComponent(ON.text('3'));
      let textHotSearch4 = await driver.findComponent(ON.text('4'));
      expect(textHotSearch1 === null).assertFalse();
      expect(textHotSearch2 === null).assertFalse();
      expect(textHotSearch3 === null).assertFalse();
      expect(textHotSearch4 === null).assertFalse();

      str = await getResourceString($r('app.string.TextHotSearch_textContent_1'));
      let hotText1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.TextHotSearch_textContent_2'));
      let hotText2 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.TextHotSearch_textContent_3'));
      let hotText3 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.TextHotSearch_textContent_4'));
      let hotText4 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.TextHotSearch_textContent_5'));
      let hotText5 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.TextHotSearch_textContent_6'));
      let hotText6 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));

      expect(hotText1 === null).assertFalse();
      expect(hotText2 === null).assertFalse();
      expect(hotText3 === null).assertFalse();
      expect(hotText4 === null).assertFalse();
      expect(hotText5 === null).assertFalse();
      expect(hotText6 === null).assertFalse();

      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testHotSearch end');
      done();
    })

    /**
     * @tc.number UiTest_008
     * @tc.name testCreateTextInput
     * @tc.desc 测试创建文本输入框场景示例
     * @tc.level: Level 1
     */
    it('testCreateTextInput', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testCreateTextInput begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.CreatTextInput_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let textInput = await driver.findComponent(ON.type('TextInput'));
      let textArea = await driver.findComponent(ON.type('TextArea'));
      str = await getResourceString($r('app.string.CreatTextInput_textContent'));
      let textArea2 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(textInput === null).assertFalse();
      expect(textArea === null).assertFalse();
      expect(textArea2 === null).assertFalse();

      await textInput.inputText('textInput');
      await textArea.inputText('textArea');

      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testCreateTextInput end');
      done();
    })

    /**
     * @tc.number UiTest_009-1
     * @tc.name testSetTextInputType
     * @tc.desc 测试设置文本输入框类型场景示例
     * @tc.level: Level 1
     */
    it('testSetTextInputType1', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testSetTextInputType1 begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.SetTextInputType_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let textInput1 = await driver.findComponent(ON.id('Normal'));
      let textInput2 = await driver.findComponent(ON.id('Password'));
      let textInput3 = await driver.findComponent(ON.id('Email'));
      let textInput4 = await driver.findComponent(ON.id('Number'));

      expect(textInput1 === null).assertFalse();
      expect(textInput2 === null).assertFalse();
      expect(textInput3 === null).assertFalse();
      expect(textInput4 === null).assertFalse();

      await textInput1.inputText('aaa');
      await textInput2.inputText('aaa');
      await textInput3.inputText('123456@example.com');
      await textInput4.inputText('123456789');

      await driver.pressBack();
      await driver.pressBack();

      console.info('uitest: testSetTextInputType1 end');
      done();
    })

    /**
     * @tc.number UiTest_009-2
     * @tc.name testSetTextInputType
     * @tc.desc 测试设置文本输入框类型场景示例
     * @tc.level: Level 1
     */
    it('testSetTextInputType2', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testSetTextInputType2 begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.SetTextInputType_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let textInput5 = await driver.findComponent(ON.id('PhoneNumber'));
      let textInput6 = await driver.findComponent(ON.id('NUMBER_DECIMAL'));
      let textInput7 = await driver.findComponent(ON.id('URL'));

      expect(textInput5 === null).assertFalse();
      expect(textInput6 === null).assertFalse();
      expect(textInput7 === null).assertFalse();

      await textInput5.inputText('+86 123-0123-0456');
      await textInput6.inputText('9.15');
      await textInput7.inputText('http://www.example.com');

      await driver.pressBack();
      await driver.pressBack();

      console.info('uitest: testSetTextInputType2 end');
      done();
    })

    /**
     * @tc.number UiTest_010
     * @tc.name testCustomTextInputStyle
     * @tc.desc 测试自定义文本输入框样式场景示例
     * @tc.level: Level 1
     */
    it('testCustomTextInputStyle', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testCustomTextInputStyle begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.CustomTextInputStyle_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      str = await getResourceString($r('app.string.CustomTextInputStyle_textContent_2'));
      let textInput = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(textInput === null).assertFalse();
      await textInput.inputText('textInput');
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testCustomTextInputStyle end');
      done();
    })

    /**
     * @tc.number UiTest_011
     * @tc.name testTextInputAddEvent
     * @tc.desc 测试文本输入框增加事件场景示例
     * @tc.level: Level 1
     */
    it('testTextInputAddEvent', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testTextInputAddEvent begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.TextInputAddEvent_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      str = await getResourceString($r('app.string.TextInputAddEvent_textContent_2'));
      let textInput = await driver.findComponent(ON.type('TextInput'));
      expect(textInput === null).assertFalse();
      await textInput.inputText('textInput');
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
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.SelectionMenu_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      str = await getResourceString($r('app.string.SelectMenu_textContent_1'));
      let selectMenuText = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(selectMenuText === null).assertFalse();

      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testTextInputSelectMenu end');
      done();
    })

    /**
     * @tc.number UiTest_013
     * @tc.name testTextInputAutoFill
     * @tc.desc 自动填充
     * @tc.level: Level 1
     */
    it('testTextInputAutoFill', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testTextInputAutoFill begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.Auto_Fill'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testTextInputAutoFill end');
      done();
    })

    /**
     * @tc.number UiTest_014
     * @tc.name testSetOmissionProperty
     * @tc.desc 设置省略属性
     * @tc.level: Level 1
     */
    it('testSetOmissionProperty', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testSetOmissionProperty begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.Set_Omission_Property'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      str = await getResourceString($r('app.string.Set_Omission_Property_textContent'));
      let textInput = await driver.findComponent(ON.type('TextInput', MatchPattern.CONTAINS));
      expect(textInput === null).assertFalse();
      await textInput.click();
      let selectMenuText = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(selectMenuText === null).assertFalse();

      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testSetOmissionProperty end');
      done();
    })

    /**
     * @tc.number UiTest_015
     * @tc.name testKeyboardAvoidance
     * @tc.desc 测试键盘避让场景示例
     * @tc.level: Level 1
     */
    it('testKeyboardAvoidance', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testKeyboardAvoidance begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.KeyboardAvoidance_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let textInput = await driver.findComponent(ON.type('TextInput'));
      await textInput.inputText('textInput');
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testKeyboardAvoidance end');
      done();
    })

    /**
     * @tc.number UiTest_016
     * @tc.name testCursorAvoidance
     * @tc.desc 光标避让
     * @tc.level: Level 1
     */
    it('testCursorAvoidance', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testCursorAvoidance begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      let str = await getResourceString($r('app.string.CursorAvoidance_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let TextArea = await driver.findComponent(ON.type('TextArea'));
      await TextArea.click();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testCursorAvoidance end');
      done();
    })

    /**
     * @tc.number UiTest_017
     * @tc.name testLoginRegisterPage
     * @tc.desc 测试登录/注册场景示例
     * @tc.level: Level 1
     */
    it('testLoginRegisterPage', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testLoginRegisterPage begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      let str = await getResourceString($r('app.string.LoginRegisterPage_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let username = await driver.findComponent(ON.id('username'));
      let password = await driver.findComponent(ON.id('password'));
      expect(username === null).assertFalse();
      expect(password === null).assertFalse();
      await username.inputText('username');
      await password.inputText('password');
      await driver.pressBack();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testLoginRegisterPage end');
      done();
    })

    /**
     * @tc.number UiTest_018
     * @tc.name testCreateRichEditor
     * @tc.desc 创建RichEditor组件
     * @tc.level: Level 1
     */
    it('testCreateRichEditor', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testCreateRichEditor begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('RichEditor', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.Create_RichEditor_Component_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      str = await getResourceString($r('app.string.Create_RichEditor_Component_title_1'));
      let richEditor1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.Create_RichEditor_Component_title_2'));
      let richEditor2 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(richEditor1 === null).assertFalse();
      expect(richEditor2 === null).assertFalse();

      await driver.pressBack();
      await driver.waitForIdle(2000, 2000);
      await driver.pressBack();
      console.info('uitest: testCreateRichEditor end');
      done();
    })

    /**
     * @tc.number UiTest_019
     * @tc.name testSetAttributes
     * @tc.desc 设置属性
     * @tc.level: Level 1
     */
    it('testSetAttributes', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testSetAttributes begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('RichEditor', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.Set_Attributes_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      str = await getResourceString($r('app.string.Set_Attributes_title_1'));
      let richEditor1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.Set_Attributes_title_2'));
      let richEditor2 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(richEditor1 === null).assertFalse();
      expect(richEditor2 === null).assertFalse();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      str = await getResourceString($r('app.string.Set_Attributes_title_3'));
      let richEditor3 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.Set_Attributes_title_4'));
      let richEditor4 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.Set_Attributes_title_5'));
      let richEditor5 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.Set_Attributes_title_6'));
      let richEditor6 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(richEditor3 === null).assertFalse();
      expect(richEditor4 === null).assertFalse();
      expect(richEditor5 === null).assertFalse();
      expect(richEditor6 === null).assertFalse();
      await driver.waitForIdle(500, 500);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('uitest: testSetAttributes end');
      done();
    })

    /**
     * @tc.number UiTest_020
     * @tc.name testAddEvent
     * @tc.desc 添加事件
     * @tc.level: Level 1
     */
    it('testAddEvent', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testAddEvent begin');
      let driver = Driver.create();
      await driver.waitForIdle(500, 500);
      let buttonComponent = await driver.findComponent(ON.text('RichEditor', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.Add_Event_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      str = await getResourceString($r('app.string.Add_Event_title_1'));
      let richEditor1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.Add_Event_title_2'));
      let richEditor2 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.Add_Event_title_3'));
      let richEditor3 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.Add_Event_title_4'));
      let richEditor4 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(richEditor1 === null).assertFalse();
      expect(richEditor2 === null).assertFalse();
      expect(richEditor3 === null).assertFalse();
      expect(richEditor4 === null).assertFalse();

      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 500, 3000);
      await driver.waitForIdle(500, 500);
      str = await getResourceString($r('app.string.Add_Event_title_5'));
      let richEditor5 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.Add_Event_title_6'));
      let richEditor6 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.Add_Event_title_7'));
      let richEditor7 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(richEditor5 === null).assertFalse();
      expect(richEditor6 === null).assertFalse();
      expect(richEditor7 === null).assertFalse();
      await driver.waitForIdle(500, 500);
      await driver.pressBack();
      await driver.waitForIdle(2000, 2000);
      await driver.pressBack();
      console.info('uitest: testAddEvent end');
      done();
    })

    /**
     * @tc.number UiTest_021
     * @tc.name testSetUserPresetTextStyles
     * @tc.desc 通过setTypingStyle设置用户预设的文本样式
     * @tc.level: Level 1
     */
    it('testSetUserPresetTextStyles', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testSetUserPresetTextStyles begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('RichEditor', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.Set_User_PresetText_Styles_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.pressBack();
      await driver.waitForIdle(2000, 2000);
      await driver.pressBack();
      console.info('uitest: testSetUserPresetTextStyles end');
      done();
    })

    /**
     * @tc.number UiTest_022
     * @tc.name testBackplaneHighlighting
     * @tc.desc 通过setSelection设置组件内的内容选中时部分背板高亮
     * @tc.level: Level 1
     */
    it('testBackplaneHighlighting', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testBackplaneHighlighting begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('RichEditor', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.Backplane_Highlighting_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.pressBack();
      await driver.waitForIdle(2000, 2000);
      await driver.pressBack();
      console.info('uitest: testBackplaneHighlighting end');
      done();
    })

    /**
     * @tc.number UiTest_023
     * @tc.name testAddTextContent
     * @tc.desc 添加文本内容
     * @tc.level: Level 1
     */
    it('testAddTextContent', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testAddTextContent begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('RichEditor', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.Add_TextContent_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      let button = await driver.findComponent(ON.text('addTextSpan'));
      expect(button === null).assertFalse();
      await button.click();
      str = await getResourceString($r('app.string.AddTextContent_Text_2'));
      let richEditor1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(richEditor1 === null).assertFalse();
      await driver.pressBack();
      await driver.waitForIdle(2000, 2000);
      await driver.pressBack();
      console.info('uitest: testAddTextContent end');
      done();
    })

    /**
     * @tc.number UiTest_024
     * @tc.name testAddImageContent
     * @tc.desc 添加图片内容
     * @tc.level: Level 1
     */
    it('testAddImageContent', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testAddImageContent begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('RichEditor', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.Add_ImageContent_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      let button = await driver.findComponent(ON.text('addImageSpan'));
      expect(button === null).assertFalse();
      await button.click();
      str = await getResourceString($r('app.string.AddImageContent_Text_1'));
      let richEditor1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(richEditor1 === null).assertFalse();
      await driver.pressBack();
      await driver.waitForIdle(2000, 2000);
      await driver.pressBack();
      console.info('uitest: testAddImageContent end');
      done();
    })

    /**
     * @tc.number UiTest_025
     * @tc.name testAddBuilderDecoratorContent
     * @tc.desc 添加@Builder装饰器修饰的内容
     * @tc.level: Level 1
     */
    it('testAddBuilderDecoratorContent', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testAddBuilderDecoratorContent begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('RichEditor', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.Add_Builder_DecoratorContent_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      let button = await driver.findComponent(ON.text('addBuilderSpan'));
      expect(button === null).assertFalse();
      await button.click();
      str = await getResourceString($r('app.string.AddBuilderDecoratorContent_Text_3'));
      let richEditor1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(richEditor1 === null).assertFalse();
      await driver.pressBack();
      await driver.waitForIdle(2000, 2000);
      await driver.pressBack();
      console.info('uitest: testAddBuilderDecoratorContent end');
      done();
    })

    /**
     * @tc.number UiTest_026
     * @tc.name testAddSymbolSpanContent
     * @tc.desc 添加SymbolSpan内容
     * @tc.level: Level 1
     */
    it('testAddSymbolSpanContent', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testAddSymbolSpanContent begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('RichEditor', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      let str = await getResourceString($r('app.string.Add_SymbolSpanContent_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      let button = await driver.findComponent(ON.text('addSymbolSpan'));
      expect(button === null).assertFalse();
      await button.click();
      str = await getResourceString($r('app.string.AddSymbolSpanContent_Text_1'));
      let richEditor1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(richEditor1 === null).assertFalse();
      await driver.pressBack();
      await driver.waitForIdle(2000, 2000);
      await driver.pressBack();
      console.info('uitest: testAddSymbolSpanContent end');
      done();
    })

    /**
     * @tc.number UiTest_027
     * @tc.name testGetGraphicInfoInComponent
     * @tc.desc 获取组件内图文信息
     * @tc.level: Level 1
     */
    it('testGetGraphicInfoInComponent', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testGetGraphicInfoInComponent begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('RichEditor', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      let str = await getResourceString($r('app.string.Get_GraphicInfo_In_Component_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      let button = await driver.findComponent(ON.text('getSpans'));
      expect(button === null).assertFalse();
      await button.click();
      str = await getResourceString($r('app.string.GetGraphicInfoInComponent_Text_1'));
      let richEditor1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(richEditor1 === null).assertFalse();
      await driver.pressBack();
      await driver.waitForIdle(2000, 2000);
      await driver.pressBack();
      console.info('uitest: testGetGraphicInfoInComponent end');
      done();
    })

    /**
     * @tc.number UiTest_028
     * @tc.name testCreatSymbolGlyph
     * @tc.desc 测试创建图标场景示例
     * @tc.level: Level 1
     */
    it('testCreatSymbolGlyph', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testCreatSymbolGlyph begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('SymbolGlyph', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.CreatSymbolGlyph_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let symbolGlyph = await driver.findComponent(ON.type('SymbolGlyph'));
      expect(symbolGlyph === null).assertFalse();

      await driver.pressBack();
      await driver.waitForIdle(2000, 2000);
      await driver.pressBack();
      console.info('uitest: testCreatSymbolGlyph end');
      done();
    })

    /**
     * @tc.number UiTest_029
     * @tc.name testSymbolGlyphSpanAddToText
     * @tc.desc 测试添加到文本场景示例
     * @tc.level: Level 1
     */
    it('testSymbolGlyphSpanAddToText', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testSymbolGlyphSpanAddToText begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('SymbolGlyph', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.SymbolGlyphSpanAddToText_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let symbolSpan1 = await driver.findComponent(ON.id('1'));
      expect(symbolSpan1 === null).assertFalse();

      let text2 = await driver.findComponent(ON.text('48'));
      expect(text2 === null).assertFalse();
      let text3 = await driver.findComponent(ON.text('72'));
      expect(text3 === null).assertFalse();
      let text4 = await driver.findComponent(ON.text('96'));
      expect(text4 === null).assertFalse();

      let symbolSpan2 = await driver.findComponent(ON.id('2'));
      expect(symbolSpan2 === null).assertFalse();
      let symbolSpan3 = await driver.findComponent(ON.id('3'));
      expect(symbolSpan3 === null).assertFalse();
      let symbolSpan4 = await driver.findComponent(ON.id('4'));
      expect(symbolSpan4 === null).assertFalse();

      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);

      let text5 = await driver.findComponent(ON.text('Light'));
      expect(text5 === null).assertFalse();
      let text6 = await driver.findComponent(ON.text('Normal'));
      expect(text6 === null).assertFalse();
      let text7 = await driver.findComponent(ON.text('Bold'));
      expect(text7 === null).assertFalse();
      let text8 = await driver.findComponent(ON.text('Black'));
      expect(text8 === null).assertFalse();
      let text9 = await driver.findComponent(ON.text('Green'));
      expect(text9 === null).assertFalse();
      let text10 = await driver.findComponent(ON.text('Pink'));
      expect(text10 === null).assertFalse();
      str = await getResourceString($r('app.string.SymbolAddToText_Text_1'));
      let text11 = await driver.findComponent(ON.text(str));
      expect(text11 === null).assertFalse();
      str = await getResourceString($r('app.string.SymbolAddToText_Text_2'));
      let text12 = await driver.findComponent(ON.text(str));
      expect(text12 === null).assertFalse();
      str = await getResourceString($r('app.string.SymbolAddToText_Text_3'));
      let text13 = await driver.findComponent(ON.text(str));
      expect(text13 === null).assertFalse();
      str = await getResourceString($r('app.string.SymbolAddToText_Text_4'));
      let text14 = await driver.findComponent(ON.text(str));
      expect(text14 === null).assertFalse();
      str = await getResourceString($r('app.string.SymbolAddToText_Text_5'));
      let text15 = await driver.findComponent(ON.text(str));
      expect(text15 === null).assertFalse();
      str = await getResourceString($r('app.string.SymbolAddToText_Text_6'));
      let text16 = await driver.findComponent(ON.text(str));
      expect(text16 === null).assertFalse();

      let symbolSpan5 = await driver.findComponent(ON.id('5'));
      expect(symbolSpan5 === null).assertFalse();
      let symbolSpan6 = await driver.findComponent(ON.id('6'));
      expect(symbolSpan6 === null).assertFalse();
      let symbolSpan7 = await driver.findComponent(ON.id('7'));
      expect(symbolSpan7 === null).assertFalse();
      let symbolSpan8 = await driver.findComponent(ON.id('8'));
      expect(symbolSpan8 === null).assertFalse();
      let symbolSpan9 = await driver.findComponent(ON.id('9'));
      expect(symbolSpan9 === null).assertFalse();
      let symbolSpan10 = await driver.findComponent(ON.id('10'));
      expect(symbolSpan10 === null).assertFalse();
      let symbolSpan11 = await driver.findComponent(ON.id('11'));
      expect(symbolSpan11 === null).assertFalse();
      let symbolSpan12 = await driver.findComponent(ON.id('12'));
      expect(symbolSpan12 === null).assertFalse();
      let symbolSpan13 = await driver.findComponent(ON.id('13'));
      expect(symbolSpan13 === null).assertFalse();
      let symbolSpan14 = await driver.findComponent(ON.id('14'));
      expect(symbolSpan14 === null).assertFalse();
      let symbolSpan15 = await driver.findComponent(ON.id('15'));
      expect(symbolSpan15 === null).assertFalse();
      let symbolSpan16 = await driver.findComponent(ON.id('16'));
      expect(symbolSpan16 === null).assertFalse();

      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testSymbolGlyphSpanAddToText end');
      done();
    })

    /**
     * @tc.number UiTest_030
     * @tc.name testSymbolGlyphSpanCustomIconAnimation
     * @tc.desc 测试自定义图标动效场景示例
     * @tc.level: Level 1
     */
    it('testSymbolGlyphSpanCustomIconAnimation', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testSymbolGlyphSpanCustomIconAnimation begin');
      let driver = Driver.create();
      await driver.waitForIdle(500, 500);
      let buttonComponent = await driver.findComponent(ON.text('SymbolGlyph', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.SymbolGlyphSpanCustomIconAnimation_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      str = await getResourceString($r('app.string.SymbolCustomIconAnimation_Text_1'));
      let text1 = await driver.findComponent(ON.text(str));
      expect(text1 === null).assertFalse();
      let symbolGlyph1 = await driver.findComponent(ON.id('1'));
      expect(symbolGlyph1 === null).assertFalse();
      str = await getResourceString($r('app.string.SymbolGlyphSpanCustomIconAnimation_Button_1'));
      let button1 = await driver.findComponent(ON.text(str));
      expect(button1 === null).assertFalse();
      await button1.click();
      str = await getResourceString($r('app.string.SymbolGlyphSpanCustomIconAnimation_Button_2'));
      expect(await button1.getText() === str).assertTrue();

      str = await getResourceString($r('app.string.SymbolCustomIconAnimation_Text_2'));
      let text2 = await driver.findComponent(ON.text(str));
      expect(text2 === null).assertFalse();
      let symbolGlyph2 = await driver.findComponent(ON.id('2'));
      expect(symbolGlyph2 === null).assertFalse();
      let button2 = await driver.findComponent(ON.text('trigger'));
      expect(button2 === null).assertFalse();
      await button1.click();
      await driver.waitForIdle(500, 500);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      console.info('uitest: testSymbolGlyphSpanCustomIconAnimation end');
      done();
    })

    /**
     * @tc.number UiTest_031
     * @tc.name testSymbolGlyphSpanAddEvent
     * @tc.desc 测试添加事件场景示例
     * @tc.level: Level 1
     */
    it('testSymbolGlyphSpanAddEvent', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testSymbolGlyphSpanAddEvent begin');
      let driver = Driver.create();
      await driver.waitForIdle(500, 500);
      let buttonComponent = await driver.findComponent(ON.text('SymbolGlyph', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.SymbolGlyphSpanAddEvent_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let symbolGlyph = await driver.findComponent(ON.id('symbolGlyph1'));
      expect(symbolGlyph === null).assertFalse();
      await symbolGlyph.click();
      await driver.waitForIdle(500, 500);
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.waitForIdle(2000, 2000);
      await driver.pressBack();
      console.info('uitest: testSymbolGlyphSpanAddEvent end');
      done();
    })

    /**
     * @tc.number UiTest_032
     * @tc.name testSymbolGlyphSpanSceneExample
     * @tc.desc 测试播放列表场景示例
     * @tc.level: Level 1
     */
    it('testSymbolGlyphSpanSceneExample', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testSymbolGlyphSpanSceneExample begin');
      let driver = Driver.create();
      await driver.waitForIdle(500, 500);
      let buttonComponent = await driver.findComponent(ON.text('SymbolGlyph', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.SymbolGlyphSpanSceneExample_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let text1 = await driver.findComponent(ON.id('text1'));
      expect(text1 === null).assertFalse();
      let symbolGlyph1 = await driver.findComponent(ON.id('symbolGlyph1'));
      expect(symbolGlyph1 === null).assertFalse();
      str = await getResourceString($r('app.string.SymbolSceneExample_Text_1'));
      let text = await driver.findComponent(ON.text(str));
      expect(text === null).assertFalse();
      await text.click();
      str = await getResourceString($r('app.string.SymbolSceneExample_Text_2'));
      expect(await text.getText() === str).assertTrue();
      await text.click();
      str = await getResourceString($r('app.string.SymbolSceneExample_Text_3'));
      expect(await text.getText() === str).assertTrue();
      let text2 = await driver.findComponent(ON.id('text2'));
      expect(text2 === null).assertFalse();
      let text3 = await driver.findComponent(ON.id('text3'));
      expect(text3 === null).assertFalse();
      let text4 = await driver.findComponent(ON.id('text4'));
      expect(text4 === null).assertFalse();

      str = await getResourceString($r('app.string.SymbolSceneExample_Text_5'));
      let text5 = await driver.findComponent(ON.text(str));
      expect(text5 === null).assertFalse();
      let symbolGlyph2 = await driver.findComponent(ON.id('symbolGlyph2'));
      expect(symbolGlyph2 === null).assertFalse();
      let symbolGlyph3 = await driver.findComponent(ON.id('symbolGlyph3'));
      expect(symbolGlyph3 === null).assertFalse();
      str = await getResourceString($r('app.string.SymbolSceneExample_Text_6'));
      let text6 = await driver.findComponent(ON.text(str));
      expect(text6 === null).assertFalse();
      let symbolGlyph4 = await driver.findComponent(ON.id('symbolGlyph4'));
      expect(symbolGlyph4 === null).assertFalse();
      let symbolGlyph5 = await driver.findComponent(ON.id('symbolGlyph5'));
      expect(symbolGlyph5 === null).assertFalse();
      str = await getResourceString($r('app.string.SymbolSceneExample_Text_7'));
      let text7 = await driver.findComponent(ON.text(str));
      expect(text7 === null).assertFalse();
      let symbolGlyph6 = await driver.findComponent(ON.id('symbolGlyph6'));
      expect(symbolGlyph6 === null).assertFalse();
      let symbolGlyph7 = await driver.findComponent(ON.id('symbolGlyph7'));
      expect(symbolGlyph7 === null).assertFalse();
      str = await getResourceString($r('app.string.SymbolSceneExample_Text_8'));
      let text8 = await driver.findComponent(ON.text(str));
      expect(text8 === null).assertFalse();
      let symbolGlyph8 = await driver.findComponent(ON.id('symbolGlyph8'));
      expect(symbolGlyph8 === null).assertFalse();
      let symbolGlyph9 = await driver.findComponent(ON.id('symbolGlyph9'));
      expect(symbolGlyph9 === null).assertFalse();
      str = await getResourceString($r('app.string.SymbolSceneExample_Text_9'));
      let text9 = await driver.findComponent(ON.text(str));
      expect(text9 === null).assertFalse();
      let symbolGlyph10 = await driver.findComponent(ON.id('symbolGlyph10'));
      expect(symbolGlyph10 === null).assertFalse();
      let symbolGlyph11 = await driver.findComponent(ON.id('symbolGlyph11'));
      expect(symbolGlyph11 === null).assertFalse();
      str = await getResourceString($r('app.string.SymbolSceneExample_Text_10'));
      let text10 = await driver.findComponent(ON.text(str));
      expect(text10 === null).assertFalse();
      let symbolGlyph12 = await driver.findComponent(ON.id('symbolGlyph12'));
      expect(symbolGlyph12 === null).assertFalse();
      let symbolGlyph13 = await driver.findComponent(ON.id('symbolGlyph13'));
      expect(symbolGlyph13 === null).assertFalse();
      str = await getResourceString($r('app.string.SymbolSceneExample_Text_11'));
      let text11 = await driver.findComponent(ON.text(str));
      expect(text11 === null).assertFalse();
      let symbolGlyph14 = await driver.findComponent(ON.id('symbolGlyph14'));
      expect(symbolGlyph14 === null).assertFalse();
      let symbolGlyph15 = await driver.findComponent(ON.id('symbolGlyph15'));
      expect(symbolGlyph15 === null).assertFalse();
      str = await getResourceString($r('app.string.SymbolSceneExample_Text_12'));
      let text12 = await driver.findComponent(ON.text(str));
      expect(text12 === null).assertFalse();

      await driver.pressBack();
      await driver.waitForIdle(2000, 2000);
      await driver.pressBack();
      console.info('uitest: testSymbolGlyphSpanSceneExample end');
      done();
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
      let str = await getResourceString($r('app.string.Create_Apply_StyledString_MutableStyledString_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      str = await getResourceString($r('app.string.CreateApply_Text_1'));
      let styledString = await driver.findComponent(ON.text(str));
      expect(styledString === null).assertFalse();
      str = await getResourceString($r('app.string.CreateApply_Text_2'));
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
     * @tc.name testStyledStringStyle
     * @tc.desc 测试设置文本样式场景示例
     * @tc.level: Level 1
     */
    it('testStyledStringStyle', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testStyledStringStyle begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('StyledString', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.StyledStringStyle_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let mutableStyledString1 = await driver.findComponent(ON.id('1'));
      expect(mutableStyledString1 === null).assertFalse();
      let mutableStyledString2 = await driver.findComponent(ON.id('2'));
      expect(mutableStyledString2 === null).assertFalse();
      let mutableStyledString3 = await driver.findComponent(ON.id('3'));
      expect(mutableStyledString3 === null).assertFalse();
      let mutableStyledString4 = await driver.findComponent(ON.id('4'));
      expect(mutableStyledString4 === null).assertFalse();
      let mutableStyledString5 = await driver.findComponent(ON.id('5'));
      expect(mutableStyledString5 === null).assertFalse();
      let mutableStyledString6 = await driver.findComponent(ON.id('6'));
      expect(mutableStyledString6 === null).assertFalse();

      await driver.pressBack();
      await driver.waitForIdle(2000, 2000);
      await driver.pressBack();
      console.info('uitest: testStyledStringStyle end');
      done();
    })

    /**
     * @tc.number UiTest_035
     * @tc.name testStyledStringParagraphStyle
     * @tc.desc 测试设置段落样式场景示例
     * @tc.level: Level 1
     */
    it('testStyledStringParagraphStyle', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testStyledStringParagraphStyle begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('StyledString', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.StyledStringParagraphStyle_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      str = await getResourceString($r('app.string.StyledStringParagraphStyle_Text_1'));
      let mutableStyledString1 =
        await driver.findComponent(ON.text(str));
      expect(mutableStyledString1 === null).assertFalse();
      let button = await driver.findComponent(ON.text('change'));
      expect(button === null).assertFalse();
      await button.click();
      await driver.waitForIdle(500, 500);

      await driver.pressBack();
      await driver.waitForIdle(2000, 2000);
      await driver.pressBack();
      console.info('uitest: testStyledStringParagraphStyle end');
      done();
    })

    /**
     * @tc.number UiTest_036
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
      await driver.waitForIdle(2000, 2000);
      await driver.pressBack();
      console.info('uitest: testStyledStringImageAttachment end');
      done();
    })

    /**
     * @tc.number UiTest_037
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
      let str = await getResourceString($r('app.string.TStyledStringGestureStyle_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let text1 = await driver.findComponent(ON.id('text1'));
      expect(text1 === null).assertFalse();

      await driver.pressBack();
      await driver.waitForIdle(2000, 2000);
      await driver.pressBack();
      console.info('uitest: testStyledStringGestureStyle end');
      done();
    })

    /**
     * @tc.number UiTest_038
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
      let str = await getResourceString($r('app.string.StyledStringHtml_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      str = await getResourceString($r('app.string.StyledStringHtml_Button_1'));
      let addButton = await driver.findComponent(ON.text(str));
      expect(addButton === null).assertFalse();
      await addButton.click();
      await driver.waitForIdle(500, 500);
      let text1 = await driver.findComponent(ON.id('text1'));
      expect(text1 === null).assertFalse();

      let toHtmlButton = await driver.findComponent(ON.text('toHtml'));
      expect(toHtmlButton === null).assertFalse();
      await toHtmlButton.click();
      await driver.waitForIdle(500, 500);
      let text3 = await driver.findComponent(ON.id('text3'));
      expect(text3 === null).assertFalse();

      let fromHtmlButton = await driver.findComponent(ON.text('fromHtml'));
      expect(fromHtmlButton === null).assertFalse();
      await fromHtmlButton.click();
      await driver.waitForIdle(500, 500);
      let text2 = await driver.findComponent(ON.id('text2'));
      expect(text2 === null).assertFalse();

      await driver.pressBack();
      await driver.waitForIdle(3000, 3000);
      await driver.pressBack();
      console.info('uitest: testStyledStringHtml end');
      done();
    })

    /**
     * @tc.number UiTest_039
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
      await driver.waitForIdle(2000, 2000);
      await driver.pressBack();
      console.info('uitest: testStyledStringSceneExample end');
      done();
    })

    /**
     * @tc.number UiTest_040
     * @tc.name testTextDrawingDisplay
     * @tc.desc 测试Text组件的文本绘制与显示场景示例
     * @tc.level: Level 1
     */
    it('testTextDrawingDisplay', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testTextDrawingDisplay begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('NDK', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.TextDrawingDisplay_NDK_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let text = await driver.findComponent(ON.type('Text'));
      expect(text === null).assertFalse();

      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testTextDrawingDisplay end');
      done();
    })

    /**
     * @tc.number UiTest_041
     * @tc.name testListenTextBoxEvents
     * @tc.desc 测试输入框文本事件监听场景示例
     * @tc.level: Level 1
     */
    it('testListenTextBoxEvents', Level.LEVEL1, async (done: Function) => {
      console.info('uitest: testListenTextBoxEvents begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('NDK', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.ListenTextBoxEvents_NDK_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let textArea = await driver.findComponent(ON.type('TextArea'));
      expect(textArea === null).assertFalse();

      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testListenTextBoxEvents end');
      done();
    })
  })
}