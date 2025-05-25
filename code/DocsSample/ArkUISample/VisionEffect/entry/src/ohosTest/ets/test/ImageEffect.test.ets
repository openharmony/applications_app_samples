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

export function ImageEffectTest() {
  describe('ImageEffectTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.example.visionEffect',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('图像效果'));
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

    it('ImageEffectTest_001', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例1（设置图片不同属性效果）'));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it('ImageEffectTest_002', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例2（设置组件线性渐变模糊效果）'));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it('ImageEffectTest_003', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例3（设置离屏渲染效果）'));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it('ImageEffectTest_004', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例4（当前组件内容与下方画布内容混合）'));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it('ImageEffectTest_005', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例5（前景智能取反色）'));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it('ImageEffectTest_006', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例6（设置同层阴影不重叠效果）'));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it('ImageEffectTest_007', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例7（设置组件图像球面效果）'));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it('ImageEffectTest_008', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例8（设置组件图像渐亮效果）'));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it('ImageEffectTest_009', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例9（设置组件图像边缘像素扩展效果）'));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it('ImageEffectTest_010', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例10（系统导航条智能反色）'));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

  })
}