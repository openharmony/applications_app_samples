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
import { beforeAll, describe, expect, it } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import Logger from '../utils/Logger';

const TAG = '[Sample_DisplaySoloist]';
const BUNDLE = 'MyApp_'
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
const DELAYMS_1S = 1000;
const DELAYMS_5S = 5000;

export default function abilityTest() {
  describe('AbilityTest', () => {
    beforeAll(async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'StartAbility_001, begin');
      let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: bundleName,
          abilityName: 'EntryAbility'
        });
      } catch (err) {
        Logger.info(TAG, `beforeAll exception = ${JSON.stringify(err)}`);
      }

      Logger.info(TAG, BUNDLE + 'StartAbility_001, end');
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
    it(BUNDLE + 'DisplaySoloist_001', 0, async (done: Function) => {
      try {
        Logger.info(TAG, BUNDLE + 'DisplaySoloist_001 begin');

        let driver = Driver.create();
        await driver.delayMs(DELAYMS_1S);

        await driver.assertComponentExist(ON.id('Start'));
        let startButton = await driver.findComponent(ON.id('Start'));
        await startButton.click();
        await driver.delayMs(DELAYMS_5S);

        await driver.assertComponentExist(ON.id('Stop'));
        let stopButton = await driver.findComponent(ON.id('Stop'));
        await stopButton.click();
        await driver.delayMs(DELAYMS_1S);

        Logger.info(TAG, BUNDLE + 'DisplaySoloist_001 end');
        done();
      } catch (error) {
        Logger.info(TAG, `DisplaySoloist_001 exception = ${JSON.stringify(error)}`);
        expect().assertFail();
      }
    });
  })
}