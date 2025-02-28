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
     * 打开应用，点击 JavaScriptProxy 按钮
     * 在Web组件初始化使用 javaScriptProxy 接口注册应用侧代码
     */
    it('JavaScriptProxy', 0, async (done: Function) => {
      console.info('uitest: JavaScriptProxy begin');
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'Entry2Ability'
      };
      await delegator.startAbility(want);
      const driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('Entry2Ability');
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('JavaScriptProxy'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.type('Button'));
      await button2.click();
      await driver.delayMs(1000);

      const button3 = await driver.findComponent(ON.type('button'));
      await button3.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('index1.html');

      await driver.pressBack();
      console.info('uitest: JavaScriptProxy end');
      done();
    });
    
    /*
     * 点击 Promise_one 按钮
     * 使用Promise使用场景
     */
    it('Promise_one', 0, async (done: Function) => {
      console.info('uitest: Promise_one begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('Promise_one'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.text('refresh'));
      await button2.click();
      await driver.delayMs(1000);

      const button3 = await driver.findComponent(ON.text('Register JavaScript To Window'));
      await button3.click();
      await driver.delayMs(1000);

      const button4 = await driver.findComponent(ON.text('deleteJavaScriptRegister'));
      await button4.click();
      await driver.delayMs(1000);

      const button5 = await driver.findComponent(ON.type('button'));
      await button5.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      console.info('uitest: Promise_one end');
      done();
    });
    
    /*
     * 点击 Promise_two 按钮
     * 使用Promise使用场景
     */
    it('Promise_two', 0, async (done: Function) => {
      console.info('uitest: Promise_two begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('Promise_two'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.text('refresh'));
      await button2.click();
      await driver.delayMs(1000);

      const button3 = await driver.findComponent(ON.text('Register JavaScript To Window'));
      await button3.click();
      await driver.delayMs(1000);

      const button4 = await driver.findComponent(ON.text('deleteJavaScriptRegister'));
      await button4.click();
      await driver.delayMs(1000);

      const button5 = await driver.findComponent(ON.type('button'));
      await button5.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      console.info('uitest: Promise_two end');
      done();
    });
    
    /*
     * 点击 RegisterJavaScriptProxy 按钮
     * 使用 registerJavaScriptProxy 接口注册应用侧代码
     */
    it('RegisterJavaScriptProxy', 0, async (done: Function) => {
      console.info('uitest: RegisterJavaScriptProxy begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('RegisterJavaScriptProxy'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.text('refresh'));
      await button2.click();
      await driver.delayMs(1000);

      const button3 = await driver.findComponent(ON.text('Register JavaScript To Window'));
      await button3.click();
      await driver.delayMs(1000);

      const button4 = await driver.findComponent(ON.text('deleteJavaScriptRegister'));
      await button4.click();
      await driver.delayMs(1000);

      const button5 = await driver.findComponent(ON.type('button'));
      await button5.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('index4.html');

      await driver.pressBack();
      console.info('uitest: RegisterJavaScriptProxy end');
      done();
    });
    
    /*
     * 点击 UsageOfComplexTypes_one 按钮
     * 在应用侧和前端页面之间传递Array
     */
    it('UsageOfComplexTypes_one', 0, async (done: Function) => {
      console.info('uitest: UsageOfComplexTypes_one begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('UsageOfComplexTypes_one'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.text('refresh'));
      await button2.click();
      await driver.delayMs(1000);

      const button3 = await driver.findComponent(ON.text('Register JavaScript To Window'));
      await button3.click();
      await driver.delayMs(1000);

      const button4 = await driver.findComponent(ON.text('deleteJavaScriptRegister'));
      await button4.click();
      await driver.delayMs(1000);

      const button5 = await driver.findComponent(ON.type('button'));
      await button5.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('index7.html');

      await driver.pressBack();
      console.info('uitest: UsageOfComplexTypes_one end');
      done();
    });
    
    /*
     * 点击 UsageOfComplexTypes_two 按钮
     * 应用侧和前端页面之间传递基础类型，非Function等复杂类型
     */
    it('UsageOfComplexTypes_two', 0, async (done: Function) => {
      console.info('uitest: UsageOfComplexTypes_two begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('UsageOfComplexTypes_two'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.text('refresh'));
      await button2.click();
      await driver.delayMs(1000);

      const button3 = await driver.findComponent(ON.text('Register JavaScript To Window'));
      await button3.click();
      await driver.delayMs(1000);

      const button4 = await driver.findComponent(ON.text('deleteJavaScriptRegister'));
      await button4.click();
      await driver.delayMs(1000);

      const button5 = await driver.findComponent(ON.type('button'));
      await button5.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('index9.html');

      await driver.pressBack();
      console.info('uitest: UsageOfComplexTypes_two end');
      done();
    });
    
    /*
     * 点击 UsageOfComplexTypes_three 按钮
     * 使用应用侧调用前端页面的Callback
     */
    it('UsageOfComplexTypes_three', 0, async (done: Function) => {
      console.info('uitest: UsageOfComplexTypes_three begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('UsageOfComplexTypes_three'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.text('refresh'));
      await button2.click();
      await driver.delayMs(1000);

      const button3 = await driver.findComponent(ON.text('Register JavaScript To Window'));
      await button3.click();
      await driver.delayMs(1000);

      const button4 = await driver.findComponent(ON.text('deleteJavaScriptRegister'));
      await button4.click();
      await driver.delayMs(1000);

      const button5 = await driver.findComponent(ON.type('button'));
      await button5.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('index8.html');

      await driver.pressBack();
      console.info('uitest: UsageOfComplexTypes_three end');
      done();
    });
    
    /*
     * 点击 UsageOfComplexTypes_four 按钮
     * 应用侧调用前端页面Object里的Function
     */
    it('UsageOfComplexTypes_four', 0, async (done: Function) => {
      console.info('uitest: UsageOfComplexTypes_four begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('UsageOfComplexTypes_four'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.text('refresh'));
      await button2.click();
      await driver.delayMs(1000);

      const button3 = await driver.findComponent(ON.text('Register JavaScript To Window'));
      await button3.click();
      await driver.delayMs(1000);

      const button4 = await driver.findComponent(ON.text('deleteJavaScriptRegister'));
      await button4.click();
      await driver.delayMs(1000);

      const button5 = await driver.findComponent(ON.type('button'));
      await button5.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('index6.html');

      await driver.pressBack();
      console.info('uitest: UsageOfComplexTypes_four end');
      done();
    });
    
    /*
     * 点击 UsageOfComplexTypes_five 按钮
     * 前端页面调用应用侧Object里的Function
     */
    it('UsageOfComplexTypes_five', 0, async (done: Function) => {
      console.info('uitest: UsageOfComplexTypes_five begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('UsageOfComplexTypes_five'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.text('refresh'));
      await button2.click();
      await driver.delayMs(1000);

      const button3 = await driver.findComponent(ON.text('Register JavaScript To Window'));
      await button3.click();
      await driver.delayMs(1000);

      const button4 = await driver.findComponent(ON.text('deleteJavaScriptRegister'));
      await button4.click();
      await driver.delayMs(1000);

      const button5 = await driver.findComponent(ON.type('button'));
      await button5.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('index5.html');

      console.info('uitest: UsageOfComplexTypes_five end');
      done();
    });
  })
}