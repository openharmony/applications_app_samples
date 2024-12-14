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

export default function nodeApiApplicationScenarioTest() {
  describe('nodeApiApplicationScenarioTest', () => {
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
     * 点击按钮，调用createArkRuntime相关函数
     */
    it('testNodeApiArkTSRuntime001', 0, async (done: Function) => {
      console.info('uitest: testNodeApiArkTSRuntime001 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button = await driver.findComponent(ON.text('Call createArkRuntime'));
      await driver.delayMs(1000);
      await button.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('ArkRuntime success'));
      console.info('uitest: testNodeApiArkTSRuntime001 end');
      done();
    })

    /**
     * 点击按钮，调用runEventLoop相关函数
     */
    it('testNodeAPIEventLoop001', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIEventLoop001 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button = await driver.findComponent(ON.text('Call runEventLoop'));
      await driver.delayMs(1000);
      await button.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('EventLoop success'));
      console.info('uitest: testNodeAPIEventLoop001 end');
      done();
    })

    /**
     * 点击按钮，调用CallThreadSafeWithPriority相关函数
     */
    it('testNodeAPICallThreadsafeFunctionWithPriority001', 0, async (done: Function) => {
      console.info('uitest: testNodeAPICallThreadsafeFunctionWithPriority001 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button = await driver.findComponent(ON.text('Call CallThreadSafeWithPriority'));
      await driver.delayMs(1000);
      await button.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('ThreadSafeWithPriority success'));
      console.info('uitest: testNodeAPIArray001 end');
      done();
    })

    /**
     * 点击按钮，调用startThread相关函数
     */
    it('testNodeAPIThreadSafety001', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIThreadSafety001 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button = await driver.findComponent(ON.text('Call startThread'));
      await driver.delayMs(1000);
      await button.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('StartThread success'));
      console.info('uitest: testNodeAPIThreadSafety001 end');
      done();
    })
  })
}