/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import { describe, it, expect } from '@ohos/hypium';
import { BusinessError } from '@kit.BasicServicesKit';
import { Want } from '@kit.AbilityKit';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = '[Sample_AutoFillTest]';
const DOMAIN_NUMBER: number = 0xFF00;
const abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let resourceManager = abilityDelegator.getAppContext().resourceManager;

function startAbility() {
  hilog.info(DOMAIN_NUMBER, TAG, 'StartAbility start');
  let want: Want = {
    bundleName: 'com.ohos.passwordbox',
    abilityName: 'EntryAbility'
  };
  hilog.info(DOMAIN_NUMBER, TAG, 'getAbilityDelegator end');
  abilityDelegator.startAbility(want, (err: BusinessError) => {
    hilog.info(DOMAIN_NUMBER, TAG, 'StartAbility get err ' + JSON.stringify(err));
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
      hilog.info(DOMAIN_NUMBER, TAG, 'AutoFill_NewPassWordTextInput_003 start');
      startAbility();
      let driver = Driver.create();
      await driver.delayMs(2000);
      let registerBtn = await driver.findComponent(
        ON.id("register"));
      await driver.delayMs(1000);
      await registerBtn.click();
      await driver.delayMs(1000);
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
      hilog.info(DOMAIN_NUMBER, TAG, 'AutoFill_NewPassWordTextInput_003_newPassWordInfo', newPassWordInfo);
      expect(newPassWordInfo).assertEqual('******');
      hilog.info(DOMAIN_NUMBER, TAG, 'AutoFill_NewPassWordTextInput_003 end');
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
      hilog.info(DOMAIN_NUMBER, TAG, 'AutoFill_ManualSave_004 start');
      let driver = Driver.create();
      await driver.delayMs(2000);
      let registerNowBtn = await driver.findComponent(
        ON.id("registerNowBtn"));
      await driver.delayMs(500);
      await registerNowBtn.click();
      await driver.delayMs(2000);
      let confirmBtn = await driver.findComponent(ON.id("saveConfirm"));
      await driver.delayMs(1000);
      await confirmBtn.click();
      await driver.delayMs(500);
      let savePage = await driver.findComponent(ON.text(
        await resourceManager.getStringValue($r('app.string.loginTest'))
      ));
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
      hilog.info(DOMAIN_NUMBER, TAG, 'AutoFill_AutoSave_005 start');
      let driver = Driver.create();
      await driver.delayMs(1000);
      let loginBtn = await driver.findComponent(
        ON.id("login"));
      await driver.delayMs(500);
      await loginBtn.click();
      await driver.delayMs(1000);
      let confirmBtn = await driver.findComponent(ON.id("saveConfirm"));
      await driver.delayMs(1000);
      await confirmBtn.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      let savePage = await driver.findComponent(ON.text(
        await resourceManager.getStringValue($r('app.string.loginTest'))
      ));
      await driver.delayMs(1000);
      await expect(savePage != null).assertTrue();
      hilog.info(DOMAIN_NUMBER, TAG, 'AutoFill_AutoSave_005 end');
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
  })
}