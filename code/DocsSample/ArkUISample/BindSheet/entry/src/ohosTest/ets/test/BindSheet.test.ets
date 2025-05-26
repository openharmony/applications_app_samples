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
const BUNDLE = 'BindSheet_'

/*初始化与UI元素交互的驱动对象*/
const driver = Driver.create();

/*当前获取到的目标组件对象*/
let aimComponent : Component

export function BindSheetTest() {
  describe(BUNDLE + 'BindSheetTest', () => {

    beforeAll(async () => {
      await delegator.startAbility({
        bundleName: 'com.samples.bindSheet',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000);

      aimComponent = await driver.findComponent(ON.text('半模态转场'));
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

    it(BUNDLE + 'BindSheetTest_001', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例1（不同高度的半模态弹窗）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('transition modal 1'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('change height'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('Set Illegal height'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('change height'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('close modal 1'))
      await aimComponent.click();
      await driver.delayMs(1000);

    })

    it(BUNDLE + 'BindSheetTest_002', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例2（设置三个不同高度的档位）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('transition modal 1'))
      await aimComponent.click();
      await driver.delayMs(1000);

      let size = await driver.getDisplaySize()
      let startX = Math.floor(size.x * 0.5)
      let startY = Math.floor(size.y * 0.565)
      let endX = Math.floor(size.x * 0.5)
      let endY = Math.floor(size.y * 0.21186)

      await driver.swipe(startX, startY, endX, endY);
      await driver.delayMs(1000);

      await driver.swipe(endX, endY, startX, Math.floor(size.y * 0.53));
      await driver.delayMs(1000);

      await driver.swipe(endX, endY, startX, Math.floor(size.y * 0.883));
      await driver.delayMs(1000);
    })

    it(BUNDLE + 'BindSheetTest_003', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例3（使用边框宽度和颜色）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('transition modal 1'))
      await aimComponent.click();
      await driver.delayMs(1000);

    })

    it(BUNDLE + 'BindSheetTest_004', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例4（使用关闭回调函数）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('NoRegisterSpringback'))
      await aimComponent.click();
      await driver.delayMs(1000);

      let size = await driver.getDisplaySize()
      let x = Math.floor(size.x * 0.5)
      await driver.swipe(x, Math.floor(size.y * 0.4125), x, Math.floor(size.y * 0.95));
      await driver.delayMs(1000);
    })

    it(BUNDLE + 'BindSheetTest_005', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例5（设置内容区刷新时机）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('BindSheet'))
      await aimComponent.click();
      await driver.delayMs(1000);

      let size = await driver.getDisplaySize()
      let x = Math.floor(size.x * 0.5)

      await driver.swipe(x, Math.floor(size.y * 0.706), x, Math.floor(size.y * 0.353));
      await driver.delayMs(1000);
    })

    it(BUNDLE + 'BindSheetTest_006', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例6（设置压缩模态内容）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('transition modal 1'))
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.type('TextInput'))
      await aimComponent.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
    })

    it(BUNDLE + 'BindSheetTest_007', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例7（镜像场景下如何设置圆角属性）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('transition modal 1'))
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it(BUNDLE + 'BindSheetTest_008', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例8（半模态Side侧边样式）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('半模态弹窗-Side'))
      await aimComponent.click();
      await driver.delayMs(1000);
    })

    it(BUNDLE + 'BindSheetTest_009', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例9（使用bindSheet构建半模态转场效果）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('选择点餐口味和餐具'))
      await aimComponent.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);
    })

    it(BUNDLE + 'BindSheetTest_0010', 0, async () => {
      aimComponent = await driver.findComponent(ON.text('示例10（使用嵌套滚动交互）'));
      await aimComponent.click();
      await driver.delayMs(1000);

      aimComponent = await driver.findComponent(ON.text('Open Sheet'))
      await aimComponent.click();
      await driver.delayMs(1000);

      let size = await driver.getDisplaySize()
      let startX = Math.floor(size.x * 0.5)
      let startY = Math.floor(size.y * 0.353)
      let endX = Math.floor(size.x * 0.5)
      let endY = Math.floor(size.y * 0.106)

      await driver.swipe(startX, Math.floor(size.y * 0.6356), endX, endY);
      await driver.delayMs(1000);

      await driver.swipe(startX, startY, endX, endY);
      await driver.delayMs(1000);

      await driver.swipe(startX, startY, endX, endY);
      await driver.delayMs(1000);

      await driver.swipe(startX, Math.floor(size.y * 0.282), endX, Math.floor(size.y * 0.6356));
      await driver.delayMs(1000);

      await driver.swipe(startX, Math.floor(size.y * 0.53), endX, Math.floor(size.y * 0.8828));
      await driver.delayMs(1000);
    })

  })
}