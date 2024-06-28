/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

function sleep(time: number): Promise<number> {
  return new Promise((resolve) => setTimeout(resolve, time));
}

const TAG = 'Sample_AutoFillTest';
const DOMAIN_NUMBER: number = 0xFF00;
const abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let resourceManager = abilityDelegator.getAppContext().resourceManager;

async function startAbility() {
  hilog.info(DOMAIN_NUMBER, TAG, 'StartAbility start');
  let want: Want = {
    bundleName: 'com.ohos.textautofill',
    abilityName: 'EntryAbility'
  };
  hilog.info(DOMAIN_NUMBER, TAG, 'getAbilityDelegator end');
  await abilityDelegator.startAbility(want).then(() => {
    hilog.info(DOMAIN_NUMBER, TAG, 'StartAbility successfully.');
  }).catch((err: BusinessError) => {
    hilog.error(DOMAIN_NUMBER, TAG, 'StartAbility err: ' + err.code);
  })
}

export default function abilityTest() {
  describe('AutoFillSampleTest', async () => {
    /*
     * @tc.number: AutoFillSampleContentTypeTest_0100
     * @tc.name: Verify the contentType of textInput
     * @tc.desc: Verify the contentType of textInput
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('AutoFillSampleContentTypeTest_0100', 0, async (done: Function) => {
      startAbility();
      hilog.info(DOMAIN_NUMBER, TAG, 'Start');
      await sleep(2000);
      let baseId = 'password1';
      let strJson = getInspectorByKey(baseId);
      expect(JSON.parse(strJson).$attrs.contentType).assertEqual('TextContentType.FULL_PHONE_NUMBER');
      hilog.info(DOMAIN_NUMBER, TAG, 'End');
      done();
    })

    /*
     * @tc.number: AutoFillSampleContentTypeTest_0200
     * @tc.name: Verify the contentType of textInput
     * @tc.desc: Verify the contentType of textInput
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('AutoFillSampleContentTypeTest_0200', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'Start');
      await sleep(2000);
      let baseId = 'password3';
      let strJson = getInspectorByKey(baseId);
      expect(JSON.parse(strJson).$attrs.contentType).assertEqual('TextContentType.PERSON_FULL_NAME');
      hilog.info(DOMAIN_NUMBER, TAG, 'End');
      await sleep(1000);
      done();
    })

    /*
     * @tc.number: AutoFillSampleManualSaveTest_0100
     * @tc.name: Verify that the manual save is successful
     * @tc.desc: Verify that the manual save is successful
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('AutoFillSampleManualSaveTest_0100', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'AutoFillSampleManualSaveTest_0100 start');
      let driver = Driver.create();
      await driver.delayMs(1000);
      let text = await driver.findComponent(ON.type('TextInput'));
      await driver.delayMs(500);
      let point = await text.getBoundsCenter();
      await driver.delayMs(1000);
      await driver.inputText(point, '123');
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      let saveBtn = await driver.findComponent(ON.id('save'));
      await driver.delayMs(1000);
      await saveBtn.click();
      hilog.info(DOMAIN_NUMBER, TAG, 'save clicked');
      await driver.delayMs(2000);
      let saveBtn1 = await driver.findComponent(ON.id('saveOnly'));
      await driver.delayMs(1000);
      await saveBtn1.click();
      hilog.info(DOMAIN_NUMBER, TAG, 'saveBtn1 clicked');
      await driver.delayMs(1000);
      let typeSetting = await driver.findComponent(ON.text(
        await resourceManager.getStringValue($r('app.string.settingTypeTest'))
      ));
      expect(typeSetting != null).assertTrue();
      done();
    })

    /*
     * @tc.number: AutoFillSampleAutoSaveTest_0100
     * @tc.name: Verify that the auto-save is successful
     * @tc.desc: Verify that the auto-save is successful
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('AutoFillSampleAutoSaveTest_0100', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'AutoFillSampleAutoSaveTest_0100 start');
      let driver = Driver.create();
      await driver.delayMs(1000);
      let saveBtn = await driver.findComponent(ON.id('changInterface'));
      await driver.delayMs(1000);
      await saveBtn.click();
      await driver.delayMs(2000);
      let saveOnlyBtn = await driver.findComponent(ON.id('saveOnly'));
      await driver.delayMs(1000);
      await saveOnlyBtn.click();
      await driver.delayMs(500);
      let backMain = await driver.findComponent(ON.text(
        await resourceManager.getStringValue($r('app.string.returnMainPageTest'))
      ));
      await driver.delayMs(1000);
      expect(backMain != null).assertTrue();
      await driver.pressBack();
      await driver.delayMs(500);
      done();
    })
  })
}