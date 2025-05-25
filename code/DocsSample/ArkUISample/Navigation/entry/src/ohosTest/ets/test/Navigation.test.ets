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

export function NavigationTest() {
  describe('NavigationTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.example.navigation',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('Navigation'));
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

    it('NavigationTest_001', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例1（Navigation页面布局）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('TitleBar'))
      expect(aimComponent)

      aimComponent = await driver.findComponent(ON.type('ToolBar'))
      expect(aimComponent)

      aimComponent = await driver.findComponent(ON.type('NavBarContent'))
      expect(aimComponent)
    })

    it('NavigationTest_002', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例2（使用路由栈方法）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPathByName'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('NavIndex'))
      expect(aimComponent)
    })

    it('NavigationTest_003', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例3（设置可交互转场动画）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPathByName'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPathByName'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPathByName'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(2000);
    })

    it('NavigationTest_004', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例4（Navigation带参返回）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('StartTest'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pop'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
    })

    it('NavigationTest_005', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例5（设置背景颜色和模糊效果）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('switch color'))
      await aimComponent.click();
      await driver.delayMs(1000);
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('switch blur'))
      await aimComponent.click();
      await driver.delayMs(1000);
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('switch blurOption'))
      await aimComponent.click();
      await driver.delayMs(1000);
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('push page'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('switch color'))
      await aimComponent.click();
      await driver.delayMs(1000);
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('switch blur'))
      await aimComponent.click();
      await driver.delayMs(1000);
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('switch effect'))
      await aimComponent.click();
      await driver.delayMs(1000);
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it('NavigationTest_006', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例6（嵌套场景下获取外层栈）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('Button'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it('NavigationTest_007', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例7（通过onReady获取栈）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it('NavigationTest_008', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例8（NavDestination生命周期时序）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPath'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it('NavigationTest_009', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例9（标题栏布局效果）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      let size = await driver.getDisplaySize()
      let startX = Math.floor(size.x * 0.5)
      let startY = Math.floor(size.y * 0.565)
      let endX = Math.floor(size.x * 0.5)
      let endY = Math.floor(size.y * 0.21186)

      await driver.swipe(startX, startY, endX, endY);
      await driver.delayMs(1000);
      await driver.swipe(endX, endY, startX, startY);
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('BarStyle.STACK'));
      await aimComponent.click();
      await driver.delayMs(1000);

      await driver.swipe(startX, startY, endX, endY);
      await driver.delayMs(1000);
      await driver.swipe(endX, endY, startX, startY);
      await driver.delayMs(1000);
    })

    it('NavigationTest_010', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例10（定义路由栈派生类）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('to Page One'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('to Page One'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('to Page One'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it('NavigationTest_011', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例11（使用Symbol组件）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('跳转'));
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it('NavigationTest_012', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例12（设置自定义标题栏边距）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('apply padding 20vp'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('apply padding 32vp'));
      await aimComponent.click();
      await driver.delayMs(1000);

      let Toggles = await driver.findComponents(ON.type('Toggle'));
      await Toggles[0].click();
      await driver.delayMs(1000);
      await Toggles[1].click();
      await driver.delayMs(1000);
      await Toggles[1].click();
      await driver.delayMs(1000);
      await Toggles[0].click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('pushPage'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('apply padding 20vp'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('apply padding 32vp'));
      await aimComponent.click();
      await driver.delayMs(1000);

      Toggles = await driver.findComponents(ON.type('Toggle'));
      await Toggles[0].click();
      await driver.delayMs(1000);
      await Toggles[1].click();
      await driver.delayMs(1000);
      await Toggles[1].click();
      await driver.delayMs(1000);
      await Toggles[0].click();
      await driver.delayMs(1000);
    })

    it('NavigationTest_013', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例13（自定义转场动画）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('push next page'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('push next page'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);
    })

  })
}