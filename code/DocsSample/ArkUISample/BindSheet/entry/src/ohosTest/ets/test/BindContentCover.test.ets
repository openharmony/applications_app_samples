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
const BUNDLE = 'BindSheet_'

/*当前获取到的目标组件对象*/
let aimComponent : Component

export function BindContentCoverTest() {
  describe(BUNDLE + 'BindContentCoverTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.bindSheet',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('全模态转场'));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    afterEach(async () => {
      aimComponent = await driver.findComponent(ON.text('Index'));
      do {
        await driver.pressBack();
        aimComponent = await driver.findComponent(ON.text('Index'));
      } while (aimComponent == null)
    })

    it(BUNDLE + 'BindContentCoverTest_001', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例1（使用全屏模态转场）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('transition modal 1'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('transition modal 2'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('close modal 2'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('close modal 1'))
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it(BUNDLE + 'BindContentCoverTest_002', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例2（自定义转场动画）'));
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('transition modal 1'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('transition modal 2'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('close modal 2'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('close modal 1'))
      await aimComponent.click();
      await driver.delayMs(2000);
    })

    it(BUNDLE + 'BindContentCoverTest_003', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例3（上下切换转场）'));
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('transition modal 1'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('transition modal 2'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('close modal 2'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('close modal 1'))
      await aimComponent.click();
      await driver.delayMs(2000);
    })

    it(BUNDLE + 'BindContentCoverTest_004', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例4（透明度渐变转场）'));
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('transition modal 1'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('transition modal 2'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('close modal 2'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('close modal 1'))
      await aimComponent.click();
      await driver.delayMs(2000);
    })

    it(BUNDLE + 'BindContentCoverTest_005', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例5（设置不同效果的自定义转场）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('Transition Modal 1'))
      await aimComponent.click();
      await driver.delayMs(5000);

      aimComponent = await driver.findComponent(ON.text('Transition Modal 2'))
      await aimComponent.click();
      await driver.delayMs(5000);

      aimComponent = await driver.findComponent(ON.text('Close Modal 2'))
      await aimComponent.click();
      await driver.delayMs(5000);

      aimComponent = await driver.findComponent(ON.text('Close Modal 1'))
      await aimComponent.click();
      await driver.delayMs(5000);
    })

    it(BUNDLE + 'BindContentCoverTest_006', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例6（使用bindContentCover构建全屏模态内容覆盖半模态）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('有票'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('+ 选择乘车人'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('确认'))
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it(BUNDLE + 'BindContentCoverTest_007', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例7（使用bindContentCover构建全屏模态转场效果）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('+ 选择乘车人'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('确认'))
      await aimComponent.click();
      await driver.delayMs(1000);
    })

  })
}