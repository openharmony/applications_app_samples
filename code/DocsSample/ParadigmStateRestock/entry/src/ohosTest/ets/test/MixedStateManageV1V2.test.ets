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

export default function mixedStateManageV1V2Test() {
  describe('mixedStateManageV1V2Test', () => {
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
     * @tc.number     : mixedState_StateMixedSceneJsV1V2Recommend
     * @tc.name       : mixedState_StateMixedSceneJsV1V2Recommend
     * @tc.desc       : mixedState
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('mixedState_StateMixedSceneJsV1V2Recommend', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('mixed_state_manage_v1_v2')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_mixed_scene_js_v1_v2_recommend')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('@State observedClass: Tom' || '@Param observedClass: Tom'));
      await text2.click();
      await driver.delayMs(100);
      const text3 =
        await driver.findComponent(ON.text('@State observedClass: Tom!' || '@Param observedClass: Tom!'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : mixedState_StateMixedSceneJsV1V2NotRecommend
     * @tc.name       : mixedState_StateMixedSceneJsV1V2NotRecommend
     * @tc.desc       : mixedState
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('mixedState_StateMixedSceneJsV1V2NotRecommend', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('mixed_state_manage_v1_v2')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_mixed_scene_js_v1_v2_not_recommend')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('@State observedClass: Tom' || '@Param observedClass: Tom'));
      await text2.click();
      await driver.delayMs(100);
      const text3 =
        await driver.findComponent(ON.text('@State observedClass: Tom!' || '@Param observedClass: Tom!'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : mixedState_StateMixedSceneJsV2V1Recommend
     * @tc.name       : mixedState_StateMixedSceneJsV2V1Recommend
     * @tc.desc       : mixedState
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('mixedState_StateMixedSceneJsV2V1Recommend', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('mixed_state_manage_v1_v2')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_mixed_scene_js_v2_v1_recommend')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('@Local observedClass: Tom' || '@ObjectLink observedClass: Tom'));
      await text2.click();
      await driver.delayMs(100);
      const text3 =
        await driver.findComponent(ON.text('@Local observedClass: Tom!' || '@ObjectLink observedClass: Tom!'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : mixedState_StateMixedSceneJsV2V1NotRecommend
     * @tc.name       : mixedState_StateMixedSceneJsV2V1NotRecommend
     * @tc.desc       : mixedState
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('mixedState_StateMixedSceneJsV2V1NotRecommend', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('mixed_state_manage_v1_v2')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_mixed_scene_js_v2_v1_not_recommend')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('@Local observedClass: Tom'));
      await text2.click();
      await driver.delayMs(100);
      const text3 =
        await driver.findComponent(ON.text('@ObjectLink observedClass: Tom'));
      await text3.click();
      await driver.delayMs(100);
      const text4 =
        await driver.findComponent(ON.text('@State observedClass: Tom'));
      await text4.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })
  })
}