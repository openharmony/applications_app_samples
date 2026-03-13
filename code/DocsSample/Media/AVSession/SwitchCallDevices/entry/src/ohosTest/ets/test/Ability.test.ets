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
import resourceManager from '@ohos.resourceManager';

const TAG = '[Sample_SwitchCallDevices]';
const DOMAIN = 0xF811;
const BUNDLE = 'SwitchCallDevices_';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const driver = Driver.create();

// 通用的测试函数
async function runTest(testCaseName: string, buttonText: string, delayTime: number, description: string,
  done: Function) {
  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, begin`);

  let btnAccept = await driver.findComponent(ON.text(buttonText));
  if (btnAccept !== undefined) {
    await btnAccept.click();
    await driver.delayMs(delayTime); // 等待操作完成
  }
  else {
    await driver.delayMs(delayTime);
  }

  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, end`);
  done(); // 测试完成
}

export default function SwitchCallDevicesTest() {
  describe('SwitchCallDevicesTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      abilityDelegator.startAbility({
        bundleName: 'com.samples.SwitchCallDevices',
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
     * @tc.number SwitchCallDevices_Start_0001
     * @tc.name SwitchCallDevices_Start_0001
     * @tc.desc Start Renderer
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SwitchCallDevices_Start_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'SwitchCallDevices_Start_0001', // 测试用例名称。
        '开始通话', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'SwitchCallDevices_Start', // 描述。
        done // done 回调
      );
    })

    /**
     * @tc.number SwitchCallDevices_SwitchOutput_0001
     * @tc.name SwitchCallDevices_SwitchOutput_0001
     * @tc.desc Switch output callDevices
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SwitchCallDevices_SwitchOutput_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'SwitchCallDevices_SwitchOutput_0001', // 测试用例名称。
        '切换通话输出设备', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'SwitchCallDevices_SwitchOutput', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number SwitchCallDevices_SwitchOutput_0002
     * @tc.name SwitchCallDevices_SwitchOutput_0002
     * @tc.desc Back
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SwitchCallDevices_SwitchOutput_0002', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'SwitchCallDevices_SwitchOutput_0002', // 测试用例名称。
        'back', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'SwitchCallDevices_SwitchOutput_0002', // 描述。
        done // done 回调
      );
    })

    /**
     * @tc.number SwitchCallDevices_SwitchInput_0001
     * @tc.name SwitchCallDevices_SwitchInput_0001
     * @tc.desc Switch input callDevices
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SwitchCallDevices_SwitchInput_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'SwitchCallDevices_SwitchInput_0001', // 测试用例名称。
        '切换通话输入设备', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'SwitchCallDevices_SwitchInput_0001', // 描述。
        done // done 回调。
      );
    })

    /**
     * @tc.number SwitchCallDevices_SwitchInput_0002
     * @tc.name SwitchCallDevices_SwitchInput_0002
     * @tc.desc Back
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SwitchCallDevices_SwitchInput_0002', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'SwitchCallDevices_SwitchInput_0002', // 测试用例名称。
        'back', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'SwitchCallDevices_SwitchInput', // 描述。
        done // done 回调
      );
    })

    /**
     * @tc.number SwitchCallDevices_Stop_0001
     * @tc.name SwitchCallDevices_Stop_0001
     * @tc.desc Stop Renderer
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SwitchCallDevices_Stop_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'SwitchCallDevices_Stop_0001', // 测试用例名称。
        '停止通话', // 按钮文本。
        2000, // 延时 2000 毫秒。
        'SwitchCallDevices_Stop', // 描述。
        done // done 回调
      );
    })
  })
}