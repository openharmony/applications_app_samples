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

export default function certificateAlgorithmLibraryTest() {
  describe('certificateAlgorithmLibraryTest', () => {
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
     * 点击按钮，创建、解析校验证书对象
     */
    it('testCertificateAlgorithmLibrary001', 0, async (done: Function) => {
      console.info('uitest: testCertificateAlgorithmLibrary001 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('CreateParseVerifyCertObject'));
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call CreateParseVerifyCertObject'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call Success'));
      console.info('uitest: testCertificateAlgorithmLibrary001 end');
      await driver.pressBack();
      done();
    })

    /**
     * 点击按钮，创建、解析和校验证书扩展信息对象
     */
    it('testCertificateAlgorithmLibrary002', 0, async (done: Function) => {
      console.info('uitest: testCertificateAlgorithmLibrary002 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('CreateParseVerifyCertextensionObject'));
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call CreateParseVerifyCertextensionObject'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call Success'));
      console.info('uitest: testCertificateAlgorithmLibrary002 end');
      await driver.pressBack();
      done();
    })

    /**
     * 点击按钮，创建、解析和校验证书吊销列表对象
     */
    it('testCertificateAlgorithmLibrary003', 0, async (done: Function) => {
      console.info('uitest: testCertificateAlgorithmLibrary003 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('CreateParseVerifyCrlObject'));
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call CreateParseVerifyCrlObject'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call Success'));
      console.info('uitest: testCertificateAlgorithmLibrary003 end');
      await driver.pressBack();
      done();
    })

    /**
     * 点击按钮，构造TrustAnchor对象数组
     */
    it('testCertificateAlgorithmLibrary004', 0, async (done: Function) => {
      console.info('uitest: testCertificateAlgorithmLibrary004 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('CreateTrustanchorFromP12'));
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call CreateTrustanchorFromP12'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call Success'));
      console.info('uitest: testCertificateAlgorithmLibrary004 end');
      await driver.pressBack();
      done();
    })

    /**
     * 点击按钮，创建和校验证书链校验器对象
     */
    it('testCertificateAlgorithmLibrary005', 0, async (done: Function) => {
      console.info('uitest: testCertificateAlgorithmLibrary005 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('CreateVerifyCerchainvalidatorObject'));
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call CreateVerifyCerchainvalidatorObject'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call Success'));
      console.info('uitest: testCertificateAlgorithmLibrary005 end');
      await driver.pressBack();
      done();
    })

    /**
     * 点击按钮，创建和获取证书集合及证书吊销列表集合对象
     */
    it('testCertificateAlgorithmLibrary006', 0, async (done: Function) => {
      console.info('uitest: testCertificateAlgorithmLibrary006 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('CreateGetCertCrlObject'));
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call CreateGetCertCrlObject'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call Success'));
      console.info('uitest: testCertificateAlgorithmLibrary006 end');
      await driver.pressBack();
      done();
    })

    /**
     * 点击按钮，创建和校验证书链对象
     */
    it('testCertificateAlgorithmLibrary007', 0, async (done: Function) => {
      console.info('uitest: testCertificateAlgorithmLibrary007 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('CreateVerifyCertchainObject'));
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call CreateVerifyCertchainObject'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call Success'));
      console.info('uitest: testCertificateAlgorithmLibrary007 end');
      done();
    })

    /**
     * 点击按钮，使用系统预制CA证书校验证书链
     */
    it('testCertificateAlgorithmLibrary008', 0, async (done: Function) => {
      console.info('uitest: testCertificateAlgorithmLibrary008 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('VerifyCertchainBySystemca'));
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call VerifyCertchainBySystemca'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call Success'));
      console.info('uitest: testCertificateAlgorithmLibrary008 end');
      done();
    })

    /**
     * 点击按钮，证书CMS签名异步
     */
    it('testCertificateAlgorithmLibrary009', 0, async (done: Function) => {
      console.info('uitest: testCertificateAlgorithmLibrary009 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button0 = await driver.findComponent(ON.text('CreateCmsOperator'));
      await button0.click();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('CreateCmsSignObjectAsync'));
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call CreateCmsSignObjectAsync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call Success'));
      console.info('uitest: testCertificateAlgorithmLibrary009 end');
      done();
    })

    /**
     * 点击按钮，证书CMS签名同步
     */
    it('testCertificateAlgorithmLibrary010', 0, async (done: Function) => {
      console.info('uitest: testCertificateAlgorithmLibrary010 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button0 = await driver.findComponent(ON.text('CreateCmsOperator'));
      await button0.click();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('CreateCmsSignObjectSync'));
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call CreateCmsSignObjectSync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call Success'));
      console.info('uitest: testCertificateAlgorithmLibrary010 end');
      done();
    })

    /**
     * 点击按钮，证书CMS封装
     */
    it('testCertificateAlgorithmLibrary011', 0, async (done: Function) => {
      console.info('uitest: testCertificateAlgorithmLibrary011 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button0 = await driver.findComponent(ON.text('CreateCmsOperator'));
      await button0.click();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('CreateCmsEnvelopedObject'));
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call CreateCmsEnvelopedObject'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call Success'));
      console.info('uitest: testCertificateAlgorithmLibrary011 end');
      done();
    })

    /**
     * 点击按钮，证书CMS验签
     */
    it('testCertificateAlgorithmLibrary012', 0, async (done: Function) => {
      console.info('uitest: testCertificateAlgorithmLibrary012 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button0 = await driver.findComponent(ON.text('CreateCmsOperator'));
      await button0.click();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('CreateCmsVerifyObject'));
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call CreateCmsVerifyObject'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call Success'));
      console.info('uitest: testCertificateAlgorithmLibrary012 end');
      done();
    })

    /**
     * 点击按钮，证书CMS解封装
     */
    it('testCertificateAlgorithmLibrary013', 0, async (done: Function) => {
      console.info('uitest: testCertificateAlgorithmLibrary013 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button0 = await driver.findComponent(ON.text('CreateCmsOperator'));
      await button0.click();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('CreateCmsDecapsulationObject'));
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call CreateCmsDecapsulationObject'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call Success'));
      console.info('uitest: testCertificateAlgorithmLibrary013 end');
      done();
    })

    /**
     * 点击按钮，证书PKCS12创建与解析异步
     */
    it('testCertificateAlgorithmLibrary014', 0, async (done: Function) => {
      console.info('uitest: testCertificateAlgorithmLibrary014 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button0 = await driver.findComponent(ON.text('CreateParsePkcs12'));
      await button0.click();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('CreateParsePkcs12Async'));
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call CreateParsePkcs12Async'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call Success'));
      console.info('uitest: testCertificateAlgorithmLibrary014 end');
      done();
    })

    /**
     * 点击按钮，证书PKCS12创建与解析同步
     */
    it('testCertificateAlgorithmLibrary015', 0, async (done: Function) => {
      console.info('uitest: testCertificateAlgorithmLibrary015 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button0 = await driver.findComponent(ON.text('CreateParsePkcs12'));
      await button0.click();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('CreateParsePkcs12Sync'));
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call CreateParsePkcs12Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call Success'));
      console.info('uitest: testCertificateAlgorithmLibrary015 end');
      done();
    })

    /**
     * 点击按钮，本地证书链吊销状态校验时仅校验终端实体证书
     */
    it('testCertificateAlgorithmLibrary016', 0, async (done: Function) => {
      console.info('uitest: testCertificateAlgorithmLibrary016 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button0 = await driver.findComponent(ON.text('VerifyCertchainOnlineRevocationStatus'));
      await button0.click();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('CreateOnlyCheckLeafCertRevocateObject'));
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call CreateOnlyCheckLeafCertRevocateObject'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call Success'));
      console.info('uitest: testCertificateAlgorithmLibrary016 end');
      done();
    })

    /**
     * 点击按钮，在线校验证书链中的中间CA证书吊销状态
     */
    it('testCertificateAlgorithmLibrary017', 0, async (done: Function) => {
      console.info('uitest: testCertificateAlgorithmLibrary017 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button0 = await driver.findComponent(ON.text('VerifyCertchainOnlineRevocationStatus'));
      await button0.click();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('CreateOnlineCheckIntermediateCertificateonlyObject'));
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call CreateOnlineCheckIntermediateCertificateonlyObject'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call Success'));
      console.info('uitest: testCertificateAlgorithmLibrary017 end');
      done();
    })

    /**
     * 点击按钮，在线证书吊销检查忽略网络不可达异常
     */
    it('testCertificateAlgorithmLibrary018', 0, async (done: Function) => {
      console.info('uitest: testCertificateAlgorithmLibrary018 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button0 = await driver.findComponent(ON.text('VerifyCertchainOnlineRevocationStatus'));
      await button0.click();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('IgnoreNetworkUnreachable'));
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call IgnoreNetworkUnreachable'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call Success'));
      console.info('uitest: testCertificateAlgorithmLibrary018 end');
      done();
    })

    /**
     * 点击按钮，在线证书吊销检查忽略网络不可达异常
     */
    it('testCertificateAlgorithmLibrary019', 0, async (done: Function) => {
      console.info('uitest: testCertificateAlgorithmLibrary019 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const button1 = await driver.findComponent(ON.text('AllowDownloadIntermediateCert'));
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call AllowDownloadIntermediateCert'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call Success'));
      console.info('uitest: testCertificateAlgorithmLibrary019 end');
      done();
    })
  })
}