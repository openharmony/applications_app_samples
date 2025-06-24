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

import { describe, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;

export default function lazyImportTest() {
  describe('lazyImportTest', () => {

    it('testLazyImport001', 0, async (done: Function) => {
      console.info('uitest: testLazyImport001 begin');
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      }
      await delegator.startAbility(want);
      const driver = Driver.create();
      await driver.delayMs(1000);

      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('LazyImport'));
      const button1 = await driver.findComponent(ON.text('Call a'));
      const button2 = await driver.findComponent(ON.text('Call b'));
      const button3 = await driver.findComponent(ON.text('Call c'));
      const button4 = await driver.findComponent(ON.text('Not advisable to use one'));
      const button5 = await driver.findComponent(ON.text('Not advisable to use two'));

      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call a success result: a = mod1 a executed'));

      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call b success result: b = mod1 b executed'));

      await button3.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call c success result: c = mod2 c executed'));

      await button4.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Not advisable to use one error: ReferenceError'));

      await button5.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Not advisable to use two error: ReferenceError'));
      console.info('uitest: testLazyImport001 end');
      done();
    })
  })
}