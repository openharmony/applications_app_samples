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

export default function encryptionDecryptionGuidanceAesArkTsTest() {
  describe('encryptionDecryptionGuidanceAesArkTsTest', () => {
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
     * 点击按钮，使用AES对称密钥（GCM模式）加解密(ArkTS)，异步方法
     */
    it('testEncryptionDecryptionGuidanceAesArkTs001', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceAesArkTs001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('aes_gcm_encryption_decryption_asynchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call AES_GCM Asynchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('AES_GCMAsynchronousSuccess'));
      console.info('uitest: testEncryptionDecryptionGuidanceAesArkTs001 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用AES对称密钥（GCM模式）加解密(ArkTS)，同步方法
     */
    it('testEncryptionDecryptionGuidanceAesArkTs002', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceAesArkTs002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('aes_gcm_encryption_decryption_synchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call AES_GCM Synchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('AES_GCMSynchronousSuccess'));
      console.info('uitest: testEncryptionDecryptionGuidanceAesArkTs002 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用AES对称密钥（CCM模式）加解密(ArkTS)，异步方法
     */
    it('testEncryptionDecryptionGuidanceAesArkTs003', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceAesArkTs003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('aes_ccm_encryption_decryption_asynchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call AES_CCM Asynchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('AES_CCMAsynchronousSuccess'));
      console.info('uitest: testEncryptionDecryptionGuidanceAesArkTs003 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用AES对称密钥（CCM模式）加解密(ArkTS)，同步方法
     */
    it('testEncryptionDecryptionGuidanceAesArkTs004', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceAesArkTs004 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('aes_ccm_encryption_decryption_synchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call AES_CCM Synchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('AES_CCMSynchronousSuccess'));
      console.info('uitest: testEncryptionDecryptionGuidanceAesArkTs004 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用AES对称密钥（CBC模式）加解密(ArkTS)，异步方法
     */
    it('testEncryptionDecryptionGuidanceAesArkTs005', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceAesArkTs005 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('aes_cbc_encryption_decryption_asynchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call AES_CBC Asynchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('AES_CBCAsynchronousSuccess'));
      console.info('uitest: testEncryptionDecryptionGuidanceAesArkTs005 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用AES对称密钥（CBC模式）加解密(ArkTS)，同步方法
     */
    it('testEncryptionDecryptionGuidanceAesArkTs006', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceAesArkTs006 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('aes_cbc_encryption_decryption_synchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call AES_CBC Synchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('AES_CBCSynchronousSuccess'));
      console.info('uitest: testEncryptionDecryptionGuidanceAesArkTs006 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用AES对称密钥（ECB模式）加解密(ArkTS)，异步方法
     */
    it('testEncryptionDecryptionGuidanceAesArkTs007', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceAesArkTs007 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('aes_ecb_encryption_decryption_asynchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call AES_ECB Asynchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('AES_ECBAsynchronousSuccess'));
      console.info('uitest: testEncryptionDecryptionGuidanceAesArkTs007 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用AES对称密钥（ECB模式）加解密(ArkTS)，同步方法
     */
    it('testEncryptionDecryptionGuidanceAesArkTs008', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceAesArkTs008 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('aes_ecb_encryption_decryption_synchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call AES_ECB Synchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('AES_ECBSynchronousSuccess'));
      console.info('uitest: testEncryptionDecryptionGuidanceAesArkTs008 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用AES对称密钥（GCM模式）分段加解密(ArkTS)，异步方法
     */
    it('testEncryptionDecryptionGuidanceAesArkTs009', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceAesArkTs009 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('aes_gcm_seg_encryption_decryption_asynchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call AES_GCM segmentation Asynchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('AES_GCMAsynchronousSuccess'));
      console.info('uitest: testEncryptionDecryptionGuidanceAesArkTs009 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用AES对称密钥（GCM模式）分段加解密(ArkTS)，同步方法
     */
    it('testEncryptionDecryptionGuidanceAesArkTs010', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceAesArkTs010 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('aes_gcm_seg_encryption_decryption_synchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call AES_GCM segmentation Synchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('AES_GCMSynchronousSuccess'));
      console.info('uitest: testEncryptionDecryptionGuidanceAesArkTs010 end');
      await driver.pressBack();
    })
  })
}