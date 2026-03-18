/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { Driver, ON} from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

export default function abilityTest() {
  let driver: Driver;

  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      driver = Driver.create();
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

    /*
     * @tc.number: audioVoIPCall_StartAbility_001
     * @tc.name: StartAbility
     * @tc.desc: StartAbility
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('audioVoIPCall_StartAbility_001', 0, async (done: Function) => {
      hilog.info(0x0000, 'AudioVoIPCallSampleTest', 'audioVoIPCall_StartAbility_001 begin');
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.audiovoipcallsample',
          abilityName: 'EntryAbility'
        });
        done();
      } catch (exception) {
        hilog.info(0x0000, 'AudioVoIPCallSampleTest',
          'audioVoIPCall_StartAbility_001 begin exception = $\{JSON.stringify(exception)}');
        expect().assertFail();
        done();
      }
      hilog.info(0x0000, 'AudioVoIPCallSampleTest', 'audioVoIPCall_StartAbility_001 end');
    })
  })
}