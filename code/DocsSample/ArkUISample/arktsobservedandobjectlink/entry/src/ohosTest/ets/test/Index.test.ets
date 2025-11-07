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
const TAG = '[Sample_ArkTSObservedAndObjectlink]';
const DOMAIN = 0xF811;
const BUNDLE = 'ArkTSObservedAndObjectlink_';

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
     * @tc.number arktsobservedandobjectlink_DecoratorDescription_001
     * @tc.name DecoratorDescriptionPageTest
     * @tc.desc 测试DecoratorDescriptionPage是否显示正常
     */
    it('DecoratorDescriptionPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN,TAG,BUNDLE + 'DecoratorDescription_001,begin')
      let targetElement = await driver.findComponent(ON.text('DecoratorDescription', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN,TAG,BUNDLE + 'DecoratorDescription_001,end')
    });
    /**
     * @tc.number arktsobservedandobjectlink_ObservationChangeInheritance_002
     * @tc.name ObservationChangeInheritancePageTest
     * @tc.desc 测试ObservationChangeInheritancePage是否显示正常
     */
    it('ObservationChangeInheritancePageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN,TAG,BUNDLE + 'ObservationChangeInheritance_002,begin')
      let targetElement = await driver.findComponent(ON.text('ObservationChangeInheritance', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement2 = await driver.findComponent(ON.text('child increase the day by 1', MatchPattern.CONTAINS));
      expect(targetElement2 === null).assertFalse();
      await targetElement2.click();
      await driver.delayMs(1000);
      let targetElement3 = await driver.findComponent(ON.text('parent update the new date', MatchPattern.CONTAINS));
      expect(targetElement3 === null).assertFalse();
      await targetElement3.click();
      await driver.delayMs(1000);
      let targetElement4 = await driver.findComponent(ON.text('ViewB: this.newData = new NewDate(new DateClass(\'2023-08-20\'))', MatchPattern.CONTAINS));
      expect(targetElement4 === null).assertFalse();
      await targetElement4.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN,TAG,BUNDLE + 'ObservationChangeInheritance_002,end')
    });

    /**
     * @tc.number arktsobservedandobjectlink_RestrictiveConditionsObserved_003
     * @tc.name RestrictiveConditionsObservedPageTest
     * @tc.desc 测试RestrictiveConditionsObservedPage是否显示正常
     */
    it('RestrictiveConditionsObservedPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN,TAG,BUNDLE + 'RestrictiveConditionsObserved_003,begin')
      let targetElement = await driver.findComponent(ON.text('RestrictiveConditionsObserved', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN,TAG,BUNDLE + 'RestrictiveConditionsObserved_003,end')
    });

    /**
     * @tc.number arktsobservedandobjectlink_ReadOnlyVariable_004
     * @tc.name ReadOnlyVariablePageTest
     * @tc.desc 测试ReadOnlyVariablePage是否显示正常
     */
    it('ReadOnlyVariablePageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN,TAG,BUNDLE + 'ReadOnlyVariable_004,begin')
      let targetElement = await driver.findComponent(ON.text('ReadOnlyVariable', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement2 = await driver.findComponent(ON.text('click', MatchPattern.CONTAINS));
      expect(targetElement2=== null).assertFalse();
      await targetElement2.click();
      await driver.delayMs(1000);
      let targetElement3 = await driver.findComponent(ON.text('num value', MatchPattern.CONTAINS));
      expect(targetElement3=== null).assertFalse();
      await targetElement3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN,TAG,BUNDLE + 'ReadOnlyVariable_004,end')
    });

    /**
     * @tc.number arktsobservedandobjectlink_NestedObject_005
     * @tc.name NestedObjectPageTest
     * @tc.desc 测试NestedObjectPage是否显示正常
     */
    it('NestedObjectPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN,TAG,BUNDLE + 'NestedObject_005,begin')
      let targetElement = await driver.findComponent(ON.text('NestedObject', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement2 = await driver.findComponent(ON.text('change bag.book.name', MatchPattern.CONTAINS));
      expect(targetElement2=== null).assertFalse();
      await targetElement2.click();
      await driver.delayMs(1000);
      let targetElement3 = await driver.findComponent(ON.text('change book.name', MatchPattern.CONTAINS));
      expect(targetElement3=== null).assertFalse();
      await targetElement3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN,TAG,BUNDLE + 'NestedObject_005,end')
    });

    /**
     * @tc.number arktsobservedandobjectlink_ObjectArray_006
     * @tc.name ObjectArrayPageTest
     * @tc.desc 测试ObjectArrayPage是否显示正常
     */
    it('ObjectArrayPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN,TAG,BUNDLE + 'ObjectArray_006,end')
      let targetElement = await driver.findComponent(ON.text('ObjectArray', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement2 = await driver.findComponent(ON.text('ViewChild [#1]', MatchPattern.CONTAINS));
      expect(targetElement2=== null).assertFalse();
      await targetElement2.click();
      await driver.delayMs(1000);
      let targetElement3 = await driver.findComponent(ON.text('ViewChild [#2]', MatchPattern.CONTAINS));
      expect(targetElement3=== null).assertFalse();
      await targetElement3.click();
      await driver.delayMs(1000);
      let targetElement4 = await driver.findComponent(ON.text('ViewChild this.arrA[first]', MatchPattern.CONTAINS));
      expect(targetElement4=== null).assertFalse();
      await targetElement4.click();
      await driver.delayMs(1000);
      let targetElement5 = await driver.findComponent(ON.text('ViewChild this.arrA[last]', MatchPattern.CONTAINS));
      expect(targetElement5=== null).assertFalse();
      await targetElement5.click();
      await driver.delayMs(1000);
      let targetElement6 = await driver.findComponent(ON.text('ViewParent: reset array', MatchPattern.CONTAINS));
      expect(targetElement6=== null).assertFalse();
      await targetElement6.click();
      await driver.delayMs(1000);
      let targetElement7 = await driver.findComponent(ON.text('ViewParent: push', MatchPattern.CONTAINS));
      expect(targetElement7=== null).assertFalse();
      await targetElement7.click();
      await driver.delayMs(1000);
      let targetElement8 = await driver.findComponent(ON.text('ViewParent: shift', MatchPattern.CONTAINS));
      expect(targetElement8=== null).assertFalse();
      await targetElement8.click();
      await driver.delayMs(1000);
      const buttons = await driver.findComponents(ON.text('ViewParent: item property in middle', MatchPattern.CONTAINS));
      expect(buttons.length >= 2).assertTrue();
      const firstButton = buttons[0];
      expect(firstButton === null).assertFalse();
      await firstButton.click();
      await driver.delayMs(1000);
      const secondButton = buttons[1];
      expect(secondButton === null).assertFalse();
      await secondButton.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN,TAG,BUNDLE + 'ObjectArray_006,end')
    });

    /**
     * @tc.number arktsobservedandobjectlink_TwoDimensionalArray_007
     * @tc.name TwoDimensionalArrayPageTest
     * @tc.desc 测试TwoDimensionalArrayPage是否显示正常
     */
    it('TwoDimensionalArrayPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN,TAG,BUNDLE + 'TwoDimensionalArray_007,begin')
      let targetElement = await driver.findComponent(ON.text('TwoDimensionalArray', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement2 = await driver.findComponent(ON.text('push two-dimensional array item', MatchPattern.CONTAINS));
      expect(targetElement2=== null).assertFalse();
      await targetElement2.click();
      await driver.delayMs(1000);
      let targetElement3 = await driver.findComponent(ON.text('push array item', MatchPattern.CONTAINS));
      expect(targetElement3=== null).assertFalse();
      await targetElement3.click();
      await driver.delayMs(1000);
      let targetElement4 = await driver.findComponent(ON.text('change two-dimensional array first item', MatchPattern.CONTAINS));
      expect(targetElement4=== null).assertFalse();
      await targetElement4.click();
      await driver.delayMs(1000);
      let targetElement5 = await driver.findComponent(ON.text('change array first item', MatchPattern.CONTAINS));
      expect(targetElement5=== null).assertFalse();
      await targetElement5.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN,TAG,BUNDLE + 'TwoDimensionalArray_007,end')
    });

    /**
     * @tc.number arktsobservedandobjectlink_CompleteExampleTwoDimensionalArray_008
     * @tc.name CompleteExampleTwoDimensionalArrayPageTest
     * @tc.desc 测试CompleteExampleTwoDimensionalArrayPage是否显示正常
     */
    it('CompleteExampleTwoDimensionalArrayPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN,TAG,BUNDLE + 'CompleteExampleTwoDimensionalArray_008,begin')
      let targetElement = await driver.findComponent(ON.text('CompleteExampleTwoDimensionalArray', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement2 = await driver.findComponent(ON.text('push two-dimensional array item', MatchPattern.CONTAINS));
      expect(targetElement2=== null).assertFalse();
      await targetElement2.click();
      await driver.delayMs(1000);
      let targetElement3 = await driver.findComponent(ON.text('push array item', MatchPattern.CONTAINS));
      expect(targetElement3=== null).assertFalse();
      await targetElement3.click();
      await driver.delayMs(1000);
      let targetElement4 = await driver.findComponent(ON.text('change two-dimensional array first item', MatchPattern.CONTAINS));
      expect(targetElement4=== null).assertFalse();
      await targetElement4.click();
      await driver.delayMs(1000);
      let targetElement5 = await driver.findComponent(ON.text('change array first item', MatchPattern.CONTAINS));
      expect(targetElement5=== null).assertFalse();
      await targetElement5.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN,TAG,BUNDLE + 'CompleteExampleTwoDimensionalArray_008,end')
    });

    /**
     * @tc.number arktsobservedandobjectlink_InheritFromMapClass_009
     * @tc.name InheritFromMapClassPageTest
     * @tc.desc 测试InheritFromMapClassPage是否显示正常
     */
    it('InheritFromMapClassPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN,TAG,BUNDLE + 'InheritFromMapClass_009,begin')
      let targetElement = await driver.findComponent(ON.text('InheritFromMapClass', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement2 = await driver.findComponent(ON.text('set new one', MatchPattern.CONTAINS));
      expect(targetElement2=== null).assertFalse();
      await targetElement2.click();
      await driver.delayMs(1000);
      let targetElement3 = await driver.findComponent(ON.text('clear', MatchPattern.CONTAINS));
      expect(targetElement3=== null).assertFalse();
      await targetElement3.click();
      await driver.delayMs(1000);
      let targetElement4 = await driver.findComponent(ON.text('replace the first one', MatchPattern.CONTAINS));
      expect(targetElement4=== null).assertFalse();
      await targetElement4.click();
      await driver.delayMs(1000);
      let targetElement5 = await driver.findComponent(ON.text('delete the first one', MatchPattern.CONTAINS));
      expect(targetElement5=== null).assertFalse();
      await targetElement5.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN,TAG,BUNDLE + 'InheritFromMapClass_009,end')
    });

    /**
     * @tc.number arktsobservedandobjectlink_InheritFromSetClass_010
     * @tc.name InheritFromSetClassPageTest
     * @tc.desc 测试InheritFromSetClassPage是否显示正常
     */
    it('InheritFromSetClassPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN,TAG,BUNDLE + 'InheritFromSetClass_010,begin')
      let targetElement = await driver.findComponent(ON.text('InheritFromSetClass', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement2 = await driver.findComponent(ON.text('set new one', MatchPattern.CONTAINS));
      expect(targetElement2=== null).assertFalse();
      await targetElement2.click();
      await driver.delayMs(1000);
      let targetElement3 = await driver.findComponent(ON.text('clear', MatchPattern.CONTAINS));
      expect(targetElement3=== null).assertFalse();
      await targetElement3.click();
      await driver.delayMs(1000);
      let targetElement5 = await driver.findComponent(ON.text('delete the first one', MatchPattern.CONTAINS));
      expect(targetElement5=== null).assertFalse();
      await targetElement5.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN,TAG,BUNDLE + 'InheritFromSetClass_010,end')
    });

    /**
     * @tc.number arktsobservedandobjectlink_ObjectLinkSupportsUnionTypes_011
     * @tc.name ObjectLinkSupportsUnionTypesPageTest
     * @tc.desc 测试ObjectLinkSupportsUnionTypesPage是否显示正常
     */
    it('ObjectLinkSupportsUnionTypesPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN,TAG,BUNDLE + 'ObjectLinkSupportsUnionTypes_011,begin')
      let targetElement = await driver.findComponent(ON.text('ObjectLinkSupportsUnionTypes', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement2 = await driver.findComponent(ON.text('change count property', MatchPattern.CONTAINS));
      expect(targetElement2=== null).assertFalse();
      await targetElement2.click();
      await driver.delayMs(1000);
      let targetElement3 = await driver.findComponent(ON.text('change count to Source', MatchPattern.CONTAINS));
      expect(targetElement3=== null).assertFalse();
      await targetElement3.click();
      await driver.delayMs(1000);
      let targetElement4 = await driver.findComponent(ON.text('change count to Data', MatchPattern.CONTAINS));
      expect(targetElement4=== null).assertFalse();
      await targetElement4.click();
      await driver.delayMs(1000);
      let targetElement5 = await driver.findComponent(ON.text('change count to undefined', MatchPattern.CONTAINS));
      expect(targetElement5=== null).assertFalse();
      await targetElement5.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN,TAG,BUNDLE + 'ObjectLinkSupportsUnionTypes_011,end')
    });

    /**
     * @tc.number arktsobservedandobjectlink_BasicNesting_012
     * @tc.name BasicNestingPageTest
     * @tc.desc 测试BasicNestingPage是否显示正常
     */
    it('BasicNestingPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN,TAG,BUNDLE + 'BasicNesting_012,begin')
      let targetElement = await driver.findComponent(ON.text('BasicNesting', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement2 = await driver.findComponent(ON.text('Change Parent.parentId', MatchPattern.CONTAINS));
      expect(targetElement2=== null).assertFalse();
      await targetElement2.click();
      await driver.delayMs(1000);
      let targetElement3 = await driver.findComponent(ON.text('Change Cousin.cousinId', MatchPattern.CONTAINS));
      expect(targetElement3=== null).assertFalse();
      await targetElement3.click();
      await driver.delayMs(1000);
      let targetElement4 = await driver.findComponent(ON.text('Change childId', MatchPattern.CONTAINS));
      expect(targetElement4=== null).assertFalse();
      await targetElement4.click();
      await driver.delayMs(1000);
      let targetElement5 = await driver.findComponent(ON.text('Change Cousin.Child.childId', MatchPattern.CONTAINS));
      expect(targetElement5=== null).assertFalse();
      await targetElement5.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN,TAG,BUNDLE + 'BasicNesting_012,end')
    });

    /**
     * @tc.number arktsobservedandobjectlink_ComplexMethodsNesting_013
     * @tc.name ComplexMethodsNestingPageTest
     * @tc.desc 测试ComplexMethodsNestingPage是否显示正常
     */
    it('ComplexMethodsNestingPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN,TAG,BUNDLE + 'ComplexMethodsNesting_013,begin')
      let targetElement = await driver.findComponent(ON.text('ComplexMethodsNesting', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN,TAG,BUNDLE + 'ComplexMethodsNesting_013,end')
    });

    /**
     * @tc.number arktsobservedandobjectlink_ComplexNestingComplete_014
     * @tc.name ComplexNestingCompletePageTest
     * @tc.desc 测试ComplexNestingCompletePage是否显示正常
     */
    it('ComplexNestingCompletePageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN,TAG,BUNDLE + 'ComplexNestingComplete_014,begin')
      let targetElement = await driver.findComponent(ON.text('ComplexNestingComplete', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement2 = await driver.findComponent(ON.text('Parent: reset entire counter', MatchPattern.CONTAINS));
      expect(targetElement2=== null).assertFalse();
      await targetElement2.click();
      await driver.delayMs(1000);
      let targetElement3 = await driver.findComponent(ON.text('Parent: incr counter[0].counter', MatchPattern.CONTAINS));
      expect(targetElement3=== null).assertFalse();
      await targetElement3.click();
      await driver.delayMs(1000);
      let targetElement4 = await driver.findComponent(ON.text('Parent: set.counter to 10', MatchPattern.CONTAINS));
      expect(targetElement4=== null).assertFalse();
      await targetElement4.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN,TAG,BUNDLE + 'ComplexNestingComplete_014,end')
    });

    /**
     * @tc.number arktsobservedandobjectlink_DifferencesPropObjectLink_015
     * @tc.name DifferencesPropObjectLinkPageTest
     * @tc.desc 测试DifferencesPropObjectLinkPage是否显示正常
     */
    it('DifferencesPropObjectLinkPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN,TAG,BUNDLE + 'DifferencesPropObjectLink_015,begin')
      let targetElement = await driver.findComponent(ON.text('DifferencesPropObjectLink', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement2 = await driver.findComponent(ON.text('change @ObjectLink value', MatchPattern.CONTAINS));
      expect(targetElement2=== null).assertFalse();
      await targetElement2.click();
      await driver.delayMs(1000);
      let targetElement3 = await driver.findComponent(ON.text('change @Prop value', MatchPattern.CONTAINS));
      expect(targetElement3=== null).assertFalse();
      await targetElement3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN,TAG,BUNDLE + 'DifferencesPropObjectLink_015,end')
    });

    /**
     * @tc.number arktsobservedandobjectlink_DelayedChange_016
     * @tc.name DelayedChangePageTest
     * @tc.desc 测试DelayedChangePage是否显示正常
     */
    it('DelayedChangePageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN,TAG,BUNDLE + 'DelayedChange_016,begin')
      let targetElement = await driver.findComponent(ON.text('DelayedChange', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN,TAG,BUNDLE + 'DelayedChange_016,end')
    });

    /**
     * @tc.number arktsobservedandobjectlink_ObjectLinkDataSourceUpdate_017
     * @tc.name ObjectLinkDataSourceUpdatePageTest
     * @tc.desc 测试ObjectLinkDataSourceUpdatePage是否显示正常
     */
    it('ObjectLinkDataSourceUpdatePageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN,TAG,BUNDLE + 'ObjectLinkDataSourceUpdate_017,begin')
      let targetElement = await driver.findComponent(ON.text('ObjectLinkDataSourceUpdate', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement2 = await driver.findComponent(ON.text('Bob', MatchPattern.CONTAINS));
      expect(targetElement2=== null).assertFalse();
      await targetElement2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN,TAG,BUNDLE + 'ObjectLinkDataSourceUpdate_017,end')
    });

    /**
     * @tc.number arktsobservedandobjectlink_ClickEventJack_018
     * @tc.name ClickEventJackPageTest
     * @tc.desc 测试ClickEventJackPage是否显示正常
     */
    it('ClickEventJackPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN,TAG,BUNDLE + 'ClickEventJack_018,begin')
      let targetElement = await driver.findComponent(ON.text('ClickEventJack', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement2 = await driver.findComponent(ON.text('Bob', MatchPattern.CONTAINS));
      expect(targetElement2=== null).assertFalse();
      await targetElement2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
      hilog.info(DOMAIN,TAG,BUNDLE + 'ClickEventJack_018,end')
    });

    /**
     * @tc.number arktsobservedandobjectlink_NotTriggerUIRefresh_019
     * @tc.name NotTriggerUIRefreshPageTest
     * @tc.desc 测试NotTriggerUIRefreshPage是否显示正常
     */
    it('NotTriggerUIRefreshPageTest', 0, async (done: Function) => {
      hilog.info(DOMAIN,TAG,BUNDLE + 'NotTriggerUIRefresh_019,begin')
      let targetElement = await driver.findComponent(ON.text('NotTriggerUIRefresh', MatchPattern.CONTAINS));
      expect(targetElement === null).assertFalse();
      await targetElement!.click();
      await driver.delayMs(2000);
      let targetElement2 = await driver.findComponent(ON.text('increaseTemperature', MatchPattern.CONTAINS));
      expect(targetElement2=== null).assertFalse();
      await targetElement2.click();
      await driver.delayMs(1000);
      let targetElement3 = await driver.findComponent(ON.text('reduceTemperature', MatchPattern.CONTAINS));
      expect(targetElement3=== null).assertFalse();
      await targetElement3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.pressBack();
      done();
      hilog.info(DOMAIN,TAG,BUNDLE + 'NotTriggerUIRefresh_019,end')
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