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
import { Want } from '@kit.AbilityKit';
import Logger from '../util/Logger';
const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
const LOAD_SUCCESS: string = 'Log information printing:';
export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async (done: Function) => {
      Logger.info(LOAD_SUCCESS + 'ActsAbilityTest begin');
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      const driver = Driver.create();
      await driver.delayMs(1000);
      Logger.info(LOAD_SUCCESS + 'get top ability');
      await driver.delayMs(1000);

      done();
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(async (done: Function) => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const driver = Driver.create();
      await driver.pressBack();
      await driver.delayMs(3000);
      done();
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('processweb_scrollTo_ArkTS_one_001', 0, async (done: Function) => {
      Logger.info(LOAD_SUCCESS + 'processweb_scrollTo_ArkTS_one_001 begin');
      const driver = Driver.create();

      const button = await driver.findComponent(ON.text('WebScrollDemoButton'));
      await button.click();
      await driver.delayMs(3000);

      const button1 = await driver.findComponent(ON.text('Scroll down ↓'));
      await button1.click();
      await driver.delayMs(100);

      const button2 = await driver.findComponent(ON.text('1. scrollTo(0, 0)'));
      await button2.click();
      await driver.delayMs(100);

      // 查找显示滚动位置的文本组件text
      const scrollPositionText = await driver.findComponent(ON.id('scrollPositionText'));
      const positionText = await scrollPositionText.getText();
      Logger.info(LOAD_SUCCESS + `positionText: ${positionText}`);

      // 从文本中提取数字
      const yPositionMatch = positionText.match(/Y:\s*(\d+)/);
      if (yPositionMatch && yPositionMatch[1]) {
        const yPosition = parseInt(yPositionMatch[1]);
        Logger.info(LOAD_SUCCESS + `yPosition: ${yPosition}`);
        expect(yPosition).assertEqual(0);
      } else {
        expect(positionText).assertContain('0');
      }
      Logger.info(LOAD_SUCCESS + 'processweb_scrollTo_ArkTS_one_001 end');

      done();
    })

    it('processweb_scrollBy_js_two_001', 0, async (done: Function) => {
      Logger.info(LOAD_SUCCESS + 'processweb_scrollBy_js_two_001 begin');
      const driver = Driver.create();

      const button = await driver.findComponent(ON.text('WebScrollDemoButton'));
      await button.click();
      await driver.delayMs(3000);

      const button1 = await driver.findComponent(ON.text('Scroll down ↓'));
      await button1.click();
      await driver.delayMs(100);

      // 查找显示滚动位置的文本组件text
      const scrollPositionText = await driver.findComponent(ON.id('scrollPositionText'));
      const positionText = await scrollPositionText.getText();
      Logger.info(LOAD_SUCCESS + `positionText: ${positionText}`);

      // 从文本中提取数字
      const yPositionMatch = positionText.match(/Y:\s*(\d+)/);
      if (yPositionMatch && yPositionMatch[1]) {
        const yPosition = parseInt(yPositionMatch[1]);
        Logger.info(LOAD_SUCCESS + `yPosition: ${yPosition}`);
        expect(yPosition).assertEqual(200);
      } else {
        expect(positionText).assertContain('200');
      }
      Logger.info(LOAD_SUCCESS + 'processweb_scrollBy_js_two_001 end');

      done();
    })

    it('processweb_scrollBy_js_three_001', 0, async (done: Function) => {
      Logger.info(LOAD_SUCCESS + 'processweb_scrollBy_js_three_001 begin');
      const driver = Driver.create();

      const button = await driver.findComponent(ON.text('WebScrollDemoButton'));
      await button.click();
      await driver.delayMs(3000);

      const button1 = await driver.findComponent(ON.text('Jump to a specific location：500px ↓'));
      await button1.click();
      await driver.delayMs(100);

      const button2 = await driver.findComponent(ON.text('阅读更多 ↓'));
      await button2.click();
      await driver.delayMs(100);

      // 查找显示滚动位置的文本组件text
      const scrollPositionText = await driver.findComponent(ON.id('scrollPositionText'));
      const positionText = await scrollPositionText.getText();
      Logger.info(LOAD_SUCCESS + `positionText: ${positionText}`);

      // 从文本中提取数字
      const yPositionMatch = positionText.match(/Y:\s*(\d+)/);
      if (yPositionMatch && yPositionMatch[1]) {
        const yPosition = parseInt(yPositionMatch[1]);
        Logger.info(LOAD_SUCCESS + `yPosition: ${yPosition}`);
        expect(yPosition).assertEqual(800);
      } else {
        expect(positionText).assertContain('800');
      }
      Logger.info(LOAD_SUCCESS + 'processweb_scrollBy_js_three_001 end');

      done();
    })

    it('processweb_scrollTo_js_four_001', 0, async (done: Function) => {
      Logger.info(LOAD_SUCCESS + 'processweb_scrollTo_js_four_001 begin');
      const driver = Driver.create();

      const button = await driver.findComponent(ON.text('WebScrollDemoButton'));
      await button.click();
      await driver.delayMs(3000);

      const button1 = await driver.findComponent(ON.text('Scroll to 400px ↓'));
      await button1.click();
      await driver.delayMs(100);

      // 查找显示滚动位置的文本组件text
      const scrollPositionText = await driver.findComponent(ON.id('scrollPositionText'));
      const positionText = await scrollPositionText.getText();
      Logger.info(LOAD_SUCCESS + `positionText: ${positionText}`);

      // 从文本中提取数字
      const yPositionMatch = positionText.match(/Y:\s*(\d+)/);
      if (yPositionMatch && yPositionMatch[1]) {
        const yPosition = parseInt(yPositionMatch[1]);
        Logger.info(LOAD_SUCCESS + `yPosition: ${yPosition}`);
        expect(yPosition).assertEqual(400);
      } else {
        expect(positionText).assertContain('400');
      }
      Logger.info(LOAD_SUCCESS + 'processweb_scrollTo_js_four_001 end');

      done();
    })

    it('processweb_scrollTo_js_five_001', 0, async (done: Function) => {
      Logger.info(LOAD_SUCCESS + 'processweb_scrollTo_js_five_001 begin');
      const driver = Driver.create();

      const button = await driver.findComponent(ON.text('WebScrollDemoButton'));
      await button.click();
      await driver.delayMs(3000);
      const button1 = await driver.findComponent(ON.text('Scroll down ↓'));
      await button1.click();
      await driver.delayMs(100);

      const button2 = await driver.findComponent(ON.text('Back to top'));
      await button2.click();
      await driver.delayMs(100);

      // 查找显示滚动位置的文本组件text
      const scrollPositionText = await driver.findComponent(ON.id('scrollPositionText'));
      const positionText = await scrollPositionText.getText();
      Logger.info(LOAD_SUCCESS + `positionText: ${positionText}`);

      // 从文本中提取数字
      const yPositionMatch = positionText.match(/Y:\s*(\d+)/);
      if (yPositionMatch && yPositionMatch[1]) {
        const yPosition = parseInt(yPositionMatch[1]);
        Logger.info(LOAD_SUCCESS + `yPosition: ${yPosition}`);
        expect(yPosition).assertEqual(0);
      } else {
        expect(positionText).assertContain('0');
      }
      Logger.info(LOAD_SUCCESS + 'processweb_scrollTo_js_five_001 end');

      done();
    })

    it('processweb_scrollTo_js_six_001', 0, async (done: Function) => {
      Logger.info(LOAD_SUCCESS + 'processweb_scrollTo_js_six_001 begin');
      const driver = Driver.create();

      const button = await driver.findComponent(ON.text('WebScrollDemoButton'));
      await button.click();
      await driver.delayMs(3000);
      const button1 = await driver.findComponent(ON.text('Jump to a specific location：500px ↓'));
      await button1.click();
      await driver.delayMs(100);

      // 查找显示滚动位置的文本组件text
      const scrollPositionText = await driver.findComponent(ON.id('scrollPositionText'));
      const positionText = await scrollPositionText.getText();
      Logger.info(LOAD_SUCCESS + `positionText: ${positionText}`);

      // 从文本中提取数字
      const yPositionMatch = positionText.match(/Y:\s*(\d+)/);
      if (yPositionMatch && yPositionMatch[1]) {
        const yPosition = parseInt(yPositionMatch[1]);
        Logger.info(LOAD_SUCCESS + `yPosition: ${yPosition}`);
        expect(yPosition).assertEqual(500);
      } else {
        expect(positionText).assertContain('500');
      }
      Logger.info(LOAD_SUCCESS + 'processweb_scrollTo_js_six_001 end');

      done();
    })
  })
}