/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { Driver, ON, } from '@ohos.UiTest'
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const delegator = abilityDelegatorRegistry.getAbilityDelegator()

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    beforeEach(async function () {
      await delegator.executeShellCommand('aa start -b com.samples.share -a EntryAbility').then(() => {
        console.log("====>  executeShellCommand result ====>");
      }).catch(err => {
        console.log("====> executeShellCommand  ====>" + err.code);
      })
    })

    /*
     * @tc.number: Acts_ShareTemplate_0100
     * @tc.name: Test the ability to provide shared templates
     * @tc.desc: Click the share button to jump to the interface, and then click the cancel button
     */
    it('Acts_ShareTemplate_0100', 0, async function (done) {
      console.log("====> Acts_ShareTemplate_0100 start ====>");
      let driver = Driver.create();
      await driver.delayMs(500);
      let button = await driver.findComponent(ON.id('share'));
      await button.click();
      await driver.delayMs(500);
      let buttons = await driver.findComponent(ON.id('cancellation'));
      await buttons.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('share'));
      await driver.pressBack();
      await driver.delayMs(1000);
      console.log("====> Acts_ShareTemplate_0100 end ====>");
      done();
    })

    /*
    * @tc.number: Acts_ShareTemplate_0200
    * @tc.name: Test the ability to provide shared templates
    * @tc.desc: Click on the share button to jump to the interface, then click on the share demo to jump to the
    *           interface, and then click on the return to share button
    */
    it('Acts_ShareTemplate_0200', 0, async function (done) {
      console.log("====> Acts_ShareTemplate_0200 start ====>");
      let driver = Driver.create();
      await driver.delayMs(500);
      let button = await driver.findComponent(ON.id('share'));
      await button.click();
      await driver.delayMs(1000);
      let shared = await driver.findComponent(ON.id('Shared'));
      await shared.click();
      await driver.delayMs(1000);
      let turnBack = await driver.findComponent(ON.id('return'));
      await turnBack.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('share'));
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.log("====> Acts_ShareTemplate_0200 end ====>");
      done();
    })

    /*
     * @tc.number: Acts_ShareTemplate_0300
     * @tc.name: Test the ability to provide shared templates
     * @tc.desc: Click on the share button to jump to the interface, then click on the share demo to jump to the
     *           interface, and then click on stay in UIExtension
     */
    it('Acts_ShareTemplate_0300', 0, async function (done) {
      console.log("====> Acts_ShareTemplate_0300 start ====>");
      let driver = Driver.create();
      await driver.delayMs(1000);
      let button = await driver.findComponent(ON.id('share'));
      await button.click();
      await driver.delayMs(1000);
      let shared = await driver.findComponent(ON.id('Shared'));
      await shared.click();
      await driver.delayMs(1000);
      let stay = await driver.findComponent(ON.id('stay'));
      await stay.click();
      await driver.delayMs(1000);
      await driver.findComponent(ON.text('It is a shared message'));
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('messages'));
      console.log("====> Acts_ShareTemplate_0300 end ====>");
      done();
    })
  })
}