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

import { describe, beforeAll, it, expect, Level, Size, TestType } from '@ohos/hypium'
// 导入测试依赖kit
import { abilityDelegatorRegistry, Driver, ON, MouseButton, Component, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator;
abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let want: Want;

const TAG = '[Sample_ReusableComponent]';
const DOMAIN = 0xF811;
const BUNDLE = 'ReusableComponent_';
const ONE_SECONDS_TIME = 1000;

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

export default function IndexTest() {

  describe('IndexTest', () => {

    beforeAll(async () => {
    })

    /**
     * @tc.number: ReusableForCustomComponentsTest_001
     * @tc.name: Reusable for custom component
     * @tc.desc: Test reusable for custom component
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('ReusableForCustomComponentsTest_001', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableForCustomComponentsTest_001, begin');
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(ONE_SECONDS_TIME);
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('ReusableForCustomComponents', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.pressBack();
      await driver.delayMs(ONE_SECONDS_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableForCustomComponentsTest_001, end');
      done();
    })

    /**
     * @tc.number: ComponentContentNotSupportReusableTest_001
     * @tc.name: ComponentContent not support reusable
     * @tc.desc: Test componentContent not support reusable
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('ComponentContentNotSupportReusableTest_001', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentContentNotSupportReusableTest_001, begin');
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(ONE_SECONDS_TIME);
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('ComponentContentNotSupportReusable',
        MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.pressBack();
      await driver.delayMs(ONE_SECONDS_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentContentNotSupportReusableTest_001, end');
      done();
    })

    /**
     * @tc.number: ReusableCorrectSampleTest_001
     * @tc.name: Reusable correct sample test
     * @tc.desc: Test reusable correct sample
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('ReusableCorrectSampleTest_001', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableCorrectSampleTest_001, begin');
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(ONE_SECONDS_TIME);
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('ReusableCorrectSample', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.pressBack();
      await driver.delayMs(ONE_SECONDS_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableCorrectSampleTest_001, end');
      done();
    })

    /**
     * @tc.number: DynamicLayoutUpdateTest_001
     * @tc.name: Dynamic layout update
     * @tc.desc: Test dynamic layout update
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('DynamicLayoutUpdateTest_001', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DynamicLayoutUpdateTest_001, begin');
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(ONE_SECONDS_TIME);
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('DynamicLayoutUpdate', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.pressBack();
      await driver.delayMs(ONE_SECONDS_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DynamicLayoutUpdateTest_001, end');
      done();
    })

    /**
     * @tc.number: ListScrollingWithLazyForEachTest_001
     * @tc.name: List scrolling with lazy for each
     * @tc.desc: Test list scrolling with lazy for each
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('ListScrollingWithLazyForEachTest_001', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ListScrollingWithLazyForEachTest_001, begin');
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(ONE_SECONDS_TIME);
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('ListScrollingWithLazyForEach', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.pressBack();
      await driver.delayMs(ONE_SECONDS_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ListScrollingWithLazyForEachTest_001, end');
      done();
    })

    /**
     * @tc.number: ListScrollingWithIfStatementsTest_001
     * @tc.name: List scrolling with if statements
     * @tc.desc: Test list scrolling with if statements
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('ListScrollingWithIfStatementsTest_001', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ListScrollingWithIfStatementsTest_001, begin');
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(ONE_SECONDS_TIME);
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('ListScrollingWithIfStatements', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.pressBack();
      await driver.delayMs(ONE_SECONDS_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ListScrollingWithIfStatementsTest_001, end');
      done();
    })

    /**
     * @tc.number: ReusableForGridUsageScenarioTest_001
     * @tc.name: Reusable for grid usage scenario
     * @tc.desc: Test reusable for grid usage scenario
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('ReusableForGridUsageScenarioTest_001', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableForGridUsageScenarioTest_001, begin');
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(ONE_SECONDS_TIME);
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('ReusableForGridUsageScenario', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.pressBack();
      await driver.delayMs(ONE_SECONDS_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableForGridUsageScenarioTest_001, end');
      done();
    })

    /**
     * @tc.number: ReusableForListItemGroupUsageScenarioTest_001
     * @tc.name: Reusable for list item group usage scenario
     * @tc.desc: Test reusable for list item group usage scenario
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('ReusableForListItemGroupUsageScenarioTest_001', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableForListItemGroupUsageScenarioTest_001, begin');
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(ONE_SECONDS_TIME);
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('ReusableForListItemGroupUsageScenario', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.pressBack();
      await driver.delayMs(ONE_SECONDS_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableForListItemGroupUsageScenarioTest_001, end');
      done();
    })

    /**
     * @tc.number: ReusableIncorrectSampleTest_001
     * @tc.name: Reusable incorrect sample
     * @tc.desc: Test incorrect sample
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('ReusableIncorrectSampleTest_001', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableIncorrectSampleTest_001, begin');
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(ONE_SECONDS_TIME);
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('ReusableIncorrectSample', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.pressBack();
      await driver.delayMs(ONE_SECONDS_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableIncorrectSampleTest_001, end');
      done();
    })

    /**
     * @tc.number: ListScrollingWithForEachTest_001
     * @tc.name: List scrolling with for each
     * @tc.desc: Test list scrolling with for each
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('ListScrollingWithForEachTest_001', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ListScrollingWithForEachTest_001, begin');
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(ONE_SECONDS_TIME);
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('ListScrollingWithForEach', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.pressBack();
      await driver.delayMs(ONE_SECONDS_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ListScrollingWithForEachTest_001, end');
      done();
    })

    /**
     * @tc.number: ReusableForWaterFlowUsageScenarioTest_001
     * @tc.name: Reusable for water flow usage scenario
     * @tc.desc: Test reusable for water flow usage scenario
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('ReusableForWaterFlowUsageScenarioTest_001', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableForWaterFlowUsageScenarioTest_001, begin');
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(ONE_SECONDS_TIME);
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('ReusableForWaterFlowUsageScenario', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.pressBack();
      await driver.delayMs(ONE_SECONDS_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableForWaterFlowUsageScenarioTest_001, end');
      done();
    })

    /**
     * @tc.number: ReusableForSwiperUsageScenarioTest_001
     * @tc.name: Reusable for swiper usage scenario
     * @tc.desc: Test reusable for swiper usage scenario
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('ReusableForSwiperUsageScenarioTest_001', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableForSwiperUsageScenarioTest_001, begin');
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(ONE_SECONDS_TIME);
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('ReusableForSwiperUsageScenario', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.pressBack();
      await driver.delayMs(ONE_SECONDS_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableForSwiperUsageScenarioTest_001, end');
      done();
    })

    /**
     * @tc.number: ReusableForCompositeTest_001
     * @tc.name: Reusable for composite
     * @tc.desc: Test reusable for composite
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('ReusableForCompositeTest_001', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableForCompositeTest_001, begin');
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(ONE_SECONDS_TIME);
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('ReusableForComposite', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.pressBack();
      await driver.delayMs(ONE_SECONDS_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableForCompositeTest_001, end');
      done();
    })

    /**
     * @tc.number: ReusableForLimitedVariationTest_001
     * @tc.name: Reusable for limited variation
     * @tc.desc: Test reusable for limited variation
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('ReusableForLimitedVariationTest_001', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableForLimitedVariationTest_001, begin');
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(ONE_SECONDS_TIME);
      let driver = Driver.create();
      let button_list = await driver.findComponent(ON.text('ReusableForLimitedVariation', MatchPattern.CONTAINS));
      expect(button_list === null).assertFalse();
      await button_list.click();
      await driver.pressBack();
      await driver.delayMs(ONE_SECONDS_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableForLimitedVariationTest_001, end');
      done();
    })
  })
}