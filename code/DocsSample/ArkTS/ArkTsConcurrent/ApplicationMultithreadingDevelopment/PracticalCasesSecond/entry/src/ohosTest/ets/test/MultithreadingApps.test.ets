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
import deviceInfo from '@ohos.deviceInfo';

const TAG = '[Sample_MultithreadingApps]';
const DOMAIN = 0xF811;
const BUNDLE = 'MultithreadingApps_';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let manager: resourceManager.ResourceManager;
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

export default function MultithreadingAppsTest() {
  describe('MultithreadingAppsTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      abilityDelegator.startAbility({
        bundleName: 'com.samples.multithreadingApps',
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
     * @tc.number MultithreadingApps_EnterPage_0001
     * @tc.name MultithreadingApps_EnterPage_0001
     * @tc.desc Enter MultithreadingApps page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('MultithreadingApps_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'MultithreadingApps_EnterPage_0001', // 测试用例名称
        '跳转到TaskPool指定任务并发度场景', // 按钮文本
        2000, // 延时 2000 毫秒
        'MultithreadingApps_EnterPage', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number MultithreadingApps_trigger_0001
     * @tc.name MultithreadingApps_trigger_0001
     * @tc.desc Trigger task
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('MultithreadingApps_trigger_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'MultithreadingApps_trigger_0001', // 测试用例名称
        '触发采集任务', // 按钮文本
        2000, // 延时 2000 毫秒
        'Trigger task', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number MultithreadingApps_EnterPage_0002
     * @tc.name MultithreadingApps_EnterPage_0002
     * @tc.desc Enter the last page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('MultithreadingApps_EnterPage_0002', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'MultithreadingApps_EnterPage_0002', // 测试用例名称
        '跳转回Index页面', // 按钮文本
        2000, // 延时 2000 毫秒
        'MultithreadingApps_EnterPage_0002', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number MultithreadingApps_EnterPage_0003
     * @tc.name MultithreadingApps_EnterPage_0003
     * @tc.desc Enter WaterFlowRender page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('MultithreadingApps_EnterPage_0003', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'MultithreadingApps_EnterPage_0003', // 测试用例名称
        '跳转到ArkUI瀑布流渲染场景', // 按钮文本
        2000, // 延时 2000 毫秒
        'Enter WaterFlowRender page', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number MultithreadingApps_EnterPage_0004
     * @tc.name MultithreadingApps_EnterPage_0004
     * @tc.desc Enter the last page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('MultithreadingApps_EnterPage_0004', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'MultithreadingApps_EnterPage_0004', // 测试用例名称
        '跳转回Index页面', // 按钮文本
        2000, // 延时 2000 毫秒
        'MultithreadingApps_EnterPage_0004', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number MultithreadingApps_EnterPage_0005
     * @tc.name MultithreadingApps_EnterPage_0005
     * @tc.desc Enter RecentList page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('MultithreadingApps_EnterPage_0005', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'MultithreadingApps_EnterPage_0005', // 测试用例名称
        '跳转到获取最近访问列表场景', // 按钮文本
        2000, // 延时 2000 毫秒
        'Enter RecentList page', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number MultithreadingApps_Visit_0001
     * @tc.name MultithreadingApps_Visit_0001
     * @tc.desc Visit the third book
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('MultithreadingApps_Visit_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'MultithreadingApps_Visit_0001', // 测试用例名称
        'third', // 按钮文本
        2000, // 延时 2000 毫秒
        'Visit the third book', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number MultithreadingApps_Back_0001
     * @tc.name MultithreadingApps_Back_0001
     * @tc.desc Enter the last page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('MultithreadingApps_Back_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'MultithreadingApps_Back_0001', // 测试用例名称
        '返回', // 按钮文本
        2000, // 延时 2000 毫秒
        'MultithreadingApps_Back_0001', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number MultithreadingApps_EnterPage_0006
     * @tc.name MultithreadingApps_EnterPage_0006
     * @tc.desc Enter the last page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('MultithreadingApps_EnterPage_0006', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'MultithreadingApps_EnterPage_0006', // 测试用例名称
        '跳转回Index页面', // 按钮文本
        2000, // 延时 2000 毫秒
        'MultithreadingApps_EnterPage_0006', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number MultithreadingApps_EnterPage_0007
     * @tc.name MultithreadingApps_EnterPage_0007
     * @tc.desc Cancel Taskpool
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('MultithreadingApps_EnterPage_0007', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'MultithreadingApps_EnterPage_0007', // 测试用例名称
        '跳转到多线程取消TaskPool任务场景', // 按钮文本
        2000, // 延时 2000 毫秒
        'Cancel Taskpool', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number MultithreadingApps_Cancel_Taskpool_0001
     * @tc.name MultithreadingApps_Cancel_Taskpool_0001
     * @tc.desc Cancel Taskpool
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('MultithreadingApps_Cancel_Taskpool_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'MultithreadingApps_Cancel_Taskpool_0001', // 测试用例名称
        'CancelTaskpool', // 按钮文本
        2000, // 延时 2000 毫秒
        'Cancel Taskpool', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number MultithreadingApps_EnterPage_0008
     * @tc.name MultithreadingApps_EnterPage_0008
     * @tc.desc Enter the last page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('MultithreadingApps_EnterPage_0008', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'MultithreadingApps_EnterPage_0008', // 测试用例名称
        '跳转回Index页面', // 按钮文本
        2000, // 延时 2000 毫秒
        'MultithreadingApps_EnterPage_0008', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number MultithreadingApps_EnterPage_0009
     * @tc.name MultithreadingApps_EnterPage_0009
     * @tc.desc Worker Concurrency
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('MultithreadingApps_EnterPage_0009', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'MultithreadingApps_EnterPage_0009', // 测试用例名称
        '跳转到Worker常驻线程并发处理场景', // 按钮文本
        2000, // 延时 2000 毫秒
        'Worker Concurrency', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number MultithreadingApps_Worker_0001
     * @tc.name MultithreadingApps_Worker_0001
     * @tc.desc Create Worker
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('MultithreadingApps_Worker_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'MultithreadingApps_Worker_0001', // 测试用例名称
        '在主线程中创建Worker线程并发送消息', // 按钮文本
        2000, // 延时 2000 毫秒
        'Create Worker', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number MultithreadingApps_EnterPage_0010
     * @tc.name MultithreadingApps_EnterPage_0010
     * @tc.desc Enter the last page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('MultithreadingApps_EnterPage_0010', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'MultithreadingApps_EnterPage_0010', // 测试用例名称
        '跳转回Index页面', // 按钮文本
        2000, // 延时 2000 毫秒
        'MultithreadingApps_EnterPage_0010', // 描述
        done // done 回调
      );
    })
  })
}