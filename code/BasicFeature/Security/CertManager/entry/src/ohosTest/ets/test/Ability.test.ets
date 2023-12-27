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
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, it, expect } from '@ohos/hypium';
import Logger from '../../../main/ets/model/Logger';


const TAG = '[Sample_CertCertManager]';
const BUNDLE = 'CertManager_';
const COMMON_DELAY_TIME = 1000;
const DISPLAY_DELAY_TIME = 50;
const VERIFY_DELAY_TIME = 200;
const CORRECT_CERTIFICATION = 'AgIIAA==';
const CORRECT_ORIGIN_TEXT = 'on Sunday at the Central Garden';
const MODIFIED_ORIGIN_TEXT = 'on Monday at the lakeside garden';
const MODIFIED_SIGNATURE = 'RxHxRAA=';

export default function abilityTest() {
  let driver = Driver.create();
  let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  describe('ActsAbilityTest', () => {
    /**
     * @tc.number StartAbility_001
     * @tc.name pull up the app
     * @tc.desc StartAbility
     * @tc.size SmallTest
     * @tc.level Level1
     * @tc.type Function
     */
    it('StartAbility_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'StartAbility_001 begin');
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.certmanager',
          abilityName: 'EntryAbility'
        });
        Logger.info(TAG, BUNDLE + 'Start certmanager');
        done();
      }
      catch (expection) {
        Logger.info(TAG, BUNDLE + 'Start CertManager00000');
        expect(0).assertEqual(expection.code);
        done();
      }
      Logger.info(TAG, 'StartAbility_001 end');
      done();
    });
    /**
     * @tc.number Install_001
     * @tc.name install the app
     * @tc.desc Install
     * @tc.size SmallTest
     * @tc.level Level1
     * @tc.type Function
     */
    it('Install_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Install_001 begin');
      await driver.delayMs(COMMON_DELAY_TIME);
      // 获取ability
      let ability = await abilityDelegator.getCurrentTopAbility();
      //获取manager
      let manager = ability.context.resourceManager;
      // 点击签名校验按钮，页面弹出toast弹窗提示：安装成功
      await driver.assertComponentExist(ON.id('installButton'));
      let verify = await driver.findComponent(ON.id('installButton'));
      await verify.click();
      await driver.delayMs(VERIFY_DELAY_TIME);
      await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.install_success'))));
      Logger.info(TAG, BUNDLE + 'Install_001 end');
      done();
    });
    /**
     * @tc.number DisplayData_001
     * @tc.name display data
     * @tc.desc DisplayData
     * @tc.size SmallTest
     * @tc.level Level1
     * @tc.type Function
     */
    it('DisplayData_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'DisplayData_001 begin');
      await driver.delayMs(COMMON_DELAY_TIME);
      // 点击数据展示按钮，页面分别显示正确的证书、原始
      await driver.assertComponentExist(ON.id('dispalyButton'));
      let displayData = await driver.findComponent(ON.id('dispalyButton'));
      await displayData.click();
      await driver.delayMs(DISPLAY_DELAY_TIME);
      await driver.assertComponentExist(ON.text(CORRECT_CERTIFICATION, MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.text(CORRECT_ORIGIN_TEXT, MatchPattern.CONTAINS));
      Logger.info(TAG, BUNDLE + 'DisplayData_001 end');
      done();
    });
    /**
     * @tc.number Sign_001
     * @tc.name validate sign
     * @tc.desc Sign
     * @tc.size SmallTest
     * @tc.level Level1
     * @tc.type Function
     */
    it('Sign_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Sign_001 begin');
      await driver.delayMs(COMMON_DELAY_TIME);
      // 获取ability
      let ability = await abilityDelegator.getCurrentTopAbility();
      //获取manager
      let manager = ability.context.resourceManager;
      // 点击签名按钮，页面弹出toast弹窗提示：签名通过
      await driver.assertComponentExist(ON.id('signButton'));
      let verify = await driver.findComponent(ON.id('signButton'));
      await verify.click();
      await driver.delayMs(VERIFY_DELAY_TIME);
      await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.sign_success'))));
      Logger.info(TAG, BUNDLE + 'Sign_001 end');
      done();
    });
    /**
     * @tc.number Verify_001
     * @tc.name verify sign
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
      // 点击签名按钮
      await driver.assertComponentExist(ON.id('signButton'));
      let sign = await driver.findComponent(ON.id('signButton'));
      await sign.click();
      await driver.delayMs(VERIFY_DELAY_TIME);
      // 点击修改原始数据按钮，页面分别显示正确的证书数据和签名数据，以及错误的原始数据
      await driver.assertComponentExist(ON.id('modifyOriginButton'));
      let modify = await driver.findComponent(ON.id('modifyOriginButton'));
      await modify.click();
      await driver.delayMs(DISPLAY_DELAY_TIME);
      await driver.assertComponentExist(ON.text(CORRECT_CERTIFICATION, MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.text(MODIFIED_ORIGIN_TEXT, MatchPattern.CONTAINS));
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
      // 点击签名按钮
      await driver.assertComponentExist(ON.id('signButton'));
      let sign = await driver.findComponent(ON.id('signButton'));
      await sign.click();
      await driver.delayMs(VERIFY_DELAY_TIME);

      // 点击修改签名数据按钮，页面分别显示正确的证书数据和原始数据，以及错误的签名数据
      await driver.assertComponentExist(ON.id('modifySignatureButton'));
      let modify = await driver.findComponent(ON.id('modifySignatureButton'));
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
     * @tc.name Restore the initial data, modify the original data, keep the signature data unchanged, and perform signature verification again
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
      await driver.assertComponentExist(ON.id('dispalyButton'));
      let display = await driver.findComponent(ON.id('dispalyButton'));
      await display.click();
      // 点击签名按钮
      await driver.assertComponentExist(ON.id('signButton'));
      let sign = await driver.findComponent(ON.id('signButton'));
      await sign.click();
      await driver.delayMs(VERIFY_DELAY_TIME);
      // 点击修改原始数据按钮，页面分别显示正确的证书数据和签名数据，以及错误的原始数据
      Logger.info(TAG, 'modify origin data');
      await driver.assertComponentExist(ON.id('modifyOriginButton'));
      let modify = await driver.findComponent(ON.id('modifyOriginButton'));
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
      await driver.assertComponentExist(ON.id('dispalyButton'));
      let display = await driver.findComponent(ON.id('dispalyButton'));
      await display.click();
      Logger.info(TAG, 'modify signature data');
      // 点击签名按钮
      await driver.assertComponentExist(ON.id('signButton'));
      let sign = await driver.findComponent(ON.id('signButton'));
      await sign.click();
      await driver.delayMs(VERIFY_DELAY_TIME);
      // 点击修改原始数据按钮，页面分别显示正确的证书数据和签名数据，以及错误的原始数据
      await driver.assertComponentExist(ON.id('modifySignatureButton'));
      let modify = await driver.findComponent(ON.id('modifySignatureButton'));
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
      await driver.assertComponentExist(ON.id('dispalyButton'));
      let display = await driver.findComponent(ON.id('dispalyButton'));
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
  })
}
