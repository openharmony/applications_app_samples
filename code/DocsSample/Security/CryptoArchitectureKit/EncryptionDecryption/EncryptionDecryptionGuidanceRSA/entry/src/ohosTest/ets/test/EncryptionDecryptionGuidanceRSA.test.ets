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

export default function encryptionDecryptionGuidanceRSATest() {
  describe('encryptionDecryptionGuidanceRSATest', () => {
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
     * 点击按钮，使用RSA非对称密钥（PKCS1模式）加解密，异步方法
     */
    it('testEncryptionDecryptionGuidanceRSA001', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceRSA001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('RSA PKCS1 Async'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call RSA PKCS1 Async'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('RSA PKCS1 Async Success'));
      console.info('uitest: testEncryptionDecryptionGuidanceRSA001 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用RSA非对称密钥（PKCS1模式）加解密，同步方法
     */
    it('testEncryptionDecryptionGuidanceRSA002', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceRSA002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('RSA PKCS1 Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call RSA PKCS1 Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('RSA PKCS1 Sync Success'));
      console.info('uitest: testEncryptionDecryptionGuidanceRSA002 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用RSA非对称密钥分段加解密，异步方法
     */
    it('testEncryptionDecryptionGuidanceRSA003', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceRSA003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('RSA Segmentation Async'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call RSA Segmentation Async'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('RSA Segmentation Async Success'));
      console.info('uitest: testEncryptionDecryptionGuidanceRSA003 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用RSA非对称密钥分段加解密，同步方法
     */
    it('testEncryptionDecryptionGuidanceRSA004', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceRSA004 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('RSA Segmentation Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call RSA Segmentation Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('RSA Segmentation Sync Success'));
      console.info('uitest: testEncryptionDecryptionGuidanceRSA004 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用RSA非对称密钥（PKCS1_OAEP模式）加解密，异步方法
     */
    it('testEncryptionDecryptionGuidanceRSA005', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceRSA005 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('RSA PKCS1 OAEP Async'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call RSA PKCS1 OAEP Async'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('RSA PKCS1 OAEP Async Success'));
      console.info('uitest: testEncryptionDecryptionGuidanceRSA005 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用RSA非对称密钥（PKCS1_OAEP模式）加解密，同步方法
     */
    it('testEncryptionDecryptionGuidanceRSA006', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceRSA006 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('RSA PKCS1 OAEP Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call RSA PKCS1 OAEP Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('RSA PKCS1 OAEP Sync Success'));
      console.info('uitest: testEncryptionDecryptionGuidanceRSA006 end');
      await driver.pressBack();
    })
  })
}