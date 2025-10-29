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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';

const TAG = '[Sample_DrawingAPI]';

export default function abilityTest() {

  describe('ActsAbilityTest', () => {
    /**
     * 打开应用
     */
    it('StartAbility_001', 0, async (done: Function) => {
      console.info(TAG, 'StartAbility_001 begin');
      try {
        let driver = Driver.create();
        let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.nativedrawing',
          abilityName: 'EntryAbility'
        });
        await driver.delayMs(1000);
        done();
      } catch (exception) {
        console.info(TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      console.info(TAG, 'StartAbility_001 end');
    })

    /**
     * 点击按钮，绘制设置主题字体效果文本
     */
    it('DrawThemeFont_001', 2, async () => {
      console.info(TAG, 'DrawPath_001 begin');
      try {
        let driver = Driver.create();
        let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.nativedrawing',
          abilityName: 'EntryAbility'
        });
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text('使用主题字体'));
        let drawPathBtn = await driver.findComponent(ON.text('使用主题字体'));
        await drawPathBtn.click();
        await driver.delayMs(1000);
        await driver.pressBack();
      } catch (exception) {
        console.info(TAG, `DrawPath_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      console.info(TAG, 'DrawPath_001 end');
    })

    /**
     * 点击按钮，绘制使用自定义字体文本
     */
    it('DrawCustomFont_001', 2, async () => {
      console.info(TAG, 'DrawCustomFont_001 begin');
      try {
        let driver = Driver.create();
        let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.nativedrawing',
          abilityName: 'EntryAbility'
        });
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text('自定义字体的注册和使用'));
        let drawPathBtn = await driver.findComponent(ON.text('自定义字体的注册和使用'));
        await drawPathBtn.click();
        await driver.delayMs(1000);
        await driver.pressBack();
      } catch (exception) {
        console.info(TAG, `DrawCustomFont_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      console.info(TAG, 'DrawCustomFont_001 end');
    })

    /**
     * 点击按钮，绘制使用系统字体文本
     */
    it('DrawSysFontMetrics_001', 2, async () => {
      console.info(TAG, 'DrawSysFontMetrics_001 begin');
      try {
        let driver = Driver.create();
        let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.nativedrawing',
          abilityName: 'EntryAbility'
        });
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text('系统字体的信息获取和使用'));
        let drawPathBtn = await driver.findComponent(ON.text('系统字体的信息获取和使用'));
        await drawPathBtn.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text('获取系统字体信息'));
        drawPathBtn = await driver.findComponent(ON.text('获取系统字体信息'));
        await drawPathBtn.click()
        await driver.delayMs(1000);
        await driver.pressBack();
      } catch (exception) {
        console.info(TAG, `DrawSysFontMetrics_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      console.info(TAG, 'DrawSysFontMetrics_001 end');
    })

    /**
     * 点击按钮，绘制禁止使用系统字体文本
     */
    it('DrawDisableSysFont_001', 2, async () => {
      console.info(TAG, 'DrawDisableSysFont_001 begin');
      try {
        let driver = Driver.create();
        let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.nativedrawing',
          abilityName: 'EntryAbility'
        });
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text('停用或切换系统字体'));
        let drawPathBtn = await driver.findComponent(ON.text('停用或切换系统字体'));
        await drawPathBtn.click()
        await driver.delayMs(1000);
        await driver.pressBack();
        console.info(TAG, 'DrawDisableSysFont_001 end');
      } catch (exception) {
        console.info(TAG, `DrawDisableSysFont_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
    })
  })
}