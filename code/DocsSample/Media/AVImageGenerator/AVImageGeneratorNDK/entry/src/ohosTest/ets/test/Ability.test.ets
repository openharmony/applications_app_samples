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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

export default function abilityTest() {
  const TAG = '[Sample_AVImageGeneratorNDK]';
  const driver = Driver.create();
  const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
  const bundleName = AbilityDelegatorRegistry.getArguments().bundleName;

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
    it('AVImageGeneratorNDK_001', 0, async (done: Function) => {
      console.info(TAG, 'AVImageGeneratorNDK_001 begin');
      try {
        await abilityDelegator.startAbility({
          bundleName: bundleName,
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        expect().assertFail();
      }
      try {
        const button = await driver.findComponent(ON.id('FetchFrameButton'));
        await button.click();
        await driver.delayMs(2000);
        const button2 = await driver.findComponent(ON.id('ClearPicturesButton'));
        await button2.click();
        await driver.delayMs(2000);
        done();
      } catch (exception) {
        expect().assertFail();
      }
      console.info(TAG, 'AVImageGeneratorNDK_001 end');
    })
  })
}