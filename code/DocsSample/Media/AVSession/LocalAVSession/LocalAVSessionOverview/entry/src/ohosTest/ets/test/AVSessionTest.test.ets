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

const TAG = '[AVSessionTest]';
const DOMAIN = 0xF817;
const BUNDLE = 'AVSessionTest_';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const driver = Driver.create();

async function runTest(testCaseName: string, textToFind: string, delayTime: number, description: string,
  done: Function) {
  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, begin`);

  let element = await driver.findComponent(ON.text(textToFind));
  if (element !== undefined) {
    await element.click();
    await driver.delayMs(delayTime);
    hilog.info(DOMAIN, TAG, BUNDLE + `Clicked on "${textToFind}" successfully`);
  } else {
    hilog.warn(DOMAIN, TAG, BUNDLE + `Element "${textToFind}" not found, still waiting...`);
    await driver.delayMs(delayTime);
  }

  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, end`);
  done();
}

export default function avSessionTest() {
  describe('AVSessionTest', () => {
    beforeAll(() => {
      abilityDelegator.startAbility({
        bundleName: 'com.samples.LocalAVSessionOverview',
        abilityName: 'EntryAbility'
      });
    });

    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})

    /**
     * @tc.number AVSession_ClickText_0001
     * @tc.name AVSession_ClickText_0001
     * @tc.desc Find and click the "hello world" text to trigger AVSession creation
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AVSession_ClickText_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AVSession_ClickText_0001',
        'hello world',
        3000,
        'Click text to create AVSession',
        done
      );
    });
  });
}
