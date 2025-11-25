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
import { afterEach, beforeAll, describe, it } from '@ohos/hypium';
import { ON } from '@ohos.UiTest';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { abilityDelegatorRegistry, Driver, Component } from '@kit.TestKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();

const BUNDLE = 'Navigation_';
const TAG = '[Sample_Navigation_]';
const DOMAIN = 0xF811;
const driver = Driver.create();

let aimComponent : Component
async function getResourceString(resource: Resource): Promise<string> {
  let manage = delegator.getAppContext().resourceManager;
  let textString: string = await manage.getStringValue(resource);
  return textString;
}

export function NavigationTest() {
  describe('NavigationTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.navigationsample',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('Navigation'));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    afterEach(async () => {

    })
    /*
     * @tc.number: PageTitleModeTest_001
     * @tc.name: PageTitleModeTest_001
     * @tc.desc: PageTitleModeTest_001
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('PageTitleModeTest_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_001_begin');
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.pageDisplayModeAuto'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.pageDisplayModeStack'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.pageDisplayModeSplit'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.titleModeMini'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.titleModeFull'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'Navigation_NavigationTest_001_end');
      done();
    })

    /*
     * @tc.number: MenusTest_002
     * @tc.name: MenusTest_002
     * @tc.desc: MenusTest_002
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('MenusTest_002', 0, async (done: Function) => {
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.menusThreeResource'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.menusThreeImage'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.menusFour'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.toolBar'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: PageDisplayTypeTest_003
     * @tc.name: PageDisplayTypeTest_003
     * @tc.desc: PageDisplayTypeTest_003
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('PageDisplayTypeTest_003', 0, async (done: Function) => {
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.pageDisplayType'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('Push DialogPage'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.pressBack();
      done();
    })

    /*
     * @tc.number: PageAnimatedTest_004
     * @tc.name: PageAnimatedTest_004
     * @tc.desc: PageAnimatedTest_004
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('PageAnimatedTest_004', 0, async (done: Function) => {
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.pageAnimated'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('push'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: PageOnceCloseTest_005
     * @tc.name: PageOnceCloseTest_005
     * @tc.desc: PageOnceCloseTest_005
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('PageOnceCloseTest_005', 0, async (done: Function) => {
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.pageOnceClose'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('push'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: GeometryTransitionTest_006
     * @tc.name: GeometryTransitionTest_006
     * @tc.desc: GeometryTransitionTest_006
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('GeometryTransitionTest_006', 0, async (done: Function) => {
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.geometryTransition'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.ToPage'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: SystemRoutingTableTest_007
     * @tc.name: SystemRoutingTableTest_007
     * @tc.desc: SystemRoutingTableTest_007
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('SystemRoutingTableTest_007', 0, async (done: Function) => {
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.systemRoutingTable'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: CustomRoutingTableTest_008
     * @tc.name: CustomRoutingTableTest_008
     * @tc.desc: CustomRoutingTableTest_008
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('CustomRoutingTableTest_008', 0, async (done: Function) => {
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.customRoutingTable'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: OnReadyParamTest_009
     * @tc.name: OnReadyParamTest_009
     * @tc.desc: OnReadyParamTest_009
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('OnReadyParamTest_009', 0, async (done: Function) => {
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.onReadyParam_text7'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPath'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: OnResultParamTest_010
     * @tc.name: OnResultParamTest_010
     * @tc.desc: OnResultParamTest_010
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('OnResultParamTest_010', 0, async (done: Function) => {
      let scrollComponent: Component = await driver.waitForComponent(ON.id('list'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text2'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPath'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: NavigationExampleTest_011
     * @tc.name: NavigationExampleTest_011
     * @tc.desc: NavigationExampleTest_011
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('NavigationExampleTest_011', 0, async (done: Function) => {
      let scrollComponent: Component = await driver.waitForComponent(ON.id('list'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.navigationExample'))));
      await aimComponent.click();
      await driver.delayMs(500);
      aimComponent = await driver.findComponent(ON.text('WLAN'));
      await aimComponent.click();
      await driver.delayMs(500);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text24'))));
      await aimComponent.click();
      await driver.delayMs(500);
      aimComponent = await driver.findComponent(ON.text('Bluetooth'));
      await aimComponent.click();
      await driver.delayMs(500);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text24'))));
      await aimComponent.click();
      await driver.delayMs(500);
      aimComponent = await driver.findComponent(ON.text('Personal Hotspot'));
      await aimComponent.click();
      await driver.delayMs(500);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text24'))));
      await aimComponent.click();
      await driver.delayMs(500);
      aimComponent = await driver.findComponent(ON.text('Connect & Share'));
      await aimComponent.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: PushPathAndPop_012
     * @tc.name: PushPathAndPop_012
     * @tc.desc: PushPathAndPop_012
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('PushPathAndPop_012', 0, async (done: Function) => {
      let scrollComponent: Component = await driver.waitForComponent(ON.id('list'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text2'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPath'));
      await aimComponent.click();
      let scrollComponent1: Component = await driver.waitForComponent(ON.id('ScrollNoParam'), 1000);
      let scrollCenter1 = await scrollComponent1.getBoundsCenter();
      await driver.swipe(scrollCenter1.x, scrollCenter1.y + 400, scrollCenter1.x, scrollCenter1.y - 400, 3000);
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })
    /*
     * @tc.number: PushPathByNameTest_013
     * @tc.name: PushPathByNameTest_013
     * @tc.desc: PushPathByNameTest_013
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('PushPathByNameTest_013', 0, async (done: Function) => {
      let scrollComponent: Component = await driver.waitForComponent(ON.id('list'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text2'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPath'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      let scrollComponent1: Component = await driver.waitForComponent(ON.id('ScrollNoParam'), 1000);
      let scrollCenter1 = await scrollComponent1.getBoundsCenter();
      await driver.swipe(scrollCenter1.x, scrollCenter1.y + 400, scrollCenter1.x, scrollCenter1.y - 400, 3000);
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: PushDestinationTest_014
     * @tc.name: PushDestinationTest_014
     * @tc.desc: PushDestinationTest_014
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('PushDestinationTest_014', 0, async (done: Function) => {
      let scrollComponent: Component = await driver.waitForComponent(ON.id('list'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text2'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPath'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushDestination'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: PushDestinationByNameTest_015
     * @tc.name: PushDestinationByNameTest_015
     * @tc.desc: PushDestinationByNameTest_015
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('PushDestinationByNameTest_015', 0, async (done: Function) => {
      let scrollComponent: Component = await driver.waitForComponent(ON.id('list'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text2'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPath'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushDestinationByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: MoveToTopTest_016
     * @tc.name: MoveToTopTest_016
     * @tc.desc: MoveToTopTest_016
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('MoveToTopTest_016', 0, async (done: Function) => {
      let scrollComponent: Component = await driver.waitForComponent(ON.id('list'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text2'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPath'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('moveToTop'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: MoveIndexToTopTest_017
     * @tc.name: MoveIndexToTopTest_017
     * @tc.desc: MoveIndexToTopTest_017
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('MoveIndexToTopTest_017', 0, async (done: Function) => {
      let scrollComponent: Component = await driver.waitForComponent(ON.id('list'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text2'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPath'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('moveIndexToTop'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: RemoveByNameTest_018
     * @tc.name: RemoveByNameTest_018
     * @tc.desc: RemoveByNameTest_018
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('RemoveByNameTest_018', 0, async (done: Function) => {
      let scrollComponent: Component = await driver.waitForComponent(ON.id('list'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text2'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPath'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('removeByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: RemoveByIndexesTest_019
     * @tc.name: RemoveByIndexesTest_019
     * @tc.desc: RemoveByIndexesTest_019
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('RemoveByIndexesTest_019', 0, async (done: Function) => {
      let scrollComponent: Component = await driver.waitForComponent(ON.id('list'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text2'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPath'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('removeByIndexes'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: RemoveByNavDestinationId_020
     * @tc.name: RemoveByNavDestinationId_020
     * @tc.desc: RemoveByNavDestinationId_020
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('RemoveByNavDestinationId_020', 0, async (done: Function) => {
      let scrollComponent: Component = await driver.waitForComponent(ON.id('list'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text2'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPath'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('removeByNavDestinationId'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: ReplacePathTest_021
     * @tc.name: ReplacePathTest_021
     * @tc.desc: ReplacePathTest_021
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('ReplacePathTest_021', 0, async (done: Function) => {
      let scrollComponent: Component = await driver.waitForComponent(ON.id('list'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text2'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPath'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('replacePath'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: ReplacePathByNameTest_022
     * @tc.name: ReplacePathByNameTest_022
     * @tc.desc: ReplacePathByNameTest_022
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('ReplacePathByNameTest_022', 0, async (done: Function) => {
      let scrollComponent: Component = await driver.waitForComponent(ON.id('list'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text2'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPath'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('replacePathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: RemoveByNavDestinationId_023
     * @tc.name: RemoveByNavDestinationId_023
     * @tc.desc: RemoveByNavDestinationId_023
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('RemoveByNavDestinationId_023', 0, async (done: Function) => {
      let scrollComponent: Component = await driver.waitForComponent(ON.id('list'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text2'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPath'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('replaceDestination'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: ClearTest_024
     * @tc.name: ClearTest_024
     * @tc.desc: ClearTest_024
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('ClearTest_024', 0, async (done: Function) => {
      let scrollComponent: Component = await driver.waitForComponent(ON.id('list'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text2'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPath'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('clear'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: GetTest_025
     * @tc.name: GetTest_025
     * @tc.desc: GetTest_025
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('GetTest_025', 0, async (done: Function) => {
      let scrollComponent: Component = await driver.waitForComponent(ON.id('list'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text2'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPath'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('get'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: PushPathByNameOnPop_026
     * @tc.name: PushPathByNameOnPop_026
     * @tc.desc: PushPathByNameOnPop_026
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('PushPathByNameOnPop_026', 0, async (done: Function) => {
      let scrollComponent: Component = await driver.waitForComponent(ON.id('list'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text4'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('StartTest'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('popToName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: PopToIndexTest_027
     * @tc.name: PopToIndexTest_027
     * @tc.desc: PopToIndexTest_027
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('PopToIndexTest_027', 0, async (done: Function) => {
      let scrollComponent: Component = await driver.waitForComponent(ON.id('list'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text4'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('StartTest'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('popToIndexWithoutResult'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: PopToName_028
     * @tc.name: PopToName_028
     * @tc.desc: PopToName_028
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('PopToName_028', 0, async (done: Function) => {
      let scrollComponent: Component = await driver.waitForComponent(ON.id('list'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text4'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('StartTest'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('pushPathByName'));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('popToNameWithoutResult'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /*
     * @tc.number: setInterception_029
     * @tc.name: setInterception_029
     * @tc.desc: setInterception_029
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('setInterception_029', 0, async (done: Function) => {
      let scrollComponent: Component = await driver.waitForComponent(ON.id('list'), 1000);
      let scrollCenter = await scrollComponent.getBoundsCenter();
      await driver.swipe(scrollCenter.x, scrollCenter.y + 400, scrollCenter.x, scrollCenter.y - 400, 3000);
      await driver.waitForIdle(500, 500);
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text2'))));
      await aimComponent.click();
      await driver.delayMs(1000);
      aimComponent = await driver.findComponent(ON.text('use interception'));
      await aimComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

  })
}