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

const TAG = '[arkRegexComplianceTest]';
const DOMAIN = 0xF815;
const BUNDLE = 'arkRegexComplianceTest_';
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

export default function arkRegexComplianceTest() {
  describe('arkRegexComplianceTest', () => {
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
     * @tc.number ArkRegexCompliance_EnterPage_0001
     * @tc.name ArkRegexCompliance_EnterPage_0001
     * @tc.desc Navigate to ArkTS runtime common issues page from main page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkRegexCompliance_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkRegexCompliance_EnterPage_0001',
        '运行时常见问题页面',
        5000,
        'Navigate to runtime common issues page',
        done
      );
    });

    /**
     * @tc.number ArkRegexCompliance_WordBoundary_0001
     * @tc.name ArkRegexCompliance_WordBoundary_0001
     * @tc.desc Test word boundary \b handling in Ark regex
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkRegexCompliance_WordBoundary_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkRegexCompliance_WordBoundary_0001',
        '测试边界处理',
        3000,
        'Test word boundary handling',
        done
      );
    });

    /**
     * @tc.number ArkRegexCompliance_LookbehindWithNestedLookahead_0001
     * @tc.name ArkRegexCompliance_LookbehindWithNestedLookahead_0001
     * @tc.desc Test lookahead nested inside lookbehind assertion
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkRegexCompliance_LookbehindWithNestedLookahead_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkRegexCompliance_LookbehindWithNestedLookahead_0001',
        '测试先行断言嵌套后行断言',
        3000,
        'Test lookbehind with nested lookahead',
        done
      );
    });

    /**
     * @tc.number ArkRegexCompliance_IgnoreCase_0001
     * @tc.name ArkRegexCompliance_IgnoreCase_0001
     * @tc.desc Test case insensitive matching with Unicode case folding
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkRegexCompliance_IgnoreCase_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkRegexCompliance_IgnoreCase_0001',
        '测试大小写忽略',
        3000,
        'Test ignore case with case folding',
        done
      );
    });

    /**
     * @tc.number ArkRegexCompliance_LastIndexEmptyGroup_0001
     * @tc.name ArkRegexCompliance_LastIndexEmptyGroup_0001
     * @tc.desc Test lastIndex behavior with empty group in global Unicode mode
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkRegexCompliance_LastIndexEmptyGroup_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkRegexCompliance_LastIndexEmptyGroup_0001',
        '测试最后索引与空组',
        3000,
        'Test lastIndex with empty group',
        done
      );
    });

    /**
     * @tc.number ArkRegexCompliance_HyphenInCharClass_0001
     * @tc.name ArkRegexCompliance_HyphenInCharClass_0001
     * @tc.desc Test hyphen handling in character class
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkRegexCompliance_HyphenInCharClass_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkRegexCompliance_HyphenInCharClass_0001',
        '测试字符类中连字符',
        3000,
        'Test hyphen in character class',
        done
      );
    });

    /**
     * @tc.number ArkRegexCompliance_NamedCaptureGroup_0001
     * @tc.name ArkRegexCompliance_NamedCaptureGroup_0001
     * @tc.desc Test named capture group access
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkRegexCompliance_NamedCaptureGroup_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkRegexCompliance_NamedCaptureGroup_0001',
        '测试具名捕获组访问',
        3000,
        'Test named capture group access',
        done
      );
    });

    /**
     * @tc.number ArkRegexCompliance_NamedCaptureGroupFallback_0001
     * @tc.name ArkRegexCompliance_NamedCaptureGroupFallback_0001
     * @tc.desc Test named capture group fallback workaround
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkRegexCompliance_NamedCaptureGroupFallback_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkRegexCompliance_NamedCaptureGroupFallback_0001',
        '测试具名捕获组规避方案',
        3000,
        'Test named capture group fallback',
        done
      );
    });

    /**
     * @tc.number ArkRegexCompliance_AlternationOperator_0001
     * @tc.name ArkRegexCompliance_AlternationOperator_0001
     * @tc.desc Test regex alternation operator with empty alternative
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkRegexCompliance_AlternationOperator_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkRegexCompliance_AlternationOperator_0001',
        '测试正则交替运算符',
        3000,
        'Test regex alternation operator',
        done
      );
    });

    /**
     * @tc.number ArkRegexCompliance_ReplaceEmptyString_0001
     * @tc.name ArkRegexCompliance_ReplaceEmptyString_0001
     * @tc.desc Test string replace with empty search value
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkRegexCompliance_ReplaceEmptyString_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkRegexCompliance_ReplaceEmptyString_0001',
        '测试替换空字符串',
        3000,
        'Test replace with empty string',
        done
      );
    });

    /**
     * @tc.number ArkRegexCompliance_AsyncErrorCapture_0001
     * @tc.name ArkRegexCompliance_AsyncErrorCapture_0001
     * @tc.desc Test async function error capture mechanism
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkRegexCompliance_AsyncErrorCapture_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkRegexCompliance_AsyncErrorCapture_0001',
        '测试异步错误捕获',
        3000,
        'Test async error capture',
        done
      );
    });

    /**
     * @tc.number ArkRegexCompliance_ArrayFlatMap_0001
     * @tc.name ArkRegexCompliance_ArrayFlatMap_0001
     * @tc.desc Test Array.flatMap() compliance issue with proxy objects
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkRegexCompliance_ArrayFlatMap_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkRegexCompliance_ArrayFlatMap_0001',
        '测试数组映射',
        3000,
        'Test Array.flatMap compliance',
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