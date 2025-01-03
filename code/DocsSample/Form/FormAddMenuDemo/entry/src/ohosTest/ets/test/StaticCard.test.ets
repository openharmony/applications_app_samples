/*
* Copyright (C) 2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { describe, it, expect } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@ohos.UiTest';
import { Logger } from '../logger/Logger';

const TAG = '[Sample_Static_Card]';
const BUNDLE = 'Form Kit';
const driver = Driver.create();
const abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();

export default function addStaticCardTest() {
  describe('AddStaticCartTest', () => {
    /**
     * 拉起应用
     */
    it(BUNDLE + '_StartAbility', 0, async () => {
      Logger.info(TAG, BUNDLE + '_StartAbility start');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.formSample',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        Logger.error(TAG, BUNDLE + '_StartAbility error');
        expect().assertFail();
      }
      Logger.info(TAG, BUNDLE + '_StartAbility end');
    })

    /**
     * 添加静态卡片，点击静态卡片跳转到制定页面
     */
    it(BUNDLE + '_Add_Static_Card', 0, async () => {
      Logger.info(TAG, BUNDLE + '_Add_Static_Card begin');
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.longClick(170,350);
      await driver.delayMs(2000);
      let btnAccept = await driver.findComponent(ON.text('卡片'));
      if (btnAccept !== undefined) {
        await btnAccept.click();
        await driver.delayMs(1000);
      }
      let btnAccept2 = await driver.findComponent(ON.text('添加至桌面'));
      if (btnAccept2 !== undefined) {
        await btnAccept2.click();
        await driver.delayMs(1000);
      }
      await driver.delayMs(1000);
      await driver.click(600,500);
      await driver.delayMs(3000);
      Logger.info(TAG, BUNDLE + '_Permission end');
    })
  })
}