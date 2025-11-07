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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import testNapi from 'libmainprocesssample.so';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

function sleep(time: number) {
  return new Promise<void>((resolve) => setTimeout(resolve, time));
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async () => {
      const delegator = AbilityDelegatorRegistry.getAbilityDelegator();
      let want: Want = {
        bundleName: "com.sample.nativechildprocessparams",
        abilityName: "EntryAbility",
        moduleName: "entry"
      };
      delegator.startAbility(want);
      await sleep(2000);
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
     * @tc.number SUB_Ability_AbilityRuntime_NativeStartChildProcess_0200
     * @tc.name testStartNativeChildProcess002
     * @tc.desc To verify the function of creating a subprocess by StartNativeChildProcess
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_Ability_AbilityRuntime_NativeStartChildProcess_0200', Level.LEVEL1, async (done: Function) => {
      let tag = `SUB_Ability_AbilityRuntime_NativeStartChildProcess_0200`;
      hilog.info(DOMAIN, 'testTag', '%{public}s', `${tag}` + 'it begin');
      let ret: Number = testNapi.testChildProcess();
      hilog.info(DOMAIN, 'testTag', '%{public}s', `${tag}: ret` + ret);
      if (ret == 16010004) {
        hilog.info(DOMAIN, 'testTag', '%{public}s', `${tag}: multi process model disable`);
        expect(16010004).assertEqual(ret);
        return;
      } else if (ret == 801) {
        hilog.info(DOMAIN, 'testTag', '%{public}s', `${tag}: Native child process disable`);
        expect(801).assertEqual(ret);
        return;
      }
      expect(0).assertEqual(ret);
      done();
    })
  })
}