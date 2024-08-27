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
import { Driver, ON } from '@ohos.UiTest';

// 启动前需要安装手动安装HSP包再执行
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
          bundleName: "com.samples.systemrouter",
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
     * 从主页跳转到entry-pageOne
     */
    it('TestCase_002', 0, async () => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let btnItem = await driver.findComponent(ON.text("toEntryPageOne"));
      await btnItem.click();
      await driver.delayMs(1000);

      // 获取标题
      let title = await driver.findComponent(ON.text("entry-pageOne"));
      // 检查
      expect(title != undefined).assertTrue();
      await driver.delayMs(1000);
    })
    /**
     * 从entry-pageOne跳转到主页
     */
    it('TestCase_003', 0, async () => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let btnItem = await driver.findComponent(ON.text("toIndex"));
      await btnItem.click();

      await driver.delayMs(1000);
      // 获取标题
      let title = await driver.findComponent(ON.text("NavIndex"));
      // 检查
      expect(title != undefined).assertTrue();
      await driver.delayMs(1000);
    })

    /**
     * 从主页跳转到entry-pageTwo
     */
    it('TestCase_004', 0, async () => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let btnItem = await driver.findComponent(ON.text("toEntryPageTwo"));
      await btnItem.click();
      await driver.delayMs(1000);

      // 获取标题
      let title = await driver.findComponent(ON.text("entry-pageTwo"));
      // 检查
      expect(title != undefined).assertTrue();
      await driver.delayMs(1000);
    })
    /**
     * 从entry-pageTwo跳转到主页
     */
    it('TestCase_005', 0, async () => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let btnItem = await driver.findComponent(ON.text("toIndex"));
      await btnItem.click();

      await driver.delayMs(1000);
      // 获取标题
      let title = await driver.findComponent(ON.text("NavIndex"));
      // 检查
      expect(title != undefined).assertTrue();
      await driver.delayMs(1000);
    })

    /**
     * 从主页跳转到harA-pageOne
     */
    it('TestCase_006', 0, async () => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let btnItem = await driver.findComponent(ON.text("toHarAPageOne"));
      await btnItem.click();

      await driver.delayMs(1000);
      // 获取标题
      let title = await driver.findComponent(ON.text("harA-pageOne"));
      // 检查
      expect(title != undefined).assertTrue();
      await driver.delayMs(1000);
    })
    /**
     * 从harA-pageOne跳转到主页
     */
    it('TestCase_007', 0, async () => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let btnItem = await driver.findComponent(ON.text("toIndex"));
      await btnItem.click();

      await driver.delayMs(1000);
      // 获取标题
      let title = await driver.findComponent(ON.text("NavIndex"));
      // 检查
      expect(title != undefined).assertTrue();
      await driver.delayMs(1000);
    })

    /**
     * 从主页跳转到harA-pageTwo
     */
    it('TestCase_008', 0, async () => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let btnItem = await driver.findComponent(ON.text("toHarAPageTwo"));
      await btnItem.click();
      await driver.delayMs(1000);

      // 获取标题
      let title = await driver.findComponent(ON.text("harA-pageTwo"));
      // 检查
      expect(title != undefined).assertTrue();
      await driver.delayMs(1000);
    })
    /**
     * 从harA-pageTwo跳转到主页
     */
    it('TestCase_009', 0, async () => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let btnItem = await driver.findComponent(ON.text("toIndex"));
      await btnItem.click();

      await driver.delayMs(1000);
      // 获取标题
      let title = await driver.findComponent(ON.text("NavIndex"));
      // 检查
      expect(title != undefined).assertTrue();
      await driver.delayMs(1000);
    })

    /**
     * 从主页跳转到hspA-pageOne
     */
    it('TestCase_010', 0, async () => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let btnItem = await driver.findComponent(ON.text("toHspAPageOne"));
      await btnItem.click();
      await driver.delayMs(1000);

      // 获取标题
      let title = await driver.findComponent(ON.text("hspA-pageOne"));
      // 检查
      expect(title != undefined).assertTrue();
      await driver.delayMs(1000);
    })
    /**
     * 从hspA-pageOne跳转到主页
     */
    it('TestCase_011', 0, async () => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let btnItem = await driver.findComponent(ON.text("toIndex"));
      await btnItem.click();

      await driver.delayMs(1000);
      // 获取标题
      let title = await driver.findComponent(ON.text("NavIndex"));
      // 检查
      expect(title != undefined).assertTrue();
      await driver.delayMs(1000);
    })

    /**
     * 从主页跳转到hspA-pageTwo
     */
    it('TestCase_012', 0, async () => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let btnItem = await driver.findComponent(ON.text("toHspAPageTwo"));
      await btnItem.click();
      await driver.delayMs(1000);

      // 获取标题
      let title = await driver.findComponent(ON.text("hspA-pageTwo"));
      // 检查
      expect(title != undefined).assertTrue();
      await driver.delayMs(1000);
    })
    /**
     * 从hspA-pageTwo跳转到主页
     */
    it('TestCase_013', 0, async () => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let btnItem = await driver.findComponent(ON.text("toIndex"));
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

