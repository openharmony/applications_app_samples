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

export default function InternalTest() {
  describe('InternalTest', () => {
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
     * @tc.number     : internal_Internal_ObservedV2_Trace_V1_pag1
     * @tc.name       : internal_Internal_ObservedV2_Trace_V1_pag1
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_@ObservedV2_@Trace_V1_pag1', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_ObservedV2_Trace_V1_pag1')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('push to Page2'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_ObservedV2_Trace_V1_pag2
     * @tc.name       : internal_Internal_ObservedV2_Trace_V1_pag2
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_@ObservedV2_@Trace_V1_pag2', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_ObservedV2_Trace_V1_pag2')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_ObservedV2_Trace_V2_pag1
     * @tc.name       : internal_Internal_ObservedV2_Trace_V2_pag1
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_@ObservedV2_@Trace_V2_pag1', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_ObservedV2_Trace_V2_pag1')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('push to Page2'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_ObservedV2_Trace_V2_pag2
     * @tc.name       : internal_Internal_ObservedV2_Trace_V2_pag2
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_@ObservedV2_@Trace_V2_pag2', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_ObservedV2_Trace_V2_pag2')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_Trace_setOrCreate_V1_pag1
     * @tc.name       : internal_Internal_Trace_setOrCreate_V1_pag1
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_Trace_setOrCreate_V1_pag1', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_Trace_setOrCreate_V1_pag1')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('push to Page2'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_Trace_setOrCreate_V1_pag2
     * @tc.name       : internal_Internal_Trace_setOrCreate_V1_pag2
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_Trace_setOrCreate_V1_pag2', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_Trace_setOrCreate_V1_pag2')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_Trace_customize_V1
     * @tc.name       : internal_Internal_Trace_customize_V1
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_Trace_customize_V1', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_Trace_customize_V1')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('Next Page'));
      await text2.click();
      await driver.delayMs(1000);
      const text3 = await driver.findComponent(ON.text('Next Page'));
      await text3.click();
      await driver.delayMs(1000);
      const text4 = await driver.findComponent(ON.text('Next Page'));
      await text4.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_Trace_customize_Param
     * @tc.name       : internal_Internal_Trace_customize_Param
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_Trace_customize_Param', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_Trace_customize_Param')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_AppStorage_V1_one
     * @tc.name       : internal_Internal_AppStorage_V1_one
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_AppStorage_V1_one', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_AppStorage_V1_one')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_AppStorage_V1_two
     * @tc.name       : internal_Internal_AppStorage_V1_two
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_AppStorage_V1_two', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 3000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_AppStorage_V1_two')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_AppStorage_V2_one
     * @tc.name       : internal_Internal_AppStorage_V2_one
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_AppStorage_V2_one', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 3000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_AppStorage_V2_one')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_AppStorage_V2_two
     * @tc.name       : internal_Internal_AppStorage_V2_two
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_AppStorage_V2_two', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 3000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_AppStorage_V2_two')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_StorageProp_V1_one
     * @tc.name       : internal_Internal_StorageProp_V1_one
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_StorageProp_V1_one', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_StorageProp_V1_one')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('change Storage Count'));
      await text2.click();
      await driver.delayMs(1000);
      const text3 = await driver.findComponent(ON.text('Jump to EntryAbility1'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_StorageProp_V1_two
     * @tc.name       : internal_Internal_StorageProp_V1_two
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_StorageProp_V1_two', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 2000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_StorageProp_V1_two')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('change Storage Count'));
      await text2.click();
      await driver.delayMs(1000);
      const text3 = await driver.findComponent(ON.text('Jump to EntryAbility'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_StorageProp_V2_one
     * @tc.name       : internal_Internal_StorageProp_V2_one
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_StorageProp_V2_one', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 2000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_StorageProp_V2_one')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('change Storage Count'));
      await text2.click();
      await driver.delayMs(1000);
      const text3 = await driver.findComponent(ON.text('Jump to EntryAbility1'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_StorageProp_V2_two
     * @tc.name       : internal_Internal_StorageProp_V2_two
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_StorageProp_V2_two', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 1000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_StorageProp_V2_two')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('change Storage Count'));
      await text2.click();
      await driver.delayMs(1000);
      const text3 = await driver.findComponent(ON.text('Jump to EntryAbility'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_Environment_V1
     * @tc.name       : internal_Internal_Environment_V1
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_Environment_V1', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 4000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_Environment_V1')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_Environment_V2
     * @tc.name       : internal_Internal_Environment_V2
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_Environment_V2', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 4000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_Environment_V2')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_Persistent_Storage_V1
     * @tc.name       : internal_Internal_Persistent_Storage_V1
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_Persistent_Storage_V1', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 4000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_Persistent_Storage_V1')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_Persistent_Storage_V2
     * @tc.name       : internal_Internal_Persistent_Storage_V2
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_Persistent_Storage_V2', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_Persistent_Storage_V2')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_Gradual_Migration
     * @tc.name       : internal_Internal_Gradual_Migration
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_Gradual_Migration', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_Gradual_Migration')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_Other_Migrations_List_V1
     * @tc.name       : internal_Internal_Other_Migrations_List_V1
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_Other_Migrations_List_V1', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 4000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 4000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_Other_Migrations_List_V1')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('change Default'));
      await text2.click();
      await driver.delayMs(1000);
      const text3 = await driver.findComponent(ON.text('splice 5'));
      await text3.click();
      await driver.delayMs(1000);
      const text4 = await driver.findComponent(ON.text('update 5'));
      await text4.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_Other_Migrations_List_V2
     * @tc.name       : internal_Internal_Other_Migrations_List_V2
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_Other_Migrations_List_V2', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 4000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_Other_Migrations_List_V2')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('change Default'));
      await text2.click();
      await driver.delayMs(1000);
      const text3 = await driver.findComponent(ON.text('splice 5'));
      await text3.click();
      await driver.delayMs(1000);
      const text4 = await driver.findComponent(ON.text('update 5'));
      await text4.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_Other_Migrations_WaterFlow_V1
     * @tc.name       : internal_Internal_Other_Migrations_WaterFlow_V1
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_Other_Migrations_WaterFlow_V1', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 4000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_Other_Migrations_WaterFlow_V1')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('push option'));
      await text2.click();
      await driver.delayMs(1000);
      const text3 = await driver.findComponent(ON.text('splice option'));
      await text3.click();
      await driver.delayMs(1000);
      const text4 = await driver.findComponent(ON.text('update option'));
      await text4.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_Other_Migrations_WaterFlow_V2
     * @tc.name       : internal_Internal_Other_Migrations_WaterFlow_V2
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_Other_Migrations_WaterFlow_V2', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 5000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 4000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_Other_Migrations_WaterFlow_V2')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('push option'));
      await text2.click();
      await driver.delayMs(1000);
      const text3 = await driver.findComponent(ON.text('splice option'));
      await text3.click();
      await driver.delayMs(1000);
      const text4 = await driver.findComponent(ON.text('update option'));
      await text4.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_attribute_Modifier_V1
     * @tc.name       : internal_Internal_attribute_Modifier_V1
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_attribute_Modifier_V1', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 4000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 4000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_attribute_Modifier_V1')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('Button'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_attribute_Modifier_V2
     * @tc.name       : internal_Internal_attribute_Modifier_V2
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_attribute_Modifier_V2', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 2000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_attribute_Modifier_V2')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('Button'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_Common_Modifier_V1
     * @tc.name       : internal_Internal_Common_Modifier_V1
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_Common_Modifier_V1', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 2000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_Common_Modifier_V1')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text(await getResourceString('EntryAbility_label')));
      await text2.click();
      await driver.delayMs(1000);
      await text2.click();
      await driver.delayMs(1000);
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_Common_Modifier_V2
     * @tc.name       : internal_Internal_Common_Modifier_V2
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_Common_Modifier_V2', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 4000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_Common_Modifier_V2')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text(await getResourceString('EntryAbility_label')));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_Module_Modifier_V1
     * @tc.name       : internal_Internal_Module_Modifier_V1
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_Module_Modifier_V1', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_Module_Modifier_V1')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text(await getResourceString('EntryAbility_label')));
      await text2.click();
      await driver.delayMs(1000);
      const text3 = await driver.findComponent(ON.text('replace whole'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_Module_Modifier_V2
     * @tc.name       : internal_Internal_Module_Modifier_V2
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_Module_Modifier_V2', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 7000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_Module_Modifier_V2')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text(await getResourceString('EntryAbility_label')));
      await text2.click();
      await driver.delayMs(1000);
      const text3 = await driver.findComponent(ON.text('replace whole'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_Attribute_Updater_V1
     * @tc.name       : internal_Internal_Attribute_Updater_V1
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_Attribute_Updater_V1', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_Attribute_Updater_V1')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('Button'));
      await text2.click();
      await driver.delayMs(1000);
      const text3 = await driver.findComponent(ON.text('Update'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : internal_Internal_Attribute_Updater_V2
     * @tc.name       : internal_Internal_Attribute_Updater_V2
     * @tc.desc       : internal
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('internal_Internal_Attribute_Updater_V2', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      const text = await driver.findComponent(ON.text(await getResourceString('internal_trace')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 6000);
      await driver.delayMs(1000);
      await driver.swipe(100, 600, 200, 20, 7000);
      await driver.delayMs(1000);
      const text1 = await driver.findComponent(ON.text(await getResourceString('Internal_Attribute_Updater_V2')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('Button'));
      await text2.click();
      await driver.delayMs(1000);
      const text3 = await driver.findComponent(ON.text('Update'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })
  })
}