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
import { describe, expect, it } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import Logger from '../utils/Logger';

const TAG = '[Sample_FFRT]';
const BUNDLE = 'MyApp_'
const DELAYMS_1S = 1000;
const DELAYMS_2S = 2000;
const DELAYMS_5S = 5000;

const bundleName = abilityDelegatorRegistry.getArguments().bundleName;

export default function abilityTest() {
  describe('AbilityTest', () => {
    it(BUNDLE + 'StartAbility_001, begin', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'StartAbility_001');
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
     * @tc.number:FFRT_CLICK_RESULT_0300
     * @tc.name:ClickResult_003
     * @tc.desc:click execution return correct result
     * @tc.size:MediumTest
     * @tc.type:Function
     * @tc.level:Level 1
     */
    it(BUNDLE + 'ClickResult_005', 0, async (done: Function) => {
      try {
        Logger.info(TAG, BUNDLE + 'ClickResult_005 beg' +
          'in');

        let driver = Driver.create();
        await driver.delayMs(DELAYMS_2S);

        await driver.assertComponentExist(ON.id('FFRTTaskGraphC'));
        let taskGraphCButton = await driver.findComponent(ON.id('FFRTTaskGraphC'));
        await taskGraphCButton.click();
        await driver.delayMs(DELAYMS_2S);

        Logger.info(TAG, BUNDLE + 'ClickResult_005 end');
        done();
      } catch (error) {
        expect().assertFail();
      }
    });

    it(BUNDLE + 'ClickResult_006', 0, async (done: Function) => {
      try {
        Logger.info(TAG, BUNDLE + 'ClickResult_006 beg' +
          'in');

        let driver = Driver.create();
        await driver.delayMs(DELAYMS_2S);

        await driver.assertComponentExist(ON.id('FFRTTaskGraphCpp'));
        let taskGraphCButton = await driver.findComponent(ON.id('FFRTTaskGraphCpp'));
        await taskGraphCButton.click();
        await driver.delayMs(DELAYMS_2S);

        Logger.info(TAG, BUNDLE + 'ClickResult_006 end');
        done();
      } catch (error) {
        expect().assertFail();
      }
    });
  })
}