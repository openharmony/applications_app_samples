/*
 * Copyright (c) 2023-2025 Huawei Device Co., Ltd.
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
import { Want } from '@kit.AbilityKit';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;

const TAG = '[Sample_startMode]';
const DOMAIN_NUMBER: number = 0xFF00;

export default function abilityTest() {
  let driver = Driver.create();
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async (done: Function) => {
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await driver.delayMs(1000);
      // 获取当前top的ability
      let entryAbility = await delegator.getCurrentTopAbility();
      expect(entryAbility.context.abilityInfo.name).assertEqual('EntryAbility');
      done();
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
    it('UIAbility_dataSync_01', 0, async (done: Function) => {
      // 拉起UIAbilityB
      hilog.info(DOMAIN_NUMBER, TAG, 'UIAbility start');
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('EventHubFuncA'));
      let StartModel = await driver.findComponent(ON.text('EventHubFuncA'));
      await StartModel.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN_NUMBER, TAG, 'UIAbility End');
      done();
    })

    it('UIAbility_dataSync_02', 0, async (done: Function) => {
      // 终止UIAbilityB
      hilog.info(DOMAIN_NUMBER, TAG, 'terminateSelf start');
      await driver.delayMs(2000);
      await driver.assertComponentExist(ON.text('EventHubFuncB'));
      let StartModel = await driver.findComponent(ON.text('EventHubFuncB'));
      await StartModel.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN_NUMBER, TAG, 'terminateSelf End');
      done();
    })
  })
}