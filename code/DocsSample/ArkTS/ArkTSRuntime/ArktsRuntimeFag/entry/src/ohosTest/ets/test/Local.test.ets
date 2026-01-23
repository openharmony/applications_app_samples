/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, Level } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const TAG = '[localTest]';
const DOMAIN = 0xF816;
const BUNDLE = 'localTest_';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const driver = Driver.create();

async function runTest(testCaseName: string, buttonText: string, delayTime: number, description: string,
  done: Function) {
  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, begin`);

  let btn = await driver.findComponent(ON.text(buttonText));
  if (btn !== undefined) {
    await btn.click();
    await driver.delayMs(delayTime);
  } else {
    hilog.warn(DOMAIN, TAG, BUNDLE + `Button "${buttonText}" not found, still waiting...`);
    await driver.delayMs(delayTime);
  }

  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, end`);
  done();
}

export default function localTest() {
  describe('localTest', () => {
    beforeAll(() => {
      abilityDelegator.startAbility({
        bundleName: 'com.sample.ArktsRuntimeFag',
        abilityName: 'EntryAbility'
      });
    });

    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})

    /**
     * @tc.number Local_EnterPage_0001
     * @tc.name Local_EnterPage_0001
     * @tc.desc Navigate to ArkTS runtime UI page from main page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Local_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Local_EnterPage_0001',
        '状态变量装饰器页面',
        5000,
        'Navigate to runtime UI page',
        done
      );
    });

    /**
     * @tc.number ArkRegexCompliance_Back_0001
     * @tc.name ArkRegexCompliance_Back_0001
     * @tc.desc Test back
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkRegexCompliance_Back_0001', Level.LEVEL1, async (done: Function) => {
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    });
  });
}