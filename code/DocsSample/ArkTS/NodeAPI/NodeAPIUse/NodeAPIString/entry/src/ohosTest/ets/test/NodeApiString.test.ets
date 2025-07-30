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

import { describe, it, expect, beforeAll } from '@ohos/hypium';
// 导入测试依赖kit
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

const testDelayMs = 1000;

export default function nodeAPIStringTest() {
  describe('nodeAPIStringTest', () => {
    /**
     * 打开应用
     */
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      const driver = Driver.create();
      await driver.delayMs(testDelayMs);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      await driver.delayMs(testDelayMs);
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * 点击按钮，调用getValueStringUtf8相关函数
     */
    it('testGetValueStringUtf8', 0, async (done: Function) => {
      console.info('uitest: testGetValueStringUtf8 begin');
      const driver = Driver.create();
      await driver.delayMs(testDelayMs);
      const text = await driver.findComponent(ON.text('1. getValueStringUtf8'));
      await driver.delayMs(testDelayMs);
      await text.click();
      await driver.delayMs(testDelayMs);
      await driver.assertComponentExist(ON.text('Result: getValueStringUtf8 tested'));
      console.info('uitest: testGetValueStringUtf8 end');
      done();
    })

    /**
     * 点击按钮，调用createStringUtf8相关函数
     */
    it('testCreateStringUtf8', 0, async (done: Function) => {
      console.info('uitest: testCreateStringUtf8 begin');
      const driver = Driver.create();
      await driver.delayMs(testDelayMs);
      const text = await driver.findComponent(ON.text('2. createStringUtf8'));
      await driver.delayMs(testDelayMs);
      await text.click();
      await driver.delayMs(testDelayMs);
      await driver.assertComponentExist(ON.text('Result: createStringUtf8 tested'));
      console.info('uitest: testCreateStringUtf8 end');
      done();
    })

    /**
     * 点击按钮，调用getValueStringUtf16相关函数
     */
    it('testGetValueStringUtf16', 0, async (done: Function) => {
      console.info('uitest: testGetValueStringUtf16 begin');
      const driver = Driver.create();
      await driver.delayMs(testDelayMs);
      const text = await driver.findComponent(ON.text('3. getValueStringUtf16'));
      await driver.delayMs(testDelayMs);
      await text.click();
      await driver.delayMs(testDelayMs);
      await driver.assertComponentExist(ON.text('Result: getValueStringUtf16 tested'));
      console.info('uitest: testGetValueStringUtf16 end');
      done();
    })

    /**
     * 点击按钮，调用createStringUtf16相关函数
     */
    it('testCreateStringUtf16', 0, async (done: Function) => {
      console.info('uitest: testCreateStringUtf16 begin');
      const driver = Driver.create();
      await driver.delayMs(testDelayMs);
      const text = await driver.findComponent(ON.text('4. createStringUtf16'));
      await driver.delayMs(testDelayMs);
      await text.click();
      await driver.delayMs(testDelayMs);
      await driver.assertComponentExist(ON.text('Result: createStringUtf16 tested'));
      console.info('uitest: testCreateStringUtf16 end');
      done();
    })

    /**
     * 点击按钮，调用getValueStringLatin1相关函数
     */
    it('testGetValueStringLatin1', 0, async (done: Function) => {
      console.info('uitest: testGetValueStringLatin1 begin');
      const driver = Driver.create();
      await driver.delayMs(testDelayMs);
      const text = await driver.findComponent(ON.text('5. getValueStringLatin1'));
      await driver.delayMs(testDelayMs);
      await text.click();
      await driver.delayMs(testDelayMs);
      await driver.assertComponentExist(ON.text('Result: getValueStringLatin1 tested'));
      console.info('uitest: testGetValueStringLatin1 end');
      done();
    })

    /**
     * 点击按钮，调用createStringLatin1相关函数
     */
    it('testCreateStringLatin1', 0, async (done: Function) => {
      console.info('uitest: testCreateStringLatin1 begin');
      const driver = Driver.create();
      await driver.delayMs(testDelayMs);
      const text = await driver.findComponent(ON.text('6. createStringLatin1'));
      await driver.delayMs(testDelayMs);
      await text.click();
      await driver.delayMs(testDelayMs);
      await driver.assertComponentExist(ON.text('Result: createStringLatin1 tested'));
      console.info('uitest: testCreateStringLatin1 end');
      done();
    })
  })
}