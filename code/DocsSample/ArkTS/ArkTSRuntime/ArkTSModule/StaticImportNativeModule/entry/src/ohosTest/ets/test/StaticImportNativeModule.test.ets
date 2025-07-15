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

export default function staticImportNativeModuleTest() {
  describe('staticImportNativeModuleTest', () => {

    it('staticImportNativeModuleTest001', 0, async (done: Function) => {
      console.info('uitest: staticImportNativeModuleTest001 begin');
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

      const button1 = await driver.findComponent(ON.text('default_import'));
      const button2 = await driver.findComponent(ON.text('named_import'));
      const button3 = await driver.findComponent(ON.text('namespace_import'));
      const button4 = await driver.findComponent(ON.text('direct_import'));
      const button5 = await driver.findComponent(ON.text('indirect_import'));
      const button6 = await driver.findComponent(ON.text('export_named_and_import'));
      const button7 = await driver.findComponent(ON.text('export_namespace_and_import'));

      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('5'));
      await driver.pressBack();

      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('5'));
      await driver.pressBack();

      await button3.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('5'));
      await driver.pressBack();

      await button4.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('5'));
      await driver.pressBack();

      await button5.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('5'));
      await driver.pressBack();

      await button6.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('hilog.info'));
      await driver.pressBack();

      await button7.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('5'));
      console.info('uitest: staticImportNativeModuleTest001 end');
      done();
    })
  })
}