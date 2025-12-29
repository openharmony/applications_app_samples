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

export default function encryptionDecryptionGuidanceChaCha20ArkTsTest() {
  describe('encryptionDecryptionGuidanceChaCha20ArkTsTest', () => {
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
     * 点击按钮，使用ChaCha20加解密(ArkTS)，异步方法
     */
    it('testEncryptionDecryptionGuidanceChaCha20ArkTs001', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceChaCha20ArkTs001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('ChaCha20 Async'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call ChaCha20 Async'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('ChaCha20 Async Success'));
      console.info('uitest: testEncryptionDecryptionGuidanceChaCha20ArkTs001 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用ChaCha20加解密(ArkTS)，同步方法
     */
    it('testEncryptionDecryptionGuidanceChaCha20ArkTs002', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceChaCha20ArkTs002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('ChaCha20 Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call ChaCha20 Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('ChaCha20 Sync Success'));
      console.info('uitest: testEncryptionDecryptionGuidanceChaCha20ArkTs002 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用ChaCha20 Poly1305加解密(ArkTS)，同步方法
     */
    it('testEncryptionDecryptionGuidanceChaCha20ArkTs003', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceChaCha20ArkTs003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('ChaCha20 Poly1305 Async'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call ChaCha20 Poly1305 Async'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('ChaCha20 Poly1305 Async Success'));
      console.info('uitest: testEncryptionDecryptionGuidanceChaCha20ArkTs003 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用ChaCha20 Poly1305加解密(ArkTS)，同步方法
     */
    it('testEncryptionDecryptionGuidanceChaCha20ArkTs004', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceChaCha20ArkTs004 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('ChaCha20 Poly1305 Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call ChaCha20 Poly1305 Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('ChaCha20 Poly1305 Sync Success'));
      console.info('uitest: testEncryptionDecryptionGuidanceChaCha20ArkTs004 end');
      await driver.pressBack();
    })
    /**
     * 点击按钮，使用ChaCha20 C++
     */
    it('testEncryptionDecryptionGuidanceChaCha20ArkTs005', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceChaCha20ArkTs005 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('ChaCha20 CppTest'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call ChaCha20 CppTest'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('ChaCha20 CppTest Success'));
      await driver.delayMs(1000);
      const button3 = await driver.findComponent(ON.text('Call ChaCha20 Poly1305 CppTest'));
      await button3.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('ChaCha20 Poly1305 CppTest Success'));
      console.info('uitest: testEncryptionDecryptionGuidanceChaCha20ArkTs005 end');
      await driver.pressBack();
    })
  })
}