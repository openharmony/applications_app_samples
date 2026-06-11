/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import hilog from '@ohos.hilog';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@kit.TestKit';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { UIAbility } from '@kit.AbilityKit';

const TAG = '[Sample_AuxiliaryWindow]';
const DOMAIN = 0xFF00
const BUNDLE = 'AuxiliaryWindowSample_';

export default function abilityTest() {

  describe('EntryAbilityTest', () => {
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "StartAbility_001, begin");
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.auxiliarywindowsample',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('辅助窗口demo'));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * 点击创建子窗按钮
     */
    it(BUNDLE + 'ClickCreateSubWindow_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + "ClickCreateSubWindow_001, begin");
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.auxiliarywindowsample',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `ClickCreateSubWindow_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }

      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('创建子窗'));
      let clickBtn = await driver.findComponent(ON.text('创建子窗'));
      await clickBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('销毁子窗'));
      clickBtn = await driver.findComponent(ON.text('销毁子窗'));
      await clickBtn.click();

      hilog.info(DOMAIN, TAG, BUNDLE + `ClickCreateSubWindow_001 end`);
    });

    /**
     * 点击创建独立子窗按钮
     */
    it(BUNDLE + 'ClickCreateIndependentSubWindow_001', 2, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + "ClickCreateIndependentSubWindow_001, begin");
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.auxiliarywindowsample',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `ClickCreateIndependentSubWindow_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('创建独立子窗'));
      let clickBtn = await driver.findComponent(ON.text('创建独立子窗'));
      await clickBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('销毁独立子窗'));
      clickBtn = await driver.findComponent(ON.text('销毁独立子窗'));
      await clickBtn.click();

      hilog.info(DOMAIN, TAG, BUNDLE + `ClickCreateIndependentSubWindow_001 end`);
    });

    /**
     * 点击创建全局悬浮窗按钮
     */
    it(BUNDLE + 'ClickCreateFloatingWindow_001', 2, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + "ClickCreateFloatingWindow_001, begin");
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.auxiliarywindowsample',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `ClickCreateFloatingWindow_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('创建全局悬浮窗'));
      let clickBtn = await driver.findComponent(ON.text('创建全局悬浮窗'));
      await clickBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('销毁全局悬浮窗'));
      clickBtn = await driver.findComponent(ON.text('销毁全局悬浮窗'));
      await clickBtn.click();

      hilog.info(DOMAIN, TAG, BUNDLE + `ClickCreateFloatingWindow_001 end`);
    });

    /**
     * 点击创建模态窗按钮
     */
    it(BUNDLE + 'ClickCreateDialogWindow_001', 2, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + "ClickCreateDialogWindow_001, begin");
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.auxiliarywindowsample',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `ClickCreateDialogWindow_007 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('创建模态窗'));
      let clickBtn = await driver.findComponent(ON.text('创建模态窗'));
      await clickBtn.click();
      await driver.delayMs(1000);
      clickBtn = await driver.findComponent(ON.text('销毁模态窗'));
      await clickBtn.click();

      hilog.info(DOMAIN, TAG, BUNDLE + `ClickCreateDialogWindow_001 end`);
    });

  })
}