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
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import hilog from '@ohos.hilog';

const TAG = '[Sample_SimManager]';
const DOMAIN = 0xF811;
const BUNDLE = 'SimManager_';

export default function appTest() {
  describe('ActsAbilityTest', function () {
    it(BUNDLE + 'StartAbility_001 begin', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.simmanager',
          abilityName: 'EntryAbility'
        });
        done();
      } catch (err) {
        expect(err.code).assertEqual(0);
        done();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * BringSimManage
     */
    it(BUNDLE + 'BringSimManageFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'BringSimManageFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      // 点击卡1
      await driver.assertComponentExist(ON.id('card1'));
      let firstCard = await driver.findComponent(ON.id('card1'));
      await firstCard.click();
      await driver.delayMs(1000);
      // 关闭卡1弹窗
      await firstCard.click();
      // 点击卡2
      await driver.assertComponentExist(ON.id('card2'));
      let secondCard = await driver.findComponent(ON.id('card2'));
      await secondCard.click();
      await driver.delayMs(1000);
      // 关闭卡2弹窗
      await secondCard.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'BringSimManageFunction_001 end');
    })
  })
}