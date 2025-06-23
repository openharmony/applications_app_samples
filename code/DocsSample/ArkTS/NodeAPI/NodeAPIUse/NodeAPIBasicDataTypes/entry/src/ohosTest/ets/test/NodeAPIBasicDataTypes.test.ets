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

export default function nodeAPIBasicDataTypesTest() {
  describe('nodeAPIBasicDataTypesTest', () => {
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
     * 点击按钮，调用napiGetValueUint32相关函数
     */
    it('testNodeAPIBasicDataTypes001', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIBasicDataTypes001 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('1.napiGetValueUint32'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetValueUint32Success'));
      console.info('uitest: testNodeAPIBasicDataTypes001 end');
      done();
    })

    /**
     * 点击按钮，调用napiGetValueInt32相关函数
     */
    it('testNodeAPIBasicDataTypes002', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIBasicDataTypes002 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('2.napiGetValueInt32'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetValueInt32Success'));
      console.info('uitest: testNodeAPIBasicDataTypes002 end');
      done();
    })

    /**
     * 点击按钮，调用napiGetValueInt64相关函数
     */
    it('testNodeAPIBasicDataTypes003', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIBasicDataTypes003 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('3.napiGetValueInt64'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetValueInt64Success'));
      console.info('uitest: testNodeAPIBasicDataTypes003 end');
      done();
    })

    /**
     * 点击按钮，调用napiGetValueDouble相关函数
     */
    it('testNodeAPIBasicDataTypes004', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIBasicDataTypes004 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('4.napiGetValueDouble'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetValueDoubleSuccess'));
      console.info('uitest: testNodeAPIBasicDataTypes004 end');
      done();
    })

    /**
     * 点击按钮，调用napiCreateInt32相关函数
     */
    it('testNodeAPIBasicDataTypes005', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIBasicDataTypes005 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('5.napiCreateInt32'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateInt32Success'));
      console.info('uitest: testNodeAPIBasicDataTypes005 end');
      done();
    })

    /**
     * 点击按钮，调用napiCreateUint32相关函数
     */
    it('testNodeAPIBasicDataTypes006', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIBasicDataTypes006 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('6.napiCreateUint32'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateUint32Success'));
      console.info('uitest: testNodeAPIBasicDataTypes006 end');
      done();
    })

    /**
     * 点击按钮，调用napiCreateInt64相关函数
     */
    it('testNodeAPIBasicDataTypes007', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIBasicDataTypes007 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('7.napiCreateInt64'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateInt64Success'));
      console.info('uitest: testNodeAPIBasicDataTypes007 end');
      done();
    })

    /**
     * 点击按钮，调用napiCreateDouble相关函数
     */
    it('testNodeAPIBasicDataTypes008', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIBasicDataTypes008 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('8.napiCreateDouble'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateDoubleSuccess'));
      console.info('uitest: testNodeAPIBasicDataTypes008 end');
      done();
    })
  })
}