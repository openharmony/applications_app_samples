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
let resourceManager = delegator.getAppContext().resourceManager;
let driver = Driver.create();

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    beforeAll(async () => {
      await driver.delayMs(500);
      try {
        await delegator.startAbility({
          bundleName: 'com.samples.hspsample',
          abilityName: 'EntryAbility'
        });
      } catch (err) {
        expect(0).assertEqual(err.code);
        Logger.info(TAG, 'StartAbility err:' + JSON.stringify(err));
      }
    })

    /*
     * @tc.number: Acts_HspSample_0100
     * @tc.name: Verify the functions of ArkUI components, interfaces, and resources that export HSP.
     * @tc.desc: Verify the functions of ArkUI components and picture resources referencing HSP.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('Acts_HspSample_0100', 0, async (done: () => void) => {
      Logger.info(TAG, 'Acts_HspSample_0100 start');
      let message = '动态分享包';
      await driver.delayMs(500);
      let component = await driver.findComponent(ON.text(message));
      expect(component != null).assertTrue();
      Logger.info(TAG, 'Acts_HspSample_0100 end');
      done();
    })

    /*
     * @tc.number: Acts_HspSample_0200
     * @tc.name: Verify the functions of ArkUI components, interfaces, and resources that export HSP.
     * @tc.desc: Verify the functionality of ts classes and methods referencing HSP.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('Acts_HspSample_0200', 0, async (done: () => void) => {
      Logger.info(TAG, 'Acts_HspSample_0200 start');
      let message = 'result: 3';
      await driver.delayMs(500);
      let button = await driver.findComponent(ON.id('add'));
      Logger.info(TAG, `Acts_HspSample_0200 button is ${JSON.stringify(button)}`);
      await button.click();
      await driver.delayMs(500);
      let component = await driver.findComponent(ON.text(message));
      expect(component != null).assertTrue();
      Logger.info(TAG, 'Acts_HspSample_0200 end');
      done();
    })

    /*
     * @tc.number: Acts_HspSample_0300
     * @tc.name: Verify the functions of ArkUI components, interfaces, and resources that export HSP.
     * @tc.desc: Verify the ability to reference native methods exported by HSP.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('Acts_HspSample_0300', 0, async (done: () => void) => {
      Logger.info(TAG, 'Acts_HspSample_0300 start');
      let message = 'result: 12';
      await driver.delayMs(500);
      let button = await driver.findComponent(ON.id('nativeMulti'));
      Logger.info(TAG, `Acts_HspSample_0300 button is ${JSON.stringify(button)}`);
      await button.click();
      await driver.delayMs(500);
      let component = await driver.findComponent(ON.text(message));
      expect(component != null).assertTrue();
      Logger.info(TAG, 'Acts_HspSample_0300 end');
      done();
    })

    /*
     * @tc.number: Acts_HspSample_0400
     * @tc.name: Verify the functions of ArkUI components, interfaces, and resources that export HSP.
     * @tc.desc: Verify correct access to resources in HSP.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('Acts_HspSample_0400', 0, async (done: () => void) => {
      Logger.info(TAG, 'Acts_HspSample_0400 start');
      await driver.delayMs(500);
      let button = await driver.findComponent(ON.id('clickToIndex'));
      Logger.info(TAG, `Acts_HspSample_0400 button is ${JSON.stringify(button)}`);
      await button.click();
      await driver.delayMs(500);
      let component = await driver.findComponent(ON.id('example'));
      expect(component != null).assertTrue();
      await driver.pressBack();
      Logger.info(TAG, 'Acts_HspSample_0400 end');
      done();
    })

    /*
     * @tc.number: Acts_HspSample_0500
     * @tc.name: Verify the functions of ArkUI components, interfaces, and resources that export HSP.
     * @tc.desc: Verify the resource functionality in the reference HSP.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('Acts_HspSample_0500', 0, async (done: () => void) => {
      Logger.info(TAG, 'Acts_HspSample_0500 start');
      await driver.delayMs(500);
      let button = await driver.findComponent(ON.id('getStringValue'));
      Logger.info(TAG, `Acts_HspSample_0500 button is ${JSON.stringify(button)}`);
      await button.click();
      await driver.delayMs(500);
      let component =
        await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.HSP_value'))));
      expect(component != null).assertTrue();
      Logger.info(TAG, 'Acts_HspSample_0500 end');
      done();
    })

    /*
     * @tc.number: Acts_HspSample_0600
     * @tc.name: Verify the functions of ArkUI components, interfaces, and resources that export HSP.
     * @tc.desc: Verify the routing jump function and route return function referencing HSP.
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('Acts_HspSample_0600', 0, async (done: () => void) => {
      Logger.info(TAG, 'Acts_HspSample_0600 start');
      let message = 'HSP menu page';
      await driver.delayMs(500);
      let button = await driver.findComponent(ON.id('clickToMenu'));
      Logger.info(TAG, `Acts_HspSample_0600 button is ${JSON.stringify(button)}`);
      await button.click();
      await driver.delayMs(500);
      let component = await driver.findComponent(ON.text(message));
      expect(component != null).assertTrue();
      await driver.delayMs(500);
      let routerButton = await driver.findComponent(ON.id('menuToBack'));
      Logger.info(TAG, `Acts_HspSample_0600 button is ${JSON.stringify(routerButton)}`);
      await routerButton.click();
      await driver.delayMs(500);
      let back = await driver.findComponent(ON.id('backToHSP'));
      await back.click();
      await driver.delayMs(500);
      let secComponent = await driver.findComponent(ON.text(message));
      expect(secComponent != null).assertTrue();
      await driver.pressBack();
      Logger.info(TAG, 'Acts_HspSample_0600 end');
      done();
    })

    /*
    * @tc.number: Acts_HspSample_0700
    * @tc.name: Verify the functions of ArkUI components, interfaces, and resources that export HSP.
    * @tc.desc: Verify the routing return function referencing HSP.
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it('Acts_HspSample_0700', 0, async (done: () => void) => {
      Logger.info(TAG, 'Acts_HspSample_0700 start');
      await driver.delayMs(500);
      let button = await driver.findComponent(ON.id('clickToBack'));
      Logger.info(TAG, `Acts_HspSample_0700 button is ${JSON.stringify(button)}`);
      await button.click();
      await driver.delayMs(500);
      let back = await driver.findComponent(ON.id('backToHAP'));
      await back.click();
      await driver.delayMs(500);
      let component =
        await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.HSP_message'))));
      expect(component != null).assertTrue();
      Logger.info(TAG, 'Acts_HspSample_0700 end');
      done();
    })
  })
}