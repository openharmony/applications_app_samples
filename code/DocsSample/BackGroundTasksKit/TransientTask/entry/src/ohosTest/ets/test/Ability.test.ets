/*
 * Copyright (c) 2023-2025 Huawei Device Co., Ltd.
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
import { Driver, ON, Component } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Want } from '@kit.AbilityKit';
import Logger from '../../../main/ets/util/Logger';
import { resourceManager } from '@kit.LocalizationKit';

const BUNDLE = 'TransientTaskTest_';
const TAG = '[Sample_TransientTask]';
const DOMAIN = 0xF811;

export default function abilityTest() {
  let delegator = AbilityDelegatorRegistry.getAbilityDelegator();
  let driver: Driver = Driver.create();
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'beforeAll start');
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'afterEach start');
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'afterAll start');
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    /**
     * 拉起应用 com.samples.transienttask
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}CameraAbility_StartAbility_001 start`);
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.transienttask',
          abilityName: 'EntryAbility'
        })
        expect(true).assertTrue();
      } catch (exception) {
        Logger.info(TAG, `${BUNDLE}Failed to start ability, error info: ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE}StartAbility_001 end`);
      done();
    })

    /**
     * 判断起应用后，判断控件是否存在
     */
    it(BUNDLE + 'ComponentIfExist_001', 0, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}ComponentIfExist_001 start`);
      await driver.delayMs(1000);
      // 测试控件是否存在
      await driver.assertComponentExist(ON.id('transient_task_id'));
      await driver.assertComponentExist(ON.id('request_suspend_delay'));
      await driver.assertComponentExist(ON.id('get_remaining_delay_time'));
      await driver.assertComponentExist(ON.id('cancel_suspend_delay'));
      expect(true).assertTrue();
      Logger.info(TAG, `${BUNDLE}ComponentIfExist_001 end`);
      done();
    })

    /**
     * 测试控件点击, 判断短时任务是否申请成功
     */
    it(BUNDLE + 'requestSuspendDelay_003', 0, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}requestSuspendDelay_003 start`);
      await driver.delayMs(1000);
      let taskIdAfter = '';
      let requestBtn = await driver.findComponent(ON.id('request_suspend_delay'));
      let taskId = await driver.findComponent(ON.id('transient_task_id'));
      await requestBtn.click();
      await driver.delayMs(1000);
      await taskId.getText().then(value => {
        taskIdAfter = value;
        Logger.info(TAG, `${BUNDLE}requestSuspendDelay_003 after requestBtn: ` + taskIdAfter);
      })
      if (taskIdAfter === '0') {
        expect(false).assertTrue();
      }
      expect(true).assertTrue();
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE}requestSuspendDelay_003 end`);
      done();
    })

    /**
     * 测试控件点击, 判断短时任务是否最多申请三次
     */
    it(BUNDLE + 'requestSuspendDelay_004', 0, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}requestSuspendDelay_004 start`);
      // 取消短时任务
      let cancelBtn = await driver.findComponent(ON.id('cancel_suspend_delay'));
      await cancelBtn.click();
      await driver.delayMs(1000);
      let taskIdBefore = '';
      let taskIdAfter = '';
      let taskId = await driver.findComponent(ON.id('transient_task_id'));
      await taskId.getText().then(value => {
        taskIdBefore = value;
        Logger.info(TAG, `${BUNDLE}requestSuspendDelay_004 before requestBtn: ` + taskIdBefore);
      })
      // 申请短时任务
      let requestBtn = await driver.findComponent(ON.id('request_suspend_delay'));
      for (let i = 0; i < 4; i++) {
        await requestBtn.click();
        await driver.delayMs(1000);
      }
      await taskId.getText().then(value => {
        taskIdAfter = value;
        Logger.info(TAG, `${BUNDLE}requestSuspendDelay_004 after requestBtn: ` + taskIdAfter);
      })
      await driver.delayMs(1000);
      // 判断短时任务是否最多可申请3次
      taskIdBefore = (parseInt(taskIdBefore, 10) + 3).toString();
      if (taskIdAfter != taskIdBefore) {
        expect(false).assertTrue();
      }
      expect(true).assertTrue();
      Logger.info(TAG, `${BUNDLE}requestSuspendDelay_004 end`);
      done();
    })

    /**
     * 测试控件点击, 获取短时任务剩余时间
     */
    it(BUNDLE + 'requestSuspendDelay_005', 0, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}requestSuspendDelay_005 start`);
      // 取消短时任务
      let cancelBtn = await driver.findComponent(ON.id('cancel_suspend_delay'));
      await cancelBtn.click();
      await driver.delayMs(1000);
      // 申请短时任务
      let requestBtn = await driver.findComponent(ON.id('request_suspend_delay'));
      await requestBtn.click();
      await driver.delayMs(1000);
      // 获取短时任务剩余时间
      let getTimeBtn = await driver.findComponent(ON.id('get_remaining_delay_time'));
      await getTimeBtn.click();
      await driver.delayMs(1000);
      expect(true).assertTrue();
      Logger.info(TAG, `${BUNDLE}requestSuspendDelay_005 end`);
      done();
    })

    /**
     * 测试控件点击, 取消短时任务
     */
    it(BUNDLE + 'requestSuspendDelay_006', 0, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}requestSuspendDelay_006 start`);
      // 取消短时任务
      let cancelBtn = await driver.findComponent(ON.id('cancel_suspend_delay'));
      await cancelBtn.click();
      await driver.delayMs(1000);
      expect(true).assertTrue();
      Logger.info(TAG, `${BUNDLE}requestSuspendDelay_006 end`);
      done();
    })
  })
}