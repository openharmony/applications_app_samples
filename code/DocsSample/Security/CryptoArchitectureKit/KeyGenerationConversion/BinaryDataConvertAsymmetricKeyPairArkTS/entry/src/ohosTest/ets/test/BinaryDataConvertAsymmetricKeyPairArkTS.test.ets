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

export default function binaryDataConvertAsymmetricKeyPairArkTSTest() {
  describe('binaryDataConvertAsymmetricKeyPairArkTSTest', () => {
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
     * 点击按钮，指定二进制数据转换ECC密钥对
     */
    it('testBinaryDataConvertAsymmetricKeyPairArkTS001', 0, async () => {
      console.info('uitest: testBinaryDataConvertAsymmetricKeyPairArkTS001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('ECC Callback'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call ECC Callback'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('ECC Callback Success'));
      console.info('uitest: testBinaryDataConvertAsymmetricKeyPairArkTS001 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，指定二进制数据转换ECC密钥对
     */
    it('testBinaryDataConvertAsymmetricKeyPairArkTS002', 0, async () => {
      console.info('uitest: testBinaryDataConvertAsymmetricKeyPairArkTS002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('ECC Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call ECC Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('ECC Sync Success'));
      console.info('uitest: testBinaryDataConvertAsymmetricKeyPairArkTS002 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，指定PKCS8二进制数据转换ECC私钥
     */
    it('testBinaryDataConvertAsymmetricKeyPairArkTS003', 0, async () => {
      console.info('uitest: testBinaryDataConvertAsymmetricKeyPairArkTS003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('PKCS8 ECC'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call PKCS8 ECC Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('PKCS8 ECC Sync Success'));
      console.info('uitest: testBinaryDataConvertAsymmetricKeyPairArkTS003 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，指定二进制数据转换RSA密钥对
     */
    it('testBinaryDataConvertAsymmetricKeyPairArkTS004', 0, async () => {
      console.info('uitest: testBinaryDataConvertAsymmetricKeyPairArkTS004 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('RSA Callback'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call RSA Callback'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('RSA Callback Success'));
      console.info('uitest: testBinaryDataConvertAsymmetricKeyPairArkTS004 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，指定二进制数据转换RSA密钥对
     */
    it('testBinaryDataConvertAsymmetricKeyPairArkTS005', 0, async () => {
      console.info('uitest: testBinaryDataConvertAsymmetricKeyPairArkTS005 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('RSA Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call RSA Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('RSA Sync Success'));
      console.info('uitest: testBinaryDataConvertAsymmetricKeyPairArkTS005 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，指定二进制数据转换SM2密钥对
     */
    it('testBinaryDataConvertAsymmetricKeyPairArkTS006', 0, async () => {
      console.info('uitest: testBinaryDataConvertAsymmetricKeyPairArkTS006 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('SM2 Callback'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SM2 Callback'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM2 Callback Success'));
      console.info('uitest: testBinaryDataConvertAsymmetricKeyPairArkTS006 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，指定二进制数据转换SM2密钥对
     */
    it('testBinaryDataConvertAsymmetricKeyPairArkTS007', 0, async () => {
      console.info('uitest: testBinaryDataConvertAsymmetricKeyPairArkTS007 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('SM2 Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SM2 Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM2 Sync Success'));
      console.info('uitest: testBinaryDataConvertAsymmetricKeyPairArkTS007 end');
      await driver.pressBack();
    })
  })
}