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

const TAG = '[ParsingTagsAndValuesTest]';
const DOMAIN = 0xF815;
const BUNDLE = 'ParsingTagsAndValuesTest_';
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

export default function ParsingTagsAndValuesTest() {
  describe('ParsingTagsAndValuesTest', () => {
    beforeAll(() => {
      abilityDelegator.startAbility({
        bundleName: 'com.samples.XmlParsing',
        abilityName: 'EntryAbility'
      });
    });

    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})

    /**
     * @tc.number ParsingTagsAndValues_EnterPage_0001
     * @tc.name ParsingTagsAndValues_EnterPage_0001
     * @tc.desc Navigate to parsing tags and values page from main page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ParsingTagsAndValues_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ParsingTagsAndValues_EnterPage_0001',
        '解析XML标签和标签值',
        3000,
        'Navigate to parsing tags and values page',
        done
      );
    });

    /**
     * @tc.number ParsingTagsAndValues_TestParsing_0001
     * @tc.name ParsingTagsAndValues_TestParsing_0001
     * @tc.desc Test parsing XML tags and values functionality
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ParsingTagsAndValues_TestParsing_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ParsingTagsAndValues_TestParsing_0001',
        '测试解析XML标签和标签值',
        3000,
        'Test parsing XML tags and values',
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
