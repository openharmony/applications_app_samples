/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

export default function sampleTest() {
  describe('ActsSampleTest', () => {
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
     * 点击按钮，调用await接口
     */
    it('testSampleAwait', 0, async () => {
      console.info('uitest: testSampleAwait begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Test Await'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call Await'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call Await Success'));
      console.info('uitest: testSampleAwait end');
      await driver.pressBack();
    })

    /**
     * 点击按钮，调用sync接口
     */
    it('testSampleSync', 0, async () => {
      console.info('uitest: testSampleSync begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Test Sync'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call Sync'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call Sync Success'));
      console.info('uitest: testSampleSync end');
      await driver.pressBack();
    })
    /**
     * 点击按钮，调用native接口
     */
    it('testSampleNative', 0, async () => {
      console.info('uitest: testSampleNative begin');
      const driver = Driver.create();
      const button1 = await driver.findComponent(ON.text('Test Native'));
      await driver.delayMs(1000);
      await button1.click();
      await driver.delayMs(1000);
      const button2 = await driver.findComponent(ON.text('Call Native'));
      await button2.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Call Native Success'));
      console.info('uitest: testSampleNative end');
      await driver.pressBack();
    })
  })
}
