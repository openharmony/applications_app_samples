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

const TAG = '[Sample_Observer]';
const DOMAIN = 0xF811;
const BUNDLE = 'Observer _';

export default function appTest() {
  describe('ActsAbilityTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.observer',
          abilityName: 'MainAbility'
        });
        done();
      } catch (err) {
        expect(err.code).assertEqual(0);
        done();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * Observer
     */
    it(BUNDLE + 'ObserverFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'ObserverFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      // 订阅网络状态变化事件
      hilog.info(DOMAIN, TAG, BUNDLE + 'ObserverFunction_001 network_state_change');
      await driver.assertComponentExist(ON.id('switch1'));
      let switch1 = await driver.findComponent(ON.id('switch1'));
      await switch1.click();
      await driver.delayMs(1000);
      // 订阅信号状态变化事件
      hilog.info(DOMAIN, TAG, BUNDLE + 'ObserverFunction_001 signal_info_change');
      await driver.assertComponentExist(ON.id('switch2'));
      let switch2 = await driver.findComponent(ON.id('switch2'));
      await switch2.click();
      await driver.delayMs(1000);
      // 订阅通话状态变化事件
      hilog.info(DOMAIN, TAG, BUNDLE + 'ObserverFunction_001 callState_change');
      await driver.assertComponentExist(ON.id('switch3'));
      let switch3 = await driver.findComponent(ON.id('switch3'));
      await switch3.click();
      await driver.delayMs(1000);
      // 订阅蜂窝数据链路连接状态
      hilog.info(DOMAIN, TAG, BUNDLE + 'ObserverFunction_001 cellular_data_connection_state_change');
      await driver.assertComponentExist(ON.id('switch4'));
      let switch4 = await driver.findComponent(ON.id('switch4'));
      await switch4.click();
      await driver.delayMs(1000);
      // 订阅蜂窝数据业务的数据流状态
      hilog.info(DOMAIN, TAG, BUNDLE + 'ObserverFunction_001 cellular_data_flow_change');
      await driver.assertComponentExist(ON.id('switch5'));
      let switch5 = await driver.findComponent(ON.id('switch5'));
      await switch5.click();
      await driver.delayMs(1000);
      // 订阅sim状态更改事件
      hilog.info(DOMAIN, TAG, BUNDLE + 'ObserverFunction_001 sim_state_change');
      await driver.assertComponentExist(ON.id('switch6'));
      let switch6 = await driver.findComponent(ON.id('switch6'));
      await switch6.click();
      await driver.delayMs(1000);
      // seeDetails
      hilog.info(DOMAIN, TAG, BUNDLE + 'ObserverFunction_001 seeDetails');
      await driver.assertComponentExist(ON.id('seeDetails'));
      let btnDetail = await driver.findComponent(ON.id('seeDetails'));
      await btnDetail.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'ObserverFunction_001 back');
      await driver.assertComponentExist(ON.id('back'));
      let back = await driver.findComponent(ON.id('back'));
      await back.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ObserverFunction_001 end');
    })
  })
}