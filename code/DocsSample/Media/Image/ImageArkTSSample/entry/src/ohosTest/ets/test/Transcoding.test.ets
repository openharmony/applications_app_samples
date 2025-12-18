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

const TAG = '[Sample_Transcoding]';
const DOMAIN = 0xF811;
const BUNDLE = 'Transcoding_';
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
    await driver.delayMs(delayTime);
  }
  else {
    await driver.delayMs(delayTime);
  }

  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, end`);
  done();
}

export default function TranscodingTest() {
  describe('TranscodingTest', () => {
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
    
    // 单独运行该测试套时将获取权限的按钮解开。
    // /**
    //  * @tc.number Transcoding_GetAccess_0001
    //  * @tc.name Transcoding_GetAccess_0001
    //  * @tc.desc Request camera permissions
    //  * @tc.size MediumTest
    //  * @tc.type Function
    //  * @tc.level Level 1
    //  */
    // it('Transcoding_GetAccess_0001', Level.LEVEL1, async (done: Function) => {
    //   await runTest(
    //     'Transcoding_GetAccess_0001',
    //     '允许',
    //     2000,
    //     'GetAccess_0001',
    //     done
    //   );
    // })
    //
    // /**
    //  * @tc.number Transcoding_GetAccess_0002
    //  * @tc.name Transcoding_GetAccess_0002
    //  * @tc.desc Request microphone permission
    //  * @tc.size MediumTest
    //  * @tc.type Function
    //  * @tc.level Level 1
    //  */
    // it('Transcoding_GetAccess_0002', Level.LEVEL1, async (done: Function) => {
    //   await runTest(
    //     'Transcoding_GetAccess_0002',
    //     '允许',
    //     2000,
    //     'GetAccess_0002',
    //     done
    //   );
    // })
    //
    // /**
    //  * @tc.number Transcoding_GetAccess_0003
    //  * @tc.name Transcoding_GetAccess_0003
    //  * @tc.desc Request media permission
    //  * @tc.size MediumTest
    //  * @tc.type Function
    //  * @tc.level Level 1
    //  */
    // it('Transcoding_GetAccess_0003', Level.LEVEL1, async (done: Function) => {
    //   await runTest(
    //     'Transcoding_GetAccess_0003',
    //     '允许',
    //     2000,
    //     'GetAccess_0003',
    //     done
    //   );
    // })
    //
    // /**
    //  * @tc.number Transcoding_GetAccess_0004
    //  * @tc.name Transcoding_GetAccess_0004
    //  * @tc.desc Request file permission
    //  * @tc.size MediumTest
    //  * @tc.type Function
    //  * @tc.level Level 1
    //  */
    // it('Transcoding_GetAccess_0004', Level.LEVEL1, async (done: Function) => {
    //   await runTest(
    //     'Transcoding_GetAccess_0004', // 测试用例名称。
    //     '允许', // 按钮文本。
    //     2000, // 延时 2000 毫秒。
    //     'GetAccess_0004', // 描述。
    //     done // done 回调。
    //   );
    // })

    /**
     * @tc.number Transcoding_EnterPage_0001
     * @tc.name Transcoding_EnterPage_0001
     * @tc.desc Enter Transcoding page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Transcoding_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Transcoding_EnterPage_0001',
        '跳转到转码页面',
        2000,
        'Transcoding_EnterPage',
        done
      );
    })

    /**
     * @tc.number Transcoding_Trigger_0001
     * @tc.name Transcoding_Trigger_0001
     * @tc.desc Trigger Transcoding
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Transcoding_Trigger_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Transcoding_Trigger_0001',
        'Transcoding',
        2000,
        'Transcoding_Trigger_0001',
        done
      );
    })

    /**
     * @tc.number Transcoding_EnterPage_0002
     * @tc.name Transcoding_EnterPage_0002
     * @tc.desc Enter the last page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('Transcoding_EnterPage_0002', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'Transcoding_EnterPage_0002',
        'back',
        2000,
        'Transcoding_EnterPage_0002',
        done
      );
    })
  })
}