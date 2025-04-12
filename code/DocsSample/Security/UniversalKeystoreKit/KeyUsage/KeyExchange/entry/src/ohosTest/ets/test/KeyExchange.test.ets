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

export default function keyExchangeTest() {
  describe('keyExchangeTest', () => {
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
     * 点击按钮，X25519非对称密钥协商
     */
    it('testKeyExchange001', 0, async () => {
      console.info('uitest: testKeyExchange001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('X25519'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('X25519').type('Button'));
      await button2.click();
      await driver.delayMs(3500);
      await driver.assertComponentExist(ON.text('X25519 Result: Success'));
      console.info('uitest: testKeyExchange001 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，DH密钥协商
     */
    it('testKeyExchange002', 0, async () => {
      console.info('uitest: testKeyExchange002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('DH'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('DH').type('Button'));
      await button2.click();
      await driver.delayMs(3500);
      await driver.assertComponentExist(ON.text('DH Result: Success'));
      console.info('uitest: testKeyExchange002 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，密钥协商(C/C++)
     */
    it('testKeyExchange003', 0, async () => {
      console.info('uitest: testKeyExchange003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call C/C++'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call C/C++ Result: 0'));
      console.info('uitest: testKeyExchange003 end');
      await driver.pressBack();
    })
  })
}