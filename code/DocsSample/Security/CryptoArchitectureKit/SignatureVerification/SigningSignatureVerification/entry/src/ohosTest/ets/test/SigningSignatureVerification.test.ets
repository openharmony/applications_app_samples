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

export default function signingSignatureVerificationTest() {
  describe('signingSignatureVerificationTest', () => {
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
     * 点击按钮，使用RSA密钥对（PKCS1模式）验签(C/C++)
     */
    it('testSigningSignatureVerificationTest001', 0, async () => {
      console.info('uitest: testSigningSignatureVerificationTest001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call SignatureSeg'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SignatureSegSuccess Result:true'));
      console.info('uitest: testSigningSignatureVerificationTest001 end');
    })

    /**
     * 点击按钮，使用RSA密钥对（PKCS1模式）签名恢复(C/C++)
     */
    it('testSigningSignatureVerificationTest002', 0, async () => {
      console.info('uitest: testSigningSignatureVerificationTest002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call Signature'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SignatureSuccess Result:true'));
      console.info('uitest: testSigningSignatureVerificationTest002 end');
    })

    /**
     * 点击按钮，使用RSA密钥对分段验签（PKCS1模式）(C/C++)
     */
    it('testSigningSignatureVerificationTest003', 0, async () => {
      console.info('uitest: testSigningSignatureVerificationTest003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call SignatureRecover'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SignatureRecoverSuccess Result:0'));
      console.info('uitest: testSigningSignatureVerificationTest003 end');
    })

    /**
     * 点击按钮，使用RSA密钥对验签（PSS模式）(C/C++)
     */
    it('testSigningSignatureVerificationTest004', 0, async () => {
      console.info('uitest: testSigningSignatureVerificationTest004 begin');
      const driver = Driver.create();
      const button = await driver.findComponent(ON.text('Call PSSSignatureSeg'));
      await driver.delayMs(1000);
      await button.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('PSSSignatureSegSuccess Result:false'));
      console.info('uitest: testSigningSignatureVerificationTest004 end');
    })

    /**
     * 点击按钮，使用ECDSA密钥对验签(C/C++)
     */
    it('testSigningSignatureVerificationTest005', 0, async () => {
      console.info('uitest: testSigningSignatureVerificationTest005 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call ECDSASignature'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('ECDSASignatureSuccess Result:false'));
      console.info('uitest: testSigningSignatureVerificationTest005 end');
    })

    /**
     * 点击按钮，使用SM2密钥对验签(C/C++)
     */
    it('testSigningSignatureVerificationTest006', 0, async () => {
      console.info('uitest: testSigningSignatureVerificationTest006 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Call SM2Signature'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM2SignatureSuccess Result:false'));
      console.info('uitest: testSigningSignatureVerificationTest006 end');
    })
  })
}