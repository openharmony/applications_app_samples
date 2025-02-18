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

export default function keyNegotiationTest() {
  describe('keyNegotiationTest', () => {
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
     * 点击按钮，使用ECDH进行密钥协商(await方式)
     */
    it('testKeyNegotiation001', 0, async () => {
      console.info('uitest: testKeyNegotiation001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('ECDH Async'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call EDCH Async'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('EDCH Async Success'));
      console.info('uitest: testKeyNegotiation001 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用ECDH进行密钥协商(同步方式)
     */
    it('testKeyNegotiation002', 0, async () => {
      console.info('uitest: testKeyNegotiation002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('ECDH Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call EDCH Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('EDCH Sync Success'));
      console.info('uitest: testKeyNegotiation002 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用X25519进行密钥协商(await方式)
     */
    it('testKeyNegotiation003', 0, async () => {
      console.info('uitest: testKeyNegotiation003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('X25519 Async'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call X25519 Async'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('X25519 Async Success'));
      console.info('uitest: testKeyNegotiation003 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用X25519进行密钥协商(同步方式)
     */
    it('testKeyNegotiation004', 0, async () => {
      console.info('uitest: testKeyNegotiation004 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('X25519 Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call X25519 Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('X25519 Sync Success'));
      console.info('uitest: testKeyNegotiation004 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用DH进行密钥协商(await方式)
     */
    it('testKeyNegotiation005', 0, async () => {
      console.info('uitest: testKeyNegotiation005 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('DH Async'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call DH Async'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('DH Async Success'));
      console.info('uitest: testKeyNegotiation005 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用DH进行密钥协商(同步方式)
     */
    it('testKeyNegotiation006', 0, async () => {
      console.info('uitest: testKeyNegotiation006 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('DH Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call DH Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('DH Sync Success'));
      console.info('uitest: testKeyNegotiation006 end');
      await driver.pressBack();
    })
  })
}