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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry } from '@kit.TestKit';
import { Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN_NUMBER = 0x0000;
const TAG = '[Sample_SetWindowSizeConstraints]';

function sleep(time: number): Promise<void> {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases start.
      hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Test suite starts');
    })

    beforeEach(() => {
      // Presets an action, which is performed before each test case starts.
      hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Test case begins');
    })

    afterEach(() => {
      // Presets a clear action, which is performed after each test case ends.
      hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Test case ends');
    })

    afterAll(() => {
      // Presets a clear action, which is performed after all test cases end.
      hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Test suite ends');
    })

    /**
     * @tc.number    SUB_SetWindowSizeConstraints_001
     * @tc.name      testSetWindowSizeConstraints
     * @tc.desc      Test ability startup with window size constraints setting
     * @tc.level     Level0
     * @tc.size      MediumTest
     * @tc.type      Function
     */
    it('SUB_SetWindowSizeConstraints_001', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'testSetWindowSizeConstraints begin');
      try {
        const delegator = abilityDelegatorRegistry.getAbilityDelegator();
        const want: Want = {
          deviceId: '',
          bundleName: 'com.example.startoptions',
          abilityName: 'SetWindowSizeConstraintsAbility'
        };

        hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Starting SetWindowSizeConstraintsAbility');
        await delegator.startAbility(want);

        // Wait for the ability to start and display UI
        await sleep(3000);

        hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'SetWindowSizeConstraintsAbility started successfully');
        expect(1).assertEqual(1);
        done();
      } catch (error) {
        hilog.error(DOMAIN_NUMBER, TAG, 'testSetWindowSizeConstraints failed: %{public}s', JSON.stringify(error));
        expect(0).assertEqual(1);
        done();
      }
    });
  })
}
