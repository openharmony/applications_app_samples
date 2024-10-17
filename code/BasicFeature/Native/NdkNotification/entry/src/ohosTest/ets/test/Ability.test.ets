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

const TAG = '[Sample_NativeNotificationAPI]';


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
          bundleName: 'com.examples.ndknotification',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Check notification enabled'));
      await driver.delayMs(2000);
      done();
      console.info(TAG, 'StartAbility_001 end');
    })

    /**
     * @tc.number: NativeNotification_001
     * @tc.name: NativeNotification_001
     * @tc.desc: detect and click the button to check application notification enabled
     */
    it('NativeNotification_001', 0, async (done: Function) => {
      console.info(TAG, 'NativeNotification_001 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.examples.ndknotification',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Check notification enabled'));
      let btn = await driver.findComponent(ON.text('Check notification enabled'));
      // 点击'Check notification enabled'按钮
      await btn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('OK'));
      await driver.delayMs(2000);
      await driver.findComponent(ON.text('OK'));
      await btn.click();
      await driver.delayMs(1000);
      done();
      console.info(TAG, 'NativeNotification_001 end');
    })
  })
}
