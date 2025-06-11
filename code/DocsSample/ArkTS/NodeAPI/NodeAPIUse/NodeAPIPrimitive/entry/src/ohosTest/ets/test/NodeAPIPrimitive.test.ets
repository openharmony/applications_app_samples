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

export default function nodeAPIPrimitiveTest() {
  describe('nodeAPIPrimitiveTest', () => {
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
     * 点击按钮，调用napiCoerceToBool相关函数
     */
    it('testNodeAPIPrimitive001', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIPrimitive001 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('1.napiCoerceToBool'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCoerceToBoolSuccess'));
      console.info('uitest: testNodeAPIPrimitive001 end');
      done();
    })

    /**
     * 点击按钮，调用napiCoerceToNumber相关函数
     */
    it('testNodeAPIPrimitive002', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIPrimitive002 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('2.napiCoerceToNumber'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCoerceToNumberSuccess'));
      console.info('uitest: testNodeAPIPrimitive002 end');
      done();
    })

    /**
     * 点击按钮，调用napiCoerceToObject相关函数
     */
    it('testNodeAPIPrimitive003', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIPrimitive003 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('3.napiCoerceToObject'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCoerceToObjectSuccess'));
      console.info('uitest: testNodeAPIPrimitive003 end');
      done();
    })

    /**
     * 点击按钮，调用napiCoerceToString相关函数
     */
    it('testNodeAPIPrimitive004', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIPrimitive004 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('4.napiCoerceToString'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCoerceToStringSuccess'));
      console.info('uitest: testNodeAPIPrimitive004 end');
      done();
    })

    /**
     * 点击按钮，调用napiGetBoolean相关函数
     */
    it('testNodeAPIPrimitive005', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIPrimitive005 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('5.napiGetBoolean'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetBooleanSuccess'));
      console.info('uitest: testNodeAPIPrimitive005 end');
      done();
    })

    /**
     * 点击按钮，调用napiGetValueBool相关函数
     */
    it('testNodeAPIPrimitive006', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIPrimitive006 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('6.napiGetValueBool'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetValueBoolSuccess'));
      console.info('uitest: testNodeAPIPrimitive006 end');
      done();
    })

    /**
     * 点击按钮，调用napiGetGlobal相关函数
     */
    it('testNodeAPIPrimitive007', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIPrimitive007 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('7.napiGetGlobal'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetGlobalSuccess'));
      console.info('uitest: testNodeAPIPrimitive007 end');
      done();
    })

    /**
     * 点击按钮，调用napiGetNull相关函数
     */
    it('testNodeAPIPrimitive008', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIPrimitive008 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('8.napiGetNull'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetNullSuccess'));
      console.info('uitest: testNodeAPIPrimitive008 end');
      done();
    })

    /**
     * 点击按钮，调用napiGetUndefined相关函数
     */
    it('testNodeAPIPrimitive009', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIPrimitive009 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('9.napiGetUndefined'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetUndefinedSuccess'));
      console.info('uitest: testNodeAPIPrimitive009 end');
      done();
    })
  })
}