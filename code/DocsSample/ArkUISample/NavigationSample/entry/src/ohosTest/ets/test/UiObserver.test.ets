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
import { abilityDelegatorRegistry, Component, Driver } from '@kit.TestKit';
import { afterEach, beforeAll, describe, it } from '@ohos/hypium';
import { ON } from '@ohos.UiTest';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator()
const driver = Driver.create();

async function getResourceString(resource: Resource): Promise<string> {
  let manage = delegator.getAppContext().resourceManager;
  let textString: string = await manage.getStringValue(resource);
  return textString;
}
let aimComponent : Component

export function UiObserverTest() {
  describe('Navigation_UiObserverTest', () => {
    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.navigationsample',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text18'))));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    afterEach(async () => {

    })

    /*
     * @tc.number: PageAnimatedTest_029
     * @tc.name: example_four_Navigation
     * @tc.desc: example_three_Navigation
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('watchPageInfoTest_001', 0, async (done: Function) => {
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.watchPageInfo'))));
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
     * @tc.number: PageAnimatedTest_029
     * @tc.name: example_four_Navigation
     * @tc.desc: example_three_Navigation
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('watchPageStatusTest_002', 0, async (done: Function) => {
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.stepperIndex_text19'))));
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
     * @tc.number: PageAnimatedTest_029
     * @tc.name: example_four_Navigation
     * @tc.desc: example_three_Navigation
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('PageCallbackFuncTest_003', 0, async (done: Function) => {
      aimComponent = await driver.findComponent(ON.text(await getResourceString($r('app.string.uiObserverCallbackFunc'))));
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

  })
}