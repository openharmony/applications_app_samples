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

import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, Component } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Logger from '../util/Logger';

const TAG = 'AppTest';
const BUNDLE = 'AbilityConnectServiceExtension_';
let driver: Driver = Driver.create();
let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();

export default function appTest() {
  describe('appTest', function () {
    // 启动应用
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      Logger.info(TAG, `${BUNDLE}StartAbility start`);
      let want = {
        bundleName: 'com.example.abilityconnectserviceextension',
        abilityName: 'MainAbility'
      }
      abilityDelegatorRegistry.startAbility(want, (err) => {
        Logger.info(TAG, `${BUNDLE}StartAbility get err ${JSON.stringify(err)}`);
        done();
      });
      Logger.info(TAG, `${BUNDLE}StartAbility end`);
    });
    // 验证数据是否更新
    it(`${BUNDLE}CheckData_001`, 0, async () => {
      Logger.info(TAG, `${BUNDLE}CheckData_001 begin`);
      await driver.delayMs(1000);
      // 获取显示温度的节点
      await driver.assertComponentExist(ON.id('temperature'));
      let currentTemperature = await driver.findComponent(ON.id('temperature'));
      await driver.delayMs(1000);
      let beforeChange = await currentTemperature.getText();
      await driver.delayMs(5000);
      let afterChange = await currentTemperature.getText();
      if (beforeChange === afterChange) {
        Logger.info(TAG,'Failed to get data');
        expect().assertFail();
      }
      Logger.info(TAG, `${BUNDLE}CheckData_001 end`);
    })
  })
}