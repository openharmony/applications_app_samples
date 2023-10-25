/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import { logger } from '../util/Logger';

const TAG: string = 'Sample_KikaInput_Test';
const BUNDLE = 'KikaInput_';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // 打开自绘编辑框应用
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
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
    it(BUNDLE + 'ChangeInputMethod_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}ChangeInputMethod_001 begin`);
      let driver: Driver = Driver.create();
      let delegator = AbilityDelegatorRegistry.getAbilityDelegator();
      await delegator.executeShellCommand('aa start ability -a InputMethod -b cn.openharmony.inputmethodchoosedialog')
        .then(result => {
          logger.info(TAG, `${BUNDLE}start ability finished, result = ${JSON.stringify(result)}`);
        })
        .catch((err: Error) => {
          logger.info(TAG, `${BUNDLE}start ability failed, err = ${JSON.stringify(err)}`);
        })
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.type('List'));
      let list = await driver.findComponent(ON.type('List'));
      let kikainput = await list.scrollSearch(ON.text('kikainput', MatchPattern.CONTAINS));
      await driver.delayMs(1000);
      let bound = await kikainput.getBounds();
      await driver.click(bound.right - 10, bound.bottom - 10);
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}ChangeInputMethod_001 end`);
      done();
    })

    // 点击自绘编辑框拉起输入法，并输入内容
    it(BUNDLE + 'ShowKeyboard_001', 0, async (done: Function) => {
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
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('a', MatchPattern.CONTAINS));
      let inputText = await driver.findComponent(ON.text('a', MatchPattern.CONTAINS));
      await inputText.click();
      await inputText.click();
      await inputText.click();
      let inputContent = await driver.findComponent(ON.id('inputText'));
      let inputString = await inputContent.getText();
      expect(inputString === 'aaa').assertTrue();
      logger.info(TAG, `${BUNDLE}ShowKeyboard_001 end`);
      done();
    })

    // 进入菜单
    it(BUNDLE + 'EditModel_001', 0, async (done: Function) => {
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
    it(BUNDLE + 'MoveCursor_001', 0, async (done: Function) => {
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
    it(BUNDLE + 'MoveCursor_002', 0, async (done: Function) => {
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
    it(BUNDLE + 'Selection_001', 0, async (done: Function) => {
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
    it(BUNDLE + 'HideKeyboard_001', 0, async (done: Function) => {
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
  })
}
