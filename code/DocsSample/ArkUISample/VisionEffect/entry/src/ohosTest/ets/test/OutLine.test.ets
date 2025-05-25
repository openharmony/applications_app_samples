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

export function OutLineTest() {
  describe('OutLineTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.example.visionEffect',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('外描边设置'));
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

    it('OutLineTest_001', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例1（使用外描边属性）'));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it('OutLineTest_002', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例2（使用LocalizedEdgeColors类型）'));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

  })
}