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

function sleep(time: number) {
  return new Promise<void>((resolve) => setTimeout(resolve, time));
}

export default function abilityTest() {
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
     * @tc.number SUB_Ability_AbilityRuntime_NativeStartChildProcess_0100
     * @tc.name testStartNativeChildProcess001
     * @tc.desc To verify the function of creating a subprocess by StartNativeChildProcess
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_Ability_AbilityRuntime_NativeStartChildProcess_0100', Level.LEVEL0, async (done: Function) => {
      let tag = `ACTS_NativeStartChildProcess_0100`;
      console.log(`${tag}, it begin`);

      try {
        console.log(`${tag}, it begin`);
        let ret: Number = testNapi.startNativeChildProcess("libmainprocesssample.so");
        console.info(`${tag}: ret` + ret);
        if (ret == 16010004) {
          console.info(`${tag}: multi process model disable`);
          expect(16010004).assertEqual(ret);
          return;
        } else if (ret == 801) {
          console.info(`${tag}: Native child process disable`);
          expect(801).assertEqual(ret);
          return;
        }

        expect(0).assertEqual(ret);

        console.info(`${tag}: Test ipc call for native child process`);
        let a = 123;
        let b = 456;
        expect(a + b).assertEqual(testNapi.childProcessAdd(a, b));
        expect(1).assertEqual(testNapi.requestExitChildProcess(0));
        await sleep(600);

        console.info(`${tag}: Test restart native child process`);
        expect(0).assertEqual(testNapi.startNativeChildProcess("libmainprocesssample.so"));
        expect(1).assertEqual(testNapi.requestExitChildProcess(0));
        await sleep(600);
      } catch (err) {
        console.error(`${tag} error: ${JSON.stringify(err)}`);
      } finally {
        done();
      }
    })

    /**
     * @tc.number SUB_Ability_AbilityRuntime_NativeStartChildProcess_0200
     * @tc.name testStartNativeChildProcess002
     * @tc.desc To verify the function of creating a subprocess by StartNativeChildProcess
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_Ability_AbilityRuntime_NativeStartChildProcess_0200', Level.LEVEL0, async (done: Function) => {
      let tag = `ACTS_NativeStartChildProcess_0200`;
      console.log(`${tag}, it begin`);

        let ret: Number = testNapi.testChildProcess();
        console.info(`${tag}: ret` + ret);
        if (ret == 16010004) {
          console.info(`${tag}: multi process model disable`);
          expect(16010004).assertEqual(ret);
          return;
        } else if (ret == 801) {
          console.info(`${tag}: Native child process disable`);
          expect(801).assertEqual(ret);
          return;
        }
        expect(0).assertEqual(ret);
        done();
    })
  })
}