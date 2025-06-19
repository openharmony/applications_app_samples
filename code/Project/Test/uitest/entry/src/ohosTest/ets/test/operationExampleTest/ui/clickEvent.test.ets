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

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
const WAIT_UI_READYMS = 1000;
const waitUiReadyMs : number = 1000;

async function startAbility(bundleName: string, abilityName: string) {
  await delegator.executeShellCommand(`aa start -b ${bundleName} -a ${abilityName}`);
}
export default function clickEventTest() {
  describe('clickEventTest', () => {
    beforeAll(async () => {
      let want: Want = {
        bundleName : bundleName,
        abilityName : 'clickAbility'
      };
      await delegator.startAbility(want);
    })

    /**
     * @tc.number:clickEventTest_001
     * @tc.name: clickEventTest_click
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest Component click 功能
     */
    it('clickEventTest_click',TestType.FUNCTION, async (done: Function) => {
      let dr = await Driver.create();
      await dr.delayMs(WAIT_UI_READYMS);
      let button = await dr.findComponent(ON.id('click_bt'));
      let text = await dr.findComponent(ON.id('result_text'));
      expect(await text.getText() == 'Hello World').assertTrue();
      await button.click();
       let text1 = await dr.findComponent(ON.id('result_text'));
      expect(await text1.getText() === 'singleClick').assertTrue();
      done();
    })

    /**
     * @tc.number:clickEventTest_002
     * @tc.name: clickEventTest_double_click
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest double click 功能
     */
    it('clickEventTest_double_click',TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let button = await driver.findComponent(ON.text('Click twice'));
      await button.doubleClick();
      await driver.delayMs(WAIT_UI_READYMS);
      let newButton = await driver.findComponent(ON.text('doubleClick'));
      let text = await newButton.getText();
      expect(text === 'doubleClick').assertTrue();
      await newButton.click();
      done();
    })

    /**
     * @tc.number:clickEventTest_003
     * @tc.name: clickEventTest_double_click
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest long click 功能
     */
    it('clickEventTest_Long_click', TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let button = await driver.findComponent(ON.text('LongClick'));
      await button.longClick();
      await driver.delayMs(WAIT_UI_READYMS);
      let newButton = await driver.findComponent(ON.text('longClick'));
      let text = await newButton.getText();
      expect(text === 'longClick').assertTrue();
      await newButton.click();
      done();
    })

    /**
     * @tc.name: clickEventTest_LongClickAt
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest long click 功能 该接口从API 20开始支持。
     */
    it('clickEventTest_LongClickAt', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
      let driver = Driver.create()
      await driver.delayMs(1000);
      let button = await driver.findComponent(ON.text('LongClick'));
      let center = await button.getBoundsCenter()
      await driver.longClickAt(center, 3000)
      await driver.delayMs(waitUiReadyMs)
      let newButton = await driver.findComponent(ON.text('longClick'))
      let text = await newButton.getText()
      expect(text == 'longClick').assertTrue()
      await newButton.click()
    })

    /**
     * @tc.name: clickEventTest_double_click
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest PressBack 功能
     */
    it('clickEventTest_PressBack', TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let button = await driver.findComponent(ON.text('LongClick'));
      await button.longClick();
      await driver.delayMs(WAIT_UI_READYMS);
      await driver.pressBack();
      await driver.delayMs(WAIT_UI_READYMS);
      let button_ori = await driver.findComponent(ON.text('Click twice'));
      expect(await button_ori.getText() === 'Click twice').assertTrue();
      done();
    })


    /**
     * @tc.number:clickEventTest_005
     * @tc.name: clickEventTest_double_click
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest triggerKey 功能
     */
    it('clickEventTest_TriggerKey', TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let button = await driver.findComponent(ON.text('LongClick'));
      await button.longClick();
      await driver.delayMs(WAIT_UI_READYMS);
      let keyBack = 2; // back
      await driver.triggerKey(keyBack);
      await driver.delayMs(WAIT_UI_READYMS);
      let button_ori = await driver.findComponent(ON.text('Click twice'));
      expect(await button_ori.getText() === 'Click twice').assertTrue();
      done();
    })

    /**
     * @tc.name: clickEventTest_ClickAt
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest 点击功能，该接口从api20开始支持使用。
     */
    it('clickEventTest_ClickAt', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
      let driver = Driver.create()
      await startAbility(bundleName, 'DemoAbility')
      await driver.delayMs(waitUiReadyMs)
      let Button = await driver.findComponent(ON.text('next page'))
      let center = await Button.getBoundsCenter()
      await driver.clickAt(center)
      await driver.delayMs(waitUiReadyMs)
      let newButton = await driver.findComponent(ON.text('back to index'))
      let text = await newButton.getText()
      expect(text == 'back to index').assertTrue()
      await newButton.click()
    })

    /**
     * @tc.name: clickEventTest_DoubleClickAt
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest 双击功能，该接口从api20开始支持使用。
     */
    it('clickEventTest_DoubleClickAt', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
      let driver = Driver.create()
      await startAbility(bundleName, 'DemoAbility')
      await driver.delayMs(waitUiReadyMs)
      let Button = await driver.findComponent(ON.text('Click twice'))
      if (Button == null) {
        let scorll = await driver.findComponent(ON.type('Scroll'))
        Button = await scorll.scrollSearch(ON.text('Click twice'))
      }
      let center = await Button.getBoundsCenter()
      await driver.doubleClickAt(center)
      await driver.delayMs(waitUiReadyMs)
      let button = await driver.findComponent(ON.text('doubleClick'))
      let text = await button.getText()
      expect(text == 'doubleClick').assertTrue()
      await button.click()
    })
  })
}