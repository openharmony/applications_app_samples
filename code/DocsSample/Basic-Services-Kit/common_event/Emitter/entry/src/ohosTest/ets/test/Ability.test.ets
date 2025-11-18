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
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@kit.TestKit';

let driver = Driver.create();
const delegator = AbilityDelegatorRegistry.getAbilityDelegator();
let want: Want = {
  bundleName: 'com.samples.itcwithemitter',
  abilityName: 'EntryAbility',
};

export default function abilityTest() {
  describe('ActsAbilityTest', () => {

    beforeAll(async () => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      await delegator.startAbility(want)
    });

    /**
     * @tc.number SUB_SAMPLE_BASIC_SERVICES_0100
     * @tc.name SUB_SAMPLE_BASIC_SERVICES_0100
     * @tc.desc Verify emitter communication
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 0
     */
    it('SUB_SAMPLE_BASIC_SERVICES_0100', 0, async (done: Function) => {
      let comp = await driver.findComponent(ON.id('emitterOn'));
      let send = await driver.findComponent(ON.id('emitter'));
      await comp.click();
      await send.click();
      await send.click();
      done();
    });

    /**
     * @tc.number SUB_SAMPLE_BASIC_SERVICES_0200
     * @tc.name SUB_SAMPLE_BASIC_SERVICES_0200
     * @tc.desc Verify emitter communication
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 0
     */
    it('SUB_SAMPLE_BASIC_SERVICES_0200', 0, async (done: Function) => {
      let comp = await driver.findComponent(ON.id('emitterOn'));
      let off = await driver.findComponent(ON.id('emitterOff'));
      let send = await driver.findComponent(ON.id('emitter'));
      await comp.click();
      await off.click();
      await send.click();
      done();
    });

    /**
     * @tc.number SUB_SAMPLE_BASIC_SERVICES_0300
     * @tc.name SUB_SAMPLE_BASIC_SERVICES_0300
     * @tc.desc Verify emitter communication
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 0
     */
    it('SUB_SAMPLE_BASIC_SERVICES_0300', 0, async (done: Function) => {
      let comp = await driver.findComponent(ON.id('emitterOn'));
      let off = await driver.findComponent(ON.id('emitterOff'));
      let send = await driver.findComponent(ON.id('emitter'));
      await comp.click();
      await send.click();
      await off.click();
      await send.click();
      done();
    });

  })
}