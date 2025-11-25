/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@kit.TestKit';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const BUNDLE = 'NativeTransientTaskTest_';
const TAG = '[Sample_NativeTransientTask]';
const DOMAIN = 0xF811;

export default function abilityTest() {
  let driver: Driver = Driver.create();
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
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
     * 拉起应用 ohos.samples.nativetransienttask
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      console.info(TAG, `${BUNDLE}CameraAbility_StartAbility_001 start`);
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.nativetransienttask',
          abilityName: 'EntryAbility'
        })
        expect(true).assertTrue();
      } catch (exception) {
        console.info(TAG, `${BUNDLE}Failed to start ability, error info: ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      console.info(TAG, `${BUNDLE}StartAbility_001 end`);
      done();
    })

    /**
     * 判断起应用后，判断控件是否存在
     */
    it(BUNDLE + 'ComponentIfExist_001', 0, async (done: Function) => {
      console.info(TAG, `${BUNDLE}ComponentIfExist_001 start`);
      await driver.delayMs(1000);
      // 测试控件是否存在
      await driver.assertComponentExist(ON.id('transient_task_id'));
      await driver.assertComponentExist(ON.id('request_suspend_delay'));
      await driver.assertComponentExist(ON.id('get_remaining_delay_time'));
      await driver.assertComponentExist(ON.id('cancel_suspend_delay'));
      await driver.assertComponentExist(ON.id('get_transient_task_info'));
      expect(true).assertTrue();
      console.info(TAG, `${BUNDLE}ComponentIfExist_001 end`);
      done();
    })

    /**
     * 测试控件点击, 判断短时任务是否申请成功
     */
    it(BUNDLE + 'requestSuspendDelay_003', 0, async (done: Function) => {
      console.info(TAG, `${BUNDLE}requestSuspendDelay_003 start`);
      await driver.delayMs(1000);
      let taskIdAfter = '';
      let requestBtn = await driver.findComponent(ON.id('request_suspend_delay'));
      let taskId = await driver.findComponent(ON.id('transient_task_id'));
      await requestBtn.click();
      await driver.delayMs(1000);
      await taskId.getText().then(value => {
        taskIdAfter = value;
        console.info(TAG, `${BUNDLE}requestSuspendDelay_003 after requestBtn: ` + taskIdAfter);
      })
      if (taskIdAfter === '0') {
        expect(false).assertTrue();
      }
      expect(true).assertTrue();
      await driver.delayMs(1000);
      console.info(TAG, `${BUNDLE}requestSuspendDelay_003 end`);
      done();
    })
  })
}