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

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 打开应用,点击Hello World执行
     */
    it('testSymbolFor', 0, async (done: Function) => {
      console.log('uitest: TestSymbolFor begin');

      const want: Want = {
        bundleName: bundleName,
        abilityName: 'SymbolforAbility'
      }
      const driver = Driver.create();
      await delegator.startAbility(want);
      await driver.delayMs(1000);

      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.log('get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('SymbolforAbility');

      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('Hello World'));
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('success'));
      console.log('uitest: TestSymbolFor end');
      done();
    })
  })
}
