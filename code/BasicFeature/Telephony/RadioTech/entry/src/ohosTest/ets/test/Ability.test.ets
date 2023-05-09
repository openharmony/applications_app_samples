/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import hilog from '@ohos.hilog';

const TAG = '[Sample_RadioTech]';
const DOMAIN = 0xF811;
const BUNDLE = 'RadioTech_';

export default function appTest() {
  describe('ActsAbilityTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.radiotech',
          abilityName: 'EntryAbility'
        });
        done();
      } catch (err) {
        expect(err.code).assertEqual(0);
        done();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
      let parameter = {
        bundleName: 'ohos.samples.radiotech',
        abilityName: 'EntryAbility'
      }
    })

    /*
     * RadioTech
     */
    it(BUNDLE + 'RadioTechFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'RadioTechFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      // SIM1 status
      hilog.info(DOMAIN, TAG, BUNDLE + 'RadioTechFunction_001 arrow1');
      await driver.assertComponentExist(ON.id('arrow1'));
      let arrow1 = await driver.findComponent(ON.id('arrow1'));
      await arrow1.click();
      await driver.delayMs(1000);
      // 弹出框隐藏
      hilog.info(DOMAIN, TAG, BUNDLE + 'RadioTechFunction_001 arrow1Close');
      await arrow1.click();
      await driver.delayMs(1000);
      // SIM2 status
      hilog.info(DOMAIN, TAG, BUNDLE + 'RadioTechFunction_001 arrow2');
      await driver.assertComponentExist(ON.id('arrow2'));
      let arrow2 = await driver.findComponent(ON.id('arrow2'));
      await arrow2.click();
      await driver.delayMs(1000);
      // 弹出框隐藏
      hilog.info(DOMAIN, TAG, BUNDLE + 'RadioTechFunction_001 arrow2Close');
      await arrow2.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'RadioTechFunction_001 end');
    })
  })
}