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

export default function nodeAPIObjectTest() {
  describe('nodeAPIObjectTest', () => {
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
     * 点击按钮，调用napiGetPrototype相关函数
     */
    it('testNodeAPIObject001', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIObject001 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('1.napiGetPrototype'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetPrototypeSuccess'));
      console.info('uitest: testNodeAPIObject001 end');
      done();
    })

    /**
     * 点击按钮，调用napiCreateObject相关函数
     */
    it('testNodeAPIObject002', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIObject002 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('2.napiCreateObject'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateObjectSuccess'));
      console.info('uitest: testNodeAPIObject002 end');
      done();
    })

    /**
     * 点击按钮，调用napiObjectFreeze相关函数
     */
    it('testNodeAPIObject003', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIObject003 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('3.napiObjectFreeze'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiObjectFreezeFail'));
      console.info('uitest: testNodeAPIObject003 end');
      done();
    })

    /**
     * 点击按钮，调用napiObjectSeal相关函数
     */
    it('testNodeAPIObject004', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIObject004 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('4.napiObjectSeal'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiObjectSealFail'));
      console.info('uitest: testNodeAPIObject004 end');
      done();
    })

    /**
     * 点击按钮，调用napiTypeof相关函数
     */
    it('testNodeAPIObject005', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIObject005 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('5.napiTypeof'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiTypeofSuccess'));
      console.info('uitest: testNodeAPIObject005 end');
      done();
    })

    /**
     * 点击按钮，调用napiInstanceof相关函数
     */
    it('testNodeAPIObject006', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIObject006 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('6.napiInstanceof'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiInstanceofSuccess'));
      console.info('uitest: testNodeAPIObject006 end');
      done();
    })

    /**
     * 点击按钮，调用napiTypeTagObject相关函数
     */
    it('testNodeAPIObject007', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIObject007 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('7.napiTypeTagObject'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiTypeTagObjectSuccess'));
      console.info('uitest: testNodeAPIObject007 end');
      done();
    })

    /**
     * 点击按钮，调用napiCreateExternal相关函数
     */
    it('testNodeAPIObject008', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIObject008 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('8.napiCreateExternal'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateExternalSuccess'));
      console.info('uitest: testNodeAPIObject008 end');
      done();
    })

    /**
     * 点击按钮，调用napiGetValueExternal相关函数
     */
    it('testNodeAPIObject009', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIObject009 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('9.napiGetValueExternal'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetValueExternalSuccess'));
      console.info('uitest: testNodeAPIObject009 end');
      done();
    })

    /**
     * 点击按钮，调用napiCreateSymbol相关函数
     */
    it('testNodeAPIObject010', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIObject010 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('10.napiCreateSymbol'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateSymbolSuccess'));
      console.info('uitest: testNodeAPIObject010 end');
      done();
    })
  })
}