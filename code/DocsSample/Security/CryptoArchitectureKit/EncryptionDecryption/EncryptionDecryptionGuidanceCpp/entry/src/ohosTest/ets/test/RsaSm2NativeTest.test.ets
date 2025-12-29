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

export default function AsymKeyEncryptTest() {
  describe('AsymKeyEncryptTest', () => {
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
     * 点击按钮，使用SM2非对称密钥加密解密，native方法
     */
    it('AsymKeyEncryptTest001', 0, async () => {
      console.info('uitest: AsymKeyEncryptTest001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call SM2_EncryptDecrypt'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM2 Encrypt Decrypt Success'));
      console.info('uitest: AsymKeyEncryptTest001 end');
    })

    /**
     * 点击按钮，使用SM2非对称密钥加密解密，native方法
     */
    it('AsymKeyEncryptTest002', 0, async () => {
      console.info('uitest: AsymKeyEncryptTest002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call CreateASN1CipherText'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM2 Gen Cipher Text Success'));
      console.info('uitest: AsymKeyEncryptTest002 end');
    })

    /**
     * 点击按钮，使用SM2非对称密钥加密解密，native方法
     */
    it('AsymKeyEncryptTest003', 0, async () => {
      console.info('uitest: AsymKeyEncryptTest003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call ObtainCipherText'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM2 Get Cipher Text Success'));
      console.info('uitest: AsymKeyEncryptTest003 end');
    })
    /**
     * 点击按钮，使用RSA非对称密钥加密解密，native方法
     */
    it('AsymKeyEncryptTest004', 0, async () => {
      console.info('uitest: AsymKeyEncryptTest004 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call PKCS1 RSA'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('RSA Encrypt Decrypt Success'));
      console.info('uitest: AsymKeyEncryptTest004 end');
    })

    /**
     * 点击按钮，使用RSA非对称密钥加密解密，native方法
     */
    it('AsymKeyEncryptTest005', 0, async () => {
      console.info('uitest: AsymKeyEncryptTest005 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call RSA Encrypt'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('RSA Encrypt Long Message Success'));
      console.info('uitest: AsymKeyEncryptTest005 end');
      await driver.pressBack();
    })
  })
}