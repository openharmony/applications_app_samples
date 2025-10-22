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

function sleep(time: number) {
  return new Promise<void>((resolve) => setTimeout(resolve, time));
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async () => {
      const delegator = AbilityDelegatorRegistry.getAbilityDelegator();
      let want: Want = {
        bundleName: "com.sample.nativechildprocessexit",
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
     * @tc.number SUB_Ability_AbilityRuntime_RegisterNativeChildProcessExitCallback_0100
     * @tc.name testRegisterNativeChildProcessExitCallback001
     * @tc.desc To verify the function of registering NativeChildProcess exit callback
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_Ability_AbilityRuntime_RegisterNativeChildProcessExitCallback_0100', Level.LEVEL1,
      async (done: Function) => {
        let tag = `SUB_Ability_AbilityRuntime_RegisterNativeChildProcessExitCallback_0100`;
        console.log(`${tag}, it begin`);
        let ret: Number = testNapi.testRegisterFunc();
        console.info(`${tag}: ret` + ret);
        expect(0).assertEqual(ret);
        done();
      })

    /**
     * @tc.number SUB_Ability_AbilityRuntime_UnregisterNativeChildProcessExitCallback_0100
     * @tc.name testUnregisterNativeChildProcessExitCallback001
     * @tc.desc To verify the function of unregistering NativeChildProcess exit callback
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_Ability_AbilityRuntime_UnregisterNativeChildProcessExitCallback_0100', Level.LEVEL1,
      async (done: Function) => {
        let tag = `SUB_Ability_AbilityRuntime_UnregisterNativeChildProcessExitCallback_0100`;
        console.log(`${tag}, it begin`);
        let ret: Number = testNapi.testUnregisterFunc();
        console.info(`${tag}: ret` + ret);
        if (ret == 16010009) {
          console.info(`The registered function is not executed`);
          expect(16010009).assertEqual(ret);
          return;
        }
        expect(0).assertEqual(ret);
        done();
      })
  })
}