/*
* Copyright (C) 2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';

let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
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
    /**
     * 拉起应用
     */
    it(`StartAbility_001`, 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0xF811, 'testTag', 'StartAbility_001 begin');
      try {
        await abilityDelegatorRegistry.startAbility({
          bundleName: 'com.samples.navigation',
          abilityName: 'EntryAbility'
        });
        done();
      } catch (err) {
        expect(0).assertEqual(err.code);
        done();
      }
      hilog.info(0xF811, 'testTag', 'StartAbility_001 end');
    })
    /**
     * 从主页跳转到harA
     */
    it('TestCase_001', 0, async () => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let btnItem = await driver.findComponent(ON.text("ToHarAPage1"));
      await btnItem.click();

      await driver.delayMs(1000);
      // 获取标题
      let title = await driver.findComponent(ON.text("HarA_Page1"));
      // 检查
      expect(title != undefined).assertTrue();
      await driver.delayMs(1000);
    })
    /**
     * 从harA跳转到harB
     */
    it('TestCase_002', 0, async () => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let btnItem = await driver.findComponent(ON.text("ToHarBPage1"));
      await btnItem.click();
      await driver.delayMs(1000);

      // 获取标题
      let title = await driver.findComponent(ON.text("HarB_Page1"));
      // 检查
      expect(title != undefined).assertTrue();
      await driver.delayMs(1000);
    })
    /**
     * 从harB跳转到主页
     */
    it('TestCase_003', 0, async () => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let btnItem = await driver.findComponent(ON.text("ToIndex"));
      await btnItem.click();

      await driver.delayMs(1000);
      // 获取标题
      let title = await driver.findComponent(ON.text("NavIndex"));
      // 检查
      expect(title != undefined).assertTrue();
      await driver.delayMs(1000);
    })
  })
}

