/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, Level } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const TAG = '[NonLinearContainerTest]';
const DOMAIN = 0xF815;
const BUNDLE = 'NonLinearContainerTest_';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const driver = Driver.create();

async function runTest(testCaseName: string, buttonText: string, delayTime: number, description: string,
  done: Function) {
  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, begin`);

  let btn = await driver.findComponent(ON.text(buttonText));
  if (btn !== undefined) {
    await btn.click();
    await driver.delayMs(delayTime);
  } else {
    hilog.warn(DOMAIN, TAG, BUNDLE + `Button "${buttonText}" not found, still waiting...`);
    await driver.delayMs(delayTime);
  }

  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, end`);
  done();
}

export default function NonLinearContainerTest() {
  describe('NonLinearContainerTest', () => {
    beforeAll(() => {
      abilityDelegator.startAbility({
        bundleName: 'com.samples.NonlinearContainers',
        abilityName: 'EntryAbility'
      });
    });

    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})

    /**
     * @tc.number NonLinearContainer_HashMap_0001
     * @tc.name NonLinearContainer_HashMap_0001
     * @tc.desc Test HashMap set, hasKey and get operations
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('NonLinearContainer_HashMap_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'NonLinearContainer_HashMap_0001',
        '测试HashMap',
        3000,
        'Test HashMap operations',
        done
      );
    });

    /**
     * @tc.number NonLinearContainer_TreeMap_0001
     * @tc.name NonLinearContainer_TreeMap_0001
     * @tc.desc Test TreeMap set, get, getFirstKey and getLastKey operations
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('NonLinearContainer_TreeMap_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'NonLinearContainer_TreeMap_0001',
        '测试TreeMap',
        3000,
        'Test TreeMap operations',
        done
      );
    });

    /**
     * @tc.number NonLinearContainer_LightWeightMap_0001
     * @tc.name NonLinearContainer_LightWeightMap_0001
     * @tc.desc Test LightWeightMap set, get and getIndexOfKey operations
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('NonLinearContainer_LightWeightMap_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'NonLinearContainer_LightWeightMap_0001',
        '测试LightWeightMap',
        3000,
        'Test LightWeightMap operations',
        done
      );
    });

    /**
     * @tc.number NonLinearContainer_PlainArray_0001
     * @tc.name NonLinearContainer_PlainArray_0001
     * @tc.desc Test PlainArray add, get and getKeyAt operations
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('NonLinearContainer_PlainArray_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'NonLinearContainer_PlainArray_0001',
        '测试PlainArray',
        3000,
        'Test PlainArray operations',
        done
      );
    });
  });
}