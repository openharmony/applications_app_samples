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

export default function nodeAPIArrayTest() {
  describe('nodeAPIArrayTest', () => {
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
     * 点击按钮，调用napiCreateArray相关函数
     */
    it('testNodeAPIArray001', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray001 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('1.napiCreateArray'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateArraySuccess'));
      console.info('uitest: testNodeAPIArray001 end');
      done();
    })

    /**
     * 点击按钮，调用napiCreateArrayWithLength相关函数
     */
    it('testNodeAPIArray002', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray002 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('2.napiCreateArrayWithLength'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateArrayWithLengthSuccess'));
      console.info('uitest: testNodeAPIArray002 end');
      done();
    })

    /**
     * 点击按钮，调用napiGetArrayLength相关函数
     */
    it('testNodeAPIArray003', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray003 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('3.napiGetArrayLength'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetArrayLengthSuccess'));
      console.info('uitest: testNodeAPIArray003 end');
      done();
    })

    /**
     * 点击按钮，调用napiIsArray相关函数
     */
    it('testNodeAPIArray004', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray004 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('4.napiIsArray'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiIsArraySuccess'));
      console.info('uitest: testNodeAPIArray004 end');
      done();
    })

    /**
     * 点击按钮，调用napiSetElement相关函数
     */
    it('testNodeAPIArray005', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray005 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('5.napiSetElement'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiSetElementSuccess'));
      console.info('uitest: testNodeAPIArray005 end');
      done();
    })

    /**
     * 点击按钮，调用napiGetElement相关函数
     */
    it('testNodeAPIArray006', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray006 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('6.napiGetElement'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetElementSuccess'));
      console.info('uitest: testNodeAPIArray006 end');
      done();
    })

    /**
     * 点击按钮，调用napiHasElement相关函数
     */
    it('testNodeAPIArray007', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray007 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('7.napiHasElement'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiHasElementSuccess'));
      console.info('uitest: testNodeAPIArray007 end');
      done();
    })

    /**
     * 点击按钮，调用napiDeleteElement相关函数
     */
    it('testNodeAPIArray008', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray008 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('8.napiDeleteElement'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiDeleteElementSuccess'));
      console.info('uitest: testNodeAPIArray008 end');
      done();
    })

    /**
     * 点击按钮，调用napiCreateTypedArray相关函数
     */
    it('testNodeAPIArray009', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray009 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('9.napiCreateTypedArray'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateUint8ArraySuccess'));
      console.info('uitest: testNodeAPIArray009 end');
      done();
    })

    /**
     * 点击按钮，调用napiIsTypedArray相关函数
     */
    it('testNodeAPIArray010', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray010 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const list = await driver.findComponent(ON.id('List'))
      await list.scrollToBottom();
      const text = await driver.findComponent(ON.text('10.napiIsTypedArray'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiIsTypedArraySuccess'));
      console.info('uitest: testNodeAPIArray010 end');
      done();
    })

    /**
     * 点击按钮，调用napiGetTypedArrayInfo相关函数
     */
    it('testNodeAPIArray011', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray011 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('11.napiGetTypedArrayInfo'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetTypedArrayInfoSuccess'));
      console.info('uitest: testNodeAPIArray011 end');
      done();
    })

    /**
     * 点击按钮，调用napiCreateDataView相关函数
     */
    it('testNodeAPIArray012', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray012 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('12.napiCreateDataView'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateDataViewSuccess'));
      console.info('uitest: testNodeAPIArray012 end');
      done();
    })

    /**
     * 点击按钮，调用napiIsDataView相关函数
     */
    it('testNodeAPIArray013', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray013 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('13.napiIsDataView'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiIsDataViewSuccess'));
      console.info('uitest: testNodeAPIArray013 end');
      done();
    })

    /**
     * 点击按钮，调用napiGetDataViewInfo相关函数
     */
    it('testNodeAPIArray014', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray014 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('14.napiGetDataViewInfo'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetDataViewInfoSuccess'));
      console.info('uitest: testNodeAPIArray014 end');
      done();
    })
  })
}