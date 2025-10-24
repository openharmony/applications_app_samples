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
import PlayMusicDemo from '../../../main/ets/insightintents/UsePlayMusicIntents';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

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
     * @tc.number SUB_Ability_AbilityRunTime_InsightIntent_0020
     * @tc.name SUB_Ability_AbilityRunTime_InsightIntent_0020
     * @tc.desc The Ability or Page with @InsightIntentEntry Decorator can start normally
     * @tc.type   : Function
     * @tc.size   : MediumTest
     * @tc.level  : Level 1
     */
    it('SUB_Ability_AbilityRunTime_InsightIntent_0020', Level.LEVEL1, async (done: Function) => {
      let caseName = 'SUB_Ability_AbilityRunTime_InsightIntent_0020';
      hilog.info(DOMAIN, 'testTag', '%{public}s',`[${caseName}] create`);
      try {
        let PlayMusicDemoData:PlayMusicDemo = new PlayMusicDemo();
        hilog.info(DOMAIN, 'testTag', '%{public}s',`[${caseName}]` + JSON.stringify(PlayMusicDemoData));
        done();
      } catch (err) {
        let error:Error = err as Error;
        hilog.error(DOMAIN, 'testTag', 'Cause: %{public}s',`[${caseName}]: error` + error.name + error.message);
        expect().assertFail();
        done();
      }
      hilog.info(DOMAIN, 'testTag', '%{public}s',`[${caseName}]: end`)
    })
  })
}