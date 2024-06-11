/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import UIAbility from '@ohos.app.ability.UIAbility';
import { describe, it, expect, TestType } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import { logger } from '../util/Logger';
import inputMethod from '@ohos.inputMethod';

const TAG: string = 'Sample_KikaInput_Test';
const BUNDLE = 'KikaInput_';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // 打开自绘编辑框应用
    it('StartAbility_001',TestType.FUNCTION, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}StartAbility_001 begin`);
      let driver: Driver = Driver.create();
      let delegator = AbilityDelegatorRegistry.getAbilityDelegator();
      await delegator.executeShellCommand('aa start -b com.samples.kikainput -a TestAbility').then(result => {
        logger.info(TAG, `${BUNDLE}start ability finished, result = ${JSON.stringify(result)}`);
      }).catch((err: Error) => {
        logger.info(TAG, `${BUNDLE}start ability failed, err = ${JSON.stringify(err)}`);
      })
      await driver.delayMs(2000);
      await delegator.getCurrentTopAbility().then((ability: UIAbility) => {
        logger.info(TAG, `${BUNDLE}get top ability`);
        expect(ability.context.abilityInfo.name).assertEqual('TestAbility');
      })
      logger.info(TAG, `${BUNDLE}StartAbility_001 end`);
      done();
    })

    // 切换输入法应用
    it('SwitchInputMethod_001',TestType.FUNCTION, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}SwitchInputMethod_001 begin`);
      let driver: Driver = Driver.create();
      await inputMethod.getSetting().showOptionalInputMethods();
      logger.info(TAG, `${BUNDLE}SwitchInputMethod_001 11`);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.type('List'));
      logger.info(TAG, `${BUNDLE}SwitchInputMethod_001 22`);

      let list = await driver.findComponent(ON.type('List'));
      let kikainput = await list.scrollSearch(ON.text('kikainput', MatchPattern.CONTAINS));
      logger.info(TAG, `${BUNDLE}SwitchInputMethod_001 33 kikainput` + kikainput);
      await driver.delayMs(1000);
      let bound = await kikainput.getBounds();
      await driver.click(bound.right - 10, bound.bottom - 10);
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}SwitchInputMethod_001 end`);
      done();
    })

    // 点击自绘编辑框拉起输入法，并输入内容
    it('ShowKeyboard_001', TestType.FUNCTION, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}ShowKeyboard_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('customInputText'));
      let customInputText = await driver.findComponent(ON.id('customInputText'));
      await customInputText.click();
      await driver.delayMs(1000);
      // 如果当前是编辑菜单，切换到主键盘
      let btnEdit = await driver.findComponent(ON.id('btnEdit'));
      if (btnEdit !== undefined && btnEdit !== null) {
        await driver.assertComponentExist(ON.id('keyboardMenu'));
        let keyboardMenu = await driver.findComponent(ON.id('keyboardMenu'));
        await keyboardMenu.click();
      }

      logger.info(TAG, `${BUNDLE}ShowKeyboard_001 11`);
      // 如果当前是编辑页面，切换到主键盘
      let btn_selection = await driver.findComponent(ON.id('btn_selection'));
      if (btn_selection !== undefined && btn_selection !== null) {
        await driver.assertComponentExist(ON.id('keyboardMenu'));
        let keyboardMenu = await driver.findComponent(ON.id('keyboardMenu'));
        await keyboardMenu.click();
      }

      // 如果当前是数字键盘或符号键盘，切换到字母键盘
      let charKey = await driver.findComponent(ON.text('ABC', MatchPattern.CONTAINS));
      if (charKey !== undefined && charKey !== null) {
        await charKey.click();
      }
      logger.info(TAG, `${BUNDLE}ShowKeyboard_001 22`);

      //点击等输入法弹出
      await customInputText.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('a', MatchPattern.CONTAINS));
      let inputTexta = await driver.findComponent(ON.text('a', MatchPattern.CONTAINS));
      await inputTexta.click();
      await driver.delayMs(2000);

      await driver.assertComponentExist(ON.text('c', MatchPattern.CONTAINS));
      let inputTextc = await driver.findComponent(ON.text('c', MatchPattern.CONTAINS));
      await inputTextc.click();
      await driver.delayMs(2000);

      await driver.assertComponentExist(ON.text('d', MatchPattern.CONTAINS));
      let inputTextd = await driver.findComponent(ON.text('d', MatchPattern.CONTAINS));
      await inputTextd.click();
      await driver.delayMs(2000);

      let inputContent = await driver.findComponent(ON.id('inputText'));
      let inputString = await inputContent.getText();
      await driver.delayMs(200);
      expect(inputString === 'acd').assertTrue();
      logger.info(TAG, `${BUNDLE}ShowKeyboard_001 end`);
      done();
    })

    // 进入菜单
    it('EditModel_001', TestType.FUNCTION, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}EditModel_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('keyboardMenu'));
      let keyboardMenu = await driver.findComponent(ON.id('keyboardMenu'));
      await keyboardMenu.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('btnEdit'));
      let btnEdit = await driver.findComponent(ON.id('btnEdit'));
      await btnEdit.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('btn_selection'));
      logger.info(TAG, `${BUNDLE}EditModel_001 end`);
      done();
    })

    // 编辑界面，向左移动光标
    it('MoveCursor_001', TestType.FUNCTION, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}MoveCursor_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      let inputContent = await driver.findComponent(ON.id('inputText'));
      let inputString = await inputContent.getText();
      await driver.assertComponentExist(ON.id('arrow_left'));
      let arrow_left = await driver.findComponent(ON.id('arrow_left'));
      await arrow_left.click();
      await driver.delayMs(1000);
      let inputContent1 = await driver.findComponent(ON.id('inputText'));
      let inputString1 = await inputContent1.getText();
      expect((inputString.length - 1) === inputString1.length).assertTrue();
      logger.info(TAG, `${BUNDLE}MoveCursor_001 end`);
      done();
    })

    // 编辑界面，向右移动光标
    it('MoveCursor_002', TestType.FUNCTION, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}MoveCursor_002 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      let inputContent = await driver.findComponent(ON.id('inputText'));
      let inputString = await inputContent.getText();
      await driver.assertComponentExist(ON.id('arrow_right'));
      let arrow_right = await driver.findComponent(ON.id('arrow_right'));
      await arrow_right.click();
      await driver.delayMs(1000);
      let inputContent1 = await driver.findComponent(ON.id('inputText'));
      let inputString1 = await inputContent1.getText();
      expect((inputString.length + 1) === inputString1.length).assertTrue();
      logger.info(TAG, `${BUNDLE}MoveCursor_002 end`);
      done();
    })

    // 编辑界面，文本选中
    it('Selection_001', TestType.FUNCTION, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}Selection_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      let btn_selection = await driver.findComponent(ON.id('btn_selection'));
      await btn_selection.click();
      await driver.assertComponentExist(ON.id('arrow_left'));
      let arrow_left = await driver.findComponent(ON.id('arrow_left'));
      await arrow_left.click();
      await driver.delayMs(1000);
      let selectInput = await driver.findComponent(ON.id('selectInput'));
      let selectString = await selectInput.getText();
      expect(selectString.length === 1).assertTrue();

      await driver.assertComponentExist(ON.id('arrow_right'));
      let arrow_right = await driver.findComponent(ON.id('arrow_right'));
      await arrow_right.click();
      await driver.delayMs(1000);
      let selectInput1 = await driver.findComponent(ON.id('selectInput'));
      expect(selectInput1).assertNull();
      logger.info(TAG, `${BUNDLE}Selection_001 end`);
      done();
    })

    // 隐藏软键盘
    it('HideKeyboard_001', TestType.FUNCTION, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}HideKeyboard_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('kikaInputDown'));
      let kikaInputDown = await driver.findComponent(ON.id('kikaInputDown'));
      await kikaInputDown.click();
      await driver.delayMs(1000);
      let down = await driver.findComponent(ON.id('kikaInputDown'));
      expect(down).assertNull();
      logger.info(TAG, `${BUNDLE}HideKeyboard_001 end`);
      done();
    })

    // 预上屏
    it('PreviewText_001', TestType.FUNCTION, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}PreviewText_001 begin`);
      let driver: Driver = Driver.create();
      let delegator = AbilityDelegatorRegistry.getAbilityDelegator();

      await delegator.executeShellCommand('aa start ability -a EntryAbility -b com.samples.kikainput')
        .then(result => {
          logger.info(TAG, `${BUNDLE}start ability finished, result = ${JSON.stringify(result)}`);
        })
        .catch((err: Error) => {
          logger.info(TAG, `${BUNDLE}start ability failed, err = ${JSON.stringify(err)}`);
        })
      logger.info(TAG, `${BUNDLE}PreviewText_001 11`);
      await driver.delayMs(1000);

      let kikaInputDown = await driver.findComponent(ON.text('kikainput', MatchPattern.CONTAINS));
      await kikaInputDown.click();
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}PreviewText_001 end`);
      done();
    })

    it('PreviewText_002', TestType.FUNCTION, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}PreviewText_002 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);

      // 输入‘hel'触发预上屏'hello world'
      await driver.assertComponentExist(ON.type('TextInput'));
      let textInput = await driver.findComponent(ON.type('TextInput'));
      await textInput.click();
      await driver.delayMs(1000); // 等待输入法应用弹出

      await driver.assertComponentExist(ON.text('h', MatchPattern.CONTAINS));
      let inputTextH = await driver.findComponent(ON.text('h', MatchPattern.CONTAINS));
      await inputTextH.click();

      await driver.assertComponentExist(ON.text('e', MatchPattern.CONTAINS));
      let inputTextE = await driver.findComponent(ON.text('e', MatchPattern.CONTAINS));
      await inputTextE.click();

      await driver.assertComponentExist(ON.text('l', MatchPattern.CONTAINS));
      let inputTextL = await driver.findComponent(ON.text('l', MatchPattern.CONTAINS));
      await inputTextL.click();
      await driver.delayMs(2000);

      // 点击回车键触发预上屏内容到编辑框
      await driver.assertComponentExist(ON.id('returnItem')); // ON.type('ReturnItem')
      let enterKey = await driver.findComponent(ON.id('returnItem')); // ON.type('ReturnItem')

      await enterKey.click();
      await driver.delayMs(1000);

      // 校验文本框的内容为预上屏内容
      let inputString = await textInput.getText();
      expect(inputString === 'hello world').assertTrue();

      logger.info(TAG, `${BUNDLE}PreviewText_002 end`);
      done();
    })

    it('PreviewText_003', TestType.FUNCTION, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}PreviewText_003 begin`);
      let driver: Driver = Driver.create();

      // 输入‘abhel'触发预上屏'hello world'
      await driver.assertComponentExist(ON.type('TextInput'));
      let textInput = await driver.findComponent(ON.type('TextInput'));
      await textInput.click();
      await textInput.clearText();
      await driver.delayMs(1000); // 等待输入法应用弹出

      await driver.assertComponentExist(ON.text('a', MatchPattern.CONTAINS));
      let inputText = await driver.findComponent(ON.text('a', MatchPattern.CONTAINS));
      await inputText.click();

      await driver.assertComponentExist(ON.text('b', MatchPattern.CONTAINS));
      inputText = await driver.findComponent(ON.text('b', MatchPattern.CONTAINS));
      await inputText.click();

      await driver.assertComponentExist(ON.text('h', MatchPattern.CONTAINS));
      let inputTextH = await driver.findComponent(ON.text('h', MatchPattern.CONTAINS));
      await inputTextH.click();

      await driver.assertComponentExist(ON.text('e', MatchPattern.CONTAINS));
      let inputTextE = await driver.findComponent(ON.text('e', MatchPattern.CONTAINS));
      await inputTextE.click();

      await driver.assertComponentExist(ON.text('l', MatchPattern.CONTAINS));
      let inputTextL = await driver.findComponent(ON.text('l', MatchPattern.CONTAINS));
      await inputTextL.click();
      await driver.delayMs(2000);

      logger.info(TAG, `${BUNDLE}PreviewText_003 11`);

      // 点击回车键触发预上屏内容到编辑框
      await driver.assertComponentExist(ON.id('returnItem')); // ON.type('ReturnItem')
      let enterKey = await driver.findComponent(ON.id('returnItem')); // ON.type('ReturnItem')

      await enterKey.click();
      await driver.delayMs(1000);

      // 校验文本框的内容为预上屏内容
      let inputString = await textInput.getText();
      expect(inputString === 'abhello world').assertTrue();

      logger.info(TAG, `${BUNDLE}PreviewText_003 end`);
      done();
    })

  })
}
