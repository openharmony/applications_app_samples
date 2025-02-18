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

export default function randomlyGenerateSymmetricKeyArkTSTest() {
  describe('randomlyGenerateSymmetricKeyArkTSTest', () => {
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
     * 点击按钮，随机生成对称密钥(AES Promise方式)
     */
    it('testRandomlyGenerateSymmetricKeyArkTS001', 0, async () => {
      console.info('uitest: testRandomlyGenerateSymmetricKeyArkTS001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('AES Promise'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call AES Promise'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('AES Promise Success'));
      console.info('uitest: testRandomlyGenerateSymmetricKeyArkTS001 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，随机生成对称密钥(AES 同步方式)
     */
    it('testRandomlyGenerateSymmetricKeyArkTS002', 0, async () => {
      console.info('uitest: testRandomlyGenerateSymmetricKeyArkTS002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('AES Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call AES Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('AES Sync Success'));
      console.info('uitest: testRandomlyGenerateSymmetricKeyArkTS002 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，随机生成对称密钥(SM4 Promise方式)
     */
    it('testRandomlyGenerateSymmetricKeyArkTS003', 0, async () => {
      console.info('uitest: testRandomlyGenerateSymmetricKeyArkTS003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('SM4 Promise'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SM4 Promise'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM4 Promise Success'));
      console.info('uitest: testRandomlyGenerateSymmetricKeyArkTS003 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，随机生成对称密钥(SM4 同步方式)
     */
    it('testRandomlyGenerateSymmetricKeyArkTS004', 0, async () => {
      console.info('uitest: testRandomlyGenerateSymmetricKeyArkTS004 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('SM4 Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SM4 Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM4 Sync Success'));
      console.info('uitest: testRandomlyGenerateSymmetricKeyArkTS004 end');
      await driver.pressBack();
    })
  })
}