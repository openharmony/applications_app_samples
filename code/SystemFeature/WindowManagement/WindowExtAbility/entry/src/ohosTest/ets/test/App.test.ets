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

const BUNDLE = 'WindowExtAbility_';
const TAG = 'AppTestPage';

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      Logger.info(TAG, 'StartAbility start')
      let want = {
        bundleName: 'ohos.samples.windowextability',
        abilityName: 'MainAbility'
      }
      let abilityDelegator: AbilityDelegatorRegistry.AbilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      abilityDelegator.startAbility(want, (err, data) => {
        Logger.info(TAG, `StartAbility get err ${JSON.stringify(err)}`);
        done()
        Logger.info(TAG, 'StartAbility end');
      })
    })
    /**
     * 点击进入WLAN详情页面、蓝牙详情页面、移动数据详情页面
     */
    it(BUNDLE + 'IndexPage_EnterDetailPage_001', 0, async function () {
      Logger.info(TAG, 'IndexPage_EnterDetailPage_001 start');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 点击进入食物详情
      for (let i = 0; i < 3; i++) {
        await driver.delayMs(1000);
        // 点击相应的设置类型进入详情页
        await driver.assertComponentExist(ON.id(`settingType${i}`));
        let settingType = await driver.findComponent(ON.id(`settingType${i}`));
        await driver.delayMs(1000);
        await settingType.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id(`back`));
        let backBtn = await driver.findComponent(ON.id('back'));
        await driver.delayMs(1000);
        await backBtn.click();
        await driver.delayMs(1000);
      }
      Logger.info(TAG, 'IndexPage_EnterDetailPage_001 end');
    })
  })
}
