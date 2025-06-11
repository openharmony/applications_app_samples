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

export default function nodeAPIPropertyTest() {
  describe('nodeAPIPropertyTest', () => {
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
     * 点击按钮，调用napiGetPropertyNames相关函数
     */
    it('testNodeAPIProperty001', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray001 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('1.napiGetPropertyNames'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetPropertyNamesSuccess'));
      console.info('uitest: testNodeAPIArray001 end');
      done();
    })

    /**
     * 点击按钮，调用napiSetProperty相关函数
     */
    it('testNodeAPIProperty002', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray002 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('2.napiSetProperty'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiSetPropertySuccess'));
      console.info('uitest: testNodeAPIArray002 end');
      done();
    })

    /**
     * 点击按钮，调用napiGetProperty相关函数
     */
    it('testNodeAPIProperty003', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray003 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('3.napiGetProperty'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetPropertySuccess'));
      console.info('uitest: testNodeAPIArray003 end');
      done();
    })

    /**
     * 点击按钮，调用napiHasProperty相关函数
     */
    it('testNodeAPIProperty004', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray004 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('4.napiHasProperty'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiHasPropertySuccess'));
      console.info('uitest: testNodeAPIArray004 end');
      done();
    })

    /**
     * 点击按钮，调用napiDeleteProperty相关函数
     */
    it('testNodeAPIProperty005', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray005 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('5.napiDeleteProperty'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiDeletePropertySuccess'));
      console.info('uitest: testNodeAPIArray005 end');
      done();
    })

    /**
     * 点击按钮，调用napiHasOwnProperty相关函数
     */
    it('testNodeAPIProperty006', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray006 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('6.napiHasOwnProperty'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiHasOwnPropertySuccess'));
      console.info('uitest: testNodeAPIArray006 end');
      done();
    })

    /**
     * 点击按钮，调用napiSetNamedProperty相关函数
     */
    it('testNodeAPIProperty007', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray007 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('7.napiSetNamedProperty'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiSetNamedPropertySuccess'));
      console.info('uitest: testNodeAPIArray007 end');
      done();
    })

    /**
     * 点击按钮，调用napiGetNamedProperty相关函数
     */
    it('testNodeAPIProperty008', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray008 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('8.napiGetNamedProperty'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetNamedPropertySuccess'));
      console.info('uitest: testNodeAPIArray008 end');
      done();
    })

    /**
     * 点击按钮，调用napiHasNamedProperty相关函数
     */
    it('testNodeAPIProperty009', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray009 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('9.napiHasNamedProperty'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiHasNamedPropertySuccess'));
      console.info('uitest: testNodeAPIArray009 end');
      done();
    })

    /**
     * 点击按钮，调用napiDefineProperties相关函数
     */
    it('testNodeAPIProperty010', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray010 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('10.napiDefineProperties'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiDefinePropertiesSuccess'));
      console.info('uitest: testNodeAPIArray010 end');
      done();
    })

    /**
     * 点击按钮，调用napiGetAllPropertyNames相关函数
     */
    it('testNodeAPIProperty011', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray011 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const list = await driver.findComponent(ON.id('List'))
      await list.scrollToBottom();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('11.napiGetAllPropertyNames'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetAllPropertyNamesSuccess'));
      console.info('uitest: testNodeAPIArray011 end');
      done();
    })
  })
}