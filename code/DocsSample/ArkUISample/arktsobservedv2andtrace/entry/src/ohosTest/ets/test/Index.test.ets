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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;
let driver: Driver;
const TAG = '[Sample_arktsobservedv2andtrace]';
const DOMAIN = 0xF811;
const BUNDLE = 'arktsobservedv2andtrace_';

export default function IndexTest() {
  describe('IndexTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      driver = Driver.create();
      await driver.delayMs(2000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(DOMAIN,TAG,BUNDLE + 'get top ability')
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })
    /**
     * @tc.number arktsobservedv2andtrace_Limitations_001
     * @tc.name LimitationsPageTest
     * @tc.desc 测试LimitationsPage是否显示正常
     */
    it('LimitationsPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Limitations_001,begin');
      let targetElement = await driver.findComponent(ON.text('Limitations', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement1 = await driver.findComponent(ON.text('name: John age: 8', MatchPattern.CONTAINS));
      expect(targetElement1 === null).assertFalse();
      await targetElement1!.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'Limitations_001,end');
    });

    /**
     * @tc.number arktsobservedv2andtrace_RealizeObservation_002
     * @tc.name RealizeObservationPageTest
     * @tc.desc 测试RealizeObservationPage是否显示正常
     */
    it('RealizeObservationPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'RealizeObservation_002,begin');
      let targetElement = await driver.findComponent(ON.text('RealizeObservation', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement1 = await driver.findComponent(ON.text('name: John age: 8', MatchPattern.CONTAINS));
      expect(targetElement1 === null).assertFalse();
      await targetElement1!.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'RealizeObservation_002,end');
    });

    /**
     * @tc.number arktsobservedv2andtrace_ObserveChanges_003
     * @tc.name ObserveChangesPageTest
     * @tc.desc 测试ObserveChangesPage是否显示正常
     */
    it('ObserveChangesPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ObserveChanges_003,begin');
      let targetElement = await driver.findComponent(ON.text('ObserveChanges', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement1 = await driver.findComponent(ON.text('100', MatchPattern.CONTAINS));
      expect(targetElement1 === null).assertFalse();
      await targetElement1!.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ObserveChanges_003,end');
    });

    /**
     * @tc.number arktsobservedv2andtrace_InheritedChanges_004
     * @tc.name InheritedChangesPageTest
     * @tc.desc 测试InheritedChangesPage是否显示正常
     */
    it('InheritedChangesPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'InheritedChanges_004,begin');
      let targetElement = await driver.findComponent(ON.text('InheritedChanges', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement1 = await driver.findComponent(ON.text('Tom', MatchPattern.CONTAINS));
      expect(targetElement1 === null).assertFalse();
      await targetElement1!.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'InheritedChanges_004,end');
    });

    /**
     * @tc.number arktsobservedv2andtrace_StaticAttribute_005
     * @tc.name StaticAttributePageTest
     * @tc.desc 测试StaticAttributePage是否显示正常
     */
    it('StaticAttributePageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StaticAttribute_005,begin');
      let targetElement = await driver.findComponent(ON.text('StaticAttribute', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement1 = await driver.findComponent(ON.text('1', MatchPattern.CONTAINS));
      expect(targetElement1 === null).assertFalse();
      await targetElement1!.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StaticAttribute_005,end');
    });

    /**
     * @tc.number arktsobservedv2andtrace_UiRefreshCannotTriggered_006
     * @tc.name UiRefreshCannotTriggeredPageTest
     * @tc.desc 测试UiRefreshCannotTriggeredPage是否显示正常
     */
    it('UiRefreshCannotTriggeredPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiRefreshCannotTriggered_006,begin');
      let targetElement = await driver.findComponent(ON.text('UiRefreshCannotTriggered', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement1 = await driver.findComponent(ON.text('8', MatchPattern.CONTAINS));
      expect(targetElement1 === null).assertFalse();
      await targetElement1!.click();
      await driver.delayMs(1000);
      let targetElement2 = await driver.findComponent(ON.text('0', MatchPattern.CONTAINS));
      expect(targetElement2 === null).assertFalse();
      await targetElement2!.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'UiRefreshCannotTriggered_006,end');
    });

    /**
     * @tc.number arktsobservedv2andtrace_UseMixture_007
     * @tc.name UseMixturePageTest
     * @tc.desc 测试UseMixturePage是否显示正常
     */
    it('UseMixturePageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'UseMixture_007,begin');
      let targetElement = await driver.findComponent(ON.text('UseMixture', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement1 = await driver.findComponent(ON.text('change age', MatchPattern.CONTAINS));
      expect(targetElement1 === null).assertFalse();
      await targetElement1!.click();
      await driver.delayMs(1000);
      let targetElement2 = await driver.findComponent(ON.text('Change job', MatchPattern.CONTAINS));
      expect(targetElement2 === null).assertFalse();
      await targetElement2!.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'UseMixture_007,end');
    });

    /**
     * @tc.number arktsobservedv2andtrace_InheritanceMixture_008
     * @tc.name InheritanceMixturePageTest
     * @tc.desc 测试InheritanceMixturePage是否显示正常
     */
    it('InheritanceMixturePageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'InheritanceMixture_008,begin');
      let targetElement = await driver.findComponent(ON.text('InheritanceMixture', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement1 = await driver.findComponent(ON.text('change age', MatchPattern.CONTAINS));
      expect(targetElement1 === null).assertFalse();
      await targetElement1!.click();
      await driver.delayMs(1000);
      let targetElement2 = await driver.findComponent(ON.text('Change job', MatchPattern.CONTAINS));
      expect(targetElement2 === null).assertFalse();
      await targetElement2!.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'InheritanceMixture_008,end');
    });

    /**
     * @tc.number arktsobservedv2andtrace_NestedClass_009
     * @tc.name NestedClassPageTest
     * @tc.desc 测试NestedClassPage是否显示正常
     */
    it('NestedClassPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'NestedClass_009,begin');
      let targetElement = await driver.findComponent(ON.text('NestedClass', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement1 = await driver.findComponent(ON.text('change length', MatchPattern.CONTAINS));
      expect(targetElement1 === null).assertFalse();
      await targetElement1!.click();
      await driver.delayMs(1000);
      let targetElement2 = await driver.findComponent(ON.text('assign Son', MatchPattern.CONTAINS));
      expect(targetElement2 === null).assertFalse();
      await targetElement2!.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'NestedClass_009,end');
    });

    /**
     * @tc.number arktsobservedv2andtrace_InheritanceClass_010
     * @tc.name InheritanceClassPageTest
     * @tc.desc 测试InheritanceClassPage是否显示正常
     */
    it('InheritanceClassPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'InheritanceClass_010,begin');
      let targetElement = await driver.findComponent(ON.text('InheritanceClass', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement1 = await driver.findComponent(ON.text('change Son age', MatchPattern.CONTAINS));
      expect(targetElement1 === null).assertFalse();
      await targetElement1!.click();
      await driver.delayMs(1000);
      let targetElement2 = await driver.findComponent(ON.text('change Cousin age', MatchPattern.CONTAINS));
      expect(targetElement2 === null).assertFalse();
      await targetElement2!.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'InheritanceClass_010,end');
    });

    /**
     * @tc.number arktsobservedv2andtrace_DecorationFoundation_011
     * @tc.name DecorationFoundationPageTest
     * @tc.desc 测试DecorationFoundationPage是否显示正常
     */
    it('DecorationFoundationPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecorationFoundation_011,begin');
      let targetElement = await driver.findComponent(ON.text('DecorationFoundation', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement1 = await driver.findComponent(ON.text('push', MatchPattern.CONTAINS));
      expect(targetElement1 === null).assertFalse();
      await targetElement1!.click();
      await driver.delayMs(1000);
      let targetElement2 = await driver.findComponent(ON.text('pop', MatchPattern.CONTAINS));
      expect(targetElement2 === null).assertFalse();
      await targetElement2!.click();
      await driver.delayMs(1000);
      let targetElement3 = await driver.findComponent(ON.text('shift', MatchPattern.CONTAINS));
      expect(targetElement3 === null).assertFalse();
      await targetElement3!.click();
      await driver.delayMs(1000);
      let targetElement4 = await driver.findComponent(ON.text('splice', MatchPattern.CONTAINS));
      expect(targetElement4 === null).assertFalse();
      await targetElement4!.click();
      await driver.delayMs(1000);
      let targetElement5 = await driver.findComponent(ON.text('unshift', MatchPattern.CONTAINS));
      expect(targetElement5 === null).assertFalse();
      await targetElement5!.click();
      await driver.delayMs(1000);
      let targetElement6 = await driver.findComponent(ON.text('copywithin', MatchPattern.CONTAINS));
      expect(targetElement6 === null).assertFalse();
      await targetElement6!.click();
      await driver.delayMs(1000);
      let targetElement7 = await driver.findComponent(ON.text('fill', MatchPattern.CONTAINS));
      expect(targetElement7 === null).assertFalse();
      await targetElement7!.click();
      await driver.delayMs(1000);
      let targetElement8 = await driver.findComponent(ON.text('reverse', MatchPattern.CONTAINS));
      expect(targetElement8 === null).assertFalse();
      await targetElement8!.click();
      await driver.delayMs(1000);
      let targetElement9 = await driver.findComponent(ON.text('sort', MatchPattern.CONTAINS));
      expect(targetElement9 === null).assertFalse();
      await targetElement9!.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecorationFoundation_011,end');
    });

    /**
     * @tc.number arktsobservedv2andtrace_DecorativeObject_012
     * @tc.name DecorativeObjectPageTest
     * @tc.desc 测试DecorativeObjectPage是否显示正常
     */
    it('DecorativeObjectPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecorativeObject_012,begin');
      let targetElement = await driver.findComponent(ON.text('DecorativeObject', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecorativeObject_012,end');
    });

    /**
     * @tc.number arktsobservedv2andtrace_DecorationMap_013
     * @tc.name DecorationMapPageTest
     * @tc.desc 测试DecorationMapPage是否显示正常
     */
    it('DecorationMapPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecorationMap_013,begin');
      let targetElement = await driver.findComponent(ON.text('DecorationMap', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecorationMap_013,end');
    });

    /**
     * @tc.number arktsobservedv2andtrace_DecorationSet_014
     * @tc.name DecorationSetPageTest
     * @tc.desc 测试DecorationSetPage是否显示正常
     */
    it('DecorationSetPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecorationSet_014,begin');
      let targetElement = await driver.findComponent(ON.text('DecorationSet', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecorationSet_014,end');
    });

    /**
     * @tc.number arktsobservedv2andtrace_DecorateDate_015
     * @tc.name DecorateDatePageTest
     * @tc.desc 测试DecorateDatePage是否显示正常
     */
    it('DecorateDatePageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecorateDate_015,begin');
      let targetElement = await driver.findComponent(ON.text('DecorateDate', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecorateDate_015,end');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('assertEqual', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'test'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })
  })
}