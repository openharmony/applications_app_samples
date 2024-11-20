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
import { Logger } from '../Logger/Logger';

const TAG = '[Sample_Add_Form]';
const BUNDLE = 'Form Kit';
const driver = Driver.create();
const abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();

export default function abilityTest() {
  describe('FormKitTest', () => {
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
     * 通过Menu添加卡片到桌面
     */
    it(BUNDLE + '_Add_Form', 0, async () => {
      Logger.info(TAG, BUNDLE + '_Add_Form begin');
      await driver.delayMs(1000);
      let ability = abilityDelegatorRegistry.getAppContext();
      let manager = ability.resourceManager;
      let btnAccept = await driver.findComponent(ON.id('add_form_by_menu'));
      if (btnAccept !== undefined) {
        await btnAccept.longClick();
        await driver.delayMs(1000);
      }
      let btnAccept2 = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.add_form'))));
      if (btnAccept2 !== undefined) {
        await btnAccept2.click();
        await driver.delayMs(1000);
      }

      Logger.info(TAG, BUNDLE + '_Permission end');
    })
  })
}