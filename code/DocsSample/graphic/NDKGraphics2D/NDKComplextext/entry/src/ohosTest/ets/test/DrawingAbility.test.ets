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
      await driver.assertComponentExist(ON.text('FontVariation'));
      done();
      console.info(TAG, 'StartAbility_001 end');
    })

    /**
     * 点击按钮，绘制可变字体文本
     */
    it('DrawFontVariationTEST_001', 2, async () => {
      console.info(TAG, 'DrawFontVariationTEST_001 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.nativedrawing',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `DrawFontVariationTEST_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('FontVariation'));
      let drawPathBtn = await driver.findComponent(ON.text('FontVariation'));
      // 点击'FontVariation'按钮
      await drawPathBtn.click();
      await driver.delayMs(1000);
      console.info(TAG, 'DrawFontVariationTEST_001 end');
    })

    /**
     * 点击按钮，绘制阴影文本
     */
    it('DrawTextShadowTEST_001', 2, async () => {
      console.info(TAG, 'DrawTextShadowTEST_001 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.nativedrawing',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `DrawTextShadowTEST_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('TextShadow'));
      let drawPathBtn = await driver.findComponent(ON.text('TextShadow'));
      // 点击'FontVariation'按钮
      await drawPathBtn.click();
      await driver.delayMs(1000);
      console.info(TAG, 'DrawTextShadowTEST_001 end');
    })

    /**
     * 点击按钮，绘制前景色和背景色文本
     */
    it('SetTextBrushTEST_001', 2, async () => {
      console.info(TAG, 'SetTextBrushTEST_001 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.nativedrawing',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `SetTextBrushTEST_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Brush'));
      let drawPathBtn = await driver.findComponent(ON.text('Brush'));
      // 点击'Brush'按钮
      await drawPathBtn.click();
      await driver.delayMs(1000);
      console.info(TAG, 'SetTextBrushTEST_001 end');
    })

    /**
     * 点击按钮，绘制省略样式文本
     */
    it('SetTextEllipsisTEST_001', 2, async () => {
      console.info(TAG, 'SetTextEllipsisTEST_001 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.nativedrawing',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `SetTextEllipsisTEST_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Ellipsis'));
      let drawPathBtn = await driver.findComponent(ON.text('Ellipsis'));
      // 点击'Ellipsis'按钮
      await drawPathBtn.click();
      await driver.delayMs(1000);
      console.info(TAG, 'SetTextEllipsisTEST_001 end');
    })

  })
}