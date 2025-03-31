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

export default function signingSignatureVerificationArkTsTest() {
  describe('signingSignatureVerificationArkTsTest', () => {
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
     * 点击按钮，使用RSA密钥对（PKCS1模式）签名验签(异步)
     */
    it('signingSignatureVerificationArkTsTest001', 0, async () => {
      console.info('uitest: signingSignatureVerificationArkTsTest001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('rsa_pkcs1_signature_validator_asynchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SignatureVerify Asynchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SignatureVerifySuccess'));
      console.info('uitest: signingSignatureVerificationArkTsTest001 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用RSA密钥对（PKCS1模式）签名验签(同步)
     */
    it('testSigningSignatureVerificationArkTsTest002', 0, async () => {
      console.info('uitest: testSigningSignatureVerificationArkTsTest002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('rsa_pkcs1_signature_validator_synchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SignatureVerify Synchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SignatureVerifySuccess'));
      console.info('uitest: testSigningSignatureVerificationArkTsTest002 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用RSA密钥对（PKCS1模式）签名及签名恢复(异步)
     */
    it('testSigningSignatureVerificationArkTsTest003', 0, async () => {
      console.info('uitest: testSigningSignatureVerificationArkTsTest003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('rsa_pkcs1_signature_restoration_asynchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SignatureRecover Asynchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SignatureRecoverSuccess'));
      console.info('uitest: testSigningSignatureVerificationArkTsTest003 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用RSA密钥对（PKCS1模式）签名及签名恢复(同步)
     */
    it('testSigningSignatureVerificationArkTsTest004', 0, async () => {
      console.info('uitest: testSigningSignatureVerificationArkTsTest004 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('rsa_pkcs1_signature_restoration_synchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SignatureRecover Synchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SignatureRecoverSuccess'));
      console.info('uitest: testSigningSignatureVerificationArkTsTest004 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用RSA密钥对分段签名验签（PKCS1模式）(异步)
     */
    it('testSigningSignatureVerificationArkTsTest005', 0, async () => {
      console.info('uitest: testSigningSignatureVerificationArkTsTest005 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('rsa_pkcs1_segment_signature_asynchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SignatureSeg Asynchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SignatureSegSuccess'));
      console.info('uitest: testSigningSignatureVerificationArkTsTest005 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用RSA密钥对分段签名验签（PKCS1模式）(同步)
     */
    it('testSigningSignatureVerificationArkTsTest006', 0, async () => {
      console.info('uitest: testSigningSignatureVerificationArkTsTest006 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('rsa_pkcs1_segment_signature_synchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SignatureSeg Synchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SignatureSegSuccess'));
      console.info('uitest: testSigningSignatureVerificationArkTsTest006 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用RSA密钥对签名验签（PSS模式）(异步)
     */
    it('testSigningSignatureVerificationArkTsTest007', 0, async () => {
      console.info('uitest: testSigningSignatureVerificationArkTsTest007 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('rsa_pss_signature_verification_asynchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call PSSSignatureSeg Asynchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('PSSSignatureSegSuccess'));
      console.info('uitest: testSigningSignatureVerificationArkTsTest007 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用RSA密钥对签名验签（PSS模式）(同步)
     */
    it('testSigningSignatureVerificationArkTsTest008', 0, async () => {
      console.info('uitest: testSigningSignatureVerificationArkTsTest008 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('rsa_pss_signature_verification_synchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call PSSSignatureSeg Synchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('PSSSignatureSegSuccess'));
      console.info('uitest: testSigningSignatureVerificationArkTsTest008 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用ECDSA密钥对签名验签(异步)
     */
    it('testSigningSignatureVerificationArkTsTest009', 0, async () => {
      console.info('uitest: testSigningSignatureVerificationArkTsTest009 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('ecdsa_signature_verification_asynchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call ECDSASignature Asynchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('ECDSASignatureSuccess'));
      console.info('uitest: testSigningSignatureVerificationArkTsTest009 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用ECDSA密钥对签名验签(同步)
     */
    it('testSigningSignatureVerificationArkTsTest010', 0, async () => {
      console.info('uitest: testSigningSignatureVerificationArkTsTest010 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('ecdsa_signature_verification_synchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call ECDSASignature Synchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('ECDSASignatureSuccess'));
      console.info('uitest: testSigningSignatureVerificationArkTsTest010 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用SM2密钥对签名验签(异步)
     */
    it('testSigningSignatureVerificationArkTsTest011', 0, async () => {
      console.info('uitest: testSigningSignatureVerificationArkTsTest011 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('sm2_signature_verification_asynchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SM2Signature Asynchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM2SignatureSuccess'));
      console.info('uitest: testSigningSignatureVerificationArkTsTest011 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用SM2密钥对签名验签(同步)
     */
    it('testSigningSignatureVerificationArkTsTest012', 0, async () => {
      console.info('uitest: testSigningSignatureVerificationArkTsTest012 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('sm2_signature_verification_synchronous'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call SM2Signature Synchronous'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SM2SignatureSuccess'));
      console.info('uitest: testSigningSignatureVerificationArkTsTest012 end');
    })
  })
}