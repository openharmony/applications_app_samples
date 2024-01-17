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

import Base from '@ohos.base';
import Want from '@ohos.app.ability.Want';
import { Driver, ON } from '@ohos.UiTest';
import { describe, it, expect } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Logger from '../util/Logger';

const TAG = '[Sample_AutoFillTest]';
const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

function startAbility() {
  Logger.info(TAG, 'StartAbility start');
  let want: Want = {
    bundleName: 'com.ohos.passwordbox',
    abilityName: 'EntryAbility'
  };
  Logger.info(TAG, 'getAbilityDelegator end');
  abilityDelegator.startAbility(want, (err: Base.BusinessError) => {
    Logger.info(TAG, 'StartAbility get err ' + JSON.stringify(err));
  });
}

export default function abilityTest() {
  describe('AutoFillSampleTest', () => {

    /*
    * @tc.number: AutoFill_NewPassWordTextInput_003
    * @tc.name: Click Enter NewPassword input field
    * @tc.desc: Click Enter NewPassword input field
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it('AutoFill_NewPassWordTextInput_003', 0, async (done: Function) => {
      Logger.info(TAG, 'AutoFill_NewPassWordTextInput_003 start');
      startAbility();
      let driver = Driver.create();
      await driver.delayMs(1000);
      let registerBtn = await driver.findComponent(
        ON.id("register"));
      await driver.delayMs(1000);
      await registerBtn.click();
      await driver.delayMs(500);
      let newPassWordTextInput = await driver.findComponent(
        ON.id("newPassWord"));
      await driver.delayMs(1000);
      await newPassWordTextInput.click();
      await driver.delayMs(1000);
      let confirmBtn = await driver.findComponent(ON.id("confirm"));
      await driver.delayMs(1000);
      await confirmBtn.click();
      await driver.delayMs(1000);
      let newPassWordInfo = await newPassWordTextInput.getText();
      await driver.delayMs(500);
      Logger.info(TAG, 'AutoFill_NewPassWordTextInput_003_newPassWordInfo', newPassWordInfo);
      expect(newPassWordInfo).assertEqual('******');
      Logger.info(TAG, 'AutoFill_NewPassWordTextInput_003 end');
      await driver.pressBack();
      done();
    })

    /*
    * @tc.number: AutoFill_ManualSave_004
    * @tc.name: The user actively calls the save interface
    * @tc.desc: The user actively calls the save interface
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it('AutoFill_ManualSave_004', 0, async (done: Function) => {
      Logger.info(TAG, 'AutoFill_ManualSave_004 start');
      let driver = Driver.create();
      await driver.delayMs(2000);
      let registerNowBtn = await driver.findComponent(
        ON.id("registerNowBtn"));
      await driver.delayMs(500);
      await registerNowBtn.click();
      await driver.delayMs(1000);
      let savePage = await driver.findComponent(ON.id('Save'));
      await driver.delayMs(1000);
      await expect(savePage != null).assertTrue();
      done();
    })

    /*
    * @tc.number: AutoFill_AutoSave_005
    * @tc.name: The page is automatically saved when it disappears
    * @tc.desc: The page is automatically saved when it disappears
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it('AutoFill_AutoSave_005', 0, async (done: Function) => {
      Logger.info(TAG, 'AutoFill_AutoSave_005 start');
      let driver = Driver.create();
      await driver.delayMs(1000);
      let loginBtn = await driver.findComponent(
        ON.id("login"));
      await driver.delayMs(500);
      await loginBtn.click();
      await driver.delayMs(500);
      let savePage = await driver.findComponent(ON.id('Save'));
      await driver.delayMs(1000);
      await expect(savePage != null).assertTrue();
      Logger.info(TAG, 'AutoFill_AutoSave_005 end');
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      done();
    })

    /*
    * @tc.number: AutoFill_UserNameTextInput_001
    * @tc.name: Click Enter Account input field
    * @tc.desc: Click Enter Account input field
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it('AutoFill_UserNameTextInput_001', 0, async (done: Function) => {
      Logger.info(TAG, 'AutoFill_UserNameTextInput_001 start');
      startAbility();
      let driver = Driver.create();
      await driver.delayMs(1000);
      let userNameTextInput = await driver.findComponent(
        ON.id("userName"));
      await driver.delayMs(1000);
      await userNameTextInput.click();
      await driver.delayMs(1000);
      let userNameColumn = await driver.findComponent(ON.id('second'));
      await driver.delayMs(1000);
      await userNameColumn.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      let userNameInfo = await userNameTextInput.getText();
      await driver.delayMs(1000);
      Logger.info(TAG, 'AutoFill_UserNameTextInput_001_userNameInfo', userNameInfo);
      expect(userNameInfo).assertEqual('user2');
      Logger.info(TAG, 'AutoFill_UserNameTextInput_001 end');
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      done();
    })

    /*
    * @tc.number: AutoFill_PassWordTextInput_002
    * @tc.name: Click Enter Password input field
    * @tc.desc: Click Enter Password input field
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it('AutoFill_PassWordTextInput_002', 0, async (done: Function) => {
      Logger.info(TAG, 'AutoFill_PassWordTextInput_002 start');
      startAbility();
      let driver = Driver.create();
      await driver.delayMs(1000);
      let passWordTextInput = await driver.findComponent(
        ON.id("passWord"));
      await driver.delayMs(1000);
      await passWordTextInput.click();
      await driver.delayMs(1000);
      let passWordColumn = await driver.findComponent(ON.id('third'));
      await driver.delayMs(1000);
      await passWordColumn.click();
      await driver.delayMs(1000);
      let passWordInfo = await passWordTextInput.getText();
      await driver.delayMs(500);
      Logger.info(TAG, 'AutoFill_PassWordTextInput_002_passWordInfo', passWordInfo);
      expect(passWordInfo).assertEqual('******');
      Logger.info(TAG, 'AutoFill_PassWordTextInput_002 end');
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      done();
    })
  })
}