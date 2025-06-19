/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, it, expect, TestType, beforeAll, Size, Level } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON, MouseButton } from '@kit.TestKit';
import { Want } from '@kit.AbilityKit';
import { BusinessError } from '@ohos.base';
const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
const WAIT_UI_READYMS = 1000;

const waitUiReadyMs : number = 1000;
const TestTag = 'UiTest_API16';

async function startAbility(bundleName: string, abilityName: string) {
  await delegator.executeShellCommand(`aa start -b ${bundleName} -a ${abilityName}`);
}

export default function MouseEventTest() {
  describe('MouseEventTest', () => {
    beforeAll(async () => {
      let want: Want = {
        bundleName : bundleName,
        abilityName : 'MouseAbility'
      };
      await delegator.startAbility(want);
    })

    /**
     * @tc.number:MouseEventTest_001
     * @tc.name: testMouseClick1
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest 模拟鼠标左键点击 功能
     */
    it('testMouseClick1', TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let button = await driver.findComponent(ON.id('mouse_test'));
      let point = await button.getBoundsCenter();
      await driver.mouseClick(point, MouseButton.MOUSE_BUTTON_LEFT, 2017) // 在100，100 鼠标左键点击
      let text = await driver.findComponent(ON.id('mouse_test_result'));
      expect(await text.getText() === 'left').assertTrue();
      done();
    })

    /**
     * @tc.number:testMouseDoubleClick1
    * @tc.name: testMouseDoubleClick1
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest 模拟鼠标左键双击 功能 只支持鼠标左键双击事件
     */
    it('testMouseDoubleClick_left', TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let Button = await driver.findComponent(ON.text('Click twice'))
      if (Button == null) {
        let scorll = await driver.findComponent(ON.type('Scroll'))
        Button = await scorll.scrollSearch(ON.text('Click twice'))
      }
      let center = await Button.getBoundsCenter()
      await driver.mouseDoubleClick(center, MouseButton.MOUSE_BUTTON_LEFT, 0, 0);
      let newButton = await driver.findComponent(ON.text('doubleClick'));
      let text = await newButton.getText();
      expect(text === 'doubleClick').assertTrue();
      await newButton.click();
      done();
    })

    /**
     * @tc.number:testMouseLongClick
    * @tc.name: testMouseLongClick
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest 模拟鼠标左键长按 功能, 只支持鼠标左键长按事件
     */
    it('testMouseLongClick', TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let button = await driver.findComponent(ON.id('mouse_test'));
      let point = await button.getBoundsCenter();
      await driver.mouseLongClick(point, MouseButton.MOUSE_BUTTON_LEFT, 0, 0);
      let newButton = await driver.findComponent(ON.text('longClick'));
      let text = await newButton.getText();
      expect(text === 'longClick').assertTrue();
      await newButton.click();
      done();
    })


    /**
     * @tc.name: testMouseClick2
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest 模拟鼠标右键点击 功能
     */
    it('testMouseClick2', TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let button = await driver.findComponent(ON.id('mouse_test'));
      let point = await button.getBoundsCenter();
      await driver.mouseClick(point, MouseButton.MOUSE_BUTTON_RIGHT, 2017) // 在100，100 鼠标右键点击
      let text = await driver.findComponent(ON.id('mouse_test_result'));
      expect(await text.getText() === 'right').assertTrue();
      done();
    })

    /**
     * @tc.name: testMouseClick3
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest 模拟鼠标中间点击 功能
     */
    it('testMouseClick3', TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let button = await driver.findComponent(ON.id('mouse_test'));
      let point = await button.getBoundsCenter();
      await driver.mouseClick(point, MouseButton.MOUSE_BUTTON_MIDDLE, 2017); // 在100，100 鼠标右键点击
      await driver.delayMs(WAIT_UI_READYMS);
      let text = await driver.findComponent(ON.id('mouse_test_result'));
      expect(await text.getText() === 'middle').assertTrue();
      done();
    })

    /**
     * @tc.name: testMouseMoveTo
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest 模拟鼠标滚轮向下滑动功能
     */
    it('testMouseMoveTo', TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let Button = await driver.findComponent(ON.id('hover_bt'));
      let center = await Button.getBoundsCenter();
      await driver.mouseMoveTo(center);
      await driver.delayMs(WAIT_UI_READYMS);
      let newButton = await driver.findComponent(ON.id('hoverText'));
      expect(await newButton.getText() === 'hover').assertTrue();
      done();
    })


    /**
     * @tc.name: testMouseScroll
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest 模拟鼠标滚轮向下滑动功能
     */
    it('testMouseScroll', TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let scroll = await driver.findComponent(ON.id('scroll_test'));
      let center = await scroll.getBoundsCenter();
      await driver.mouseScroll(center,true,30);
      let button1 = await driver.findComponent(ON.id('scroll_item'));
      expect(await button1.getText() !== '0').assertTrue();
      done();
    })

    /**
     * @tc.name: testMouseScroll_with
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest 模拟鼠标滚轮向下滑动与Ctrl + 删除键组合使用。
     */
    it('testMouseScroll_with', TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let scroll = await driver.findComponent(ON.id('scroll_test'));
      let center = await scroll.getBoundsCenter();
      // 10: 滚轮滚动的单元格数, 2072: 左Ctrl键, 2071: 删除键, 20: 滚动速度
      await driver.mouseScroll(center,true,10, 2072, 2071, 20);
      let button1 = await driver.findComponent(ON.id('scroll_item'));
      expect(await button1.getText() !== '0').assertTrue();
      done();
    })

    /**
    * @tc.name: testMouseScroll
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest 模拟移动鼠标光标 坐标点仅支持RK3568
     */
    it('testMouseMoveWithTrack', TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.mouseMoveWithTrack({x:360, y:300}, {x:360, y:600}, 15000);
      expect(true).assertTrue();
      done();
    })

    /**
     * @tc.number:testMouseDragTest
     * @tc.name: testMouseDragTest
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest 模拟移动鼠标光标 坐标点仅支持RK3568
     */
    it('testMouseDragTest', TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create()
      await startAbility(bundleName, 'DemoAbility')
      await driver.delayMs(waitUiReadyMs)
      let button = await driver.findComponent(ON.id('jump'))
      let center = await button.getBoundsCenter();
      await driver.mouseLongClick(center, MouseButton.MOUSE_BUTTON_LEFT, 0, 2072, 3000)
      await driver.delayMs(waitUiReadyMs)
      let text1 = await driver.findComponent(ON.text('one'))
      let text2 = await driver.findComponent(ON.text('two'))
      let point1 = await text1.getBoundsCenter()
      let point2 = await text2.getBoundsCenter()
      await driver.mouseDrag(point1, point2, 600)
      await driver.delayMs(2000)
      let text = await driver.findComponent(ON.text('one').isBefore(ON.text('two')))
      expect(text == null).assertTrue()
      done();
    })

    /*
    * @tc.name: testNewMouseDrag
    * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
    * @tc.desc: 检测uitest 鼠标拖拽操作, 该API从20开始支持使用。
    */
    it('testNewMouseDrag', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
      console.log(TestTag, 'testNewMouseDrag start');
      let driver = Driver.create()
      await startAbility(bundleName, 'DemoAbility')
      await driver.delayMs(waitUiReadyMs)
      let button = await driver.findComponent(ON.id('jump'))
      let center = await button.getBoundsCenter();
      await driver.mouseLongClick(center, MouseButton.MOUSE_BUTTON_LEFT, 0, 2072, 3000)
      console.log(TestTag, 'mouseLongClick successful');
      await driver.delayMs(waitUiReadyMs)
      let text1 = await driver.findComponent(ON.text('one'))
      let text2 = await driver.findComponent(ON.text('two'))
      let point1 = await text1.getBoundsCenter()
      let point2 = await text2.getBoundsCenter()
      await driver.mouseDrag(point1, point2, 600, 3000)
      await driver.delayMs(2000)
      let text = await driver.findComponent(ON.text('one').isBefore(ON.text('two')))
      expect(text == null).assertTrue()
      console.log(TestTag, 'testNewMouseDrag over');
    })

    /*
    * @tc.name: testNewMouseLongClick
    * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
    * @tc.desc: 检测uitest 鼠标长按操作, 该接口从20开始支持使用.
    */
    it('testNewMouseLongClick', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
      console.log(TestTag, 'testNewMouseLongClick start');
      let driver = Driver.create()
      await startAbility(bundleName, 'DemoAbility')
      await driver.delayMs(1000);
      let Button = await driver.findComponent(ON.text('next page'))
      let center = await Button.getBoundsCenter()
      await driver.mouseLongClick(center, MouseButton.MOUSE_BUTTON_LEFT, 0, 0, 3000)
      await driver.delayMs(waitUiReadyMs)
      let newButton = await driver.findComponent(ON.text('longClick'))
      let text = await newButton.getText()
      expect(text == 'longClick').assertTrue()
      console.log(TestTag, 'testNewMouseLongClick over');
    })


    /*
    * @tc.number: uiTest_20025
    * @tc.name: testDragBetween
    * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
    * @tc.desc: 检测uitest拖拽操作, 该接口从20开始支持使用.
    */
    it('testDragBetween', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
      console.log(TestTag, 'testDragBetween start');
      await startAbility(bundleName, 'DemoAbility')
      let driver = Driver.create()
      await driver.delayMs(waitUiReadyMs)
      let button = await driver.findComponent(ON.id('jump'))
      await button.longClick()
      await driver.delayMs(waitUiReadyMs)
      let text1 = await driver.findComponent(ON.text('one'))
      let text2 = await driver.findComponent(ON.text('two'))
      let center1 = await text1.getBoundsCenter()
      let center2 = await text2.getBoundsCenter()
      await driver.dragBetween(center1, center2, 3000, 3000)
      await driver.delayMs(waitUiReadyMs)
      let text = await driver.findComponent(ON.text('one').isBefore(ON.text('two')))
      expect(text == null).assertTrue()
      console.log(TestTag, 'testDragBetween over');
    })
  })
}