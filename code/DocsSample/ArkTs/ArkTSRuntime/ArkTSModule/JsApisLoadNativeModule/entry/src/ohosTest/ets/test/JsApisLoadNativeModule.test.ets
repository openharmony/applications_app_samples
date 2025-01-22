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
// 导入测试依赖kit
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;

export default function JsApisLoadNativeModuleTest() {
  describe('jsApisLoadNativeModuleTest', () => {

    it('testJsApisLoadNativeModule001', 0, async () => {
      console.info('uitest: testJsApisLoadNativeModule001 begin');
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

      const button1 = await driver.findComponent(ON.text('LoadSystemModule'));
      const button2 = await driver.findComponent(ON.text('LoadNativeModule'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('loadNativeModule ohos.hilog success'));

      await driver.delayMs(1000);
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('loadNativeModule libentry.so success result: 3'));
      console.info('uitest: testJsApisLoadNativeModule001 end');
    })
  })
}