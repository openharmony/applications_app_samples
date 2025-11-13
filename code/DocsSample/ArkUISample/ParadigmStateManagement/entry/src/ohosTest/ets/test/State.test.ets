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

export default function stateTest() {
  describe('stateTest', () => {
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
     * @tc.number     : state_StateSceneSimpleType
     * @tc.name       : state_StateSceneSimpleType
     * @tc.desc       : state
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('state_StateSceneSimpleType', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('state')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_scene_simple_type')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('click times: 0'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : state_StateChangeObservationObject
     * @tc.name       : state_StateChangeObservationObject
     * @tc.desc       : state
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('state_StateChangeObservationObject', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('state')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_change_observation_object')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text(await getResourceString('state_decorate_object_change_text_01')));
      await text2.click();
      await driver.delayMs(300);
      const text3 =
        await driver.findComponent(ON.text(await getResourceString('state_decorate_object_change_text_02')));
      await text3.click();
      await driver.delayMs(300);
      const text4 =
        await driver.findComponent(ON.text(await getResourceString('state_decorate_object_change_text_03')));
      await text4.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : state_StateChangeObservationArray
     * @tc.name       : state_StateChangeObservationArray
     * @tc.desc       : state
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('state_StateChangeObservationArray', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('state')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_change_observation_array')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text(await getResourceString('state_decorate_array_change_text_01')));
      await text2.click();
      await driver.delayMs(300);
      const text3 =
        await driver.findComponent(ON.text(await getResourceString('state_decorate_array_change_text_02')));
      await text3.click();
      await driver.delayMs(300);
      const text4 =
        await driver.findComponent(ON.text(await getResourceString('state_decorate_array_change_text_03')));
      await text4.click();
      await driver.delayMs(300);
      const text5 =
        await driver.findComponent(ON.text(await getResourceString('state_decorate_array_change_text_04')));
      await text5.click();
      await driver.delayMs(300);
      const text6 =
        await driver.findComponent(ON.text(await getResourceString('state_decorate_array_change_text_05')));
      await text6.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : state_StateSceneTypeClass
     * @tc.name       : state_StateSceneTypeClass
     * @tc.desc       : state
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('state_StateSceneTypeClass', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('state')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_scene_type_class')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('Click to change title'));
      await text2.click();
      await driver.delayMs(300);
      const text3 =
        await driver.findComponent(ON.text('Click to increase count = 0'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : state_StateSceneTypeMap
     * @tc.name       : state_StateSceneTypeMap
     * @tc.desc       : state
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('state_StateSceneTypeMap', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('state')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_scene_type_map')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('init map'));
      await text2.click();
      await driver.delayMs(300);
      const text3 =
        await driver.findComponent(ON.text('set new one'));
      await text3.click();
      await driver.delayMs(300);
      const text4 =
        await driver.findComponent(ON.text('clear'));
      await text4.click();
      await driver.delayMs(300);
      const text5 =
        await driver.findComponent(ON.text('replace the first one'));
      await text5.click();
      await driver.delayMs(300);
      const text6 =
        await driver.findComponent(ON.text('delete the first one'));
      await text6.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : state_StateSceneTypeSet
     * @tc.name       : state_StateSceneTypeSet
     * @tc.desc       : state
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('state_StateSceneTypeSet', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('state')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_scene_type_set')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('init set'));
      await text2.click();
      await driver.delayMs(300);
      const text3 =
        await driver.findComponent(ON.text('set new one'));
      await text3.click();
      await driver.delayMs(300);
      const text4 =
        await driver.findComponent(ON.text('clear'));
      await text4.click();
      await driver.delayMs(300);
      const text5 =
        await driver.findComponent(ON.text('delete the first one'));
      await text5.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : state_StateSceneTypeDate
     * @tc.name       : state_StateSceneTypeDate
     * @tc.desc       : state
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('state_StateSceneTypeDate', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('state')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_scene_type_date')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('set selectedDate to 2023-07-08'));
      await text2.click();
      await driver.delayMs(300);
      const text3 =
        await driver.findComponent(ON.text('increase the year by 1'));
      await text3.click();
      await driver.delayMs(300);
      const text4 =
        await driver.findComponent(ON.text('increase the month by 1'));
      await text4.click();
      await driver.delayMs(300);
      const text5 =
        await driver.findComponent(ON.text('increase the day by 1'));
      await text5.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : state_StateSceneJointTypeInstance
     * @tc.name       : state_StateSceneJointTypeInstance
     * @tc.desc       : state
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('state_StateSceneJointTypeInstance', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('state')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_scene_joint_type_instance')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : state_PlayDetailPageOpposite
     * @tc.name       : state_PlayDetailPageOpposite
     * @tc.desc       : state
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('state_PlayDetailPageOpposite', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('state')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_problem_arrow_function_opposite')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('Change Color'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : state_PlayDetailPagePositive
     * @tc.name       : state_PlayDetailPagePositive
     * @tc.desc       : state
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('state_PlayDetailPagePositive', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('state')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(2000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_problem_arrow_function_positive')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('Change Color'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : state_StateProblemThisUnableObserveOpposite
     * @tc.name       : state_StateProblemThisUnableObserveOpposite
     * @tc.desc       : state
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('state_StateProblemThisUnableObserveOpposite', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('state')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(2000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_problem_this_unable_observe_opposite')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : state_StateProblemThisUnableObservePositive
     * @tc.name       : state_StateProblemThisUnableObservePositive
     * @tc.desc       : state
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('state_StateProblemThisUnableObservePositive', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('state')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(2000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_problem_this_unable_observe_positive')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : state_StateProblemStateUiRefreshExample01
     * @tc.name       : state_StateProblemStateUiRefreshExample01
     * @tc.desc       : state
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('state_StateProblemStateUiRefreshExample01', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('state')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(2000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_problem_state_ui_refresh_example_01')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : state_StateProblemStateUiRefreshExample02
     * @tc.name       : state_StateProblemStateUiRefreshExample02
     * @tc.desc       : state
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('state_StateProblemStateUiRefreshExample02', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('state')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(2000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_problem_state_ui_refresh_example_02')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : state_StateProblemStateUiRefreshExample03
     * @tc.name       : state_StateProblemStateUiRefreshExample03
     * @tc.desc       : state
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('state_StateProblemStateUiRefreshExample03', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('state')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(2000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_problem_state_ui_refresh_example_03')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : state_StateProblemComplexConstantRepeatRefresh
     * @tc.name       : state_StateProblemComplexConstantRepeatRefresh
     * @tc.desc       : state
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('state_StateProblemComplexConstantRepeatRefresh', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('state')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(2000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_problem_complex_constant_repeat_refresh')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change to self'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : state_StateProblemComplexSolution01
     * @tc.name       : state_StateProblemComplexSolution01
     * @tc.desc       : state
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('state_StateProblemComplexSolution01', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('state')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(2000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(2000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_problem_complex_solution_01')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change to self'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : state_StateProblemComplexSolution02
     * @tc.name       : state_StateProblemComplexSolution02
     * @tc.desc       : state
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('state_StateProblemComplexSolution02', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('state')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(2000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(2000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_problem_complex_solution_02')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change to self'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : state_StateProblemNotUpdateInBuildError01
     * @tc.name       : state_StateProblemNotUpdateInBuildError01
     * @tc.desc       : state
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('state_StateProblemNotUpdateInBuildError01', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('state')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(2000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(2000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_problem_not_update_in_build_error_01')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : state_StateProblemABCallUiRefreshOpposite
     * @tc.name       : state_StateProblemABCallUiRefreshOpposite
     * @tc.desc       : state
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('state_StateProblemABCallUiRefreshOpposite', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('state')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(2000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(2000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_problem_a_b_call_ui_refresh_opposite')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('increaseVolume'));
      await text2.click();
      await driver.delayMs(300);
      const text3 =
        await driver.findComponent(ON.text('reduceVolume'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : state_StateProblemABCallUiRefreshPositive
     * @tc.name       : state_StateProblemABCallUiRefreshPositive
     * @tc.desc       : state
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('state_StateProblemABCallUiRefreshPositive', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('state')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(2000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(2000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_problem_a_b_call_ui_refresh_positive')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('increaseVolume'));
      await text2.click();
      await driver.delayMs(300);
      const text3 =
        await driver.findComponent(ON.text('reduceVolume'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : state_StateProblemUnregisterStateCallback
     * @tc.name       : state_StateProblemUnregisterStateCallback
     * @tc.desc       : state
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('state_StateProblemUnregisterStateCallback', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('state')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(2000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(2000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('state_problem_unregister_state_callback')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change'));
      await text2.click();
      await driver.delayMs(200);
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })
  })
}