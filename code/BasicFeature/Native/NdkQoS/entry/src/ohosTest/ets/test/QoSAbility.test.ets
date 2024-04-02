/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';

const TAG = '[Sample_NativeWindowAPI]';

export default function abilityTest() {

  describe('ActsAbilityTest', () => {
    /**
     * @tc.number: StartAbility_001
     * @tc.name: StartAbility_001
     * @tc.desc: open the hap
     */
    it('StartAbility_001', 0, async (done: Function) => {
      console.info(TAG, 'StartAbility_001 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.qossample',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('QoS Sample'));
      done();
      console.info(TAG, 'StartAbility_001 end');
    })

    /**
     * @tc.number: NativeQoS_001
     * @tc.name: NativeQoS_001
     * @tc.desc: detect and click the button to start the high QoS level thread to complete the computation.
     */
    it('NativeQoS_001', 2, async () => {
      console.info(TAG, 'NativeQoS_001 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.qossample',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `NativQoS_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('High level QoS test'));
      let btn = await driver.findComponent(ON.text('High level QoS test'));
      // 点击'High level QoS test'按钮
      await btn.click();
      await driver.delayMs(1000);
      console.info(TAG, 'NativeQoS_001 end');
    })

    /**
     * @tc.number: NativeQoS_002
     * @tc.name: NativeQoS_002
     * @tc.desc: detect and click the button to start the low QoS level thread to complete the computation.
     */

    it('NativeQoS_002', 2, async () => {
      console.info(TAG, 'NativeQoS_002 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.qossample',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `NativQoS_002 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Low level QoS test'));
      let btn = await driver.findComponent(ON.text('Low level QoS test'));
      // 点击'Low level QoS test'按钮
      await btn.click();
      await driver.delayMs(1000);
      console.info(TAG, 'NativeQoS_002 end');
    })
  })
}