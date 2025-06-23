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

export default function nodeAPIErrorTest() {
  describe('nodeAPIErrorTest', () => {
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
     * 点击按钮，调用napiGetLastErrorInfo相关函数
     */
    it('testNodeAPIError001', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIError001 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('1.napiGetLastErrorInfo'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetLastErrorInfoSuccess'));
      console.info('uitest: testNodeAPIError001 end');
      done();
    })

    /**
     * 点击按钮，调用napiCreateTypeError相关函数
     */
    it('testNodeAPIError002', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIError002 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('2.napiCreateTypeError'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateTypeErrorFail'));
      console.info('uitest: testNodeAPIError002 end');
      done();
    })

    /**
     * 点击按钮，调用napiCreateRangeError相关函数
     */
    it('testNodeAPIError003', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIError003 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('3.napiCreateRangeError'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateRangeErrorFail'));
      console.info('uitest: testNodeAPIError003 end');
      done();
    })

    /**
     * 点击按钮，调用napiCreateErrorAndNapiThrow相关函数
     */
    it('testNodeAPIError004', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIError004 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('4.napiCreateErrorAndNapiThrow'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateErrorAndNapiThrowFail'));
      console.info('uitest: testNodeAPIError004 end');
      done();
    })

    /**
     * 点击按钮，调用napiThrowError相关函数
     */
    it('testNodeAPIError005', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIError005 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('5.napiThrowError'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiThrowErrorFail'));
      console.info('uitest: testNodeAPIError005 end');
      done();
    })

    /**
     * 点击按钮，调用napiThrowTypeError相关函数
     */
    it('testNodeAPIError006', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIError006 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('6.napiThrowTypeError'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: throwTypeErrorFail'));
      console.info('uitest: testNodeAPIError006 end');
      done();
    })

    /**
     * 点击按钮，调用napiThrowRangeError相关函数
     */
    it('testNodeAPIError007', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIError007 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('7.napiThrowRangeError'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: throwRangeErrorFail'));
      console.info('uitest: testNodeAPIError007 end');
      done();
    })

    /**
     * 点击按钮，调用napiIsError相关函数
     */
    it('testNodeAPIError008', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIError008 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('8.napiIsError'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiIsErrorFail'));
      console.info('uitest: testNodeAPIError008 end');
      done();
    })

    /**
     * 点击按钮，调用napiGetAndClearLastException相关函数
     */
    it('testNodeAPIError009', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIError009 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('9.napiGetAndClearLastException'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetAndClearLastExceptionSuccess'));
      console.info('uitest: testNodeAPIError009 end');
      done();
    })

    /**
     * 点击按钮，调用napiIsExceptionPending相关函数
     */
    it('testNodeAPIError010', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIError010 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('10.napiIsExceptionPending'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiIsExceptionPendingSuccess'));
      console.info('uitest: testNodeAPIError010 end');
      done();
    })
  })
}