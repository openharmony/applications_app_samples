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

export default function encryptionDecryptionTest() {
  describe('encryptionDecryptionTest', () => {
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
     * 点击按钮，加解密AES/CBC/PKCS7
     */
    it('testEncryptionDecryption001', 0, async () => {
      console.info('uitest: testEncryptionDecryption001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('AES/CBC/PKCS7'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call AES/CBC/PKCS7'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('AES/CBC/PKCS7 Result: Success'));
      console.info('uitest: testEncryptionDecryption001 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，加解密AES/GCM/NoPadding
     */
    it('testEncryptionDecryption002', 0, async () => {
      console.info('uitest: testEncryptionDecryption002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('AES/GCM/NoPadding'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call AES/GCM/NoPadding'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('AES/GCM/NoPadding Result: Success'));
      console.info('uitest: testEncryptionDecryption002 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，加解密RSA/ECB/PKCS1_V1_5
     */
    it('testEncryptionDecryption003', 0, async () => {
      console.info('uitest: testEncryptionDecryption003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('RSA/ECB/PKCS1_V1_5'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call RSA/ECB/PKCS1_V1_5'));
      await button2.click();
      await driver.delayMs(3500);
      await driver.assertComponentExist(ON.text('RSA/ECB/PKCS1_V1_5 Result: Success'));
      console.info('uitest: testEncryptionDecryption003 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，加解密RSA/ECB/OAEP/SHA256
     */
    it('testEncryptionDecryption004', 0, async () => {
      console.info('uitest: testEncryptionDecryption004 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('RSA/ECB/OAEP/SHA256'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call RSA/ECB/OAEP/SHA256'));
      await button2.click();
      await driver.delayMs(3500);
      await driver.assertComponentExist(ON.text('RSA/ECB/OAEP/SHA256 Result: Success'));
      console.info('uitest: testEncryptionDecryption004 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，加解密SM2
     */
    it('testEncryptionDecryption005', 0, async () => {
      console.info('uitest: testEncryptionDecryption005 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('SM2'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SM2'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM2 Result: Success'));
      console.info('uitest: testEncryptionDecryption005 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，加解密C/C++
     */
    it('testEncryptionDecryption006', 0, async () => {
      console.info('uitest: testEncryptionDecryption006 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call C/C++'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call C/C++ Result: 0'));
      console.info('uitest: testEncryptionDecryption006 end');
      await driver.pressBack();
    })
  })
}