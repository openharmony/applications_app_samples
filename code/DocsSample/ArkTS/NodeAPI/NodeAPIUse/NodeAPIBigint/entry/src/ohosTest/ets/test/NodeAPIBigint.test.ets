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

export default function nodeAPIBigintTest() {
  describe('nodeAPIBigintTest', () => {
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
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      await driver.delayMs(1000);
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * 点击按钮，调用napiCreateBigintInt64相关函数
     */
    it('testNodeAPIBigint001', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIBigint001 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('1.napiCreateBigintInt64'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateBigintInt64Success'));
      console.info('uitest: testNodeAPIBigint001 end');
      done();
    })

    /**
     * 点击按钮，调用napiCreateBigintUint64相关函数
     */
    it('testNodeAPIBigint002', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIBigint002 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('2.napiCreateBigintUint64'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateBigintUint64Success'));
      console.info('uitest: testNodeAPIBigint002 end');
      done();
    })

    /**
     * 点击按钮，调用napiCreateBigintWords相关函数
     */
    it('testNodeAPIBigint003', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIBigint003 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('3.napiCreateBigintWords'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateBigintWordsSuccess'));
      console.info('uitest: testNodeAPIBigint003 end');
      done();
    })

    /**
     * 点击按钮，调用napiGetValueBigintInt64相关函数
     */
    it('testNodeAPIBigint004', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIBigint004 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('4.napiGetValueBigintInt64'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetValueBigintInt64Success'));
      console.info('uitest: testNodeAPIBigint004 end');
      done();
    })

    /**
     * 点击按钮，调用napiGetValueBigintUint64相关函数
     */
    it('testNodeAPIBigint005', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIBigint005 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('5.napiGetValueBigintUint64'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetValueBigintUint64Success'));
      console.info('uitest: testNodeAPIBigint005 end');
      done();
    })

    /**
     * 点击按钮，调用napiGetValueBigintWords相关函数
     */
    it('testNodeAPIBigint006', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIBigint006 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('6.napiGetValueBigintWords'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetValueBigintWordsSuccess'));
      console.info('uitest: testNodeAPIBigint006 end');
      done();
    })
  })
}