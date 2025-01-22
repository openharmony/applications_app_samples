/*
* Copyright (C) 2024-2025 Huawei Device Co., Ltd.
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
import { Driver, ON, Point, UiDirection } from '@ohos.UiTest';
import { Logger } from '../logger/Logger';

const TAG = '[Sample_Add_Form]';
const BUNDLE = 'Form Kit';
const driver = Driver.create();
const DELAY_MS = 1000;
const abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
const ability = abilityDelegatorRegistry.getAppContext();
const manager = ability.resourceManager;

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
      let btnAccept =
        await driver.findComponent(ON.id(await manager.getStringValue($r('app.string.add_form_by_menu_id'))));
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

    /**
     * 返回桌面，长按应用图标打开卡片。
     */
    it(BUNDLE + '_router_to_PageA', 0, async (done: Function) => {
      await driver.pressHome();
      await driver.delayMs(DELAY_MS);
      // 查询应用所在的图标桌面
      let findApp = false;
      do {
        await driver.fling(UiDirection.RIGHT, 1000);
        await driver.delayMs(DELAY_MS);
        try {
          await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.app_name'))));
          findApp = true;
        } catch (e) {
        }
      } while (!findApp)
      // 获取应用名称中心点
      let appName = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.app_name'))));
      let appNameCenter: Point = await appName.getBoundsCenter();
      // 打开添加卡片界面
      await driver.longClick(appNameCenter.x, appNameCenter.y - 20);
      let cardBtn = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.widgets_name'))));
      await driver.delayMs(1000);
      await cardBtn.click();
      await driver.delayMs(2000);
      // 将卡片添加到桌面
      await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.add_form_to_desktop'))));
      let addBtn = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.add_form_to_desktop'))));
      await addBtn.click();
      await driver.delayMs(2000);
      // 点击卡片跳转到对应页面
      await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.form_static_card_desc'))));
      let routerBtn =
        await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.form_static_card_desc'))));
      await routerBtn.click();
      await driver.delayMs(2000);
      done();
    })
  })
}