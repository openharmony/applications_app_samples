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
     * 打开应用，点击 RenderTxtBoxSameLayer_one 按钮
     * 采用<embed>标签同层渲染输入框
     */
    it('RenderTxtBoxSameLayer_one',0, async (done: Function) => {
      console.info('uitest: RenderTxtBoxSameLayer_one begin');
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
      await driver.delayMs(3000);

      const button1 = await driver.findComponent(ON.text('RenderTxtBoxSameLayer_one'));
      await button1.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('test1.html');

      await driver.pressBack();
      console.info('uitest: RenderTxtBoxSameLayer_one end');
      done();
    });
    
    /*
     * 点击 RenderTxtBoxSameLayer_two 按钮
     * 采用<object>标签同层渲染输入框
     */
    it('RenderTxtBoxSameLayer_two', 0, async (done: Function) => {
      console.info('uitest: RenderTxtBoxSameLayer_two begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('RenderTxtBoxSameLayer_two'));
      await button1.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('test2.html');

      await driver.pressBack();
      console.info('uitest: RenderTxtBoxSameLayer_two end');
      done();
    });
    
    /*
     * 点击 DrawXCompAVPBtn 按钮
     * 通过 enableNativeEmbedMode 控制同层渲染开关，显式使用embed标签
     */
    it('DrawXCompAVPBtn', 0, async (done: Function) => {
      console.info('uitest: DrawXCompAVPBtn begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('DrawXCompAVPBtn'));
      await button1.click();
      await driver.delayMs(1000);

      const button2 = await driver.findComponent(ON.type('Button'));
      await button2.click();
      await driver.delayMs(1000);

      const web1 = await driver.findComponent(ON.type('Web'));
      let src: string = await web1.getText();
      expect(src).assertContain('test3.html');

      console.info('uitest: DrawXCompAVPBtn end');
      done();
    });
  })
}