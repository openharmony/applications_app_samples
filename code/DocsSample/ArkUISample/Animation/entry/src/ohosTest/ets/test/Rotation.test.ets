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
import { abilityDelegatorRegistry, Component, DisplayRotation, Driver } from '@kit.TestKit';
import { afterEach, beforeAll, describe, expect, it } from '@ohos/hypium';
import { ON } from '@ohos.UiTest';

/*获取AbilityDelegator实例,管理Ability的生命周期和事件*/
const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator()

/*初始化与UI元素交互的驱动对象*/
const driver = Driver.create();

/*当前获取到的目标组件对象*/
let aimComponent : Component

export function RotationTest() {
  describe('RotationTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.example.animation',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('旋转屏动画'));
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

    it('RotationTest_001', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例1（布局切换的旋转屏动画）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      await driver.setDisplayRotation(DisplayRotation.ROTATION_90)
      await driver.delayMs(1000);
      await driver.setDisplayRotation(DisplayRotation.ROTATION_0)
      await driver.delayMs(1000);
    })

    it('RotationTest_002', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例2（透明度变化的旋转屏动画）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      await driver.setDisplayRotation(DisplayRotation.ROTATION_90)
      await driver.delayMs(1000);
      await driver.setDisplayRotation(DisplayRotation.ROTATION_0)
      await driver.delayMs(1000);
    })

  })
}