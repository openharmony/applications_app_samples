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
import Logger from '../Logger';

const BUNDLE = "PaySecurely_";
const TAG: string = '[Sample_PaySecurely]';
const DELEGATOR = AbilityDelegatorRegistry.getAbilityDelegator();

let driver: Driver = Driver.create();

// 资源本地化
async function getResourceString(resource: Resource): Promise<string> {
  let manage = DELEGATOR.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

// 通过id验证有没有这个组件 有的话点击一下
async function checkButtonAndClickWithID(text: string) {
  let atom = text;
  await driver.assertComponentExist(ON.id(atom));
  let button = await driver.findComponent(ON.id(atom));
  await button.click();
  await driver.delayMs(1000);
}

export default function abilityTest() {
  describe('ActsAbilityTest',  ()=> {

    /**
     * 拉起应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done:Function)=> {
      Logger.info(TAG, BUNDLE + 'StartAbility_001 begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.pay',
          abilityName: 'EntryAbility'
        });
        done();
      } catch (error) {
        Logger.info(TAG, `StartAbility end ${JSON.stringify(error)}`);
        expect(0).assertEqual(error.code);
        done();
      }
      Logger.info(TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * 选择商品进入支付hap
     */
    it(BUNDLE + 'PaySecurely_001', 0, async (done:Function) => {
      Logger.info(TAG, BUNDLE + 'PaySecurely_001 begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(3000);
      await checkButtonAndClickWithID('main_list_item_0');
      await driver.delayMs(3000);
      done();
      Logger.info(TAG, BUNDLE + 'PaySecurely_001 end');
    })

    /**
     * 点击立即支付
     */
    it(BUNDLE + 'PaySecurely_002', 0, async (done:Function) => {
      Logger.info(TAG, BUNDLE + 'PaySecurely_002 begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      let payButton = await driver.findComponent(ON.text(await getResourceString($r('app.string.pay_now'))));
      await payButton.click();
      await driver.delayMs(100);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.enter_password'))));

      // 输入密码
      let oneButton = await driver.findComponent(ON.text('1'));
      let twoButton = await driver.findComponent(ON.text('2'));
      let threeButton = await driver.findComponent(ON.text('3'));
      let fourButton = await driver.findComponent(ON.text('4'));
      let fiveButton = await driver.findComponent(ON.text('5'));
      let sixButton = await driver.findComponent(ON.text('6'));
      await oneButton.click();
      await twoButton.click();
      await threeButton.click();
      await fourButton.click();
      await fiveButton.click();
      await sixButton.click();

      // 返回商家
      await driver.delayMs(6000);
      await driver.assertComponentExist(ON.id('main_list_item_0'));
      await driver.delayMs(6000);
      done();
      Logger.info(TAG, BUNDLE + 'PaySecurely_002 end');
    })


  })
}