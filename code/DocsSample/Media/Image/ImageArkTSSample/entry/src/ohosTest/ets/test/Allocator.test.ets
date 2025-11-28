/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
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

const TAG = '[Sample_Allocator]';
const DOMAIN = 0xF811;
const BUNDLE = 'Allocator_';
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

export default function AllocatorTest() {
  describe('AllocatorTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      abilityDelegator.startAbility({
        bundleName: 'com.sample.jsImage',
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

    // 单独运行该测试套时将获取权限的按钮解开
    // /**
    //  * @tc.number Allocator_GetAccess_0001
    //  * @tc.name Allocator_GetAccess_0001
    //  * @tc.desc Request camera permissions
    //  * @tc.size MediumTest
    //  * @tc.type Function
    //  * @tc.level Level 1
    //  */
    // it('Allocator_GetAccess_0001', Level.LEVEL1, async (done: Function) => {
    //   await runTest(
    //     'Allocator_GetAccess_0001', // 测试用例名称
    //     '允许', // 按钮文本
    //     2000, // 延时 2000 毫秒
    //     'GetAccess_0001', // 描述
    //     done // done 回调
    //   );
    // })
    //
    // /**
    //  * @tc.number Allocator_GetAccess_0002
    //  * @tc.name Allocator_GetAccess_0002
    //  * @tc.desc Request microphone permission
    //  * @tc.size MediumTest
    //  * @tc.type Function
    //  * @tc.level Level 1
    //  */
    // it('Allocator_GetAccess_0002', Level.LEVEL1, async (done: Function) => {
    //   await runTest(
    //     'Allocator_GetAccess_0002', // 测试用例名称
    //     '允许', // 按钮文本
    //     2000, // 延时 2000 毫秒
    //     'GetAccess_0002', // 描述
    //     done // done 回调
    //   );
    // })
    //
    // /**
    //  * @tc.number Allocator_GetAccess_0003
    //  * @tc.name Allocator_GetAccess_0003
    //  * @tc.desc Request media permission
    //  * @tc.size MediumTest
    //  * @tc.type Function
    //  * @tc.level Level 1
    //  */
    // it('Allocator_GetAccess_0003', Level.LEVEL1, async (done: Function) => {
    //   await runTest(
    //     'Allocator_GetAccess_0003', // 测试用例名称
    //     '允许', // 按钮文本
    //     2000, // 延时 2000 毫秒
    //     'GetAccess_0003', // 描述
    //     done // done 回调
    //   );
    // })
    //
    // /**
    //  * @tc.number Allocator_GetAccess_0004
    //  * @tc.name Allocator_GetAccess_0004
    //  * @tc.desc Request file permission
    //  * @tc.size MediumTest
    //  * @tc.type Function
    //  * @tc.level Level 1
    //  */
    // it('Allocator_GetAccess_0004', Level.LEVEL1, async (done: Function) => {
    //   await runTest(
    //     'Allocator_GetAccess_0004', // 测试用例名称
    //     '允许', // 按钮文本
    //     2000, // 延时 2000 毫秒
    //     'GetAccess_0004', // 描述
    //     done // done 回调
    //   );
    // })

    /**
     * @tc.number Allocator_EnterPage_0001
     * @tc.name Allocator_EnterPage_0001
     * @tc.desc Enter allocator page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Allocator_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Allocator_EnterPage_0001', // 测试用例名称
        '跳转到内存申请页面', // 按钮文本
        2000, // 延时 2000 毫秒
        'Allocator_EnterPage', // 描述
        done // done 回调
      );
    })

    // 选择DMA方式申请内存解码图片
    /**
     * @tc.number Allocator_DMA_0001
     * @tc.name Allocator_DMA_0001
     * @tc.desc Select DMA method to apply for memory for decoding
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Allocator_DMA_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Allocator_DMA_0001', // 测试用例名称
        'DMA', // 按钮文本
        2000, // 延时 2000 毫秒
        'Allocator_DMA_0001', // 描述
        done // done 回调
      );
    })

    // 选择ShareMemory方式申请内存解码图片
    /**
     * @tc.number Allocator_ShareMemory_0001
     * @tc.name Allocator_ShareMemory_0001
     * @tc.desc Select SHARE method to apply for memory for decoding
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Allocator_ShareMemory_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Allocator_ShareMemory_0001', // 测试用例名称
        'SHARE', // 按钮文本
        2000, // 延时 2000 毫秒
        'Allocator_ShareMemory_0001', // 描述
        done // done 回调
      );
    })

    // 选择AUTO方式申请内存解码图片
    /**
     * @tc.number Allocator_AUTO_0001
     * @tc.name Allocator_AUTO_0001
     * @tc.desc Select SHARE method to apply for memory for decoding
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Allocator_AUTO_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Allocator_AUTO_0001', // 测试用例名称
        'AUTO', // 按钮文本
        2000, // 延时 2000 毫秒
        'Allocator_AUTO_0001', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Allocator_Release_0001
     * @tc.name Allocator_Release_0001
     * @tc.desc Release source
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Allocator_Release_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Allocator_Release_0001', // 测试用例名称
        '释放', // 按钮文本
        2000, // 延时 2000 毫秒
        'Allocator_Release', // 描述
        done // done 回调
      );
    })

    /**
     * @tc.number Allocator_EnterPage_0002
     * @tc.name Allocator_EnterPage_0002
     * @tc.desc Enter the last page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Allocator_EnterPage_0002', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Allocator_EnterPage_0002', // 测试用例名称
        'back', // 按钮文本
        2000, // 延时 2000 毫秒
        'Allocator_EnterPage_0002', // 描述
        done // done 回调
      );
    })
  })
}