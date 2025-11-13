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

export default function monitorTest() {
  describe('monitorTest', () => {
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
     * @tc.number     : monitor_WatchDecoratorLimitationsV1
     * @tc.name       : monitor_WatchDecoratorLimitationsV1
     * @tc.desc       : monitor
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('monitor_WatchDecoratorLimitationsV1', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('monitor')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('monitor_watch_decorator_limitations_v1')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : monitor_MonitorDecoratorMultiWatchCompV2
     * @tc.name       : monitor_MonitorDecoratorMultiWatchCompV2
     * @tc.desc       : monitor
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('monitor_MonitorDecoratorMultiWatchCompV2', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('monitor')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('monitor_decorator_multi_watch_comp_v2')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : monitor_MonitorDecoratorObjectTraceCompV2
     * @tc.name       : monitor_MonitorDecoratorObjectTraceCompV2
     * @tc.desc       : monitor
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('monitor_MonitorDecoratorObjectTraceCompV2', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('monitor')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('monitor_decorator_object_trace_comp_v2')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change info'));
      await text2.click();
      await driver.delayMs(1000);
      const text3 =
        await driver.findComponent(ON.text('change info.name'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : monitor_MonitorDecoratorMultiWatchObservedV2
     * @tc.name       : monitor_MonitorDecoratorMultiWatchObservedV2
     * @tc.desc       : monitor
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('monitor_MonitorDecoratorMultiWatchObservedV2', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('monitor')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('monitor_decorator_multi_watch_observed_v2')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change name'));
      await text2.click();
      await driver.delayMs(200);
      const text4 =
        await driver.findComponent(ON.text('change age'));
      await text4.click();
      await driver.delayMs(200);
      const text5 =
        await driver.findComponent(ON.text('change region'));
      await text5.click();
      await driver.delayMs(200);
      const text6 =
        await driver.findComponent(ON.text('change job'));
      await text6.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : monitor_MonitorDecoratorObjectTraceObservedV2
     * @tc.name       : monitor_MonitorDecoratorObjectTraceObservedV2
     * @tc.desc       : monitor
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('monitor_MonitorDecoratorObjectTraceObservedV2', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('monitor')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('monitor_decorator_object_trace_observed_v2')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change num'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : monitor_MonitorDecoratorInheritanceSupportObservedV2
     * @tc.name       : monitor_MonitorDecoratorInheritanceSupportObservedV2
     * @tc.desc       : monitor
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('monitor_MonitorDecoratorInheritanceSupportObservedV2', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('monitor')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('monitor_decorator_inheritance_support_observed_v2')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change name'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : monitor_MonitorDecoratorArraySupport
     * @tc.name       : monitor_MonitorDecoratorArraySupport
     * @tc.desc       : monitor
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('monitor_MonitorDecoratorArraySupport', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('monitor')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('monitor_decorator_array_support')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('Change dimensionTwo'));
      await text2.click();
      await driver.delayMs(200);
      const text4 =
        await driver.findComponent(ON.text('Change dimensionThree'));
      await text4.click();
      await driver.delayMs(200);
      const text5 =
        await driver.findComponent(ON.text('Change info property'));
      await text5.click();
      await driver.delayMs(200);
      const text6 =
        await driver.findComponent(ON.text('Change whole infoArr'));
      await text6.click();
      await driver.delayMs(200);
      const text7 =
        await driver.findComponent(ON.text('Push new info to infoArr'));
      await text7.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })
    /**
     * @tc.number     : monitor_MonitorDecoratorObjectSupport
     * @tc.name       : monitor_MonitorDecoratorObjectSupport
     * @tc.desc       : monitor
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('monitor_MonitorDecoratorObjectSupport', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('monitor')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 4000);
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('monitor_decorator_object_support')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('Step1: Only change name'));
      await text2.click();
      await driver.delayMs(200);
      const text3 =
        await driver.findComponent(ON.text('Step2: Only change age'));
      await text3.click();
      await driver.delayMs(200);
      const text4 =
        await driver.findComponent(ON.text('Step3: Change name and age'));
      await text4.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : monitor_MonitorDecoratorLastWrite
     * @tc.name       : monitor_MonitorDecoratorLastWrite
     * @tc.desc       : monitor
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('monitor_MonitorDecoratorLastWrite', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('monitor')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 4000);
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('monitor_decorator_last_write')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change count to 1000'));
      await text2.click();
      await driver.delayMs(200);
      const text3 =
        await driver.findComponent(ON.text('change count to 0 then to 1000'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : monitor_MonitorLimitationLastListenerWins
     * @tc.name       : monitor_MonitorLimitationLastListenerWins
     * @tc.desc       : monitor
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('monitor_MonitorLimitationLastListenerWins', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('monitor')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 4000);
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('monitor_limitation_last_listener_wins')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change name'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : monitor_MonitorLimitationMultiplePathParams
     * @tc.name       : monitor_MonitorLimitationMultiplePathParams
     * @tc.desc       : monitor
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('monitor_MonitorLimitationMultiplePathParams', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('monitor')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 4000);
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('monitor_limitation_multiple_path_params')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change name'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : monitor_MonitorSceneDeepAttributeChanges
     * @tc.name       : monitor_MonitorSceneDeepAttributeChanges
     * @tc.desc       : monitor
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('monitor_MonitorSceneDeepAttributeChanges', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('monitor')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 4000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 4000);
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('monitor_scene_deep_attribute_changes')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change!'));
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

    /**
     * @tc.number     : monitor_MonitorProblemEffectTimeCompV2
     * @tc.name       : monitor_MonitorProblemEffectTimeCompV2
     * @tc.desc       : monitor
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('monitor_MonitorProblemEffectTimeCompV2', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('monitor')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 4000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('monitor_problem_effect_time_comp_v2')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('show/hide Child'));
      await text2.click();
      await driver.delayMs(200);
      const text3 =
        await driver.findComponent(ON.text('change message in Index'));
      await text3.click();
      await driver.delayMs(200);
      const text4 =
        await driver.findComponent(ON.text('change message in Child'));
      await text4.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : monitor_MonitorProblemEffectTimeClass
     * @tc.name       : monitor_MonitorProblemEffectTimeClass
     * @tc.desc       : monitor
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('monitor_MonitorProblemEffectTimeClass', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('monitor')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 4000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('monitor_problem_effect_time_class')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change message'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : monitor_MonitorProblemClassDelayed
     * @tc.name       : monitor_MonitorProblemClassDelayed
     * @tc.desc       : monitor
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('monitor_MonitorProblemClassDelayed', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('monitor')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('monitor_problem_class_delayed')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change showFlag'));
      await text2.click();
      await driver.delayMs(300);
      const text3 =
        await driver.findComponent(ON.text('change number'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : monitor_MonitorProblemClassFailureTimeSetComp
     * @tc.name       : monitor_MonitorProblemClassFailureTimeSetComp
     * @tc.desc       : monitor
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('monitor_MonitorProblemClassFailureTimeSetComp', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('monitor')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('monitor_problem_class_failure_time_set_comp')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change showFlag'));
      await text2.click();
      await driver.delayMs(300);
      const text3 =
        await driver.findComponent(ON.text('change number'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : monitor_MonitorProblemClassFailureTimeEmptyObject
     * @tc.name       : monitor_MonitorProblemClassFailureTimeEmptyObject
     * @tc.desc       : monitor
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('monitor_MonitorProblemClassFailureTimeEmptyObject', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('monitor')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('monitor_problem_class_failure_time_empty_object')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change showFlag'));
      await text2.click();
      await driver.delayMs(300);
      const text3 =
        await driver.findComponent(ON.text('change number'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : monitor_MonitorProblemParamCounterExample1
     * @tc.name       : monitor_MonitorProblemParamCounterExample1
     * @tc.desc       : monitor
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('monitor_MonitorProblemParamCounterExample1', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('monitor')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(2000);
      await driver.swipe(100, 600, 200, 20, 3000);
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('monitor_problem_param_counter_example_1')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change age&name'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : monitor_MonitorProblemParamPositiveExample1
     * @tc.name       : monitor_MonitorProblemParamPositiveExample1
     * @tc.desc       : monitor
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('monitor_MonitorProblemParamPositiveExample1', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('monitor')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(2000);
      await driver.swipe(100, 600, 200, 20, 3000);
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('monitor_problem_param_positive_example_1')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change age&name'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : monitor_MonitorProblemParamCounterExample2
     * @tc.name       : monitor_MonitorProblemParamCounterExample2
     * @tc.desc       : monitor
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('monitor_MonitorProblemParamCounterExample2', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('monitor')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(2000);
      await driver.swipe(100, 600, 200, 20, 3000);
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('monitor_problem_param_counter_example_2')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change age'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : monitor_MonitorProblemParamPositiveExample2
     * @tc.name       : monitor_MonitorProblemParamPositiveExample2
     * @tc.desc       : monitor
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('monitor_MonitorProblemParamPositiveExample2', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('monitor')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(2000);
      await driver.swipe(100, 600, 200, 20, 3000);
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('monitor_problem_param_positive_example_2')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change age'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : monitor_MonitorProblemParamStateVariables
     * @tc.name       : monitor_MonitorProblemParamStateVariables
     * @tc.desc       : monitor
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('monitor_MonitorProblemParamStateVariables', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('monitor')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(2000);
      await driver.swipe(100, 600, 200, 20, 3000);
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('monitor_problem_param_state_variables')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change age'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : monitor_MonitorProblemStateChangeUseAddMonitor
     * @tc.name       : monitor_MonitorProblemStateChangeUseAddMonitor
     * @tc.desc       : monitor
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('monitor_MonitorProblemStateChangeUseAddMonitor', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('monitor')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(2000);
      await driver.swipe(100, 600, 200, 20, 4000);
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('monitor_problem_state_change_use_addMonitor')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('set user to undefined'));
      await text2.click();
      await driver.delayMs(300);
      const text3 =
        await driver.findComponent(ON.text('set user to User'));
      await text3.click();
      await driver.delayMs(300);
      const text4 =
        await driver.findComponent(ON.text('set user to null'));
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