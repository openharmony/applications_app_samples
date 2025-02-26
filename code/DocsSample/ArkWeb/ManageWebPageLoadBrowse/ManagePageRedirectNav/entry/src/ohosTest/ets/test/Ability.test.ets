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
     * 打开应用，点击 HistoryNavigati 按钮
     * 点击 loadData 按钮来触发前端页面的后退操作
     */
    it('HistoryNavigati',0, async (done: Function) => {
      console.info('uitest: HistoryNavigati begin');
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
      await driver.delayMs(4000);

      const button1 = await driver.findComponent(ON.text('HistoryNavigati'));
      await button1.click();
      await driver.delayMs(3000);

      const clickText = await driver.findComponent(ON.type('link'));
      await clickText.click();
      await driver.delayMs(3000);

      const button2 = await driver.findComponent(ON.type('Button'));
      await button2.click();
      await driver.delayMs(1000);

      const web = await driver.findComponent(ON.type('Web'));
      let src: string = await web.getText();
      expect(src).assertContain('example.com');

      await driver.pressBack();
      console.info('uitest: HistoryNavigati end');
      done();
    });

    /*
     * 点击 PageRedirection 按钮
     * 点击网页中的链接跳转到应用内其他页面
     */
    it('PageRedirection',0, async (done: Function) => {
      console.info('uitest: PageRedirection begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('PageRedirection'));
      await button1.click();
      await driver.delayMs(3000);

      const clickText = await driver.findComponent(ON.clickable(true).enabled(true));
      await clickText.click();
      await driver.delayMs(1000);

      const text = await driver.findComponent(ON.text('Hello World'));
      let type: string = await text.getType();
      expect(type).assertEqual('Text');
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      console.info('uitest: PageRedirection end');
      done();
    });

    /*
     * 点击 CrossApplicationRedirection 按钮
     * 击前端页面超链接跳转到其他应用
     */
    it('CrossApplicationRedirection',0, async (done: Function) => {
      console.info('uitest: CrossApplicationRedirection begin');
      const driver = Driver.create();
      await driver.delayMs(1000);

      const button1 = await driver.findComponent(ON.text('CrossApplicationRedirection'));
      await button1.click();
      await driver.delayMs(3000);

      const clickText = await driver.findComponent(ON.clickable(true).enabled(true));
      await clickText.click();
      await driver.delayMs(1000);

      const type = await driver.findComponent(ON.type('Web'));
      expect(type).assertEqual(null);

      await driver.pressBack();
      console.info('uitest: CrossApplicationRedirection end');
      done();
    });
  })
}