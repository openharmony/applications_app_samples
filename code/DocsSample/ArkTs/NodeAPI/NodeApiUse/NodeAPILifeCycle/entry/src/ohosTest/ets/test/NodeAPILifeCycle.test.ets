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

export default function nodeAPILifeCycleTest() {
  describe('nodeAPILifeCycleTest', () => {
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
     * 点击按钮，调用napiOpenHandleScope相关函数
     */
    it('testNodeAPILifeCycle001', 0, async (done: Function) => {
      console.info('uitest: testNodeAPILifeCycle001 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('1.napiOpenHandleScope'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiOpenHandleScopeSuccess'));
      console.info('uitest: testNodeAPILifeCycle001 end');
      done();
    })

    /**
     * 点击按钮，调用napiOpenEscapableHandleScope相关函数
     */
    it('testNodeAPILifeCycle002', 0, async (done: Function) => {
      console.info('uitest: testNodeAPILifeCycle002 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('2.napiOpenEscapableHandleScope'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiOpenEscapableHandleScopeSuccess'));
      console.info('uitest: testNodeAPILifeCycle002 end');
      done();
    })

    /**
     * 点击按钮，调用napiAddFinalizer相关函数
     */
    it('testNodeAPILifeCycle003', 0, async (done: Function) => {
      console.info('uitest: testNodeAPILifeCycle003 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('3.napiAddFinalizer'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiAddFinalizerSuccess'));
      console.info('uitest: testNodeAPILifeCycle003 end');
      done();
    })
  })
}