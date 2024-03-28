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
          bundleName: 'com.samples.nativewindow',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Change Color'));
      done();
      console.info(TAG, 'StartAbility_001 end');
    })

    /**
     * @tc.number: NativeWindow_001
     * @tc.name: NativeWindow_001
     * @tc.desc: detect and click the button to change the window color
     */
    it('NativeWindow_001', 2, async () => {
      console.info(TAG, 'NativeWindow_001 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.nativewindow',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `NativeWindow_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Change Color'));
      let btn = await driver.findComponent(ON.text('Change Color'));
      // 点击'Change Color'按钮
      await btn.click();
      await driver.delayMs(1000);
      console.info(TAG, 'NativeWindow_001 end');
    })

    /**
     * @tc.number: NativeWindow_002
     * @tc.name: NativeWindow_002
     * @tc.desc: detect and click the button to change the window color
     */
    it('NativeWindow_002', 2, async () => {
      console.info(TAG, 'NativeWindow_002 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.nativewindow',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `NativeWindow_002 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('attach buffer'));
      let btn = await driver.findComponent(ON.text('attach buffer'));
      // 点击'attach buffer'按钮
      await btn.click();
      await driver.delayMs(1000);
      console.info(TAG, 'NativeWindow_002 end');
    })

    /**
     * @tc.number: NativeWindow_003
     * @tc.name: NativeWindow_003
     * @tc.desc: detect and click the button to change the window color
     */
    it('NativeWindow_003', 2, async () => {
      console.info(TAG, 'NativeWindow_003 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.nativewindow',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `NativeWindow_003 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('dettach buffer'));
      let btn = await driver.findComponent(ON.text('dettach buffer'));
      // 点击'dettach buffer'按钮
      await btn.click();
      await driver.delayMs(1000);
      console.info(TAG, 'NativeWindow_003 end');
    })
  })
}