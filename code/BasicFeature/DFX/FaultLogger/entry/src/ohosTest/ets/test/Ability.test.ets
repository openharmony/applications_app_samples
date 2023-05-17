/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import { logger } from '../util/Logger';

const TAG: string = 'Sample_FaultLogger';
const BUNDLE: string = 'FaultLogger_';
const NO_EXCEPTION: string = 'No exception log was obtained';

export default function abilityTest() {
  let delegator = AbilityDelegatorRegistry.getAbilityDelegator();
  let driver: Driver = Driver.create();
  describe('ActsAbilityTest', function () {
    // 打开应用
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}StartAbility_001 begin`);
      let want = {
        bundleName: "ohos.samples.faultlogger",
        abilityName: "EntryAbility"
      };
      delegator.startAbility(want, (err) => {
        logger.info(TAG, `${BUNDLE}startAbility end err ${JSON.stringify(err)}`);
      })
      await driver.delayMs(1000);
      await delegator.getCurrentTopAbility().then((Ability)=>{
        console.info("get top ability");
        expect(Ability.context.abilityInfo.name).assertEqual('EntryAbility');
      })
      logger.info(TAG, `${BUNDLE}StartAbility_001 end`);
      done();
    })

    // 检查构造异常的弹窗是否正常
    it(BUNDLE + 'CrashDialog_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}CrashDialog_001 begin`);
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(getString($r('app.string.create_fault'))));
      let button = await driver.findComponent(ON.text(getString($r('app.string.create_fault'))));
      await button.click();
      await driver.delayMs(500);
      //check text
      await driver.assertComponentExist(ON.id('JS_CRASH'));
      await driver.assertComponentExist(ON.id('cancel'));
      let cancel = await driver.findComponent(ON.id('cancel'));
      await cancel.click();
      logger.info(TAG, `${BUNDLE}CrashDialog_001 end`);
      done();
    })

    // 获取JS_crash
    it(BUNDLE + 'GetJsCrash_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}GetJsCrash_001 begin`);
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(getString($r('app.string.catch_js_fault'))));
      let getJsCrash = await driver.findComponent(ON.text(getString($r('app.string.catch_js_fault'))));
      await getJsCrash.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('message'));
      let message = await driver.findComponent(ON.id('message'));
      let messageText = await message.getText();
      let result = messageText === NO_EXCEPTION || messageText.startsWith('faultLogger num:');
      expect(result).assertTrue();
      logger.info(TAG, `${BUNDLE}GetJsCrash_001 end`);
      done();
    })

    // 获取CPP_crash
    it(BUNDLE + 'GetCppCrash_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}GetCppCrash_001 begin`);
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(getString($r('app.string.catch_cpp_fault'))));
      let getJsCrash = await driver.findComponent(ON.text(getString($r('app.string.catch_cpp_fault'))));
      await getJsCrash.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('message'));
      let message = await driver.findComponent(ON.id('message'));
      let messageText = await message.getText();
      let result = messageText === NO_EXCEPTION || messageText.startsWith('faultLogger num:');
      expect(result).assertTrue();
      logger.info(TAG, `${BUNDLE}GetCppCrash_001 end`);
      done();
    })

    // 获取APP_FREEZE异常
    it(BUNDLE + 'GetAppFreeze_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}GetAppFreeze_001 begin`);
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(getString($r('app.string.catch_app_freeze_fault'))));
      let getJsCrash = await driver.findComponent(ON.text(getString($r('app.string.catch_app_freeze_fault'))));
      await getJsCrash.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('message'));
      let message = await driver.findComponent(ON.id('message'));
      let messageText = await message.getText();
      let result = messageText === NO_EXCEPTION || messageText.startsWith('faultLogger num:');
      expect(result).assertTrue();
      logger.info(TAG, `${BUNDLE}GetAppFreeze_001 end`);
      done();
    })

    // 获取NO_SPECIFIC异常
    it(BUNDLE + 'GetNoSpecific_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}_GetNoSpecific_001 begin`);
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(getString($r('app.string.catch_all_fault'))));
      let getJsCrash = await driver.findComponent(ON.text(getString($r('app.string.catch_all_fault'))));
      await getJsCrash.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('message'));
      let message = await driver.findComponent(ON.id('message'));
      let messageText = await message.getText();
      let result = messageText === NO_EXCEPTION || messageText.startsWith('faultLogger num:');
      expect(result).assertTrue();
      logger.info(TAG, `${BUNDLE}_GetNoSpecific_001 end`);
      done();
    })

    function getString(resource: Resource) {
      return delegator.getAppContext().resourceManager.getStringSync(resource);
    }
  })
}