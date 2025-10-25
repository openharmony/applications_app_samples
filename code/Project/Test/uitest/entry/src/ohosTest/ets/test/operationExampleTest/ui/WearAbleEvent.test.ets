/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

import { describe, it, expect, TestType, beforeAll, Level, Size } from '@ohos/hypium';
import abilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry';
import {Driver, ON} from '@ohos.UiTest'
import { BusinessError } from '@ohos.base';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const delegator : AbilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName : string = abilityDelegatorRegistry.getArguments().bundleName;
// Error code when the device is not supported.
const CapabilityCode = 801;

async function startAbility(bundleName: string, abilityName: string) {
  await delegator.executeShellCommand(`aa start -b ${bundleName} -a ${abilityName}`);
}

export default function wearAbleEventTest() {
  describe('wearAbleEventTest', () => {
    beforeAll(async () => {
    })
    /*
     * @tc.name: testCrownRotate
     * @tc.desc: crownRotate test，该接口从api20开始支持使用。
     */
    it('testCrownRotate', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
      let driver = Driver.create()
      await startAbility(bundleName, 'DemoAbility')
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.text('Click twice'))
      if (btn == null) {
        let scorll = await driver.findComponent(ON.type('Scroll'))
        btn = await scorll.scrollSearch(ON.text('Click twice'))
      }
      await btn.longClick();
      try {
        await driver.crownRotate(50);
        await driver.delayMs(1000);
        let toastBtn = await driver.findComponent(ON.text('1'));
        await driver.delayMs(1000);
        expect(toastBtn == null).assertTrue();
        await driver.delayMs(1000);
        await driver.crownRotate(-50);
        await driver.delayMs(1000);
        let toastBtn1 = await driver.findComponent(ON.text('1'));
        await driver.delayMs(1000);
        expect(toastBtn1 != null).assertTrue();
      } catch (error) {
        expect(error.code).assertEqual(CapabilityCode);
      }
    })
  })
}