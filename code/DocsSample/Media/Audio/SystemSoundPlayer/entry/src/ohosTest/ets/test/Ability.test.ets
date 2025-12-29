/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

export default function abilityTest() {
  const TAG = '[Sample_SoundPlayer]';
  const driver = Driver.create();
  const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
  const bundleName = AbilityDelegatorRegistry.getArguments().bundleName;

  describe('ActsAbilityTest', () => {
    it('SoundPlayer_Test_001', 0, async (done: Function) => {
      console.info(TAG, 'SoundPlayer_Test_001 begin');
      try {
        await abilityDelegator.startAbility({
          bundleName: bundleName,
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        expect().assertFail();
      }
      await driver.delayMs(1000);
      const button = await driver.findComponent(ON.id('playSoundPoolButton'));
      await button.click();
      await driver.delayMs(2000);
      await button.click();
      await driver.delayMs(2000);
      done();
      console.info(TAG, 'SoundPlayer_Test_001 end');
    })
  })
}