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
// Import test dependency kit
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
const delayMs = 1000;
let want: Want;

export default function nodeApiLoadModuleTest() {
  describe('nodeApiLoadModuleTest', () => {
    /**
     * start app
     */
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      const driver = Driver.create();
      await driver.delayMs(delayMs);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      await driver.delayMs(delayMs);
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * Click the button to invoke the loadModuleSystem-related function
     */
    it('testNodeApiLoadModuleTest001', 0, async () => {
      console.info('uitest: testNodeApiLoadModuleTest001 begin');
      const driver = Driver.create();
      await driver.delayMs(delayMs);
      const button = await driver.findComponent(ON.text('Call loadModuleSystem'));
      await driver.delayMs(delayMs);
      await button.click();
      await driver.delayMs(delayMs);
      await driver.assertComponentExist(ON.text('loadModuleSystem success'));
      console.info('uitest: testNodeApiLoadModuleTest001 end');
    })

    /**
     * Click the button will invoke the loadEtsDirModule-related function
     */
    it('testNodeApiLoadModuleTest002', 0, async () => {
      console.info('uitest: testNodeApiLoadModuleTest002 begin');
      const driver = Driver.create();
      await driver.delayMs(delayMs);
      const button = await driver.findComponent(ON.text('Call loadEtsDirModule'));
      await driver.delayMs(delayMs);
      await button.click();
      await driver.delayMs(delayMs);
      await driver.assertComponentExist(ON.text('loadEtsDirModule success'));
      console.info('uitest: testNodeApiLoadModuleTest002 end');
    })

    /**
     * Click the button triggers the loadModuleFile-related function call
     */
    it('testNodeApiLoadModuleTest003', 0, async () => {
      console.info('uitest: testNodeApiLoadModuleTest003 begin');
      const driver = Driver.create();
      await driver.delayMs(delayMs);
      const button = await driver.findComponent(ON.text('Call loadModuleFile'));
      await driver.delayMs(delayMs);
      await button.click();
      await driver.delayMs(delayMs);
      await driver.assertComponentExist(ON.text('loadModuleFile success'));
      console.info('uitest: testNodeApiLoadModuleTest003 end');
    })

    /**
     * Click the button to invoke the loadHarModule-related function
     */
    it('testNodeApiLoadModuleTest004', 0, async () => {
      console.info('uitest: testNodeApiLoadModuleTest004 begin');
      const driver = Driver.create();
      await driver.delayMs(delayMs);
      const button = await driver.findComponent(ON.text('Call loadHarModule'));
      await driver.delayMs(delayMs);
      await button.click();
      await driver.delayMs(delayMs);
      await driver.assertComponentExist(ON.text('loadHarModule success'));
      console.info('uitest: testNodeApiLoadModuleTest004 end');
    })

    /**
     * Click the button to invoke the loadHspModule-related function
     */
    it('testNodeApiLoadModuleTest005', 0, async () => {
      console.info('uitest: testNodeApiLoadModuleTest005 begin');
      const driver = Driver.create();
      await driver.delayMs(delayMs);
      const button = await driver.findComponent(ON.text('Call loadHspModule'));
      await driver.delayMs(delayMs);
      await button.click();
      await driver.delayMs(delayMs);
      await driver.assertComponentExist(ON.text('loadHspModule success'));
      console.info('uitest: testNodeApiLoadModuleTest005 end');
    })

    /**
     * Click the button to invoke the loadFarHarModule-related function
     */
    it('testNodeApiLoadModuleTest006', 0, async () => {
      console.info('uitest: testNodeApiLoadModuleTest006 begin');
      const driver = Driver.create();
      await driver.delayMs(delayMs);
      const button = await driver.findComponent(ON.text('Call loadFarHarModule'));
      await driver.delayMs(delayMs);
      await button.click();
      await driver.delayMs(delayMs);
      await driver.assertComponentExist(ON.text('loadFarHarModule success'));
      console.info('uitest: testNodeApiLoadModuleTest006 end');
    })

    /**
     * Click the button to invoke the loadOhpmModule-related function
     */
    it('testNodeApiLoadModuleTest007', 0, async () => {
      console.info('uitest: testNodeApiLoadModuleTest007 begin');
      const driver = Driver.create();
      await driver.delayMs(delayMs);
      const button = await driver.findComponent(ON.text('Call loadOhpmModule'));
      await driver.delayMs(delayMs);
      await button.click();
      await driver.delayMs(delayMs);
      await driver.assertComponentExist(ON.text('loadOhpmModule success'));
      console.info('uitest: testNodeApiLoadModuleTest007 end');
    })

    /**
     * Click the button to invoke the loadNativeModule-related function
     */
    it('testNodeApiLoadModuleTest008', 0, async () => {
      console.info('uitest: testNodeApiLoadModuleTest008 begin');
      const driver = Driver.create();
      await driver.delayMs(delayMs);
      const button = await driver.findComponent(ON.text('Call loadNativeModule'));
      await driver.delayMs(delayMs);
      await button.click();
      await driver.delayMs(delayMs);
      await driver.assertComponentExist(ON.text('loadNativeModule success'));
      console.info('uitest: testNodeApiLoadModuleTest008 end');
    })

    /**
     * Click the button to invoke the loadNativeModule-related function
     */
    it('testNodeApiLoadModuleTest009', 0, async () => {
      console.info('uitest: testNodeApiLoadModuleTest009 begin');
      const driver = Driver.create();
      await driver.delayMs(delayMs);
      const button = await driver.findComponent(ON.text('Call har1LodeHar2'));
      await driver.delayMs(delayMs);
      await button.click();
      await driver.delayMs(delayMs);
      await driver.assertComponentExist(ON.text('har1LodeHar2 success'));
      console.info('uitest: testNodeApiLoadModuleTest009 end');
    })

  })
}