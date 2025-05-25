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

export function ParticleTest() {
  describe('ParticleTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.example.animation',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('粒子动画'));
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

    it('ParticleTest_001', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例1（圆形初始化粒子）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('root'));
      for (let index = 0; index < 20; index++) {
        await aimComponent.click();
        await driver.delayMs(100);
      }
    })

    it('ParticleTest_002', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例2（图片初始化粒子）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('root'));
      for (let index = 0; index < 20; index++) {
        await aimComponent.click();
        await driver.delayMs(100);
      }
    })

    it('ParticleTest_003', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例3（粒子扰动场的干扰下运动轨迹发生变化）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('root'));
      for (let index = 0; index < 20; index++) {
        await aimComponent.click();
        await driver.delayMs(100);
      }
    })

    it('ParticleTest_004', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例4（调整粒子发射器位置）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('root'));
      for (let index = 0; index < 10; index++) {
        await aimComponent.click();
        await driver.delayMs(100);
      }
    })

    it('ParticleTest_005', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例5（环形发射器创建）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('root'));
      for (let index = 0; index < 10; index++) {
        await aimComponent.click();
        await driver.delayMs(100);
      }
    })

    it('ParticleTest_006', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例6（环形发射器更新）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('root'));
      for (let index = 0; index < 10; index++) {
        await aimComponent.click();
        await driver.delayMs(100);
      }
    })

  })
}