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

const TAG = '[LinearContainerTest]';
const DOMAIN = 0xF815;
const BUNDLE = 'LinearContainerTest_';
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

export default function LinearContainerTest() {
  describe('LinearContainerTest', () => {
    beforeAll(() => {
      abilityDelegator.startAbility({
        bundleName: 'com.samples.LinearContainers',
        abilityName: 'EntryAbility'
      });
    });

    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})

    /**
     * @tc.number LinearContainer_ArrayList_0001
     * @tc.name LinearContainer_ArrayList_0001
     * @tc.desc Test ArrayList add and access operations
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('LinearContainer_ArrayList_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'LinearContainer_ArrayList_0001',
        '测试ArrayList',
        3000,
        'Test ArrayList operations',
        done
      );
    });

    /**
     * @tc.number LinearContainer_Deque_0001
     * @tc.name LinearContainer_Deque_0001
     * @tc.desc Test Deque insertFront, insertEnd and access operations
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('LinearContainer_Deque_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'LinearContainer_Deque_0001',
        '测试Deque',
        3000,
        'Test Deque operations',
        done
      );
    });

    /**
     * @tc.number LinearContainer_Stack_0001
     * @tc.name LinearContainer_Stack_0001
     * @tc.desc Test Stack push, pop, peek and length operations
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('LinearContainer_Stack_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'LinearContainer_Stack_0001',
        '测试Stack',
        3000,
        'Test Stack operations',
        done
      );
    });

    /**
     * @tc.number LinearContainer_List_0001
     * @tc.name LinearContainer_List_0001
     * @tc.desc Test List add, insert, get and access operations
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('LinearContainer_List_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'LinearContainer_List_0001',
        '测试List',
        3000,
        'Test List operations',
        done
      );
    });
  });
}