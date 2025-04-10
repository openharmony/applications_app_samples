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

export default function encryptionDecryptionGuidanceSM4Test() {
  describe('encryptionDecryptionGuidanceSM4Test', () => {
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
     * 点击按钮，使用SM4对称密钥（ECB模式）加解密(C/C++)
     */
    it('testEncryptionDecryptionGuidanceSM4001', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceSM4001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call SM4_ECB'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM4_ECBSuccess Result:0'));
      console.info('uitest: testEncryptionDecryptionGuidanceSM4001 end');
    })

    /**
     * 点击按钮，使用SM4对称密钥（CBC模式）加解密(C/C++)
     */
    it('testEncryptionDecryptionGuidanceSM4002', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceSM4002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call SM4_CBC'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM4_CBCSuccess Result:0'));
      console.info('uitest: testEncryptionDecryptionGuidanceSM4002 end');
    })

    /**
     * 点击按钮，使用SM4对称密钥（GCM模式）加解密(C/C++)
     */
    it('testEncryptionDecryptionGuidanceSM4003', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceSM4003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call SM4_GCM'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM4_GCMSuccess Result:0'));
      console.info('uitest: testEncryptionDecryptionGuidanceSM4003 end');
    })

    /**
     * 点击按钮，使用SM4对称密钥（GCM模式）分段加解密(C/C++)
     */
    it('testEncryptionDecryptionGuidanceSM4004', 0, async () => {
      console.info('uitest: testEncryptionDecryptionGuidanceSM4004 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call SM4_GCM_SEG'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM4_GCM_SEGSuccess Result:0'));
      console.info('uitest: testEncryptionDecryptionGuidanceSM4004 end');
    })
  })
}