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

export default function specifiedParametersGenerateAsymmetricKeyPairTest() {
  describe('specifiedParametersGenerateAsymmetricKeyPairTest', () => {
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
     * 点击按钮，指定密钥参数生成RSA公钥(callback方式)
     */
    it('testSpecifiedParametersGenerateAsymmetricKeyPair001', 0, async () => {
      console.info('uitest: testSpecifiedParametersGenerateAsymmetricKeyPair001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('ECC Promise'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call ECC Promise'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('ECC Promise Success'));
      console.info('uitest: testSpecifiedParametersGenerateAsymmetricKeyPair001 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，指定密钥参数生成RSA公钥(同步方式)
     */
    it('testSpecifiedParametersGenerateAsymmetricKeyPair002', 0, async () => {
      console.info('uitest: testSpecifiedParametersGenerateAsymmetricKeyPair002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('ECC Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call ECC Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('ECC Sync Success'));
      console.info('uitest: testSpecifiedParametersGenerateAsymmetricKeyPair002 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，指定密钥参数生成ECC密钥对(Promise方式)
     */
    it('testSpecifiedParametersGenerateAsymmetricKeyPair003', 0, async () => {
      console.info('uitest: testSpecifiedParametersGenerateAsymmetricKeyPair003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('RSA Callback'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call RSA Callback'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('RSA Callback Success'));
      console.info('uitest: testSpecifiedParametersGenerateAsymmetricKeyPair003 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，指定密钥参数生成ECC密钥对(同步方式)
     */
    it('testSpecifiedParametersGenerateAsymmetricKeyPair004', 0, async () => {
      console.info('uitest: testSpecifiedParametersGenerateAsymmetricKeyPair004 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('RSA Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call RSA Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('RSA Sync Success'));
      console.info('uitest: testSpecifiedParametersGenerateAsymmetricKeyPair004 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，安根据椭圆曲线名生成SM2密钥对(Promise方式)
     */
    it('testSpecifiedParametersGenerateAsymmetricKeyPair005', 0, async () => {
      console.info('uitest: testSpecifiedParametersGenerateAsymmetricKeyPair005 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('SM2 Promise'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SM2 Promise'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM2 Promise Success'));
      console.info('uitest: testSpecifiedParametersGenerateAsymmetricKeyPair005 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，根据椭圆曲线名生成SM2密钥对(同步方式)
     */
    it('testSpecifiedParametersGenerateAsymmetricKeyPair006', 0, async () => {
      console.info('uitest: testSpecifiedParametersGenerateAsymmetricKeyPair006 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('SM2 Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SM2 Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM2 Sync Success'));
      console.info('uitest: testSpecifiedParametersGenerateAsymmetricKeyPair006 end');
    })
  })
}