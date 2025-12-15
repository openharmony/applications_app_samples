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
     * 点击按钮，绘制多语言文本
     */
    it('DrawMultilingualTextTEST', 2, async () => {
      console.info(TAG, 'DrawMultilingualTextTEST_001 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.drawing',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `DrawMultilingualTextTEST exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Multilanguage-text page'));
      let drawTextBtn = await driver.findComponent(ON.text('Multilanguage-text page'));
      // 点击'Multilanguage-text page'按钮
      await drawTextBtn.click();
      await driver.delayMs(1000);
      // 返回上一级页面
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info(TAG, 'DrawMultilingualTextTEST end');
    })

    /**
     * 点击按钮，绘制断词策略多行文本
     */
    it('DrawMultiLineTextTEST', 2, async () => {
      console.info(TAG, 'DrawMultiLineTextTEST_001 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.drawing',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `DrawMultiLineTextTEST exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Multiline-text page'));
      let drawTextBtn = await driver.findComponent(ON.text('Multiline-text page'));
      // 点击'Multi-line text'按钮
      await drawTextBtn.click();
      await driver.delayMs(1000);
      // 返回上一级页面
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info(TAG, 'DrawMultiLineTextTEST end');
    })

    /**
     * 点击按钮，进入绘制复杂样式排版文本页面，依次编译所有样例。
     */
    it('DrawComplexStyleTextTEST', 2, async () => {
      console.info(TAG, 'DrawComplexStyleTextTEST begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.drawing',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `DrawComplexStyleTextTEST exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('Complex-text page'));

      let drawTextBtn = await driver.findComponent(ON.text('Complex-text page'));
      // 点击'Complex-text page'按钮
      await drawTextBtn.click();
      await driver.delayMs(500);


      let drawTextExample1 = await driver.findComponent(ON.text('Example1 (Decoration, FontFeature)'));
      // 点击'Example1 (Decoration, FontFeature)'按钮
      await drawTextExample1.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);

      let drawTextExample2 = await driver.findComponent(ON.text('Example2 (FontVariation, TextShadow, Placeholder)'));
      // 点击'Example2 (FontVariation, TextShadow, Placeholder)'按钮
      await drawTextExample2.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);

      let drawTextExample3 = await driver.findComponent(ON.text('Example3 (VerticalAlign)'));
      // 点击'Example3 (VerticalAlign)'按钮
      await drawTextExample3.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);

      let drawTextExample4 = await driver.findComponent(ON.text('Example4 (BadgeType)'));
      // 点击'Example4 (BadgeType)'按钮
      await drawTextExample4.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);

      let drawTextExample5 = await driver.findComponent(ON.text('Example5 (TextHighContrast)'));
      // 点击'Example5 (TextHighContrast)'按钮
      await drawTextExample5.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);

      // 返回Index页面
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info(TAG, 'DrawComplexStyleTextTEST end');
    })

    /**
     * 点击按钮，绘制独立塑形文本
     */
    it('DrawShapeTextTEST', 2, async () => {
      console.info(TAG, 'DrawShapeTextTEST_001 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.drawing',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `DrawShapeTextTEST exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Shape page'));
      let drawTextBtn = await driver.findComponent(ON.text('Shape page'));
      // 点击'Shape page'按钮
      await drawTextBtn.click();
      await driver.delayMs(1000);
      // 返回上一级页面
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info(TAG, 'DrawShapeTextTEST end');
    })

  })
}