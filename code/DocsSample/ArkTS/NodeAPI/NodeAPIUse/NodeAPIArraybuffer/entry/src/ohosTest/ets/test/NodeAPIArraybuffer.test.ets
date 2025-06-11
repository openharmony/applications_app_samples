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

export default function nodeAPIArraybufferTest() {
  describe('nodeAPIArraybufferTest', () => {
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
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * 点击按钮，调用napiIsArraybuffer相关函数
     */
    it('testNodeAPIArraybuffer001', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArraybuffer001 begin');
      const driver = Driver.create();
      const text = await driver.findComponent(ON.text('1.napiIsArraybuffer'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiIsArraybufferSuccess'));
      console.info('uitest: testNodeAPIArraybuffer001 end');
      done();
    })

    /**
     * 点击按钮，调用napiGetArraybufferInfo相关函数
     */
    it('testNodeAPIArraybuffer002', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArraybuffer002 begin');
      const driver = Driver.create();
      const text = await driver.findComponent(ON.text('2.napiGetArraybufferInfo'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiGetArraybufferInfoSuccess'));
      console.info('uitest: testNodeAPIArraybuffer002 end');
      done();
    })

    /**
     * 点击按钮，调用napiDetachArraybuffer相关函数
     */
    it('testNodeAPIArraybuffer003', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArraybuffer003 begin');
      const driver = Driver.create();
      const text = await driver.findComponent(ON.text('3.napiDetachArraybuffer'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiDetachArraybufferSuccess'));
      console.info('uitest: testNodeAPIArraybuffer003 end');
      done();
    })

    /**
     * 点击按钮，调用napiCreateArraybuffer相关函数
     */
    it('testNodeAPIArraybuffer004', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArraybuffer004 begin');
      const driver = Driver.create();
      const text = await driver.findComponent(ON.text('4.napiCreateArraybuffer'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateArraybufferSuccess'));
      console.info('uitest: testNodeAPIArraybuffer004 end');
      done();
    })
  })
}