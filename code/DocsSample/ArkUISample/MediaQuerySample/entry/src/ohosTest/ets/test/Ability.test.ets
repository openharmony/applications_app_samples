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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
// 导入测试依赖kit
import { abilityDelegatorRegistry, Driver, ON, MatchPattern} from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async () => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(0x0000, 'testTag', 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
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
     * @tc.number testChangeOrientation_001
     * @tc.name testChangeOrientation_001
     * @tc.desc test ChangeOrientation
     * @tc.level: Level 1
     */
    it('testChangeOrientation_001', Level.LEVEL1, async (done: Function) => {
      hilog.info(0x0000, 'testTag', 'testChangeOrientation_001 begin');
      let driver = Driver.create();
      let buttonComponent = await driver.findComponent(ON.text('Landscape', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();

      buttonComponent = await driver.findComponent(ON.text('Portrait', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();

      hilog.info(0x0000, 'testTag', 'testChangeOrientation_001 end');
      done();
    })
  })
}