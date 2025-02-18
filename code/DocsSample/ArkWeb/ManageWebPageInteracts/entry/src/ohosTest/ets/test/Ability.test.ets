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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    /*
     * 打开应用，点击 ImpNestedScroll 按钮
     * 设置滚动模式
     */
    it('ImpNestedScroll', 0, async (done: Function) => {
      console.info('uitest: ImpNestedScroll begin');
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      const driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('ImpNestedScroll'));
      await button1.click();
      await driver.delayMs(500);

      const button2 = await driver.findComponent(ON.text('SELF_ONLY'));
      await button2.click();
      await driver.delayMs(500);

      const button3 = await driver.findComponent(ON.text('SELF_FIRST'));
      await button3.click();
      await driver.delayMs(500);

      const button4 = await driver.findComponent(ON.text('PARENT_FIRST'));
      await button4.click();
      await driver.delayMs(500);

      const button5 = await driver.findComponent(ON.text('PARALLEL'));
      await button5.click();
      await driver.delayMs(500);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('www.example.com');

      await driver.pressBack();
      console.info('uitest: ImpNestedScroll end');
      done();
    });

    /*
     * 打开应用，点击 OnIntKbdAttachSysCustIn 按钮
     * 调用onInterceptKeyboardAttach来拦截系统软键盘的弹出
     */
    it('OnIntKbdAttachSysCustIn', 0, async (done: Function) => {
      console.info('uitest: OnIntKbdAttachSysCustIn begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('OnIntKbdAttachSysCustIn'));
      await button1.click();
      await driver.delayMs(1000);

      const input1 = await driver.findComponent(ON.clickable(true).enabled(true));
      await input1.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('index.html');

      await driver.pressBack();
      await driver.pressBack();
      console.info('uitest: OnIntKbdAttachSysCustIn end');
      done();
    });

    /*
     * 打开应用，点击 SetSKBMode_one 按钮
     * 设置ArkWeb组件的键盘避让模式
     */
    it('SetSKBMode_one', 0, async (done: Function) => {
      console.info('uitest: SetSKBMode_one begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('SetSKBMode_one'));
      await button1.click();
      await driver.delayMs(2000);

      const input1 = await driver.findComponent(ON.clickable(true).enabled(true));
      await input1.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('SetSKBModeIndex.html');

      await driver.pressBack();
      console.info('uitest: SetSKBMode_one end');
      done();
    });
  })
}