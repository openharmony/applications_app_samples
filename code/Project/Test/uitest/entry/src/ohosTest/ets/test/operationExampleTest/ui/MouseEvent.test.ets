/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { describe, beforeAll, it, expect, TestType } from '@ohos/hypium'
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, MouseButton, ON} from '@ohos.UiTest'
import Want from '@ohos.app.ability.Want';
import Router from '@system.router';
import router from '@ohos.router';

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
const WAIT_UI_READYMS = 1000;

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
      let button = await driver.findComponent(ON.id('mouse_test'));
      let point = await button.getBoundsCenter();
      await driver.mouseDoubleClick(point, MouseButton.MOUSE_BUTTON_LEFT, 0, 0);
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
     * @tc.number:MouseEventTest_002
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
     * @tc.number:MouseEventTest_003
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
     * @tc.number:MouseEventTest_004
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
     * @tc.number:MouseEventTest_005
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
     * @tc.number:MouseEventTest_005
     * @tc.name: testMouseScroll
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 检测uitest 模拟鼠标滚轮向下滑动功能
     */
    it('testMouseScroll_speed', TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let scroll = await driver.findComponent(ON.id('scroll_test'));
      await scroll.scrollToTop();
      let center = await scroll.getBoundsCenter();
      await driver.mouseScroll(center,true,10, 2072, 2071, 20);
      let button1 = await driver.findComponent(ON.id('scroll_item'));
      expect(await button1.getText() !== '0').assertTrue();
      done();
    })

    /**
     * @tc.number:MouseEventTest_005
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
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let toMouseDragBtn = await driver.findComponent(ON.id('toMouseDrag'));
      await toMouseDragBtn.click();
      let appleBtn = await driver.findComponent(ON.id('apple'));
      let appPoint = await appleBtn.getBoundsCenter();
      await driver.mouseLongClick(appPoint, MouseButton.MOUSE_BUTTON_LEFT);
      await driver.delayMs(WAIT_UI_READYMS);
      await driver.mouseDrag(appPoint, {x: 500, y: 500});
      await driver.delayMs(WAIT_UI_READYMS);
      let appleBtn1 = await driver.findComponent(ON.id('apple'));
      expect(appleBtn1=== null).assertTrue();
      done();
    })


  })
}