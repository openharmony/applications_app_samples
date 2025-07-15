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

import { describe, it, expect, beforeAll, Level } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
const delayMs = 1000;

let want: Want;

export default function abilityTest() {
  describe('NodeAPISendable', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      const driver = Driver.create();
      await driver.delayMs(delayMs);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      await driver.delayMs(delayMs);
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number UiTest_001
     * @tc.name testIndex
     * @tc.desc test binding between Native and Sendable ArkTS objects
     * @tc.level: Level 1
     */
    it('testIndex', Level.LEVEL1, async (done: Function) => {
      console.log('uitest: testIndex begin');
      const driver = Driver.create();
      await driver.delayMs(delayMs);
      const text1 = await driver.findComponent(ON.text('Hello World'));
      await text1.click();
      await driver.delayMs(delayMs);
      await driver.assertComponentExist(ON.text('success'));
      await driver.pressBack();
      done();
    })
  })
}