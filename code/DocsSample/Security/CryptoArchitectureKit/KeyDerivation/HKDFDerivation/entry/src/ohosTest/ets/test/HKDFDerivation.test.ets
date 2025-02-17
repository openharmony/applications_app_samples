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

import { describe, it, expect, beforeAll } from '@ohos/hypium';
// 导入测试依赖kit
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

export default function hKDFDerivationTest() {
  describe('hKDFDerivationTest', () => {
    /**
     * 打开应用
     */
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      const driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      await driver.delayMs(1000);
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * 点击按钮，使用HKDF进行密钥派生，通过await返回结果
     */
    it('testHKDFDerivation001', 0, async () => {
      console.info('uitest: testHKDFDerivation001 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Await'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call Await'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Await Success'));
      console.info('uitest: testHKDFDerivation001 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用HKDF进行密钥派生，通过Promise返回结果
     */
    it('testHKDFDerivation002', 0, async () => {
      console.info('uitest: testHKDFDerivation002 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Promise'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call Promise'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Promise Success'));
      console.info('uitest: testHKDFDerivation002 end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，使用HKDF进行密钥派生，通过同步方式返回结果
     */
    it('testHKDFDerivation003', 0, async () => {
      console.info('uitest: testHKDFDerivation003 begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Sync Success'));
      console.info('uitest: testHKDFDerivation003 end');
      await driver.pressBack();
    })
  })
}