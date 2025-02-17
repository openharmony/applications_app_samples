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

export default function encryptionDecryptionGuidance3DESArkTsTest() {
  describe('encryptionDecryptionGuidance3DESArkTsTest', () => {
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
     * 点击按钮，使用SM4对称密钥（ECB模式）加解密(ArkTS)，异步方法
     */
    it('testEncryptionDecryptionGuidance3DESArkTs001', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidance3DESArkTs001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('sm4_cbc_encryption_decryption_asynchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SM4_CBC Asynchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM4_CBCSuccess'));
      console.info('uitest: testEncryptionDecryptionGuidance3DESArkTs001 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用SM4对称密钥（ECB模式）加解密(ArkTS)，同步方法
     */
    it('testEncryptionDecryptionGuidance3DESArkTs002', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidance3DESArkTs002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('sm4_cbc_encryption_decryption_synchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SM4_CBC Synchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM4_CBCSuccess'));
      console.info('uitest: testEncryptionDecryptionGuidance3DESArkTs002 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用SM4对称密钥（CBC模式）加解密(ArkTS)，异步方法
     */
    it('testEncryptionDecryptionGuidance3DESArkTs003', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidance3DESArkTs003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('sm4_ecb_encryption_decryption_asynchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SM4_ECB Asynchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM4_ECBSuccess'));
      console.info('uitest: testEncryptionDecryptionGuidance3DESArkTs003 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用SM4对称密钥（CBC模式）加解密(ArkTS)，同步方法
     */
    it('testEncryptionDecryptionGuidance3DESArkTs004', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidance3DESArkTs004 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('sm4_ecb_encryption_decryption_synchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SM4_ECB Synchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM4_ECBSuccess'));
      console.info('uitest: testEncryptionDecryptionGuidance3DESArkTs004 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用SM4对称密钥（GCM模式）加解密(ArkTS)，异步方法
     */
    it('testEncryptionDecryptionGuidance3DESArkTs005', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidance3DESArkTs005 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('sm4_gcm_encryption_decryption_asynchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SM4_GCM Asynchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM4_GCMSuccess'));
      console.info('uitest: testEncryptionDecryptionGuidance3DESArkTs005 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用SM4对称密钥（GCM模式）加解密(ArkTS)，同步方法
     */
    it('testEncryptionDecryptionGuidance3DESArkTs006', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidance3DESArkTs006 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('sm4_gcm_encryption_decryption_synchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SM4_GCM Synchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM4_GCMSuccess'));
      console.info('uitest: testEncryptionDecryptionGuidance3DESArkTs006 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用SM4对称密钥（GCM模式）分段加解密(ArkTS)，异步方法
     */
    it('testEncryptionDecryptionGuidance3DESArkTs007', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidance3DESArkTs007 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('sm4_gcm_seg_encryption_decryption_asynchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SM4_GCM Segmentation Asynchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM4_GCMSegmentationSuccess'));
      console.info('uitest: testEncryptionDecryptionGuidance3DESArkTs007 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用SM4对称密钥（GCM模式）分段加解密(ArkTS)，同步方法
     */
    it('testEncryptionDecryptionGuidance3DESArkTs008', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidance3DESArkTs008 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('sm4_gcm_seg_encryption_decryption_synchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SM4_GCM Segmentation Synchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM4_GCMSegmentationSuccess'));
      console.info('uitest: testEncryptionDecryptionGuidance3DESArkTs008 end');
      await driver.pressBack();
    })
  })
}