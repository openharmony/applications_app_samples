/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

export default function KeyNegotiationTest() {
  describe('KeyNegotiationTest', () => {
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
     * 点击按钮，使用DH密钥协商，native方法
     */
    it('KeyNegotiationTest001', 0, async () => {
      console.info('uitest: KeyNegotiationTest001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call DH Key Agreement'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('DH Key Agreement Success'));
      console.info('uitest: KeyNegotiationTest001 end');
    })

    /**
     * 点击按钮，使用ECDH密钥协商，native方法
     */
    it('KeyNegotiationTest002', 0, async () => {
      console.info('uitest: KeyNegotiationTest002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call ECDH Key Agreement'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('ECDH Key Agreement Success'));
      console.info('uitest: KeyNegotiationTest002 end');
    })

    /**
     * 点击按钮，使用X25519密钥协商，native方法
     */
    it('KeyNegotiationTest003', 0, async () => {
      console.info('uitest: KeyNegotiationTest003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call X25519 Key Agreement'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('X25519 Key Agreement Success'));
      console.info('uitest: KeyNegotiationTest003 end');
    })
  })
}