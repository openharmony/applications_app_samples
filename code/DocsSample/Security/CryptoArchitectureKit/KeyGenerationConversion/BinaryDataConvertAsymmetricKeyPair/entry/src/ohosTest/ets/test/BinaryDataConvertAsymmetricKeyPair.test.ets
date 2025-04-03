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

export default function binaryDataConvertAsymmetricKeyPairTest() {
  describe('binaryDataConvertAsymmetricKeyPairTest', () => {
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
     * 点击按钮，指定二进制数据转换RSA密钥对
     */
    it('testBinaryDataConvertAsymmetricKeyPair001', 0, async () => {
      console.info('uitest: testBinaryDataConvertAsymmetricKeyPair001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call RSA'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call RSA Success Result:0'));
      console.info('uitest: testBinaryDataConvertAsymmetricKeyPair001 end');
    })

    /**
     * 点击按钮，指定二进制数据转换ECC密钥对
     */
    it('testBinaryDataConvertAsymmetricKeyPair002', 0, async () => {
      console.info('uitest: testBinaryDataConvertAsymmetricKeyPair002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call ECC'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call ECC Success Result:0'));
      console.info('uitest: testBinaryDataConvertAsymmetricKeyPair002 end');
    })

    /**
     * 点击按钮，指定二进制数据转换SM2密钥对
     */
    it('testBinaryDataConvertAsymmetricKeyPair003', 0, async () => {
      console.info('uitest: testBinaryDataConvertAsymmetricKeyPair003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call SM2'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call SM2 Success Result:0'));
      console.info('uitest: testBinaryDataConvertAsymmetricKeyPair003 end');
    })
  })
}