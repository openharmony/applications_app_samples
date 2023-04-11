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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON, Component } from '@ohos.UiTest';
import { logger } from '../util/Logger';

const TAG: string = 'Sample_DeviceManagementTest';
const BUNDLE = 'DeviceManagement';
const delegator = AbilityDelegatorRegistry.getAbilityDelegator();

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    // 打开应用
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}StartAbility_001 begin`);
      let want = {
        bundleName: "com.samples.devicemanagementcollection",
        abilityName: "EntryAbility"
      };
      let driver: Driver = Driver.create();
      delegator.startAbility(want, (err) => {
        logger.info(TAG, `${BUNDLE}_startAbility end err ${JSON.stringify(err)}`);
      })
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}StartAbility_001 end`);
      done();
    })

    // 系统电源管理
    it(BUNDLE + 'power_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}power_001 begin`);
      let driver: Driver = await Driver.create();
      await driver.delayMs(1000);
      //find component on text '系统电源管理'
      await driver.assertComponentExist(ON.text('系统电源管理'));
      let button = await driver.findComponent(ON.text('系统电源管理'));
      await button.click();
      await button.click();
      await driver.delayMs(1000);
      //check text
      await driver.assertComponentExist(ON.text('系统电源管理'));
      await driver.delayMs(1000);
      await driver.pressBack();
      logger.info(TAG, `${BUNDLE}power_001 end`);
      done();
    })

    // USB管理
    it(BUNDLE + 'usb_manager_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}usb_manager_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      //find component on type 'list'
      await driver.assertComponentExist(ON.type('List'));
      let list = await driver.findComponent(ON.type('List'));
      let button = await list.scrollSearch(ON.text('USB管理'));
      await button.click();
      await button.click();
      await driver.delayMs(1000);
      //check text
      await driver.assertComponentExist(ON.text('USB管理'));
      await driver.delayMs(1000);
      await driver.pressBack();
      logger.info(TAG, `${BUNDLE}usb_manager_001 end`);
      done();
    })
  })
}