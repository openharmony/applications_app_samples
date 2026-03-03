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

export default function encryptionDecryptionGuidanceArkTsTest() {
  describe('encryptionDecryptionGuidanceArkTsTest', () => {
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
     * 点击按钮，使用RC2对称密钥（CBC模式）加解密(ArkTS)，异步方法
     */
    it('testEncryptionDecryptionGuidanceArkTs001', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceArkTs001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('rc2_cbc_encryption_decryption_asynchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call RC2_CBC Asynchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('RC2_CBCAsynchronousSuccess'));
      console.info('uitest: testEncryptionDecryptionGuidanceArkTs001 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用RC2对称密钥（CBC模式）加解密(ArkTS)，同步方法
     */
    it('testEncryptionDecryptionGuidanceArkTs002', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceArkTs002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('rc2_cbc_encryption_decryption_synchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call RC2_CBC Synchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('RC2_CBCSynchronousSuccess'));
      console.info('uitest: testEncryptionDecryptionGuidanceArkTs002 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用RC4对称密钥加解密(ArkTS)，异步方法
     */
    it('testEncryptionDecryptionGuidanceArkTs003', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceArkTs003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('rc4_encryption_decryption_asynchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call RC4_EncryptionDecryption Asynchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('RC4_EncryptionDecryptionAsynchronousSuccess'));
      console.info('uitest: testEncryptionDecryptionGuidanceArkTs003 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用RC4对称密钥加解密(ArkTS)，同步方法
     */
    it('testEncryptionDecryptionGuidanceArkTs004', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceArkTs004 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('rc4_encryption_decryption_synchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call RC4_EncryptionDecryption Synchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('RC4_EncryptionDecryptionSynchronousSuccess'));
      console.info('uitest: testEncryptionDecryptionGuidanceArkTs004 end');
      await driver.pressBack();
    })
  })
}