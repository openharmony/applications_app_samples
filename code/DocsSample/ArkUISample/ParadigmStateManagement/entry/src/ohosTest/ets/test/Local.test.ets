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
      await driver.delayMs(300);
      const text3 = await driver.findComponent(ON.text('change name'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : local_LocalObserveChangesArray
     * @tc.name       : local_LocalObserveChangesArray
     * @tc.desc       : local
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('local_LocalObserveChangesArray', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('local')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('local_observe_changes_array')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('change array item'));
      await text2.click();
      await driver.delayMs(300);
      const text3 = await driver.findComponent(ON.text('change whole array'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : local_LocalObserveChangesDeepObject
     * @tc.name       : local_LocalObserveChangesDeepObject
     * @tc.desc       : local
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('local_LocalObserveChangesDeepObject', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('local')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('local_observe_changes_deep_object')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('change infoArr item'));
      await text2.click();
      await driver.delayMs(300);
      const text3 = await driver.findComponent(ON.text('change originInfo'));
      await text3.click();
      await driver.delayMs(300);
      const text4 = await driver.findComponent(ON.text('change originInfo region'));
      await text4.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : local_LocalUseCaseObject
     * @tc.name       : local_LocalUseCaseObject
     * @tc.desc       : local
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('local_LocalUseCaseObject', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('local')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('local_use_case_object')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('change info&localInfo'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : local_LocalUseCaseArray
     * @tc.name       : local_LocalUseCaseArray
     * @tc.desc       : local
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('local_LocalUseCaseArray', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('local')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('local_use_case_array')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('init array'));
      await text2.click();
      await driver.delayMs(300);
      const text3 = await driver.findComponent(ON.text('push'));
      await text3.click();
      await driver.delayMs(300);
      const text4 = await driver.findComponent(ON.text('reverse'));
      await text4.click();
      await driver.delayMs(300);
      const text5 = await driver.findComponent(ON.text('fill'));
      await text5.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : local_LocalUseCaseDate
     * @tc.name       : local_LocalUseCaseDate
     * @tc.desc       : local
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('local_LocalUseCaseDate', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('local')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('local_use_case_date')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('set selectedDate to 2023-07-08'));
      await text2.click();
      await driver.delayMs(300);
      const text3 = await driver.findComponent(ON.text('increase the year by 1'));
      await text3.click();
      await driver.delayMs(300);
      const text4 = await driver.findComponent(ON.text('increase the month by 1'));
      await text4.click();
      await driver.delayMs(300);
      const text5 = await driver.findComponent(ON.text('increase the day by 1'));
      await text5.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : local_LocalUseCaseMap
     * @tc.name       : local_LocalUseCaseMap
     * @tc.desc       : local
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('local_LocalUseCaseMap', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('local')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('local_use_case_map')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('init map'));
      await text2.click();
      await driver.delayMs(300);
      const text3 = await driver.findComponent(ON.text('set new one'));
      await text3.click();
      await driver.delayMs(300);
      const text4 = await driver.findComponent(ON.text('clear'));
      await text4.click();
      await driver.delayMs(300);
      const text5 = await driver.findComponent(ON.text('replace key 0'));
      await text5.click();
      await driver.delayMs(300);
      const text6 = await driver.findComponent(ON.text('delete key 0'));
      await text6.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : local_LocalUseCaseSet
     * @tc.name       : local_LocalUseCaseSet
     * @tc.desc       : local
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('local_LocalUseCaseSet', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('local')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('local_use_case_set')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('init set'));
      await text2.click();
      await driver.delayMs(300);
      const text3 = await driver.findComponent(ON.text('set new one'));
      await text3.click();
      await driver.delayMs(300);
      const text4 = await driver.findComponent(ON.text('clear'));
      await text4.click();
      await driver.delayMs(300);
      const text5 = await driver.findComponent(ON.text('delete the first one'));
      await text5.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : local_LocalUseCaseJoin
     * @tc.name       : local_LocalUseCaseJoin
     * @tc.desc       : local
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('local_LocalUseCaseJoin', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('local')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('local_use_case_join')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('change to undefined'));
      await text2.click();
      await driver.delayMs(300);
      const text3 = await driver.findComponent(ON.text('change to number'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : local_LocalQuestionSparkUpdate
     * @tc.name       : local_LocalQuestionSparkUpdate
     * @tc.desc       : local
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('local_LocalQuestionSparkUpdate', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('local')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('local_question_spark_update')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('change to self'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : local_LocalQuestionUIUtils
     * @tc.name       : local_LocalQuestionUIUtils
     * @tc.desc       : local
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('local_LocalQuestionUIUtils', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('local')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('local_question_ui_utils')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('change to self'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : local_LocalQuestionV2animateTo
     * @tc.name       : local_LocalQuestionV2animateTo
     * @tc.desc       : local
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('local_LocalQuestionV2animateTo', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('local')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('local_question_v2_animate_to')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('change size'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : local_LocalQuestionExpectedEffect
     * @tc.name       : local_LocalQuestionExpectedEffect
     * @tc.desc       : local
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('local_LocalQuestionExpectedEffect', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('local')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 800, 200, 20, 6000);
      await driver.delayMs(1500);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('local_question_expected_effect')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('change size'));
      await text2.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })
  })
}