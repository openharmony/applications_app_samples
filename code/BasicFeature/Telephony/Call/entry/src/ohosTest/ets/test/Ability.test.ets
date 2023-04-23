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

import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, Component } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Logger from '../util/Logger';

const TAG = 'AppTest';
const BUNDLE = 'Call_';
let driver: Driver = Driver.create();

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      Logger.info(TAG, `${BUNDLE}StartAbility start`);
      let want = {
        bundleName: 'ohos.samples.call',
        abilityName: 'EntryAbility'
      }
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      abilityDelegator.startAbility(want, (err) => {
        Logger.info(TAG, `${BUNDLE}StartAbility get err ${JSON.stringify(err)}`);
        done();
        Logger.info(TAG, `${BUNDLE}StartAbility end`);
      });
    })
    /**
     * 输入电话号码并拨打
     */
    it(BUNDLE + 'CallFunction_001', 0, async function () {
      // create UiDriver
      Logger.info(TAG, `${BUNDLE}CallFunction_001 begin`);
      await driver.delayMs(1000);
      // 输入电话号码
      await driver.assertComponentExist(ON.id('telInput'));
      let telInput = await driver.findComponent(ON.id('telInput'));
      await driver.delayMs(1000);
      await telInput.inputText('13566254180');
      await driver.delayMs(1000);
      let telVal = await telInput.getText();
      await driver.delayMs(1000);
      expect('13566254180').assertEqual(telVal);
      await driver.delayMs(1000);
      // 点击图标拨号
      await driver.assertComponentExist(ON.id('callImg'));
      let callBtn = await driver.findComponent(ON.id('callImg'));
      await driver.delayMs(1000);
      await callBtn.click();
      await driver.delayMs(1000);
      // 返回桌面
      await driver.click(360,1244);
      Logger.info(TAG, `${BUNDLE}CallFunction_001 end`);
    })
  })
}