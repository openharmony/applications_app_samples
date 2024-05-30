/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { describe, it, beforeAll, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Logger from '../utils/Logger';

const TAG = '[Sample_DisplaySoloist]';
const DELAYMS1S = 1000;

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    beforeAll(async (done: Function) => {
      Logger.info(TAG, 'beforeAll begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.DisplaySoloist',
          abilityName: 'EntryAbility'
        });
      } catch (err) {
        Logger.info(TAG, `beforeAll exception = ${JSON.stringify(err)}`);
      }

      Logger.info(TAG, 'beforeAll end');
      done();
    });

    /**
     * @tc.number:SUB_GRAPHIC_2D_HGM_DISPLAYSOLOIST_0100
     * @tc.name:DisplaySoloist_001
     * @tc.desc:DisplaySoloist
     * @tc.size:MediumTest
     * @tc.type:Function
     * @tc.level:Level 1
     */
    it('DisplaySoloist_001', 0, async (done: Function) => {
      try {
        Logger.info(TAG, 'DisplaySoloist_001 begin');

        let driver = Driver.create();
        await driver.assertComponentExist(ON.id('Start30'));
        let Start30Button = await driver.findComponent(ON.id('Start30'));
        await Start30Button.click();

        await driver.assertComponentExist(ON.id('Start60'));
        let start60Button = await driver.findComponent(ON.id('Start60'));
        await start60Button.click();

        await driver.assertComponentExist(ON.id('Start120'));
        let Start120Button = await driver.findComponent(ON.id('Start120'));
        await Start120Button.click();

        await driver.assertComponentExist(ON.id('Start30'));
        let Stop30Button = await driver.findComponent(ON.id('Start30'));
        await Stop30Button.click();

        await driver.assertComponentExist(ON.id('Start60'));
        let Stop60Button = await driver.findComponent(ON.id('Start60'));
        await Stop60Button.click();

        await driver.assertComponentExist(ON.id('Start120'));
        let Stop120Button = await driver.findComponent(ON.id('Start120'));
        await Stop120Button.click();
        await driver.delayMs(DELAYMS1S);

        Logger.info(TAG, 'DisplaySoloist_001 end');
        done();
      } catch (error) {
        Logger.info(TAG, `DisplaySoloist_001 exception = ${JSON.stringify(error)}`);
        expect().assertFail();
      }
    });
  })
}