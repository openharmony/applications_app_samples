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

export default function nodeAPIFunctionTest() {
  describe('nodeAPIFunctionTest', () => {
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
     * 点击，调用napiGetCbInfo相关函数
     */
    it('testNodeAPIFunction001', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray001 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('1.napiGetCbInfo'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetCbInfoSuccess'));
      console.info('uitest: testNodeAPIArray001 end');
      done();
    })

    /**
     * 点击，调用napiCallFunction相关函数
     */
    it('testNodeAPIFunction002', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIFunction002 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('2.napiCallFunction'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCallFunctionSuccess'));
      console.info('uitest: testNodeAPIFunction002 end');
      done();
    })

    /**
     * 点击，调用napiCreateFunction相关函数
     */
    it('testNodeAPIFunction003', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIFunction003 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('3.napiCreateFunction'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateFunctionSuccess'));
      console.info('uitest: testNodeAPIFunction003 end');
      done();
    })
  })
}