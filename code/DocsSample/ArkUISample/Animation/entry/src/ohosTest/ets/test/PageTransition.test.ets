/*
 * Copyright (c) 2025 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { abilityDelegatorRegistry, Component, Driver } from '@kit.TestKit';
import { afterEach, beforeAll, describe, expect, it } from '@ohos/hypium';
import { ON } from '@ohos.UiTest';

/*获取AbilityDelegator实例,管理Ability的生命周期和事件*/
const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator()

/*初始化与UI元素交互的驱动对象*/
const driver = Driver.create();

/*当前获取到的目标组件对象*/
let aimComponent : Component

export function PageTransitionTest() {
  describe('PageTransitionTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.example.animation',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('页面间转场'));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    afterEach(async () => {
      aimComponent = await driver.findComponent(ON.text('AnimateIndex'));
      do {
        await driver.pressBack();
        aimComponent = await driver.findComponent(ON.text('AnimateIndex'));
      } while (aimComponent == null)
    })

    it('PageTransitionTest_001', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例1（设置退入场动画）'));
      await aimComponent.click();
      await driver.delayMs(5000);
    })

    it('PageTransitionTest_002', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例2（设置退入场平移效果）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('页面1'));
      await aimComponent.click();
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('页面2'));
      await aimComponent.click();
      await driver.delayMs(3000);
    })

    it('PageTransitionTest_003', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例3（不推荐)（利用pushUrl跳转能力）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushUrl'));
      await aimComponent.click();
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('back'));
      await aimComponent.click();
      await driver.delayMs(3000);
    })

    it('PageTransitionTest_004', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例4（不推荐)（type为None的页面转场）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushUrl'));
      await aimComponent.click();
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('back'));
      await aimComponent.click();
      await driver.delayMs(3000);
    })

  })
}