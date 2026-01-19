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
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import resourceManager from '@ohos.resourceManager';
import inputMethod from '@ohos.inputMethod'

const TAG = '[Sample_CodeObfuscationIssues]';
const DOMAIN = 0xF811;
const BUNDLE = 'CodeObfuscationIssues_';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let manager: resourceManager.ResourceManager;
const driver = Driver.create();

// 通用的测试函数。
async function runTest(testCaseName: string, buttonText: string, delayTime: number, description: string,
  done: Function) {
  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, begin`);

  let btnAccept = await driver.findComponent(ON.text(buttonText));
  if (btnAccept !== undefined) {
    await btnAccept.click();
    await driver.delayMs(delayTime); // 等待操作完成。
  }
  else {
    await driver.delayMs(delayTime);
  }

  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, end`);
  done(); // 测试完成。
}

export default function ObfuscationTest() {
  describe('ObfuscationTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      abilityDelegator.startAbility({
        bundleName: 'com.samples.CodeObfuscationIssues',
        abilityName: 'EntryAbility'
      });
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    /**
     * @tc.number Obfuscation_TestObjObfuscation_0001
     * @tc.name Obfuscation_TestObjObfuscation_0001
     * @tc.desc Test Object Obfuscation
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Obfuscation_TestObjObfuscation_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Obfuscation_TestObjObfuscation_0001', // 测试用例名称。
        '测试对象字节码混淆', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Obfuscation_TestObjObfuscation_0001', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Obfuscation_TestPropertyObfuscation_0001
     * @tc.name Obfuscation_TestPropertyObfuscation_0001
     * @tc.desc Test Property Obfuscation
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Obfuscation_TestPropertyObfuscation_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Obfuscation_TestPropertyObfuscation_0001', // 测试用例名称。
        '测试属性字节码混淆', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Obfuscation_TestPropertyObfuscation_0001', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Obfuscation_LoadAndUseAdd_0001
     * @tc.name Obfuscation_LoadAndUseAdd_0001
     * @tc.desc Test Load And Use Add
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Obfuscation_LoadAndUseAdd_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Obfuscation_LoadAndUseAdd_0001', // 测试用例名称。
        '测试外源函数', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Obfuscation_LoadAndUseAdd_0001', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Obfuscation_TestExportNamespace_0001
     * @tc.name Obfuscation_TestExportNamespace_0001
     * @tc.desc Test Export Namespace
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Obfuscation_TestExportNamespace_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Obfuscation_TestExportNamespace_0001', // 测试用例名称。
        '测试外源命名空间', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Obfuscation_TestExportNamespace_0001', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Obfuscation_TestLibentryAdd_0001
     * @tc.name Obfuscation_TestLibentryAdd_0001
     * @tc.desc Test Napi
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Obfuscation_TestLibentryAdd_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Obfuscation_TestLibentryAdd_0001', // 测试用例名称。
        '测试Napi', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Obfuscation_TestLibentryAdd_0001', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number Obfuscation_TestHsp_0001
     * @tc.name Obfuscation_TestHsp_0001
     * @tc.desc Test Hsp
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Obfuscation_TestHsp_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Obfuscation_TestHsp_0001', // 测试用例名称。
        '测试Napi', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'Obfuscation_TestHsp_0001', // 描述。
        done // done 回调。
      );
    })
  })
}