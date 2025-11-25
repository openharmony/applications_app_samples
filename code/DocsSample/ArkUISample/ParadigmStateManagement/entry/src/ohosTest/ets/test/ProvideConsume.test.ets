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

export default function provideConsumeTest() {
  describe('provideConsumeTest', () => {
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
     * @tc.number     : provideConsume_ProvideConsumeProperDemo
     * @tc.name       : provideConsume_ProvideConsumeProperDemo
     * @tc.desc       : provideConsume
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('provideConsume_ProvideConsumeProperDemo', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('provide_and_consume')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('provide_consume_proper_demo')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : provideConsume_ProvideConsumeProperDemoTwo
     * @tc.name       : provideConsume_ProvideConsumeProperDemoTwo
     * @tc.desc       : provideConsume
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('provideConsume_ProvideConsumeProperDemoTwo', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('provide_and_consume')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('provide_consume_proper_demo_two')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : provideConsume_ProvideConsumeBidirectionalSync
     * @tc.name       : provideConsume_ProvideConsumeBidirectionalSync
     * @tc.desc       : provideConsume
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('provideConsume_ProvideConsumeBidirectionalSync', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('provide_and_consume')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('provide_consume_bidirectional_sync')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('count(0), count + 1'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : provideConsume_ProvideConsumeMapSync
     * @tc.name       : provideConsume_ProvideConsumeMapSync
     * @tc.desc       : provideConsume
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('provideConsume_ProvideConsumeMapSync', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('provide_and_consume')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('provide_consume_map_sync')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('Provide init Map'));
      await text2.click();
      await driver.delayMs(300);
      const text3 =
        await driver.findComponent(ON.text('Consume init Map'));
      await text3.click();
      await driver.delayMs(300);
      const text4 =
        await driver.findComponent(ON.text('Consume set new one'));
      await text4.click();
      await driver.delayMs(300);
      const text5 =
        await driver.findComponent(ON.text('Consume clear'));
      await text5.click();
      await driver.delayMs(300);
      const text6 =
        await driver.findComponent(ON.text('Consume replace the first item'));
      await text6.click();
      await driver.delayMs(300);
      const text7 =
        await driver.findComponent(ON.text('Consume delete the first item'));
      await text7.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : provideConsume_ProvideConsumeSetSync
     * @tc.name       : provideConsume_ProvideConsumeSetSync
     * @tc.desc       : provideConsume
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('provideConsume_ProvideConsumeSetSync', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('provide_and_consume')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('provide_consume_set_sync')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('Provide init set'));
      await text2.click();
      await driver.delayMs(300);
      const text3 =
        await driver.findComponent(ON.text('Consume init set'));
      await text3.click();
      await driver.delayMs(300);
      const text4 =
        await driver.findComponent(ON.text('Consume set new one'));
      await text4.click();
      await driver.delayMs(300);
      const text5 =
        await driver.findComponent(ON.text('Consume clear'));
      await text5.click();
      await driver.delayMs(300);
      const text6 =
        await driver.findComponent(ON.text('Consume delete the first one'));
      await text6.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : provideConsume_ProvideConsumeDateSync
     * @tc.name       : provideConsume_ProvideConsumeDateSync
     * @tc.desc       : provideConsume
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('provideConsume_ProvideConsumeDateSync', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('provide_and_consume')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('provide_consume_date_sync')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('parent increase the day by 1'));
      await text2.click();
      await driver.delayMs(300);
      const text3 =
        await driver.findComponent(ON.text('parent update the new date'));
      await text3.click();
      await driver.delayMs(300);
      const text4 =
        await driver.findComponent(ON.text('child increase the day by 1'));
      await text4.click();
      await driver.delayMs(300);
      const text5 =
        await driver.findComponent(ON.text('child update the new date'));
      await text5.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : provideConsume_ProvideConsumeFederation
     * @tc.name       : provideConsume_ProvideConsumeFederation
     * @tc.desc       : provideConsume
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('provideConsume_ProvideConsumeFederation', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('provide_and_consume')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('provide_consume_federation')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('count(Child), Child'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : provideConsume_ProvideConsumeProvideAllowOverride
     * @tc.name       : provideConsume_ProvideConsumeProvideAllowOverride
     * @tc.desc       : provideConsume
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('provideConsume_ProvideConsumeProvideAllowOverride', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('provide_and_consume')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('provide_consume_provide_allow_override')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('reviewVotes(40), give +1'));
      await text2.click();
      await driver.delayMs(500);
      const text3 =
        await driver.findComponent(ON.text('reviewVotes(10), give +1'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : provideConsume_ProvideConsumeDecoratedVariable
     * @tc.name       : provideConsume_ProvideConsumeDecoratedVariable
     * @tc.desc       : provideConsume
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('provideConsume_ProvideConsumeDecoratedVariable', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('provide_and_consume')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('provide_consume_decorated_variable')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change textOne'));
      await text2.click();
      await driver.delayMs(500);
      const text3 =
        await driver.findComponent(ON.text('change textTwo'));
      await text3.click();
      await driver.delayMs(500);
      const text4 =
        await driver.findComponent(ON.text('change provideOne'));
      await text4.click();
      await driver.delayMs(500);
      const text5 =
        await driver.findComponent(ON.text('change provideTwo'));
      await text5.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : provideConsume_ProvideConsumeTwoWay
     * @tc.name       : provideConsume_ProvideConsumeTwoWay
     * @tc.desc       : provideConsume
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('provideConsume_ProvideConsumeTwoWay', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('provide_and_consume')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('provide_consume_two_way')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('add Child'));
      await text2.click();
      await driver.delayMs(500);
      const text3 =
        await driver.findComponent(ON.text('remove Child'));
      await text3.click();
      await driver.delayMs(500);
      const text4 =
        await driver.findComponent(ON.text('dispose Child'));
      await text4.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : provideConsume_ProvideConsumeProvideError
     * @tc.name       : provideConsume_ProvideConsumeProvideError
     * @tc.desc       : provideConsume
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('provideConsume_ProvideConsumeProvideError', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('provide_and_consume')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 400, 200, 20, 600);
      await driver.delayMs(1500);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('provide_consume_provide_error')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('Hello'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : provideConsume_ProvideConsumeThisObject
     * @tc.name       : provideConsume_ProvideConsumeThisObject
     * @tc.desc       : provideConsume
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('provideConsume_ProvideConsumeThisObject', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('provide_and_consume')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 400, 200, 20, 600);
      await driver.delayMs(1500);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('provide_consume_this_object')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('changeName'));
      await text2.click();
      await driver.delayMs(500);
      const text3 =
        await driver.findComponent(ON.text('changeZooGrandChildName'));
      await text3.click();
      await driver.delayMs(500);
      const text4 =
        await driver.findComponent(ON.text('changeAge'));
      await text4.click();
      await driver.delayMs(500);
      const text5 =
        await driver.findComponent(ON.text('changeZooDogAge'));
      await text5.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })
  })
}