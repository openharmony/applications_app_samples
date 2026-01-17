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

const TAG = '[ArkTSHighPerformanceTest]';
const DOMAIN = 0xF815;
const BUNDLE = 'ArkTSHighPerformanceTest_';
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
    hilog.warn(DOMAIN, TAG, BUNDLE + `Button '${buttonText}' not found, still waiting...`);
    await driver.delayMs(delayTime);
  }

  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, end`);
  done();
}

export default function ArkTSHighPerformanceTest() {
  describe('ArkTSHighPerformanceTest', () => {
    beforeAll(() => {
      abilityDelegator.startAbility({
        bundleName: 'com.samples.PerformantPractices',
        abilityName: 'EntryAbility'
      });
    });

    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})

    /**
     * @tc.number ArkTSHighPerformance_VariableDefinition_0001
     * @tc.name ArkTSHighPerformance_VariableDefinition_0001
     * @tc.desc Test use const to declare immutable variables and number type variables
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSHighPerformance_VariableDefinition_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSHighPerformance_VariableDefinition_0001',
        '高性能编程-声明与表达式',
        3000,
        'Test variable declaration',
        done
      );
    });

    /**
     * @tc.number ArkTSHighPerformance_VariablesInLoop_0001
     * @tc.name ArkTSHighPerformance_VariablesInLoop_0001
     * @tc.desc Test constant extraction in the loop reduces the number of attribute accesses
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSHighPerformance_VariablesInLoop_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSHighPerformance_VariablesInLoop_0001',
        '高性能编程-循环中常量',
        3000,
        'Test variables in loop',
        done
      );
    });

    /**
     * @tc.number ArkTSHighPerformance_VariableOutsideFunction_0001
     * @tc.name ArkTSHighPerformance_VariableOutsideFunction_0001
     * @tc.desc Test function overloading with different parameter types
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSHighPerformance_VariableOutsideFunction_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSHighPerformance_VariableOutsideFunction_0001',
        '高性能编程-函数外变量',
        3000,
        'Test variables outside the function',
        done
      );
    });

    /**
     * @tc.number ArkTSHighPerformance_OptionalParameters_0001
     * @tc.name ArkTSHighPerformance_OptionalParameters_0001
     * @tc.desc Test avoid using optional parameters
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSHighPerformance_OptionalParameters_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSHighPerformance_OptionalParameters_0001',
        '高性能编程-可选参数',
        3000,
        'Test optional parameters',
        done
      );
    });

    /**
     * @tc.number ArkTSHighPerformance_TypeArray_0001
     * @tc.name ArkTSHighPerformance_TypeArray_0001
     * @tc.desc Test use type array
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSHighPerformance_TypeArray_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSHighPerformance_TypeArray_0001',
        '高性能编程-类型数组',
        3000,
        'Test use type array',
        done
      );
    });

    /**
     * @tc.number ArkTSHighPerformance_SparseArray_0001
     * @tc.name ArkTSHighPerformance_SparseArray_0001
     * @tc.desc Test avoid using sparse arrays
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSHighPerformance_SparseArray_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSHighPerformance_SparseArray_0001',
        '高性能编程-稀疏数组',
        3000,
        'Test sparse arrays',
        done
      );
    });

    /**
     * @tc.number ArkTSHighPerformance_AssociativeTypeArrays_0001
     * @tc.name ArkTSHighPerformance_AssociativeTypeArrays_0001
     * @tc.desc Test avoid using associative type arrays
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSHighPerformance_AssociativeTypeArrays_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSHighPerformance_AssociativeTypeArrays_0001',
        '高性能编程-联合类型数组',
        3000,
        'Test associative type arrays',
        done
      );
    });

    /**
     * @tc.number ArkTSHighPerformance_ExceptionThrown_0001
     * @tc.name ArkTSHighPerformance_ExceptionThrown_0001
     * @tc.desc Test avoid frequently throwing exceptions
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('ArkTSHighPerformance_ExceptionThrown_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'ArkTSHighPerformance_ExceptionThrown_0001',
        '高性能编程-避免频繁异常',
        3000,
        'Test exception thrown',
        done
      );
    });
  });
}