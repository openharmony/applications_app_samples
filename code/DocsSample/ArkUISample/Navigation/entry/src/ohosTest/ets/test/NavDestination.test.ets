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
const BUNDLE = 'Navigation_'

/*当前获取到的目标组件对象*/
let aimComponent : Component

export function NavDestinationTest() {
  describe(BUNDLE + 'NavDestinationTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.navigation',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('NavDestination'));
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

    it(BUNDLE + 'NavDestinationTest_001', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例1（标题栏工具栏与可滚动类组件联动）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('push PageTwo'))
      await aimComponent.click();
      await driver.delayMs(1000);

      let size = await driver.getDisplaySize()
      let startX = Math.floor(size.x * 0.5)
      let startY = Math.floor(size.y * 0.6356)
      let endX = Math.floor(size.x * 0.5)
      let endY = Math.floor(size.y * 0.459)
      let startY2 = Math.floor(size.y * 0.883)
      let endY2 = Math.floor(size.y * 0.353)


      await driver.swipe(startX, startY, endX, endY);
      await driver.delayMs(1000);
      await driver.swipe(endX, endY, startX, startY);
      await driver.delayMs(1000);
      await driver.swipe(startX, startY, endX, endY);
      await driver.delayMs(1000);
      await driver.swipe(endX, endY, startX, startY);
      await driver.delayMs(1000);

      await driver.pressBack();

      aimComponent = await driver.findComponent(ON.text('push PageOne'))
      await aimComponent.click();
      await driver.delayMs(1000);

      await driver.swipe(startX, startY, endX, endY);
      await driver.delayMs(1000);
      await driver.swipe(endX, endY, startX, startY);
      await driver.delayMs(1000);
      await driver.swipe(startX, startY, endX, endY);
      await driver.delayMs(1000);
      await driver.swipe(startX, startY2, endX, endY2);
      await driver.delayMs(1000);
    })

    it(BUNDLE + 'NavDestinationTest_002', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例2（设置NavDestination自定义转场）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('push next page'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.text('push next page'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(2000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it(BUNDLE + 'NavDestinationTest_003', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例3（设置指定的NavDestination系统转场）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('fade'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('explode'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('slide right'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('slide bottom'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('BackButton'))
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it(BUNDLE + 'NavDestinationTest_004', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例4（NavDestination配置页面方向和对应状态栏、导航条显隐）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('push LANDSCAPE page'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('push PORTRAIT page'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('push LANDSCAPE page'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('push PORTRAIT page'))
      await aimComponent.click();
      await driver.delayMs(1000);
    })

  })
}