/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { MatchPattern, Driver, ON } from '@ohos.UiTest';
import Logger from '../../../main/ets/model/Logger';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import resource from '@ohos.resourceManager'

const TAG = '[Sample_CertFramework]';
const BUNDLE = 'CertFramework_';
const COMMON_DELAY_TIME = 1000;
const DISPLAY_DELAY_TIME = 50;
const VERIFY_DELAY_TIME = 200;
const CORRECT_CERTIFICATION = 'gt8da5Zg==';
const CORRECT_ORIGIN_TEXT = 'on Sunday at the Central Garden';
const MODIFIED_ORIGIN_TEXT = 'on Monday at the lakeside garden';
const CORRECT_SIGNATURE = 'd7mi/';
const MODIFIED_SIGNATURE = 'AAAREleX';

const CHAIN_DATA = 'TCbf9g==';
const CHAIN_ROOT = 'QroAR2mV';
const CHAIN_CRL = 'hg==';

export default function abilityTest() {
  let driver = Driver.create();
  let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
  describe('ActsAbilityTest', () => {
    /**
     * @tc.number StartAbility_001
     * @tc.name Pull up the app
     * @tc.desc StartAbility
     * @tc.size SmallTest
     * @tc.level Level1
     * @tc.type Function
     */
    it('StartAbility_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'StartAbility_001 begin');
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.certframework',
          abilityName: 'EntryAbility'
        });
        Logger.info(TAG, BUNDLE + 'Start certframework');
        done();
      }
      catch (expection) {
        Logger.info(TAG, BUNDLE + 'Start certframework00000');
        expect(0).assertEqual(expection.code);
        done();
      }
      Logger.info(TAG, 'StartAbility_001 end');
      done();
    });
    /**
     * @tc.number DisplayData_001
     * @tc.name Display data
     * @tc.desc DisplayData
     * @tc.size SmallTest
     * @tc.level Level1
     * @tc.type Function
     */
    it('DisplayData_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'DisplayData_001 begin');
      await driver.delayMs(COMMON_DELAY_TIME);
      // 点击数据展示按钮，页面分别显示正确的证书、原始、签名数据
      await driver.assertComponentExist(ON.id('dataDispalyButton'));
      let displayData = await driver.findComponent(ON.id('dataDispalyButton'));
      await displayData.click();
      await driver.delayMs(DISPLAY_DELAY_TIME);
      await driver.assertComponentExist(ON.text(CORRECT_CERTIFICATION, MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.text(CORRECT_ORIGIN_TEXT, MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.text(CORRECT_SIGNATURE, MatchPattern.CONTAINS));
      Logger.info(TAG, BUNDLE + 'DisplayData_001 end');
      done();
    });
    /**
     * @tc.number Verify_001
     * @tc.name Verify sign
     * @tc.desc Verify
     * @tc.size SmallTest
     * @tc.level Level1
     * @tc.type Function
     */
    it('Verify_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Verify_001 begin');
      await driver.delayMs(COMMON_DELAY_TIME);
      // 获取ability
      let ability = await abilityDelegator.getCurrentTopAbility();
      //获取manager
      let manager = ability.context.resourceManager;
      // 点击签名校验按钮，页面弹出toast弹窗提示：校验通过
      await driver.assertComponentExist(ON.id('verifyButton'));
      let verify = await driver.findComponent(ON.id('verifyButton'));
      await verify.click();
      await driver.delayMs(VERIFY_DELAY_TIME);
      await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.verify_success'))));
      Logger.info(TAG, BUNDLE + 'Verify_001 end');
      done();
    });
    /**
     * @tc.number ModifyOriginData_001
     * @tc.name Modify the original data and keep the signature data intact
     * @tc.desc Verify
     * @tc.size SmallTest
     * @tc.level Level1
     * @tc.type Function
     */
    it('ModifyOriginData_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'ModifyOriginData_001 begin');
      await driver.delayMs(COMMON_DELAY_TIME);
      // 点击修改原始数据按钮，页面分别显示正确的证书数据和签名数据，以及错误的原始数据
      await driver.assertComponentExist(ON.id('modifyOriginDataButton'));
      let modify = await driver.findComponent(ON.id('modifyOriginDataButton'));
      await modify.click();
      await driver.delayMs(DISPLAY_DELAY_TIME);
      await driver.assertComponentExist(ON.text(CORRECT_CERTIFICATION, MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.text(MODIFIED_ORIGIN_TEXT, MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.text(CORRECT_SIGNATURE, MatchPattern.CONTAINS));
      Logger.info(TAG, BUNDLE + 'ModifyOriginData_001 begin');
      done();
    });
    /**
     * @tc.number ModifySignatureData_001
     * @tc.name Modify the signature data and keep the original data intact
     * @tc.desc ModifySignatureData
     * @tc.size SmallTest
     * @tc.level Level1
     * @tc.type Function
     */
    it('ModifySignatureData_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'ModifySignatureData_001 begin');
      await driver.delayMs(COMMON_DELAY_TIME);
      // 点击修改签名数据按钮，页面分别显示正确的证书数据和原始数据，以及错误的签名数据
      await driver.assertComponentExist(ON.id('modifySignatureDataButton'));
      let modify = await driver.findComponent(ON.id('modifySignatureDataButton'));
      await modify.click();
      await driver.delayMs(DISPLAY_DELAY_TIME);
      await driver.assertComponentExist(ON.text(CORRECT_CERTIFICATION, MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.text(CORRECT_ORIGIN_TEXT, MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.text(MODIFIED_SIGNATURE, MatchPattern.CONTAINS));
      Logger.info(TAG, BUNDLE + 'ModifySignatureData_001 begin');
      done();
    });
    /**
     * @tc.number Verify_002
     * @tc.name Restore the initial data, modify the original data and keep the signature data unchanged, and perform signature verification again
     * @tc.desc Verify
     * @tc.size SmallTest
     * @tc.level Level1
     * @tc.type Function
     */
    it('Verify_002', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Verify_002 begin');
      await driver.delayMs(COMMON_DELAY_TIME);
      // 获取ability
      let ability = await abilityDelegator.getCurrentTopAbility();
      //获取manager
      let manager = ability.context.resourceManager;
      // 点击数据展示按钮恢复正确的数据，页面分别显示正确的证书、签名、原始数据
      Logger.info(TAG, 'display data');
      await driver.assertComponentExist(ON.id('dataDispalyButton'));
      let display = await driver.findComponent(ON.id('dataDispalyButton'));
      await display.click();
      // 点击修改原始数据按钮，页面分别显示正确的证书数据和签名数据，以及错误的原始数据
      Logger.info(TAG, 'modify origin data');
      await driver.assertComponentExist(ON.id('modifyOriginDataButton'));
      let modify = await driver.findComponent(ON.id('modifyOriginDataButton'));
      await modify.click();
      // 点击签名校验按钮，页面弹出toast弹窗提示：校验失败
      Logger.info(TAG, 'verify');
      await driver.assertComponentExist(ON.id('verifyButton'));
      let verify = await driver.findComponent(ON.id('verifyButton'));
      await verify.click();
      await driver.delayMs(VERIFY_DELAY_TIME);
      await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.verify_fail'))));
      Logger.info(TAG, BUNDLE + 'Verify_002 end');
      done();
    });
    /**
     * @tc.number Verify_003
     * @tc.name Restore the initial data, modify the signature data and keep the original data unchanged, and perform signature verification again
     * @tc.desc Verify
     * @tc.size SmallTest
     * @tc.level Level1
     * @tc.type Function
     */
    it('Verify_003', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Verify_003 begin');
      await driver.delayMs(COMMON_DELAY_TIME);
      // 获取ability
      let ability = await abilityDelegator.getCurrentTopAbility();
      //获取manager
      let manager = ability.context.resourceManager;
      // 点击数据展示按钮恢复正确的数据，页面分别显示正确的证书、签名、原始数据
      Logger.info(TAG, 'display data');
      await driver.assertComponentExist(ON.id('dataDispalyButton'));
      let display = await driver.findComponent(ON.id('dataDispalyButton'));
      await display.click();
      // 点击修改原始数据按钮，页面分别显示正确的证书数据和签名数据，以及错误的原始数据
      Logger.info(TAG, 'modify signature data');
      await driver.assertComponentExist(ON.id('modifySignatureDataButton'));
      let modify = await driver.findComponent(ON.id('modifySignatureDataButton'));
      await modify.click();
      // 点击签名校验按钮，页面弹出toast弹窗提示：校验失败
      Logger.info(TAG, 'verify');
      await driver.assertComponentExist(ON.id('verifyButton'));
      let verify = await driver.findComponent(ON.id('verifyButton'));
      await verify.click();
      await driver.delayMs(VERIFY_DELAY_TIME);
      await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.verify_fail'))));
      Logger.info(TAG, BUNDLE + 'Verify_003 end');
      done();
    });
    /**
     * @tc.number Verify_004
     * @tc.name Restore the correct signature data and original data, and perform signature verification again
     * @tc.desc Verify
     * @tc.size SmallTest
     * @tc.level Level1
     * @tc.type Function
     */
    it('Verify_004', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Verify_004 begin');
      await driver.delayMs(COMMON_DELAY_TIME);
      // 获取ability
      let ability = await abilityDelegator.getCurrentTopAbility();
      //获取manager
      let manager = ability.context.resourceManager;
      // 点击数据展示按钮恢复正确的数据，页面分别显示正确的证书、签名、原始数据
      Logger.info(TAG, 'display data');
      await driver.assertComponentExist(ON.id('dataDispalyButton'));
      let display = await driver.findComponent(ON.id('dataDispalyButton'));
      await display.click();
      // 点击签名校验按钮，页面弹出toast弹窗提示：校验通过
      Logger.info(TAG, 'verify');
      await driver.assertComponentExist(ON.id('verifyButton'));
      let verify = await driver.findComponent(ON.id('verifyButton'));
      await verify.click();
      await driver.delayMs(VERIFY_DELAY_TIME);
      await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.verify_success'))));
      Logger.info(TAG, BUNDLE + 'Verify_004 end');
      done();
    });
    /**
     * @tc.number CertChain_001
     * @tc.name CertChain validation
     * @tc.desc CertChain
     * @tc.size SmallTest
     * @tc.level Level1
     * @tc.type Function
     */
    it('CertChain_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'CertChain_001 begin');
      await driver.delayMs(COMMON_DELAY_TIME);
      // 获取ability
      let ability = await abilityDelegator.getCurrentTopAbility();
      //获取manager
      let manager = ability.context.resourceManager;
      // 点击数据展示按钮恢复正确的数据，页面分别显示正确的证书、签名、原始数据
      Logger.info(TAG, 'display data');

      // 切换到记录tab
      await driver.assertComponentExist(ON.id('tab_certchain'));
      let tabCertchain = await driver.findComponent(ON.id('tab_certchain'));
      await tabCertchain.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.id('certchainDataButton'));
      let display = await driver.findComponent(ON.id('certchainDataButton'));
      await display.click();

      await driver.delayMs(DISPLAY_DELAY_TIME);
      await driver.assertComponentExist(ON.text(CHAIN_DATA, MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.text(CHAIN_ROOT, MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.text(CHAIN_CRL, MatchPattern.CONTAINS));

      Logger.info(TAG, 'show');
      await driver.assertComponentExist(ON.id('certchainValidateButton'));
      let verify = await driver.findComponent(ON.id('certchainValidateButton'));
      await verify.click();
      await driver.delayMs(VERIFY_DELAY_TIME);

      await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.verify_success'))));
      Logger.info(TAG, BUNDLE + 'CertChain_001 end');
      done();
    });
    /**
     * @tc.number CertChain_002
     * @tc.name CertChain validation
     * @tc.desc CertChain
     * @tc.size SmallTest
     * @tc.level Level1
     * @tc.type Function
     */
    it('CertChain_002', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'CertChain_001 begin');
      await driver.delayMs(COMMON_DELAY_TIME);
      // 获取ability
      let ability = await abilityDelegator.getCurrentTopAbility();
      //获取manager
      let manager = ability.context.resourceManager;
      // 点击数据展示按钮恢复正确的数据，页面分别显示正确的证书、签名、原始数据
      Logger.info(TAG, 'display data');

      await driver.assertComponentExist(ON.id('toggleSwitchCrl'));
      const switchs = await driver.findComponent(ON.id('toggleSwitchCrl'));
      await switchs.click();
      await driver.delayMs(VERIFY_DELAY_TIME);

      Logger.info(TAG, 'show');
      await driver.assertComponentExist(ON.id('certchainValidateButton'));
      let verify = await driver.findComponent(ON.id('certchainValidateButton'));
      await verify.click();
      await driver.delayMs(VERIFY_DELAY_TIME);

      await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.verify_fail'))));
      Logger.info(TAG, BUNDLE + 'CertChain_001 end');
      done();
    });
  })
}