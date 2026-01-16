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

export default function PrikeyOperationTest() {
  describe('PrikeyOperationTest', () => {
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
     * 点击按钮，私钥获取公钥对象(C/C++)
     */
    it('PrikeyOperationTest001', 0, async () => {
      console.info('uitest: PrikeyOperationTest001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Get PubKey From Prikey'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Get Pubkey From Prikey Success'));
      console.info('uitest: PrikeyOperationTest001 end');
    })

    /**
     * 点击按钮，私钥编码(C/C++)
     */
    it('PrikeyOperationTest002', 0, async () => {
      console.info('uitest: PrikeyOperationTest002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Prikey Encoding'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Prikey Encoding Success'));
      console.info('uitest: PrikeyOperationTest002 end');
    })
    /**
     * 点击按钮，私钥解码(C/C++)
     */
    it('PrikeyOperationTest003', 0, async () => {
      console.info('uitest: PrikeyOperationTest003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Prikey Decoding'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Prikey Decoding Success'));
      console.info('uitest: PrikeyOperationTest003 end');
      await driver.pressBack();
    })
    /**
     * 点击按钮，私钥获取公钥对象(ArkTS 异步方式)
     */
    it('PrikeyOperationTest004', 0, async () => {
      console.info('uitest: PrikeyOperationTest004 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Prikey Get Pubkey Async'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call Prikey Get Pubkey Async'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Prikey Get Pubkey Async Success'));
      console.info('uitest: PrikeyOperationTest004 end');
      await driver.pressBack();
    })
    /**
     * 点击按钮，私钥获取公钥对象(ArkTS 同步方式)
     */
    it('PrikeyOperationTest005', 0, async () => {
      console.info('uitest: PrikeyOperationTest005 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Prikey Get Pubkey Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call Prikey Get Pubkey Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Prikey Get Pubkey Sync Success'));
      console.info('uitest: PrikeyOperationTest005 end');
      await driver.pressBack();
    })
    /**
     * 点击按钮，私钥编码(ArkTS)
     */
    it('PrikeyOperationTest006', 0, async () => {
      console.info('uitest: PrikeyOperationTest006 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Prikey Encoding'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call Prikey Encoding'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Prikey Encoding Success'));
      console.info('uitest: PrikeyOperationTest006 end');
      await driver.pressBack();
    })
    /**
     * 点击按钮，私钥解码(ArkTS)
     */
    it('PrikeyOperationTest007', 0, async () => {
      console.info('uitest: PrikeyOperationTest007 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Prikey Decoding'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call Prikey Decoding'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Prikey Decoding Success'));
      console.info('uitest: PrikeyOperationTest007 end');
      await driver.pressBack();
    })
  })
}