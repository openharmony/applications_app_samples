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

const TAG = '[Sample_EnhancedDeviceRouting]';
const DOMAIN = 0xF811;
const BUNDLE = 'EnhancedDeviceRouting_';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const driver = Driver.create();

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

export default function EnhancedDeviceRoutingTest() {
  describe('EnhancedDeviceRoutingTest', () => {
    beforeAll(() => {
      abilityDelegator.startAbility({
        bundleName: 'com.example.myapplication',
        abilityName: 'EntryAbility'
      });
    })
    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})

    /**
     * @tc.number EnhancedDeviceRouting_IsEnhancedRoutingSupported_0001
     * @tc.name EnhancedDeviceRouting_IsEnhancedRoutingSupported_0001
     * @tc.desc Query whether enhanced routing is supported
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('EnhancedDeviceRouting_IsEnhancedRoutingSupported_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'EnhancedDeviceRouting_IsEnhancedRoutingSupported_0001',
        '查询增强路由支持',
        3000,
        'IsEnhancedRoutingSupported',
        done
      );
    })

    /**
     * @tc.number EnhancedDeviceRouting_CreateAudioRenderer_0001
     * @tc.name EnhancedDeviceRouting_CreateAudioRenderer_0001
     * @tc.desc Create AudioRenderer instance
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('EnhancedDeviceRouting_CreateAudioRenderer_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'EnhancedDeviceRouting_CreateAudioRenderer_0001',
        '创建AudioRenderer',
        3000,
        'CreateAudioRenderer',
        done
      );
    })

    /**
     * @tc.number EnhancedDeviceRouting_CreateAudioCapturer_0001
     * @tc.name EnhancedDeviceRouting_CreateAudioCapturer_0001
     * @tc.desc Create AudioCapturer instance with microphone permission
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('EnhancedDeviceRouting_CreateAudioCapturer_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'EnhancedDeviceRouting_CreateAudioCapturer_0001',
        '创建AudioCapturer',
        3000,
        'CreateAudioCapturer',
        done
      );
    })

    /**
     * @tc.number EnhancedDeviceRouting_SelectOutputDevice_0001
     * @tc.name EnhancedDeviceRouting_SelectOutputDevice_0001
     * @tc.desc Select output device for application
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('EnhancedDeviceRouting_SelectOutputDevice_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'EnhancedDeviceRouting_SelectOutputDevice_0001',
        '为应用选择输出',
        3000,
        'SelectOutputDevice',
        done
      );
    })

    /**
     * @tc.number EnhancedDeviceRouting_SelectInputDevice_0001
     * @tc.name EnhancedDeviceRouting_SelectInputDevice_0001
     * @tc.desc Select input device for application
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('EnhancedDeviceRouting_SelectInputDevice_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'EnhancedDeviceRouting_SelectInputDevice_0001',
        '为应用选择输入',
        3000,
        'SelectInputDevice',
        done
      );
    })

    /**
     * @tc.number EnhancedDeviceRouting_SelectOutputDeviceForAudioRenderer_0001
     * @tc.name EnhancedDeviceRouting_SelectOutputDeviceForAudioRenderer_0001
     * @tc.desc Select output device for AudioRenderer stream
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('EnhancedDeviceRouting_SelectOutputDeviceForAudioRenderer_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'EnhancedDeviceRouting_SelectOutputDeviceForAudioRenderer_0001',
        '为Renderer选择输出',
        3000,
        'SelectOutputDeviceForAudioRenderer',
        done
      );
    })

    /**
     * @tc.number EnhancedDeviceRouting_SelectInputDeviceForAudioCapturer_0001
     * @tc.name EnhancedDeviceRouting_SelectInputDeviceForAudioCapturer_0001
     * @tc.desc Select input device for AudioCapturer stream
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('EnhancedDeviceRouting_SelectInputDeviceForAudioCapturer_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'EnhancedDeviceRouting_SelectInputDeviceForAudioCapturer_0001',
        '为Capturer选择输入',
        3000,
        'SelectInputDeviceForAudioCapturer',
        done
      );
    })
  })
}
