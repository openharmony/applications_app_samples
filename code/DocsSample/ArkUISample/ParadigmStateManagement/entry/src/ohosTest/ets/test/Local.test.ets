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
import { describe, beforeAll, it, expect } from '@ohos/hypium';
import { UIAbility, Want } from '@kit.AbilityKit';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { getResourceString } from './Ability.test';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;

let want: Want;
const DOMAIN = 0x0000;

export default function localTest() {
  describe('localTest', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number     : local_LocalV1StateDecorator
     * @tc.name       : local_LocalV1StateDecorator
     * @tc.desc       : local
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('local_LocalV1StateDecorator', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('local')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('local_v1_state_decorator')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : local_LocalObserveChangesType
     * @tc.name       : local_LocalObserveChangesType
     * @tc.desc       : local
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('local_LocalObserveChangesType', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('local')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('local_observe_changes_type')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('change Local'));
      await text2.click();
      await driver.delayMs(1000);
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : local_LocalObserveChangesDecorator
     * @tc.name       : local_LocalObserveChangesDecorator
     * @tc.desc       : local
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('local_LocalObserveChangesDecorator', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('local')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('local_observe_changes_decorator')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('change object'));
      await text2.click();
      await driver.delayMs(1000);
      const text3 = await driver.findComponent(ON.text('change name'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

  })
}