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
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.nativedrawing',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Draw theme font'));
      done();
      console.info(TAG, 'StartAbility_001 end');
    })

    /**
     * 点击按钮，绘制设置主题字体效果文本
     */
    it('DrawThemeFont_001', 2, async () => {
      console.info(TAG, 'DrawPath_001 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.nativedrawing',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `DrawPath_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Draw theme font'));
      let drawPathBtn = await driver.findComponent(ON.text('Draw theme font'));
      // 点击'Draw Path'按钮
      await drawPathBtn.click();
      await driver.delayMs(1000);
      console.info(TAG, 'DrawPath_001 end');
    })

    /**
     * 点击按钮，绘制使用自定义字体文本
     */
    it('DrawCustomFont_001', 2, async () => {
      console.info(TAG, 'DrawCustomFont_001 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.nativedrawing',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `DrawCustomFont_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Draw CustomFont'));
      let drawPathBtn = await driver.findComponent(ON.text('Draw CustomFont'));
      // 点击'Draw Path'按钮
      await drawPathBtn.click();
      await driver.delayMs(1000);
      console.info(TAG, 'DrawCustomFont_001 end');
    })

    /**
     * 点击按钮，绘制使用系统字体文本
     */
    it('DrawSysFontMetrics_001', 2, async () => {
      console.info(TAG, 'DrawSysFontMetrics_001 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.nativedrawing',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `DrawSysFontMetrics_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('SysFontMetrics'));
      let drawPathBtn = await driver.findComponent(ON.text('SysFontMetrics'));
      // 点击'Draw Path'按钮
      await drawPathBtn.click();
      await driver.delayMs(1000);
      console.info(TAG, 'DrawSysFontMetrics_001 end');
    })

    /**
     * 点击按钮，绘制禁止使用系统字体文本
     */
    it('DrawDisableSysFont_001', 2, async () => {
      console.info(TAG, 'DrawDisableSysFont_001 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.nativedrawing',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `DrawDisableSysFont_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('DisableSysFont'));
      let drawPathBtn = await driver.findComponent(ON.text('DisableSysFont'));
      // 点击'Draw Path'按钮
      await drawPathBtn.click();
      await driver.delayMs(1000);
      console.info(TAG, 'DrawDisableSysFont_001 end');
    })

  })
}