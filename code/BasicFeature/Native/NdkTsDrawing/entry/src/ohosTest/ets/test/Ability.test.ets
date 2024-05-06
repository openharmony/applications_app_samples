/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
    it("StartAbility_001", 0, async (done: Function) => {
      console.info(TAG, "StartAbility_001 begin");
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.ndktsdrawing',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Draw Path'));
      done();
      console.info(TAG, 'StartAbility_001 end');
    })

    /**
     * 点击按钮，绘制路径
     */
    it('DrawPath_001', 2, async () => {
      console.info(TAG, 'DrawPath_001 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.ndktsdrawing',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `DrawPath_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Draw Path'));
      let drawPathBtn = await driver.findComponent(ON.text('Draw Path'));
      // 点击'Draw Path'按钮
      await drawPathBtn.click();
      await driver.delayMs(1000);
      console.info(TAG, 'DrawPath_001 end');
    })

    /**
     * 点击按钮，绘制矩形
     */
    it('DrawRect_001', 2, async () => {
      console.info(TAG, 'DrawRect_001 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.ndktsdrawing',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `DrawRect_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Draw Rect'));
      let drawPathBtn = await driver.findComponent(ON.text('Draw Rect'));
      // 点击'Draw Rect'按钮
      await drawPathBtn.click();
      await driver.delayMs(1000);
      console.info(TAG, 'DrawRect_001 end');
    })

    /**
     * 点击按钮，绘制文字
     */
    it('DrawText_001', 2, async () => {
      console.info(TAG, 'DrawText_001 begin');
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.ndktsdrawing',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        console.info(TAG, `DrawText_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Draw Text'));
      let drawPathBtn = await driver.findComponent(ON.text('Draw Text'));
      // 点击'Draw Text'按钮
      await drawPathBtn.click();
      await driver.delayMs(1000);
      console.info(TAG, 'DrawPath_001 end');
    })
  })
}