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

const TAG = '[ParsingNestedQuotationMarksTest]';
const DOMAIN = 0xF815;
const BUNDLE = 'ParsingNestedQuotationMarksTest_';
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

export default function ParsingNestedQuotationMarksTest() {
  describe('ParsingNestedQuotationMarksTest', () => {
    beforeAll(() => {
      abilityDelegator.startAbility({
        bundleName: 'com.samples.JsonExtensionLibrary',
        abilityName: 'EntryAbility'
      });
    });

    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})

    /**
     * @tc.number ParsingNestedQuotes_EnterPage_0001
     * @tc.name ParsingNestedQuotes_EnterPage_0001
     * @tc.desc Navigate to parsing nested quotation marks page from main page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ParsingNestedQuotes_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ParsingNestedQuotes_EnterPage_0001',
        '解析包含嵌套引号的JSON字符串场景',
        5000,
        'Navigate to parsing nested quotes page',
        done
      );
    });

    /**
     * @tc.number ParsingNestedQuotes_Method1_0001
     * @tc.name ParsingNestedQuotes_Method1_0001
     * @tc.desc Test parsing nested quotes JSON string with method 1
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ParsingNestedQuotes_Method1_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ParsingNestedQuotes_Method1_0001',
        '测试解析包含嵌套引号的JSON字符串场景, 方式1',
        3000,
        'Test parsing nested quotes method 1',
        done
      );
    });

    /**
     * @tc.number ParsingNestedQuotes_Method2_0001
     * @tc.name ParsingNestedQuotes_Method2_0001
     * @tc.desc Test parsing nested quotes JSON string with method 2
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ParsingNestedQuotes_Method2_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ParsingNestedQuotes_Method2_0001',
        '测试解析包含嵌套引号的JSON字符串场景, 方式2',
        3000,
        'Test parsing nested quotes method 2',
        done
      );
    });

    /**
     * @tc.number Decorator_Back_0001
     * @tc.name Decorator_EnterPage_0001
     * @tc.desc Test back
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Decorator_Back_0001', Level.LEVEL1, async (done: Function) => {
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    });
  });
}