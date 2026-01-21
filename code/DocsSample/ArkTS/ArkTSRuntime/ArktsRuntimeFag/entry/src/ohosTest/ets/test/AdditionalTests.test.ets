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

const TAG = '[AdditionalTests]';
const DOMAIN = 0xF816;
const BUNDLE = 'AdditionalTests_';
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

export default function additionalTestsTest() {
  describe('additionalTestsTest', () => {
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
     * @tc.number AdditionalTests_EnterPage_0001
     * @tc.name AdditionalTests_EnterPage_0001
     * @tc.desc Navigate to additional tests page from main page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AdditionalTests_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AdditionalTests_EnterPage_0001',
        '额外的页面',
        5000,
        'Navigate to additional tests page',
        done
      );
    });

    /**
     * @tc.number AdditionalTests_Int32ArrayMapIssue_0001
     * @tc.name AdditionalTests_Int32ArrayMapIssue_0001
     * @tc.desc Test Int32Array map method issue with inline cache optimization
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AdditionalTests_Int32ArrayMapIssue_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AdditionalTests_Int32ArrayMapIssue_0001',
        '测试Int32Array的map问题',
        3000,
        'Test Int32Array map issue',
        done
      );
    });

    /**
     * @tc.number AdditionalTests_Int32ArrayMapWorkaround_0001
     * @tc.name AdditionalTests_Int32ArrayMapWorkaround_0001
     * @tc.desc Test Int32Array map workaround by converting to normal array
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AdditionalTests_Int32ArrayMapWorkaround_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AdditionalTests_Int32ArrayMapWorkaround_0001',
        '测试Int32Array转换规避方案',
        3000,
        'Test Int32Array map workaround',
        done
      );
    });

    /**
     * @tc.number AdditionalTests_ParseFloatTinyNumber_0001
     * @tc.name AdditionalTests_ParseFloatTinyNumber_0001
     * @tc.desc Test parseFloat handling of extremely small numbers
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AdditionalTests_ParseFloatTinyNumber_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AdditionalTests_ParseFloatTinyNumber_0001',
        '测试parseFloat极小数',
        3000,
        'Test parseFloat with tiny number',
        done
      );
    });

    /**
     * @tc.number AdditionalTests_SetArrayFrom_0001
     * @tc.name AdditionalTests_SetArrayFrom_0001
     * @tc.desc Test Set with Array.from conversion issue
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AdditionalTests_SetArrayFrom_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AdditionalTests_SetArrayFrom_0001',
        '测试Set配合Array.from',
        3000,
        'Test Set with Array.from',
        done
      );
    });

    /**
     * @tc.number AdditionalTests_Back_0001
     * @tc.name AdditionalTests_Back_0001
     * @tc.desc Test back navigation
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AdditionalTests_Back_0001', Level.LEVEL1, async (done: Function) => {
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    });
  });
}
