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

const TAG = '[Sample_EnhancedDeviceRouting]';
const DOMAIN = 0xF811;
const BUNDLE = 'EnhancedDeviceRouting_';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const driver = Driver.create();

async function runTest(buttonText: string, delayTime: number, description: string, done: Function) {
  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, begin`);

  let btn = await driver.findComponent(ON.text(buttonText));
  if (btn !== undefined) {
    await btn.click();
    await driver.delayMs(delayTime);
  } else {
    hilog.error(DOMAIN, TAG, BUNDLE + `${description}, button not found: ${buttonText}`);
    await driver.delayMs(delayTime);
  }

  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, end`);
  done();
}

export default function EnhancedDeviceRoutingTest() {
  describe('EnhancedDeviceRoutingTest', () => {
    beforeAll(() => {
      abilityDelegator.startAbility({
        bundleName: 'com.example.myapplication',
        abilityName: 'EntryAbility'
      });
    });

    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})

    /**
     * @tc.number EnhancedRouting_EnterPage_0001
     * @tc.name EnhancedRouting_EnterPage_0001
     * @tc.desc Navigate to enhanced device routing page
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('EnhancedRouting_EnterPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest('增强路由设备选择页面', 5000, 'Enter_EnhancedDeviceRouting_Page', done);
    })

    /**
     * @tc.number EnhancedRouting_QuerySupport_0001
     * @tc.name EnhancedRouting_QuerySupport_0001
     * @tc.desc Query whether enhanced routing is supported
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('EnhancedRouting_QuerySupport_0001', Level.LEVEL1, async (done: Function) => {
      await runTest('查询增强路由支持', 2000, 'Query_Enhanced_Routing_Support', done);
    })

    /**
     * @tc.number EnhancedRouting_CreateRenderer_0001
     * @tc.name EnhancedRouting_CreateRenderer_0001
     * @tc.desc Create AudioRenderer instance
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('EnhancedRouting_CreateRenderer_0001', Level.LEVEL1, async (done: Function) => {
      await runTest('创建AudioRenderer', 3000, 'Create_AudioRenderer', done);
    })

    /**
     * @tc.number EnhancedRouting_CreateCapturer_0001
     * @tc.name EnhancedRouting_CreateCapturer_0001
     * @tc.desc Create AudioCapturer instance
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('EnhancedRouting_CreateCapturer_0001', Level.LEVEL1, async (done: Function) => {
      await runTest('创建AudioCapturer', 5000, 'Create_AudioCapturer', done);
    })

    /**
     * @tc.number EnhancedRouting_SelectOutputForApp_0001
     * @tc.name EnhancedRouting_SelectOutputForApp_0001
     * @tc.desc Select output device for app
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('EnhancedRouting_SelectOutputForApp_0001', Level.LEVEL1, async (done: Function) => {
      await runTest('为应用选择输出', 3000, 'Select_Output_Device_For_App', done);
    })

    /**
     * @tc.number EnhancedRouting_SelectInputForApp_0001
     * @tc.name EnhancedRouting_SelectInputForApp_0001
     * @tc.desc Select input device for app
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('EnhancedRouting_SelectInputForApp_0001', Level.LEVEL1, async (done: Function) => {
      await runTest('为应用选择输入', 3000, 'Select_Input_Device_For_App', done);
    })

    /**
     * @tc.number EnhancedRouting_SelectOutputForRenderer_0001
     * @tc.name EnhancedRouting_SelectOutputForRenderer_0001
     * @tc.desc Select output device for AudioRenderer
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('EnhancedRouting_SelectOutputForRenderer_0001', Level.LEVEL1, async (done: Function) => {
      await runTest('为Renderer选择输出', 3000, 'Select_Output_Device_For_Renderer', done);
    })

    /**
     * @tc.number EnhancedRouting_SelectInputForCapturer_0001
     * @tc.name EnhancedRouting_SelectInputForCapturer_0001
     * @tc.desc Select input device for AudioCapturer
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('EnhancedRouting_SelectInputForCapturer_0001', Level.LEVEL1, async (done: Function) => {
      await runTest('为Capturer选择输入', 3000, 'Select_Input_Device_For_Capturer', done);
    })
  })
}
