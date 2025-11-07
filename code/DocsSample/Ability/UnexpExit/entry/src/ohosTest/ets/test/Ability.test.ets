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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN_NUMBER = 0xF811;
const TAG = '[Sample_UnexpExit]';

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
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
    it('assertContain', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let a = 'abc';
      let b = 'b';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertContain(b);
      expect(a).assertEqual(a);
    })


    /**
     * @tc.number    SUB_ExitAbility1
     * @tc.name      SUB_ExitAbility1
     * @tc.desc      test ExitAbility1
     * @tc.level     Level1
     * @tc.size      MediumTest
     * @tc.type      Function
     */
    it('SUB_ExitAbility1', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER,TAG,'uitest: TestUiExample begin');
      try {
        const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
        const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
        const want: Want = {
          deviceId: '',
          bundleName: 'com.example.unexpexit',
          abilityName: 'ExitAbility'
        };
        await delegator.startAbility(want);
        const ability: UIAbility = await delegator.getCurrentTopAbility();
        await sleep(5000);
        hilog.info(DOMAIN_NUMBER, TAG, 'get top ability');
        expect(1).assertEqual(1);
        done();
      } catch (error) {
       hilog.error(DOMAIN_NUMBER, TAG, 'Start Fail: ', error);
        expect(0).assertEqual(1);
        done();
      }
    });

    /**
     * @tc.number    SUB_ExitAbility2
     * @tc.name      SUB_ExitAbility2
     * @tc.desc      test ExitAbility2
     * @tc.level     Level1
     * @tc.size      MediumTest
     * @tc.type      Function
     */
    it('SUB_ExitAbility2', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER,TAG,'uitest: TestUiExample begin');
      try {
        const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
        const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
        const want: Want = {
          deviceId: '',
          bundleName: 'com.example.unexpexit',
          abilityName: 'ExitAbility'
        };
        await delegator.startAbility(want);
        const ability: UIAbility = await delegator.getCurrentTopAbility();
        await sleep(5000);
        hilog.info(DOMAIN_NUMBER,TAG,'get top ability');
        expect(1).assertEqual(1);
        done();
      } catch (error) {
       hilog.error(DOMAIN_NUMBER, TAG, 'Start Fail: ', error);
        expect(0).assertEqual(1);
      }
    });
  })
}