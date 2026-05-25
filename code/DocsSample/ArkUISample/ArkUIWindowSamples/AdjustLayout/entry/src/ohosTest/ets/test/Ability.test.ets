/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

const TAG = '[Sample_AdjustLayout]';
const DOMAIN = 0xFF00
const BUNDLE = 'AdjustLayout_';

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
          bundleName: 'com.samples.adjustlayout',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Main Window'));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * 点击开启主窗比例限制按钮
     */
    it(BUNDLE + 'ClickAspectRatioButton_001', 2, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + "ClickAspectRatioButton_001, begin");
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.adjustlayout',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `ClickAspectRatioButton_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('开启主窗比例限制'));
      let clickBtn = await driver.findComponent(ON.text('开启主窗比例限制'));
      await clickBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('关闭主窗比例限制'));

      hilog.info(DOMAIN, TAG, BUNDLE + `ClickAspectRatioButton_001 end`);
    })

    /**
     * 点击显示子窗按钮
     */
    it(BUNDLE + 'ClickShowSubWindowButton_001', 2, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + "ClickShowSubWindowButton_001, begin");
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.adjustlayout',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `ClickShowSubWindowButton_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('显示子窗'));
      let clickBtn = await driver.findComponent(ON.text('显示子窗'));
      await clickBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('隐藏子窗'));

      hilog.info(DOMAIN, TAG, BUNDLE + `ClickShowSubWindowButton_001 end`);
    })

    /**
     * 点击关闭子窗拖拽大小按钮
     */
    it(BUNDLE + 'ClickResizeButton_001', 2, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + "ClickResizeButton_001, begin");
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.adjustlayout',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `ClickResizeButton_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('关闭子窗拖拽大小'));
      let clickBtn = await driver.findComponent(ON.text('关闭子窗拖拽大小'));
      await clickBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('开启子窗拖拽大小'));

      hilog.info(DOMAIN, TAG, BUNDLE + `ClickResizeButton_001 end`);
    })

    /**
     * 点击关闭子窗拖拽位置按钮
     */
    it(BUNDLE + 'ClickMoveButton_001', 2, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + "ClickMoveButton_001, begin");
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.adjustlayout',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `ClickMoveButton_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('关闭子窗拖拽位置'));
      let clickBtn = await driver.findComponent(ON.text('关闭子窗拖拽位置'));
      await clickBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('开启子窗拖拽位置'));

      hilog.info(DOMAIN, TAG, BUNDLE + `ClickMoveButton_001 end`);
    })

    /**
     * 点击设置子窗口 windowLimits 按钮
     */
    it(BUNDLE + 'ClickSetWindowLimitsButton_001', 2, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + "ClickSetWindowLimitsButton_001, begin");
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.adjustlayout',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `ClickSetWindowLimitsButton_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      // 找到设置按钮（按钮上的文本）
      let clickBtn = await driver.findComponent(ON.text('设置子窗口 windowLimits'));
      await clickBtn.click();
      await driver.delayMs(1000);
      // 通过 id 定位 resultText 组件，验证点击后有响应
      await driver.assertComponentExist(ON.id('resultText'));

      hilog.info(DOMAIN, TAG, BUNDLE + `ClickSetWindowLimitsButton_001 end`);
    })

  })
}