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
import { KeyCode } from '@kit.InputKit';

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
     * 打开应用
     * 测试复用、释放以及恢复离线Web组件
     */
    it('TestUiExample', 0, async (done: Function) => {
      console.info('uitest: TestUiExample begin');
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'Entry3Ability'
      };
      await delegator.startAbility(want);
      const driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('Entry3Ability');
      await driver.delayMs(3000);

      // go home page
      await (await driver.findComponent(ON.id("go_home"))).click();
      await driver.delayMs(1000);

      // go page1
      await (await driver.findComponent(ON.id("go_page1"))).click();
      await driver.delayMs(2000);
      // back home page
      await driver.triggerKey(KeyCode.KEYCODE_BACK);

      // go page2:1
      await (await driver.findComponent(ON.id('go_page2:1'))).click();
      await driver.delayMs(1000);
      // back home page
      await driver.triggerKey(KeyCode.KEYCODE_BACK);
      await driver.delayMs(500);

      // go page2:2
      await (await driver.findComponent(ON.id('go_page2:2'))).click();
      await driver.delayMs(1000);
      // back home page
      await driver.triggerKey(KeyCode.KEYCODE_BACK);
      await driver.delayMs(500);

      // go page2:3
      await (await driver.findComponent(ON.id('go_page2:3'))).click();
      await driver.delayMs(1000)
      let src_web: string = await (await driver.findComponent(ON.type('Web'))).getText();
      expect(src_web).assertContain('about:blank');
      // back home page
      await driver.triggerKey(KeyCode.KEYCODE_BACK);
      await driver.delayMs(1000);

      // back index page
      await (await driver.findComponent(ON.id('back_index'))).click();
      await driver.delayMs(1000);

      // check offline NWebs
      const textInfo = await driver.findComponent(ON.type("Text"))
      let src1: string = await textInfo.getText();
      expect(src1).assertContain('.com\n     isBound :');
      expect(src1).assertContain('about:blank?tab=1\n     isBound :');
      expect(src1).assertContain('about:blank?tab=2\n     isBound :');

      // recycleNWebs and check
      await (await driver.findComponent(ON.id('recycleNWebs'))).click();
      await driver.delayMs(1000);
      let src2: string = await textInfo.getText();
      console.info(src2);
      expect(src2).assertContain('[recycledNWebs]\n[1]');
      expect(src2).assertContain('.com\n[2]about:blank?tab=1\n[3]about:blank?tab=2');

      // restoreNWebs and check
      await (await driver.findComponent(ON.id('restoreNWebs'))).click();
      await driver.delayMs(1000);
      let src3: string = await textInfo.getText();
      expect(src3).assertContain('.com\n     isBound :');
      expect(src3).assertContain('about:blank?tab=1\n     isBound :');
      expect(src3).assertContain('about:blank?tab=2\n     isBound :');
      console.info('uitest: TestUiExample end');
      done();
    })
  })
}