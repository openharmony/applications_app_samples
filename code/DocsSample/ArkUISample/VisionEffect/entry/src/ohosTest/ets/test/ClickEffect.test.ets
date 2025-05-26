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
const BUNDLE = 'VisionEffect_'

/*当前获取到的目标组件对象*/
let aimComponent : Component

export function ClickEffectTest() {
  describe(BUNDLE + 'ClickEffectTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.visionEffect',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('点击回弹效果'));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    afterEach(async () => {
      aimComponent = await driver.findComponent(ON.text('VisionEffectIndex'));
      do {
        await driver.pressBack();
        aimComponent = await driver.findComponent(ON.text('VisionEffectIndex'));
      } while (aimComponent == null)
    })

    it(BUNDLE + 'ClickEffectTest_001', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例1'));
      await aimComponent.click();
      await driver.delayMs(1000);

      let Toggles = await driver.findComponents(ON.type('Toggle'));
      await Toggles[0].click();
      await driver.delayMs(1000);

      await Toggles[1].click();
      await driver.delayMs(1000);

      await Toggles[2].click();
      await driver.delayMs(1000);

      await Toggles[3].click();
      await driver.delayMs(1000);

      let aimComponents = await driver.findComponents(ON.text('status button'));
      await aimComponents[0].click();
      await driver.delayMs(1000);

      await aimComponents[1].click();
      await driver.delayMs(1000);

    })

  })
}