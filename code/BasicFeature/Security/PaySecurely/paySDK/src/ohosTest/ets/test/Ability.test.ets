/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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
import Logger from '../../../main/ets/util/Logger';

const BUNDLE = "PaySecurely_";
const TAG: string = '[Sample_PaySecurely]';

let driver: Driver = Driver.create();

// 通过id验证有没有这个组件 有的话点击一下
async function checkButtonAndClickWithID(text: string) {
  let atom = text;
  await driver.assertComponentExist(ON.id(atom));
  let button = await driver.findComponent(ON.id(atom));
  await button.click();
  await driver.delayMs(1000);
}

// 路由返回
async function goBack() {
  await driver.assertComponentExist(ON.id('btnBack'));
  let btnBack = await driver.findComponent(ON.id('btnBack'));
  await btnBack.click();
  await driver.delayMs(1000);
}


export default function abilityTest() {
  describe('ActsAbilityTest', function () {

    /**
     * 支付
     */
    it(BUNDLE + 'PaySecurely_002', 0, async (done) => {
      Logger.info(TAG, BUNDLE + 'PaySecurely_002 begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(2000);
      await driver.assertComponentExist(ON.text('立即支付'));
      let pay = await driver.findComponent(ON.id('立即支付'));
      await pay.click();
      await driver.delayMs(100);
      done();
      Logger.info(TAG, BUNDLE + 'PaySecurely_002 end');
    })



  })
}