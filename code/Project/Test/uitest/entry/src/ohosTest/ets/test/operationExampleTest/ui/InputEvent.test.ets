/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

import { describe, it, expect, TestType, beforeAll, Level, Size } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { Want } from '@kit.AbilityKit';
import { BusinessError } from '@ohos.base';
import { display } from '@kit.ArkUI';

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
const WAIT_UI_READYMS = 1000;
let test: string = '中文测试';
const waitUiReadyMs : number = 1000;
const TestTag = 'InputEventTest';

async function startAbility(bundleName: string, abilityName: string) {
  await delegator.executeShellCommand(`aa start -b ${bundleName} -a ${abilityName}`);
}

async function exitInputMethod() {
  let driver = Driver.create()
  let softKeyBoard = await driver.findComponent(ON.type('Canvas'))
  if (softKeyBoard != null) {
    await driver.pressBack()
  }
}
export default function InputEventTest() {
  describe('InputEventTest', () => {
      beforeAll(async () => {
      await  delegator.addAbilityMonitor({
        abilityName: 'InputAbility',
        moduleName: bundleName,
      });

        let want: Want = {
          bundleName : bundleName,
          abilityName : 'InputAbility'
        };
        await delegator.startAbility(want);
    })

    /**
     * @tc.number:InputEventTest_001
     * @tc.name: clickEventTest_Input
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest inputText 功能
     */
    it('clickEventTest_Input',TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let input = await driver.findComponent(ON.type('TextInput'));
      await input.inputText('123');
      await driver.delayMs(WAIT_UI_READYMS);
      let input_new = await driver.findComponent(ON.type('TextInput'));
      let text = await input_new.getText();
      expect(text === '123').assertTrue();
      done();
    })

    /**
     * @tc.number:InputEventTest_002
    * @tc.name: clickEventTest_Input_zh
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest inputText 输入中文功能测试
     */
    it('clickEventTest_Input_zh',TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let input = await driver.findComponent(ON.type('TextInput'));
      await input.inputText(test);
      await driver.delayMs(WAIT_UI_READYMS);
      let input_new = await driver.findComponent(ON.type('TextInput'));
      let text = await input_new.getText();
      expect(text == test).assertTrue();
      done();
    })

    /**
     * @tc.number:InputEventTest_002
     * @tc.name: clickEventTest_Input_zh
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest 指定坐标位置inputText输入功能测试
     */
    it('clickEventTest_Input_center',TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let input = await driver.findComponent(ON.type('TextInput'));
      let center = await input.getBoundsCenter();
      await input.clearText();
      await driver.inputText(center, '1234556');
      await driver.delayMs(WAIT_UI_READYMS);
      let input_new = await driver.findComponent(ON.type('TextInput'));
      let text = await input_new.getText();
      expect(text == '1234556').assertTrue();
      done();
    })

    /**
     * @tc.name: InputEventTest_ClearText
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest clear text
     */
    it('InputEventTest_ClearText', TestType.FUNCTION, async () => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let input1 = await driver.findComponent(ON.type('TextInput'));
      await input1.inputText('abc');
      await driver.delayMs(WAIT_UI_READYMS);
      let input2 = await driver.findComponent(ON.type('TextInput'));
      await input2.clearText();
      await driver.delayMs(WAIT_UI_READYMS);
      let input_new = await driver.findComponent(ON.type('TextInput'));
      let text = await input_new.getText();
      console.info("testClearText result :" + text);
      expect(text).assertEqual('');
    })

    /*
     * @tc.name: InputEventTest_InputText
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: enter '123',the values of both paste and addition are false，该接口从api20开始支持使用。
     */
    it('InputEventTest_InputText', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
      console.log(TestTag, 'InputEventTest_InputText start');
      let driver = Driver.create()
      await startAbility(bundleName, 'DemoAbility')
      await driver.delayMs(2000)
      let text = await driver.findComponent(ON.type('TextInput'))
      if (text == null) {
        let scorll = await driver.findComponent(ON.type('Scroll'))
        text = await scorll.scrollSearch(ON.type('TextInput'))
      }
      let center = await text.getBoundsCenter()
      await text.clearText();
      await driver.delayMs(2000);
      await driver.inputText(center, '123', {paste:false, addition:false})
      await driver.delayMs(2000);
      let text1 = await driver.findComponent(ON.type('TextInput'))
      expect(await text1.getText() == '123').assertTrue()
      console.log(TestTag, 'InputEventTest_InputText over');
    })

    /*
     * @tc.name: InputEventTest_InputText2
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: enter '123',the values of paste is true,the values of addition is false，该接口从api20开始支持使用。
     */
    it('InputEventTest_InputText2', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
      console.log(TestTag, 'InputEventTest_InputText2 start');
      let driver = Driver.create()
      await startAbility(bundleName, 'DemoAbility')
      await driver.delayMs(2000)
      let text = await driver.findComponent(ON.type('TextInput'))
      if (text == null) {
        let scorll = await driver.findComponent(ON.type('Scroll'))
        text = await scorll.scrollSearch(ON.type('TextInput'))
      }
      await text.clearText()
      await driver.delayMs(2000)
      await exitInputMethod()
      let center = await text.getBoundsCenter()
      await driver.inputText(center, '123', {paste:true, addition:false})
      await driver.delayMs(2000)
      await exitInputMethod()
      await driver.delayMs(2000)
      let text1 = await driver.findComponent(ON.type('TextInput'))
      expect(await text1.getText() == '123').assertTrue()
      console.log(TestTag, 'InputEventTest_InputText2 over');
    })

    /*
     * @tc.name: InputEventTest_TriggerCombineKeysWithId
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 多屏下，triggerCombineKeys test，该接口从api20开始支持使用。
     */
    it('InputEventTest_TriggerCombineKeysWithId', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
      console.log(TestTag, 'InputEventTest_TriggerCombineKeysWithId start');
      await startAbility(bundleName, 'DemoAbility')
      let driver = Driver.create()
      await driver.delayMs(waitUiReadyMs)
      let disPlay = display.getDefaultDisplaySync();
      console.log(`${TestTag}, InputEventTest_TriggerCombineKeysWithId disPlay is: ${JSON.stringify(disPlay)}`);
      await driver.delayMs(1000)
      let text = await driver.findComponent(ON.belongingDisplay(disPlay.id).type('TextInput'))
      if (text == null) {
        let scorll = await driver.findComponent(ON.belongingDisplay(disPlay.id).type('Scroll'))
        text = await scorll.scrollSearch(ON.belongingDisplay(disPlay.id).type('TextInput'))
      }
      let center = await text.getBoundsCenter()
      // set pasteBoard data
      await text.inputText('123')
      await driver.delayMs(1000)
      await driver.click(center.x, center.y)
      await driver.delayMs(waitUiReadyMs)
      await driver.triggerCombineKeys(2072, 2017, 0, disPlay.id)
      await driver.delayMs(waitUiReadyMs)
      await driver.triggerCombineKeys(2072, 2019, 0, disPlay.id)
      await driver.delayMs(waitUiReadyMs)
      // clear and paste
      let text2 = await driver.findComponent(ON.belongingDisplay(disPlay.id).type('TextInput'))
      await text2.clearText()
      await driver.delayMs(waitUiReadyMs)
      await driver.triggerCombineKeys(2072, 2038, 0, disPlay.id)
      await driver.delayMs(1000)
      let text3 = await driver.findComponent(ON.belongingDisplay(disPlay.id).type('TextInput'))
      expect(await text3.getText() == '123').assertTrue()
      console.log(TestTag, 'InputEventTest_TriggerCombineKeysWithId over');
    })
  })
}