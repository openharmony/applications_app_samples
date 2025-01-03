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
import { abilityDelegatorRegistry, Driver, ON, MatchPattern } from '@kit.TestKit';
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
     */
    it('testCreateText', 0, async (done: Function) => {
      console.info('uitest: testCreateText begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('Text', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      let str = await getResourceString($r('app.string.CreatText_title'));
      let sampleButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();

      let textString = await driver.findComponent(ON.text('This is a text string', MatchPattern.CONTAINS));
      let textResource = await driver.findComponent(ON.text('module description', MatchPattern.CONTAINS));
      expect(textString === null).assertFalse();
      expect(textResource === null).assertFalse();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testCreateText end');
      done();
    })

    /**
     * @tc.number UiTest_002
     * @tc.name testCreateText
     * @tc.desc 测试文本段创建场景示例
     */
    it('testTextSpan', 0, async (done: Function) => {
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
      str = await getResourceString($r('app.string.TextSpan_textContent_4'));
      let textColorSpan = await driver.findComponent(ON.text('我是Span2', MatchPattern.CONTAINS));
      str = await getResourceString($r('app.string.TextSpan_textContent_6'));
      let textCase = await driver.findComponent(ON.text('I am Upper-span', MatchPattern.CONTAINS));
      expect(textSpan === null).assertFalse();
      expect(textColorSpan === null).assertFalse();
      expect(textCase === null).assertFalse();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testTextSpan end');
      done();
    })

    /**
     * @tc.number UiTest_003
     * @tc.name testCustomTextStyle
     * @tc.desc 测试自定义文本样式场景示例
     */
    it('testCustomTextStyle', 0, async (done: Function) => {
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
      expect(textLeft === null).assertFalse();
      expect(textCenter === null).assertFalse();
      expect(textRight === null).assertFalse();
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testCustomTextStyle end');
      done();
    })

    /**
     * @tc.number UiTest_004
     * @tc.name testTextAddEvent
     * @tc.desc 测试文本增加事件场景示例
     */
    it('testTextAddEvent', 0, async (done: Function) => {
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
     * @tc.name testHotSearch
     * @tc.desc 测试热搜榜场景示例
     */
    it('testHotSearch', 0, async (done: Function) => {
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
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testHotSearch end');
      done();
    })

    /**
     * @tc.number UiTest_006
     * @tc.name testCreateTextInput
     * @tc.desc 测试创建文本输入框场景示例
     */
    it('testCreateTextInput', 0, async (done: Function) => {
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
     * @tc.number UiTest_007
     * @tc.name testSetTextInputType
     * @tc.desc 测试设置文本输入框类型场景示例
     */
    it('testSetTextInputType', 0, async (done: Function) => {
      console.info('uitest: testSetTextInputType begin');
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
      expect(textInput1 === null).assertFalse();
      expect(textInput2 === null).assertFalse();
      await textInput1.inputText('Normal');
      await textInput2.inputText('Password');
      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: testSetTextInputType end');
      done();
    })

    /**
     * @tc.number UiTest_008
     * @tc.name testCustomTextInputStyle
     * @tc.desc 测试自定义文本输入框样式场景示例
     */
    it('testCustomTextInputStyle', 0, async (done: Function) => {
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
     * @tc.number UiTest_009
     * @tc.name testTextInputAddEvent
     * @tc.desc 测试文本输入框增加事件场景示例
     */
    it('testTextInputAddEvent', 0, async (done: Function) => {
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
     * @tc.number UiTest_010
     * @tc.name testLoginRegisterPage
     * @tc.desc 测试登录/注册场景示例
     */
    it('testLoginRegisterPage', 0, async (done: Function) => {
      console.info('uitest: testLoginRegisterPage begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('TextInput', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
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
      console.info('uitest: testLoginRegisterPage end');
      done();
    })

    /**
     * @tc.number UiTest_011
     * @tc.name testKeyboardAvoidance
     * @tc.desc 测试键盘避让场景示例
     */
    it('testKeyboardAvoidance', 0, async (done: Function) => {
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
  })
}