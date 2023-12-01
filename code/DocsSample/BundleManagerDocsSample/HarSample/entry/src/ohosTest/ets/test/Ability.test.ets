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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON, } from '@ohos.UiTest';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Logger from '../logger/Logger';

const TAG = 'ActsAbilityTest';
let delegator = abilityDelegatorRegistry.getAbilityDelegator();
let driver = Driver.create();

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    beforeAll(async () => {
      await driver.delayMs(500);
      try {
        await delegator.startAbility({
          bundleName: 'com.samples.harsample',
          abilityName: 'EntryAbility'
        });
      } catch (err) {
        expect(0).assertEqual(err.code);
        Logger.info(TAG, 'StartAbility err:' + JSON.stringify(err));
      }
    })

    /*
     * @tc.number: Acts_HarSample_0100
     * @tc.name: Verify the functions of ArkUI components, interfaces, and resources that export HAR.
     * @tc.desc: Verify the functionality of ArkUI components that reference HAR.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('Acts_HarSample_0100', 0, async (done: () => void) => {
      Logger.info(TAG, 'Acts_HarSample_0100 start');
      let pageMessage = 'HAR MainPage';
      await driver.delayMs(500);
      let button = await driver.findComponent(ON.id('mainPage'));
      Logger.info(TAG, `Acts_HarSample_0100 button is ${JSON.stringify(button)}`);
      await button.click();
      await driver.delayMs(500);
      let message = await driver.findComponent(ON.text(pageMessage));
      expect(message != null).assertTrue();
      await driver.delayMs(500);
      await driver.pressBack();
      Logger.info(TAG, 'Acts_HarSample_0100 end');
      done();
    })

    /*
     * @tc.number: Acts_HarSample_0200
     * @tc.name: Verify the functions of ArkUI components, interfaces, and resources that export HAR.
     * @tc.desc: Verify the functionality of ts classes and methods referencing HAR.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('Acts_HarSample_0200', 0, async (done: () => void) => {
      Logger.info(TAG, 'Acts_HarSample_0200 start');
      let message = 'func return: har func';
      await driver.delayMs(500);
      let button = await driver.findComponent(ON.id('button'));
      Logger.info(TAG, `Acts_HarSample_0200 button is ${JSON.stringify(button)}`);
      await button.click();
      await driver.delayMs(500);
      let component = await driver.findComponent(ON.text(message));
      expect(component != null).assertTrue();
      Logger.info(TAG, 'Acts_HarSample_0200 end');
      done();
    })

    /*
     * @tc.number: Acts_HarSample_0300
     * @tc.name: Verify the functions of ArkUI components, interfaces, and resources that export HAR.
     * @tc.desc: Verify the ability to reference native methods exported by HAR.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('Acts_HarSample_0300', 0, async (done: () => void) => {
      Logger.info(TAG, 'Acts_HarSample_0300 start');
      let message = 'result: 3';
      await driver.delayMs(500);
      let button = await driver.findComponent(ON.id('nativeAdd'));
      Logger.info(TAG, `Acts_HarSample_0300 button is ${JSON.stringify(button)}`);
      await button.click();
      await driver.delayMs(500);
      let component = await driver.findComponent(ON.text(message));
      expect(component != null).assertTrue();
      Logger.info(TAG, 'Acts_HarSample_0300 end');
      done();
    })

    /*
     * @tc.number: Acts_HarSample_0400
     * @tc.name: Verify the functions of ArkUI components, interfaces, and resources that export HAR.
     * @tc.desc: Verify the function of string resources and picture resources referencing HAR.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('Acts_HarSample_0400', 0, async (done: () => void) => {
      Logger.info(TAG, 'Acts_HarSample_0400 start');
      let message = 'hello har';
      await driver.delayMs(500);
      let component = await driver.findComponent(ON.text(message));
      expect(component != null).assertTrue();
      Logger.info(TAG, 'Acts_HarSample_0400 end');
      done();
    })
  })
}