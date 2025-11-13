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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, TestType, Size, Level } from '@ohos/hypium';
import { abilityDelegatorRegistry, BY, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import Napi from 'libentry.so';

const SECONDS_TIME = 1000;
const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
const DOMAIN = 0x0000;
const TAG = 'interface';

let want: Want;

export default function InterfaceTest() {
  describe('InterfaceTest', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(SECONDS_TIME);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(DOMAIN, TAG, 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    beforeEach(async () => {
      let driver = Driver.create();
      await driver.delayMs(SECONDS_TIME);
    })

    afterEach(() => {
      hilog.info(DOMAIN, TAG, 'Public event test case completed');
    })

    afterAll(() => {
      hilog.info(DOMAIN, TAG, 'All publicTest event tests completed');
    })

    /**
     * @tc.number: InterfaceTest_001
     * @tc.name: InterfaceTest_001
     * @tc.desc: To test creat first page
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('InterfaceTest_001', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'InterfaceTest_001 begin');
      let driver = Driver.create();
      await driver.delayMs(SECONDS_TIME);

      try {
        const button1 = await driver.findComponent(ON.id('First'));
        await button1.click();
        await driver.delayMs(SECONDS_TIME);

        let button = await driver.findComponent(ON.type('Button'));
        await button.click();
        hilog.info(DOMAIN, TAG, 'Modify First Page Success');

      } catch (error) {
        hilog.error(DOMAIN, TAG, 'testPublicVisibility failed: %{public}s', error.message);
      }
      hilog.info(DOMAIN, TAG, 'InterfaceTest_001 end');
      done();
    });
  });
}