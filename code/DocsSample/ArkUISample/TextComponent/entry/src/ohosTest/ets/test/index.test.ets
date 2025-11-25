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

export default function IndexTest() {

  describe('IndexTest', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.CreatText_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.TextSpan_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      let textBeforeClick = await driver.findComponent(ON.text('I am Upper-span2', MatchPattern.CONTAINS));
      await textBeforeClick.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testTextSpan end');
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.TextAddEvent_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      let textClick = await driver.findComponent(ON.id('Click'));
      await textClick.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.SetSelectionMenu_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      str = await getResourceString($r('app.string.show_selected_menu'));
      let selectMenuText = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.CreatTextInput_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      let textInput = await driver.findComponent(ON.type('TextInput'));
      let textArea = await driver.findComponent(ON.type('TextArea'));
      await driver.delayMs(500);
      str = await getResourceString($r('app.string.CreatTextInput_textContent'));
      await textInput.inputText('textInput');
      await textArea.inputText('textArea');
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.SetTextInputType_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      let textInput1 = await driver.findComponent(ON.id('Normal'));
      let textInput2 = await driver.findComponent(ON.id('Password'));
      let textInput3 = await driver.findComponent(ON.id('Email'));
      await textInput1.inputText('aaa');
      await driver.delayMs(500);
      await textInput2.inputText('123');
      await driver.delayMs(500);
      await textInput3.inputText('123456@example.com');
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.SetTextInputType_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      let textInput4 = await driver.findComponent(ON.id('Number'));
      let textInput5 = await driver.findComponent(ON.id('PhoneNumber'));
      await textInput4.inputText('123456789');
      await driver.delayMs(500);
      await textInput5.inputText('+86 123-0123-0456');
      await driver.pressBack();
      await driver.delayMs(500);
      let textInput6 = await driver.findComponent(ON.id('NUMBER_DECIMAL'));
      await driver.delayMs(500);
      await textInput6.inputText('9.15');
      await driver.pressBack();
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.SetTextInputType_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.CustomTextInputStyle_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      str = await getResourceString($r('app.string.i_am_current_text_content'));
      let textInput = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await textInput.inputText('textInput');
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.TextInputAddEvent_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      str = await getResourceString($r('app.string.TextInputAddEvent_textContent_2'));
      let textInput = await driver.findComponent(ON.type('TextInput'));
      await textInput.inputText('textInput');
      await textInput.clearText()
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testTextInputAddEvent end');
      done();
    })

    /**
     * @tc.number UiTest_012
     * @tc.name testTextInputSelectMenu
     * @tc.desc 测试设置选中菜单场景示例
     * @tc.level: Level 1
     */
    it('testTextInputSelectMenu', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testTextInputSelectMenu begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.SelectionMenu_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      str = await getResourceString($r('app.string.show_selected_menu'));
      let selectMenuText = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      await driver.swipe(100, 600, 200, 20, 3000);
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.Auto_Fill'))
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(500);
      await sampleButton.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      await driver.swipe(100, 600, 200, 20, 3000);
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.Set_Property'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      await driver.swipe(100, 600, 200, 20, 3000);
      str = await getResourceString($r('app.string.Set_Omission_Property_textContent'));
      let textInput = await driver.findComponent(ON.type('TextInput', MatchPattern.CONTAINS));
      await textInput.click();
      await driver.delayMs(500);
      await driver.swipe(100, 600, 200, 20, 3000);
      let selectMenuText = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.Set_stroke_Property_textContent'));
      textInput = await driver.findComponent(ON.type('TextInput', MatchPattern.CONTAINS));
      await textInput.click();
      await driver.delayMs(500);
      selectMenuText = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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

      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.delayMs(500);

      let str = await getResourceString($r('app.string.KeyboardAvoidance_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      let symbolSpan1 = await driver.findComponent(ON.id('7'));
      await symbolSpan1.inputText('textInput');
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 600, 3000);
      await driver.delayMs(500);
      await driver.swipe(100, 600, 200, 20, 3000);
      let str = await getResourceString($r('app.string.CursorAvoidance_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      let TextArea = await driver.findComponent(ON.type('TextArea'));
      await TextArea.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.Create_RichEditor_Component_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      str = await getResourceString($r('app.string.Create_RichEditor_Component_title_1'));
      let richEditor1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.Create_RichEditor_Component_title_2'));
      let richEditor2 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.Set_Attributes_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.Add_Event_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 500, 3000);
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.Set_User_PresetText_Styles_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.Backplane_Highlighting_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.Add_TextContent_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      let button = await driver.findComponent(ON.text('addTextSpan'));
      await button.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.Add_ImageContent_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      let button = await driver.findComponent(ON.text('addImageSpan'));
      await button.click();
      await driver.delayMs(500);
      str = await getResourceString($r('app.string.AddImageContent_Text_1'));
      let richEditor1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.Add_Builder_DecoratorContent_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      let button = await driver.findComponent(ON.text('addBuilderSpan'));
      await button.click();
      await driver.delayMs(500);
      str = await getResourceString($r('app.string.AddBuilderDecoratorContent_Text_3'));
      let richEditor1 = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.Add_SymbolSpanContent_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      let button = await driver.findComponent(ON.text('addSymbolSpan'));
      await button.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.Get_GraphicInfo_In_Component_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      let button = await driver.findComponent(ON.text('getSpans'));
      await button.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.CreatSymbolGlyph_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.SymbolGlyphSpanAddToText_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.SymbolGlyphSpanCustomIconAnimation_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      str = await getResourceString($r('app.string.variable_color_animation'));
      str = await getResourceString($r('app.string.off'));
      let button1 = await driver.findComponent(ON.text(str));
      await button1.click();
      await driver.delayMs(500);
      str = await getResourceString($r('app.string.on'));
      str = await getResourceString($r('app.string.bounce_animation'));
      let button2 = await driver.findComponent(ON.text('trigger'));
      await button2.click();
      await driver.delayMs(500);
      str = await getResourceString($r('app.string.disable_animation'));
      let button3 = await driver.findComponent(ON.text('trigger'));
      await button3.click();
      await driver.delayMs(500);
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.delayMs(500);
      str = await getResourceString($r('app.string.quick_replacement_animation'));
      let button4 = await driver.findComponent(ON.text('trigger'));
      await button4.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      let buttonComponent = await driver.findComponent(ON.text('SymbolGlyph', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.SymbolGlyphSpanAddEvent_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      let buttonComponent = await driver.findComponent(ON.text('SymbolGlyph', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.SymbolGlyphSpanSceneExample_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      str = await getResourceString($r('app.string.play_in_order'));
      let text = await driver.findComponent(ON.text(str));
      await text.click();
      await driver.delayMs(500);
      str = await getResourceString($r('app.string.play_in_single_repeat'));
      await text.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.TextDrawingDisplay_NDK_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.ListenTextBoxEvents_NDK_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      let buttonComponent = await driver.findComponent(ON.text('SymbolGlyph', MatchPattern.CONTAINS));
      await buttonComponent.click();
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.SymbolShadowAndColor_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      let button1 = await driver.findComponent(ON.text(str));
      await button1.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
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
      await driver.delayMs(500)
      let scrollComponent: Component = await driver.waitForComponent(ON.id('scroll_'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.Set_Text_Margin'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500)
      str = await getResourceString($r('app.string.SetTextMargin_Content'));
      let textInput = await driver.findComponent(ON.type('TextArea', MatchPattern.CONTAINS));
      await textInput.click();
      await driver.delayMs(500)
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500)
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
      await driver.delayMs(500);
      let str = await getResourceString($r('app.string.ProhibitSelectionMenu_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      str = await getResourceString($r('app.string.ProhibitSelectMenu_title_1'));
      sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await sampleButton.click();
      await driver.delayMs(500);
      str = await getResourceString($r('app.string.ProhibitSelectMenu_content'));
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testProhibitSelectMenu end');
      done();
    })
  })
}