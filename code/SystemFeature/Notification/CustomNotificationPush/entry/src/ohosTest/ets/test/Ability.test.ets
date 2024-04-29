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

import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@ohos.UiTest';
import Base from '@ohos.base';

const TAG: string = '[Sample_CustomPush]';
const DOMAIN = 0xF811;
const BUNDLE = 'CustomPush_';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.customnotificationpush',
          abilityName: 'EntryAbility'
        });
        done();
      } catch (expection) {
        hilog.info(DOMAIN, TAG, 'StartAbility end err:' + JSON.stringify(expection as Base.BusinessError));
        expect(0).assertEqual(expection.code);
        done();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })
    /**
     * 点击toggle
     */
    it(BUNDLE + 'ClickToggle_001', 1, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickToggle_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('toggle'));
      let toggle1 = await driver.findComponent(ON.id('toggle'));
      await toggle1.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickToggle_001_001 end');
    })
    /**
     * 点击四个checkbox
     */
    it(BUNDLE + 'ClickCheck_001_001', 1, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCheck_001_001 begin');
      let driver = Driver.create();
      await driver.assertComponentExist(ON.id('checkbox0'));
      await driver.assertComponentExist(ON.id('checkbox1'));
      await driver.assertComponentExist(ON.id('checkbox2'));
      await driver.assertComponentExist(ON.id('checkbox3'));
      let checkbox0 = await driver.findComponent(ON.id(`checkbox0`));
      await checkbox0.click();
      await driver.delayMs(1000);

      let checkbox1 = await driver.findComponent(ON.id('checkbox1'));
      await checkbox1.click();
      await driver.delayMs(1000);

      let checkbox2 = await driver.findComponent(ON.id('checkbox2'));
      await checkbox2.click();
      await driver.delayMs(1000);

      let checkbox3 = await driver.findComponent(ON.id('checkbox3'));
      await checkbox3.click();
      await driver.delayMs(1000);

      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCheck_001_001 end');
    })
  })
}