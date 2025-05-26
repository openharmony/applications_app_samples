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
const BUNDLE = 'VisionEffect_'

/*初始化与UI元素交互的驱动对象*/
const driver = Driver.create();

/*当前获取到的目标组件对象*/
let aimComponent : Component

export function TransformTest() {
  describe(BUNDLE + 'TransformTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.visionEffect',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('图形变换'));
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

    it(BUNDLE + 'TransformTest_001', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例1（为组件添加图形变换效果）'));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it(BUNDLE + 'TransformTest_002', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例2（设置旋转视距）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('change prep'))
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it(BUNDLE + 'TransformTest_003', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例3（按中心点旋转）'));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

  })
}