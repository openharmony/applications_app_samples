/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
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

import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'

import { Driver, ON, MatchPattern, Component } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import Logger from '../utils/Logger';
import { getStringData } from '../../../main/ets/data/ResourceDataHandle';

const BUNDLE = 'ComponentCollection_';

const DELAY_TIME = 1000;
let driver: Driver = Driver.create();

// 获取AbilityDelegator
let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
// 启动后获取app上下文
let context;
// 启动后获取resourceManager
let manager;

// 通过 resource 验证有没有这个组件 有的话点击一下
async function checkButtonAndClickWithTextByResource(text: Resource) {
  let atom = await manager.getStringValue(text);
  await driver.assertComponentExist(ON.text(atom));
  let button = await driver.findComponent(ON.text(atom));
  await button.click();
  await driver.delayMs(DELAY_TIME);
  Logger.info(BUNDLE + atom);
}
// 通过 ID 滑动 slider
async function drawSliderWithId(text: string){
  let atom = text;
  await driver.assertComponentExist(ON.id(atom));
  let slider_01 = await driver.findComponent(ON.id(atom));
  let rect = await slider_01.getBoundsCenter();
  await driver.drag(rect.x - 100, rect.y, rect.x + 100, rect.y, 800)
}
// 通过text验证有没有这个组件 有的话点击一下
async function checkButtonAndClickWithText(text: string) {
  let atom = text;
  await driver.assertComponentExist(ON.text(atom));
  let button = await driver.findComponent(ON.text(atom));
  await button.click();
  await driver.delayMs(DELAY_TIME);
  Logger.info(BUNDLE + atom);
}

// 通过id验证有没有这个组件 有的话点击一下
async function checkButtonAndClickWithID(text: string) {
  let atom = text;
  await driver.assertComponentExist(ON.id(atom));
  let button = await driver.findComponent(ON.id(atom));
  await button.click();
  await driver.delayMs(DELAY_TIME);
  Logger.info(BUNDLE + atom);
}

// 通过id验证有没有这个组件 有的话点击一下
async function checkButtonAndLongClickWithID(text: string) {
  let atom = text;
  await driver.assertComponentExist(ON.id(atom));
  let button = await driver.findComponent(ON.id(atom));
  await button.longClick();
  await driver.delayMs(DELAY_TIME);
  Logger.info(BUNDLE + atom);
}

// 通过id验证有没有这个组件 有的话拖拽到目标组件
async function checkButtonAndDragToTargetWithID(text: string, target: Component) {
  let atom = text;
  await driver.assertComponentExist(ON.id(atom));
  let button = await driver.findComponent(ON.id(atom));
  await button.dragTo(target);
  await driver.delayMs(DELAY_TIME);
  Logger.info(BUNDLE + atom);
}

// 展开Select并选择
async function clickSelectIDAndSelectText(toggleId: string, selectText: string) {
  { //展开
    let atom = toggleId;
    await checkButtonAndClickWithID(atom);
  }
  { //选择
    let atom = selectText;
    await checkButtonAndClickWithText(atom);
  }
}

// 根据id拿到组件并拖动至目标组件旁
async function checkAndDragById(id: string, targetId: string) {
  await driver.assertComponentExist(ON.id(id));
  let res = await driver.findComponent(ON.id(id));
  await driver.assertComponentExist(ON.id(targetId));
  let targetComponent = await driver.findComponent(ON.id(targetId));
  await res.dragTo(targetComponent);
}

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(function () {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(function () {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(function () {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(function () {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('assertContain', 0, function () {

      Logger.info("Sample_ComponentCollection test start")
      /**
       * 打开应用
       */
      it(BUNDLE + 'StartAbility_001', 0, async function (done) {
        Logger.info(BUNDLE + 'StartAbility_001 begin')
        let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
        try {
          await abilityDelegator.startAbility({
            bundleName: 'ohos.samples.componentcollection',
            abilityName: 'MainAbility'
          })

          context = await abilityDelegatorRegistry.getAppContext();
          manager = context.resourceManager;

          done();
        } catch (exception) {
          Logger.info(BUNDLE, `StartAbility_001 end ${JSON.stringify(exception)}`);
          expect(0).assertEqual(exception.code);
          done();
        }
        Logger.info(BUNDLE + 'StartAbility_001' + ' end');
      })

      /**
       * Divider 分隔器
       */
      it(BUNDLE + 'DividerFunction_001', 0, async function () {
        let testName = 'DividerFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入Divider 分隔器
        let atom = await manager.getStringValue($r('app.string.divider_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          // 自动判断是否展开可以方便单元测试 只有第一次需要展开 再点一次会关上
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.blank_and_divider')));
        }
        await checkButtonAndClickWithText(atom);

        // 移动bar 分割线宽度
        await driver.delayMs(DELAY_TIME);
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(212, 916, 400, 916, 800);
        await driver.delayMs(DELAY_TIME);
        { // 更改颜色
          let keys = ['Green', 'Orange', 'Pink'];
          for (let i = 0; i < keys.length; i++) {
            {
              let atom = 'colorSelect';
              await checkButtonAndClickWithID(atom);
              Logger.info(BUNDLE + testName + atom);
            }
            {
              let atom = keys[i];
              await checkButtonAndClickWithText(atom);
              Logger.info(BUNDLE + testName + atom);
            }
          }
        }
        { // 更改圆角
          let keys = ['Butt', 'Round', 'Square'];
          for (let i = 0; i < keys.length; i++) {
            {
              let atom = 'capSelect';
              await checkButtonAndClickWithID(atom);
              Logger.info(BUNDLE + testName + atom);
            }
            {
              let atom = keys[i];
              await checkButtonAndClickWithText(atom);
              Logger.info(BUNDLE + testName + atom);
            }
          }
        }

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        // 关闭展开
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.blank_and_divider')));

        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * 按钮与选择
       */
      it(BUNDLE + 'ButtonAndSelectFunction_001', 0, async function () {
        let testName = 'ButtonAndSelectFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入Button 按钮
        let atom = await manager.getStringValue($r('app.string.button_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.button_and_selection')));
        }
        await checkButtonAndClickWithText(atom);

        // 依次点击类型按钮
        { // 类型
          let keys = ['Capsule', 'Normal', 'Circle'];
          for (let i = 0; i < keys.length; i++) {
            { // 点击按钮
              let atom = keys[i];
              await checkButtonAndClickWithID(atom);
            }
            { // 验证点击有无响应
              let atom = keys[i] + ' onClickId';
              await driver.assertComponentExist(ON.id(atom));
            }
          }
        }
        { // 状态效果
          let keys = ['Disable', 'Has effect', 'No effect'];
          for (let i = 0; i < keys.length; i++) {
            { // 点击按钮
              let atom = keys[i];
              await checkButtonAndClickWithID(atom);
            }
            { // 验证点击有无响应
              if (i === 0) {
                // 因为是disable 所以点击不应该有响应
                let atom = keys[i] + ' onClickId';
                let button = await driver.findComponents(ON.id(atom));
                expect(button).assertEqual(null);
                continue;
              }
              let atom = keys[i] + ' onClickId';
              await driver.assertComponentExist(ON.id(atom));
            }
          }
        }
        { // 自定义样式
          let keys = ['Rounded button', 'Icon button', 'Custom color'];
          for (let i = 0; i < keys.length; i++) {
            { // 点击按钮
              let atom = keys[i];
              await checkButtonAndClickWithID(atom);
            }
            { // 验证点击有无响应
              let atom = keys[i] + ' onClickId';
              await driver.assertComponentExist(ON.id(atom));
            }
          }
        }

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * DatePicker 时间选择器
       */
      it(BUNDLE + 'DatePickerFunction_001', 0, async function () {
        let testName = 'DatePickerFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入DatePicker 时间选择器
        let atom = await manager.getStringValue($r('app.string.date_picker_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.button_and_selection')));
        }
        await checkButtonAndClickWithText(atom);

        // 滑动一次
        await driver.assertComponentExist(ON.id('datePicker'));
        let datePicker = await driver.findComponent(ON.id('datePicker'));
        let point = await datePicker.getBoundsCenter();
        await driver.swipe(point.x - 20, point.y + 20, point.x - 20, point.y - 20);
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('dateValue'));
        let dateValue = await driver.findComponent(ON.id('dateValue'));
        if (await dateValue.getText() !== '2022-11-30') {
          Logger.info(`Date error,dateValueText：${await dateValue.getText()}`);
          expect().assertFail();
        }
        await driver.delayMs(1000);
        // 使时间计时器上滑6次
        for (let i = 0; i < 6; i++) {
          await driver.swipe(point.x - 20, point.y + 20, point.x - 20, point.y - 20);
          await driver.delayMs(1000);
        }
        if (await dateValue.getText() !== '2023-05-28') {
          Logger.info(`Date error,dateValueText：${await dateValue.getText()}`);
          expect().assertFail();
        }
        await driver.delayMs(1000);
        // 切换农历
        await driver.assertComponentExist(ON.id('Checkbox'));
        let checkbox = await driver.findComponent(ON.id('Checkbox'));
        await driver.delayMs(1000);
        await checkbox.click();
        await driver.delayMs(1000);
        // 验证农历是否切换成功
        await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.april'))));
        await driver.delayMs(1000);
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * Radio 单选按钮
       */
      it(BUNDLE + 'RadioFunction_001', 0, async function () {
        let testName = 'RadioFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入Radio 单选按钮
        let atom = await manager.getStringValue($r('app.string.radio_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.button_and_selection')));
        }
        await checkButtonAndClickWithText(atom);

        { // 不添加热区
          let keys = [await manager.getStringValue($r('app.string.radio_beijing')),
            await manager.getStringValue($r('app.string.radio_shanghai')),
            await manager.getStringValue($r('app.string.radio_shenzhen')),
            await manager.getStringValue($r('app.string.radio_guangzhou'))];
          for (let i = 0; i < keys.length; i++) {
            if (i == 0) {
              continue;
            }
            { // 点击按钮
              let atom = 'city' + i;
              await checkButtonAndClickWithID(atom);
            }
            { // 验证点击有无响应
              let atom = keys[i];
              await driver.assertComponentExist(ON.text(atom));
            }
          }
          for (let i = 0; i < keys.length; i++) {
            if (i == 0) {
              continue;
            }
            { // 点击按钮
              let atom = 'cityHot' + i;
              await checkButtonAndClickWithID(atom);
            }
            { // 验证点击有无响应
              let atom = keys[i];
              await driver.assertComponentExist(ON.text(atom));
            }
          }
        }

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * Select 选择菜单
       */
      it(BUNDLE + 'SelectFunction_001', 0, async function () {
        let testName = 'SelectFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入Select 选择菜单
        let atom = await manager.getStringValue($r('app.string.select_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.button_and_selection')));
        }
        await checkButtonAndClickWithText(atom);

        { // 含图标 group=0
          // 选中项背景 group=1
          // 未选中项背景 group=2
          // 按钮本身文本 group=3
          for (let group = 0; group < 4; group++) {
            var keys = [await manager.getStringValue($r('app.string.select_picture')),
              await manager.getStringValue($r('app.string.select_collection')),
              await manager.getStringValue($r('app.string.select_gesture'))];
            if (group != 0) {
              keys = [await manager.getStringValue($r('app.string.radio_beijing')),
                await manager.getStringValue($r('app.string.radio_shanghai')),
                await manager.getStringValue($r('app.string.radio_shenzhen'))];
            }
            for (let i = 0; i < keys.length; i++) {
              { // 点击展开
                let atom = 'select' + group;
                await checkButtonAndClickWithID(atom);
                Logger.info(BUNDLE + testName + atom);
              }
              { // 选择一个
                let atom = keys[i];
                await checkButtonAndClickWithText(atom);
                Logger.info(BUNDLE + testName + atom);
              }
            }
          }
        }

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * Slider 滑动条
       */
      it(BUNDLE + 'SlideFunction_001', 0, async function () {
        let testName = 'SlideFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入Slider 滑动条
        let atom = await manager.getStringValue($r('app.string.slider_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.button_and_selection')));
        }
        await checkButtonAndClickWithText(atom);

        // 显示当前值
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(195, 273, 354, 273, 800);
        await driver.delayMs(DELAY_TIME);

        // 滑块颜色
        await checkButtonAndClickWithID('test_select1');
        await checkButtonAndClickWithText('Green');
        // 已滑动颜色
        await checkButtonAndClickWithID('test_select2');
        await checkButtonAndClickWithText('Orange');
        // 未滑动颜色
        await checkButtonAndClickWithID('test_select3');
        await checkButtonAndClickWithText('Pink');

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * Toggle 切换按钮
       */
      it(BUNDLE + 'ToggleFunction_001', 0, async function () {
        let testName = 'ToggleFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入Toggle 切换按钮
        let atom = await manager.getStringValue($r('app.string.toggle_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.button_and_selection')));
        }
        await checkButtonAndClickWithText(atom);

        await checkButtonAndClickWithID('test_ToggleSwitch1');
        // 验证点击有无响应
        await driver.assertComponentExist(ON.id('test_ToggleSwitch1'));

        await checkButtonAndClickWithID('test_ToggleSwitch2');
        // 验证点击有无响应
        await driver.assertComponentExist(ON.id('test_ToggleSwitch2'));

        await checkButtonAndClickWithID('test_ToggleCheckbox1');
        //验证点击有无响应
        await driver.assertComponentExist(ON.id('test_ToggleCheckbox1'));

        await checkButtonAndClickWithID('test_ToggleCheckbox2');
        // 验证点击有无响应
        await driver.assertComponentExist(ON.id('test_ToggleCheckbox2'));

        await checkButtonAndClickWithID('test_ToggleCheckbox1');
        // 验证点击有无响应
        await driver.assertComponentExist(ON.id('test_ToggleCheckbox1'));

        await checkButtonAndClickWithID('test_ToggleCheckbox2');
        // 验证点击有无响应
        await driver.assertComponentExist(ON.id('test_ToggleCheckbox2'));

        let backBtn = await driver.findComponent(ON.id('backBtn'));
        // 返回
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * 勾选框
       */
      it(BUNDLE + 'CheckboxFunction_001', 0, async function () {
        let testName = 'CheckboxFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入勾选框
        let atom = await manager.getStringValue($r('app.string.checkbox_checkboxgroup'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.button_and_selection')));
        }
        await checkButtonAndClickWithText(atom);

        // 点击全选
        await checkButtonAndClickWithID('test_selectAll');
        // 更改颜色
        await checkButtonAndClickWithID('test_changeColor3');

        let backBtn = await driver.findComponent(ON.id('backBtn'));
        // 返回
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * TimePicker 时间选择器
       */
      it(BUNDLE + 'CheckboxFunction_001', 0, async function () {
        let testName = 'CheckboxFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        //进入TimePicker 时间选择器
        let atom = await manager.getStringValue($r('app.string.time_picker'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.button_and_selection')));
        }
        await checkButtonAndClickWithText(atom);

        // 点击_useMilitaryTime
        await checkButtonAndClickWithID('test_toggle');

        let backBtn = await driver.findComponent(ON.id('backBtn'));
        // 返回
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })
      /**
       * Counter 计数器
       */
      it(BUNDLE + 'CounterFunction_001', 0, async function () {
        let testName = 'CounterFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入Counter 计数器
        let atom = await manager.getStringValue($r('app.string.counter_name'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.button_and_selection')));
        }
        await checkButtonAndClickWithText(atom);

        await driver.delayMs(DELAY_TIME);

        let backBtn = await driver.findComponent(ON.id('backBtn'));
        // 返回
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * Rating 评分条
       */
      it(BUNDLE + 'RatingFunction_001', 0, async function () {
        let testName = 'RatingFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入Rating 评分条
        let atom = await manager.getStringValue($r('app.string.rating_name'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.button_and_selection')));
        }
        await checkButtonAndClickWithText(atom);

        // 点击评分条 打一半分
        await checkButtonAndClickWithID('test_rating');
        // 点击indicator
        await checkButtonAndClickWithID('test_indicator');

        let backBtn = await driver.findComponent(ON.id('backBtn'));
        // 返回
        await backBtn.click();
        await driver.delayMs(500);
        // 关闭展开
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.button_and_selection')));

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * Scroll 滚动
       */
      it(BUNDLE + 'ScrollFunction_001', 0, async function () {
        let testName = 'ScrollFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        //进入Scroll 滚动
        let atom = await manager.getStringValue($r('app.string.scroll_name'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          //如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.scroll_swiper')));
        }
        await checkButtonAndClickWithText(atom);

        // 左右滑动
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(195, 273, 354, 273, 800);
        await driver.drag(400, 273, 100, 273, 800);
        await driver.delayMs(DELAY_TIME);

        // 上下滑动
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(110, 800, 110, 900, 800);
        await driver.drag(110, 900, 110, 800, 800);
        await driver.delayMs(DELAY_TIME);

        let backBtn = await driver.findComponent(ON.id('backBtn'));
        // 返回
        await backBtn.click();
        await driver.delayMs(500);

        // 关闭展开
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.scroll_swiper')));

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * QRCode 二维码
       */
      it(BUNDLE + 'QRCodeFunction_001', 0, async function () {
        let testName = 'QRCodeFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入QRCode 二维码
        let atom = await manager.getStringValue($r('app.string.qrcode_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.information_presentation_and_dynamic_effects')));
        }
        await checkButtonAndClickWithText(atom);

        // 改变二维码内容
        let input = await driver.findComponent(ON.id('test_qrcode'));
        await input.inputText('test');

        // 展开颜色
        await checkButtonAndClickWithID('test_colorSelect');
        // 改变颜色
        await checkButtonAndClickWithText('Orange');

        let backBtn = await driver.findComponent(ON.id('backBtn'));
        // 返回
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * LoadingProgress
       */
      it(BUNDLE + 'LoadingProgressFunction_001', 0, async function () {
        let testName = 'LoadingProgressFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        //进入LoadingProgress
        let atom = 'LoadingProgress';
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.information_presentation_and_dynamic_effects')));
        }
        await checkButtonAndClickWithText(atom);

        // 选择颜色红色
        await checkButtonAndClickWithID('test_circle1');
        // 选择颜色粉色
        await checkButtonAndClickWithID('test_circle3');

        let backBtn = await driver.findComponent(ON.id('backBtn'));
        // 返回
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * Marquee 跑马灯
       */
      it(BUNDLE + 'MarqueeFunction_001', 0, async function () {
        let testName = 'MarqueeFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入Marquee 跑马灯
        let atom = await manager.getStringValue($r('app.string.marquee_name'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.information_presentation_and_dynamic_effects')));
        }
        await checkButtonAndClickWithText(atom);

        // 点击start
        await checkButtonAndClickWithID('test_marqueeButton');
        // 更改方向
        await checkButtonAndClickWithID('test_toggle');
        // 点击stop
        await checkButtonAndClickWithID('test_marqueeButton');

        let backBtn = await driver.findComponent(ON.id('backBtn'));
        // 返回
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * TextTimer 文字计时器
       */
      it(BUNDLE + 'TextTimerFunction_001', 0, async function () {
        let testName = 'TextTimerFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入TextTimer 文字计时器
        let atom = await manager.getStringValue($r('app.string.text_timer'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.information_presentation_and_dynamic_effects')));
        }
        await checkButtonAndClickWithText(atom);

        // 点击start
        await checkButtonAndClickWithID('test_start');
        // 点击pause
        await checkButtonAndClickWithID('test_pause');
        // 点击reset
        await checkButtonAndClickWithID('test_reset');
        // 点击isCountDown
        await checkButtonAndClickWithID('test_toggle');
        // 点击时间格式mm:ss
        await checkButtonAndClickWithID('test_radio1');
        // 点击时间格式HH:ss
        await checkButtonAndClickWithID('test_radio2');
        // 点击时间格式DD-HH
        await checkButtonAndClickWithID('test_radio3');
        // 切换格式后再次测试计时器
        // 点击start
        await checkButtonAndClickWithID('test_start');
        // 点击pause
        await checkButtonAndClickWithID('test_pause');
        // 点击reset
        await checkButtonAndClickWithID('test_reset');

        let backBtn = await driver.findComponent(ON.id('backBtn'));
        // 返回
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * TextClock 文字时钟
       */
      it(BUNDLE + 'TextClockFunction_001', 0, async function () {
        let testName = 'TextClockFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入TextClock 文字时钟
        let atom = await manager.getStringValue($r('app.string.text_clock'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.information_presentation_and_dynamic_effects')));
        }
        await checkButtonAndClickWithText(atom);

        // 点击时间格式YY:mm
        await checkButtonAndClickWithID('test_radio2');
        // 点击时间格式hh-mm
        await checkButtonAndClickWithID('test_radio3');
        // 点击时间格式HH:mm
        await checkButtonAndClickWithID('test_radio1');
        // 点击stop
        await checkButtonAndClickWithID('test_stop');
        // 点击start
        await checkButtonAndClickWithID('test_start');

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * Progress 进度条
       */
      it(BUNDLE + 'ProgressFunction_001', 0, async function () {
        let testName = 'ProgressFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入Progress 进度条
        let atom = await manager.getStringValue($r('app.string.progress_name'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.information_presentation_and_dynamic_effects')));
        }
        await checkButtonAndClickWithText(atom);

        // 调整进度
        await driver.delayMs(DELAY_TIME);
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(212, 1087, 400, 1087, 800);
        await driver.drag(800, 1087, 100, 1087, 800);
        await driver.delayMs(DELAY_TIME);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * Gauge 仪表盘
       */
      it(BUNDLE + 'GaugeFunction_001', 0, async function () {
        let testName = 'GaugeFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入Gauge 仪表盘
        let atom = await manager.getStringValue($r('app.string.gauge_name'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.information_presentation_and_dynamic_effects')));
        }
        await checkButtonAndClickWithText(atom);

        // 调整Value
        await driver.delayMs(DELAY_TIME);
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(212, 664, 400, 664, 800);
        await driver.drag(800, 664, 100, 664, 800);
        await driver.delayMs(DELAY_TIME);

        // 调整strokeWidth
        await driver.delayMs(DELAY_TIME);
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(212, 739, 400, 739, 800);
        await driver.drag(800, 739, 100, 739, 800);
        await driver.delayMs(DELAY_TIME);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })
      /**
       * DataPanel 数据面板
       */
      it(BUNDLE + 'DataPanelFunction_001', 0, async function () {
        let testName = 'DataPanelFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入DataPanel 数据面板
        let atom = await manager.getStringValue($r('app.string.data_panel'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.information_presentation_and_dynamic_effects')));
        }
        await checkButtonAndClickWithText(atom);

        // 看一下 展示动画
        await driver.delayMs(DELAY_TIME);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        await driver.drag(200,500,200,200,200);

        // 关闭展开
        // await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.information_presentation_and_dynamic_effects')));

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * ScrollTo 动效
       */
      it(BUNDLE + 'ScrollTo_effect_001', 0, async function () {
        let testName = 'ScrollToEffect';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);
        // 进入Scroll To 动效
        let atom = await manager.getStringValue($r('app.string.scroll_To_effect'))

        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.information_presentation_and_dynamic_effects')));
        }
        await driver.delayMs(DELAY_TIME);
        await checkButtonAndClickWithText(atom);

        await driver.delayMs(DELAY_TIME);
        // 点击按钮
        await checkButtonAndClickWithID('scroll_to_effect_scroller');
        await checkButtonAndClickWithID('scroll_to_effect_list');
        await driver.swipe(100, 1000, 100, 400, 5000);
        await driver.delayMs(DELAY_TIME);
        await checkButtonAndClickWithID('scroll_to_effect_grid');
        await checkButtonAndClickWithID('scroll_to_effect_waterflow');

        let backBtn = await driver.findComponent(ON.id('backBtn'));
        if(!backBtn)
        {
          Logger.error('No backbtn found in ' + testName);
        }
        // 返回
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })


      /**
       * Tab 模糊切换
       */
      it(BUNDLE + 'Tab_switch_effect_001', 0, async function () {
        let testName = 'TabToEffect';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入Scroll To 动效
        let atom = await manager.getStringValue($r('app.string.tabs_switch_effect'))

        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.information_presentation_and_dynamic_effects')));
        }
        await driver.delayMs(DELAY_TIME);
        await checkButtonAndClickWithText(atom);

        // 点击按钮
        await checkButtonAndClickWithText('green');
        await checkButtonAndClickWithText('blue');
        await checkButtonAndClickWithText('yellow');
        await checkButtonAndClickWithText('pink');

        let backBtn = await driver.findComponent(ON.id('backBtn'));
        if (!backBtn)
        {
          Logger.error('Cannot find backbtn in this page');
        }
        // 返回
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * ImageFit 切换
       */
      it(BUNDLE + 'ImageFit_effect_001', 0, async function () {
        let testName = 'ImageFitEffect';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入Scroll To 动效
        let atom = await manager.getStringValue($r('app.string.image_fit_Full_effect'))

        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.information_presentation_and_dynamic_effects')));
        }
        await driver.delayMs(DELAY_TIME);
        await checkButtonAndClickWithText(atom);

        // 点击按钮
        await checkButtonAndClickWithText('RadioContain');
        await checkButtonAndClickWithText('RadioCover');
        await checkButtonAndClickWithText('RadioAuto');
        await checkButtonAndClickWithText('RadioFill');
        await checkButtonAndClickWithText('RadioScaleDown');
        await checkButtonAndClickWithText('RadioNone');

        let backBtn = await driver.findComponent(ON.id('backBtn'));
        // 返回
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * Particle 粒子效果
       */
      it(BUNDLE + 'Particle_effect_001', 0, async function () {
        let testName = 'Particle Effect';
        Logger.info(BUNDLE + testName + ' begin');

        // 进入Scroll To 动效
        let atom = await manager.getStringValue($r('app.string.particle_effect'))
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.information_presentation_and_dynamic_effects')));
        }
        await driver.delayMs(DELAY_TIME);
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);

        // 点击按钮
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.particle_spawn')));
        await driver.delayMs(DELAY_TIME);
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.particle_spawn_stop')));

        let backBtn = await driver.findComponent(ON.id('backBtn'));
        // 返回
        await backBtn.click();
        await driver.delayMs(500);

        await driver.swipe(100, 400, 100, 1000, 5000);
        await driver.delayMs(DELAY_TIME);
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.information_presentation_and_dynamic_effects')));
        Logger.info(BUNDLE + testName + ' end');
      })


      /**
       * ImageSpan 行内图像
       */
      it(BUNDLE + 'ImageSpanFunction_001', 0, async function () {
        let testName = 'ImageSpanFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入Span 行内文本
        let atom = await manager.getStringValue($r('app.string.image_span_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.text_and_input')));
        }
        await checkButtonAndClickWithText(atom);

        // 展开跨度对齐方式
        await checkButtonAndClickWithID('alignment');

        // 选择一个center
        let center = await manager.getStringValue($r('app.string.image_span_alignment_center'));
        await checkButtonAndClickWithText(center);

        // 展开图像缩放类型
        await checkButtonAndClickWithID('fit');

        // 选择一个contain
        let contain = await manager.getStringValue($r('app.string.image_fit_contain'));
        await checkButtonAndClickWithText(contain);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * Span 行内文本
       */
      it(BUNDLE + 'SpanFunction_001', 0, async function () {
        let testName = 'SpanFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入Span 行内文本
        let atom = await manager.getStringValue($r('app.string.span_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.text_and_input')));
        }
        await checkButtonAndClickWithText(atom);

        // 字符间距
        await driver.delayMs(DELAY_TIME);
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(212, 606, 400, 606, 800);
        await driver.drag(800, 606, 100, 606, 800);
        await driver.delayMs(DELAY_TIME);

        // 展开装饰线类型
        await checkButtonAndClickWithID('test_itemSelect');

        // 选择一个underline
        await checkButtonAndClickWithText('Underline');

        // 展开装饰线颜色
        await checkButtonAndClickWithID('test_colorSelect');

        // 选择一个Pink
        await checkButtonAndClickWithText('Pink');

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * TextInput 文本输入
       */
      it(BUNDLE + 'TextInputFunction_001', 0, async function () {
        let testName = 'TextInputFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入TextInput 文本输入
        let atom = await manager.getStringValue($r('app.string.text_input_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.text_and_input')));
        }
        await checkButtonAndClickWithText(atom);

        // 输入文本
        let input = await driver.findComponent(ON.id('test_input'));
        await input.inputText('test');

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * Text 文本
       */
      it(BUNDLE + 'TextFunction_001', 0, async function () {
        let testName = 'TextFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入Text 文本
        let atom = await manager.getStringValue($r('app.string.text_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.text_and_input')));
        }
        await checkButtonAndClickWithText(atom);

        // 字符间距
        await driver.delayMs(DELAY_TIME);
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(212, 463, 400, 463, 800);
        await driver.drag(800, 463, 100, 463, 800);
        await driver.delayMs(DELAY_TIME);

        // 行高
        await driver.delayMs(DELAY_TIME);
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(212, 523, 400, 523, 800);
        await driver.drag(800, 523, 100, 523, 800);
        await driver.delayMs(DELAY_TIME);

        // 选择对齐类型 居中
        await clickSelectIDAndSelectText('select1', await manager.getStringValue($r('app.string.text_text_align_center')));
        // 选择超长文本显示方式 省略
        await clickSelectIDAndSelectText('select2', await manager.getStringValue($r('app.string.text_text_over_flow_ellipsis')));
        // 选择装饰线 下划线
        await clickSelectIDAndSelectText('select3', await manager.getStringValue($r('app.string.text_decoration_type_under_line')));
        // 选择字体颜色 Pink
        await clickSelectIDAndSelectText('select4', 'Pink');
        // 选择大小写 大写
        await clickSelectIDAndSelectText('select5', await manager.getStringValue($r('app.string.text_text_case_uppercase')));

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * RichText 富文本
       */
      it(BUNDLE + 'RichTextFunction_001', 0, async function () {
        let testName = 'RichTextFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入RichText 富文本
        let atom = await manager.getStringValue($r('app.string.rich_text'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.text_and_input')));
        }
        await checkButtonAndClickWithText(atom);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        // 关闭展开
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.text_and_input')));

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * Badge 标记
       */
      it(BUNDLE + 'BadgeFunction_001', 0, async function () {
        let testName = 'BadgeFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入Badge 标记
        let atom = await manager.getStringValue($r('app.string.auxiliary_badge'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.auxiliary')));
        }
        await checkButtonAndClickWithText(atom);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * ScrollBar 滚动条
       */
      it(BUNDLE + 'ScrollBarFunction_001', 0, async function () {
        let testName = 'ScrollBarFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入ScrollBar 滚动条
        let atom = await manager.getStringValue($r('app.string.scroll_bar'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.auxiliary')));
        }
        await checkButtonAndClickWithText(atom);

        // 纵向滚动
        await driver.delayMs(DELAY_TIME);
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(212, 200, 212, 463, 800);
        await driver.drag(212, 463, 212, 200, 800);
        await driver.delayMs(DELAY_TIME);

        // 横向滚动
        await driver.delayMs(DELAY_TIME);
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(112, 900, 412, 900, 800);
        await driver.drag(412, 900, 112, 900, 800);
        await driver.delayMs(DELAY_TIME);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * 下拉刷新
       */
      it(BUNDLE + 'RefreshFunction_001', 0, async function () {
        let testName = 'RefreshFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入下拉刷新
        let atom = await manager.getStringValue($r('app.string.auxiliary_refresh'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.auxiliary')));
        }
        await checkButtonAndClickWithText(atom);

        // 下拉刷新
        await driver.delayMs(DELAY_TIME);
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(212, 200, 212, 663, 800);
        await driver.delayMs(DELAY_TIME);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * Panel 弹出面板
       */
      it(BUNDLE + 'PanelFunction_001', 0, async function () {
        let testName = 'PanelFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入Panel 弹出面板
        let atom = await manager.getStringValue($r('app.string.auxiliary_panel'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.auxiliary')));
        }
        await checkButtonAndClickWithText(atom);

        // 打开minibar
        await checkButtonAndClickWithID('test_miniBarButton');
        // 选择Banana
        await checkButtonAndClickWithID('test_miniBarRadio1');
        // 关闭minibar
        await checkButtonAndClickWithID('test_miniBarButton');

        // 打开foldable
        await checkButtonAndClickWithID('test_foldableButton');
        // 选择Banana
        await checkButtonAndClickWithID('test_foldableRadio1');
        // 关闭minibar
        await checkButtonAndClickWithID('test_foldableButton');

        // 打开temporary
        await checkButtonAndClickWithID('test_temporaryButton');
        // 选择Banana
        await checkButtonAndClickWithID('test_temporaryRadio1');
        // 关闭minibar
        await checkButtonAndClickWithID('test_temporaryButton');

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * AlphabetIndexer 字母索引条
       */
      it(BUNDLE + 'AlphabetIndexerFunction_001', 0, async function () {
        let testName = 'AlphabetIndexerFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 进入AlphabetIndexer 字母索引条
        let atom = await manager.getStringValue($r('app.string.auxiliary_alphabetIndexer'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.auxiliary')));
        }
        await checkButtonAndClickWithText(atom);

        // 点击alphabet
        await checkButtonAndClickWithID('test_alphabet');

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.auxiliary')));
        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * Swiper 翻页
       */
      it(BUNDLE + 'SwiperFunction_001', 0, async function () {
        let testName = 'SwiperFunction';
        Logger.info(BUNDLE + testName + ' begin ------------------------------');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.swiper_name'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.scroll_swiper')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);

        await checkButtonAndClickWithTextByResource($r('app.string.swiper_controller_next'));
        await checkButtonAndClickWithTextByResource($r('app.string.swiper_controller_previous'));
        await checkButtonAndClickWithID(`swiper_001`);
        await checkButtonAndClickWithID(`swiper_002`);
        await checkButtonAndClickWithTextByResource($r('app.string.swiper_controller_next'));
        await checkButtonAndClickWithID(`swiper_003`);
        await checkButtonAndClickWithID(`swiper_004`);
        await drawSliderWithId(`swiper_005`);
        await checkButtonAndClickWithID(`swiper_006`);
        await checkButtonAndClickWithText(`1000`)
        await checkButtonAndClickWithID(`swiper_007`);
        await checkButtonAndClickWithText(`2000`)

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.scroll_swiper')));

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * Row
       */
      it(BUNDLE + ' RowFunction_001', 0, async function () {
        let testName = 'RowFunction';
        Logger.info(BUNDLE + testName + ' begin ------------------------------');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.row_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.rows_and_columns')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);

        await drawSliderWithId(`row_001`);
        await checkButtonAndClickWithID(`row_002`);
        await checkButtonAndClickWithText(`Bottom`);
        await checkButtonAndClickWithID(`row_003`);
        await checkButtonAndClickWithText(`SpaceEvenly`);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * RowSplit
       */
      it(BUNDLE + 'RowSplitFunction_001', 0, async function () {
        let testName = 'RowSplitFunction';
        Logger.info(BUNDLE + testName + ' begin ------------------------------');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.rowsplit_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.rows_and_columns')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);
        await checkButtonAndClickWithID(`rowsplit_001`)
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        await driver.drag(200,500,200,200,200);
        Logger.info(BUNDLE + testName + ' end');
      })
      /**
       * Column
       */
      it(BUNDLE + 'ColumnFunction_001', 0, async function () {
        let testName = 'ColumnFunction';
        Logger.info(BUNDLE + testName + ' begin ------------------------------');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.column_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.rows_and_columns')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);

        await drawSliderWithId(`column_001`);
        await checkButtonAndClickWithID(`column_002`);
        await checkButtonAndClickWithText(`End`);
        await checkButtonAndClickWithID(`column_003`);
        await checkButtonAndClickWithText(`Start`);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * ColumnSplit
       */
      it(BUNDLE + 'ColumnSplitFunction_001', 0, async function () {
        let testName = 'ColumnSplitFunction';
        Logger.info(BUNDLE + testName + ' begin ------------------------------');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.columnsplit_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.rows_and_columns')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);
        await checkButtonAndClickWithID(`columnsplit_001`);
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        await driver.drag(200,500,200,200,800);
        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * SideBarContainer
       */
      it(BUNDLE + 'SideBarContainerFunction_001', 0, async function () {
        let testName = 'SideBarContainerFunction';
        Logger.info(BUNDLE + testName + ' begin ------------------------------');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.sidebarcontainer_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.rows_and_columns')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);
        await checkButtonAndClickWithID(`sidebarContainer_001`);
        await checkButtonAndClickWithText(`Embed`)
        await checkButtonAndClickWithID(`sidebarContainer_002`)
        await drawSliderWithId(`sidebarContainer_003`)
        await drawSliderWithId(`sidebarContainer_004`)
        await checkButtonAndClickWithID(`sidebarContainer_005`)
        await checkButtonAndClickWithID(`sidebarContainer_006`);
        await checkButtonAndClickWithText(`End`)
        await driver.drag(200,700,200,100,800);
        await drawSliderWithId(`sidebarContainer_007`)
        await drawSliderWithId(`sidebarContainer_008`)
        await checkButtonAndClickWithID(`sidebarContainer_009`)

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        // 关闭 行列与分栏 二级菜单
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.rows_and_columns')));
        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * Stack
       */
      it(BUNDLE + 'StackFunction_001', 0, async function () {
        let testName = 'StackFunction';
        Logger.info(BUNDLE + testName + ' begin ------------------------------');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.stack_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.stack_flex_and_grid')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);
        await checkButtonAndClickWithID(`stack_001`);
        await checkButtonAndClickWithText(`Bottom`)
        await checkButtonAndClickWithID(`stack_002`);
        await checkButtonAndClickWithText(`4`)

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * Flex
       */
      it(BUNDLE + 'FlexFunction_001', 0, async function () {
        let testName = 'FlexFunction';
        Logger.info(BUNDLE + testName + ' begin ------------------------------');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.flex_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.stack_flex_and_grid')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);

        await checkButtonAndClickWithID(`flex_001`);
        await checkButtonAndClickWithText(`Row`);
        await checkButtonAndClickWithID(`flex_002`);
        await checkButtonAndClickWithText(`Wrap`);
        await checkButtonAndClickWithID(`flex_003`);
        await checkButtonAndClickWithText(`SpaceEvenly`);
        await driver.drag(200,700,200,100,800);
        await checkButtonAndClickWithID(`flex_004`);
        await checkButtonAndClickWithText(`Stretch`);
        await checkButtonAndClickWithID(`flex_005`);
        await checkButtonAndClickWithText(`SpaceAround`);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * GridContainer
       */
      it(BUNDLE + 'GridContainerFunction_001', 0, async function () {
        let testName = 'GridContainerFunction';
        Logger.info(BUNDLE + testName + ' begin ------------------------------');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.gridcontainer_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.stack_flex_and_grid')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);

        await checkButtonAndClickWithID(`gridcontainer_001`);
        await checkButtonAndClickWithText(`LG`);
        await drawSliderWithId(`gridcontainer_002`);
        await drawSliderWithId(`gridcontainer_003`);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.stack_flex_and_grid')));
        Logger.info(BUNDLE + testName + ' end');
      })


      /**
       * List
       */
      it(BUNDLE + 'ListFunction_001', 0, async function () {
        let testName = 'ListFunction';
        Logger.info(BUNDLE + testName + ' begin ------------------------------');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.list_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.list_and_grid')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);

        await drawSliderWithId(`list_001`);
        await checkButtonAndClickWithID(`list_002`);
        await checkButtonAndClickWithText(`5`);
        await checkButtonAndClickWithID(`list_003`);
        await checkButtonAndClickWithText(`Horizontal`);
        await drawSliderWithId(`list_004`);
        await checkButtonAndClickWithID(`list_005`);
        await checkButtonAndClickWithText(`Pink`);
        await driver.drag(200,700,200,100,800);
        await checkButtonAndClickWithID(`list_006`);
        await checkButtonAndClickWithText(`On`);
        await checkButtonAndClickWithID(`list_007`);
        await checkButtonAndClickWithText(`Spring`);
        await checkButtonAndClickWithID(`list_008`);
        await checkButtonAndClickWithID(`list_009`);
        await checkButtonAndClickWithID(`list_010`);
        await checkButtonAndClickWithText(`4`);
        await checkButtonAndClickWithID(`list_011`);
        await checkButtonAndClickWithText(`Start`);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })



      /**
       * ListItem
       */
      it(BUNDLE + 'ListItemFunction_001', 0, async function () {
        let testName = 'ListItemFunction';
        Logger.info(BUNDLE + testName + ' begin ------------------------------');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.list_item_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.list_and_grid')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);

        await checkButtonAndClickWithID(`listitem_001`);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * Grid
       */
      it(BUNDLE + 'GridFunction_001', 0, async function () {
        let testName = 'GridFunction';
        Logger.info(BUNDLE + testName + ' begin ------------------------------');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.grid_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.list_and_grid')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);

        await checkButtonAndClickWithID(`grid_001`);
        await checkButtonAndClickWithText(`3`);
        await checkButtonAndClickWithID(`grid_002`);
        await checkButtonAndClickWithText(`3`);
        await drawSliderWithId(`grid_003`)
        await drawSliderWithId(`grid_004`)

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        await driver.drag(200,500,200,200,800);
        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * GridItem
       */
      it(BUNDLE + 'GridItemFunction_001', 0, async function () {
        let testName = 'GridItemFunction';
        Logger.info(BUNDLE + testName + ' begin ------------------------------');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.grid_item_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.list_and_grid')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);

        await checkButtonAndClickWithID(`griditem_001`);
        await checkButtonAndClickWithText(`1`);
        await checkButtonAndClickWithID(`griditem_002`);
        await checkButtonAndClickWithText(`2`);
        await checkButtonAndClickWithID(`griditem_003`);
        await checkButtonAndClickWithText(`3`);
        await checkButtonAndClickWithID(`griditem_004`);
        await checkButtonAndClickWithText(`4`);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.list_and_grid')));
        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * Navigation
       */
      it(BUNDLE + 'NavigationFunction_001', 0, async function () {
        let testName = 'NavigationFunction';
        Logger.info(BUNDLE + testName + ' begin ------------------------------');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.navigation_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.navigation')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * Tabs
       */
      it(BUNDLE + 'TabsFunction_001', 0, async function () {
        let testName = 'TabsFunction';
        Logger.info(BUNDLE + testName + ' begin ------------------------------');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.tabs_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.navigation')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);

        await checkButtonAndClickWithID(`tab_001`)
        await checkButtonAndClickWithText(`End`)
        await checkButtonAndClickWithID(`tab_002`)
        await checkButtonAndClickWithText(`2`)
        await checkButtonAndClickWithID(`tab_003`)
        await checkButtonAndClickWithID(`tab_004`)
        await checkButtonAndClickWithID(`tab_005`)
        await checkButtonAndClickWithText(`Scrollable`)
        await checkButtonAndClickWithID(`tab_006`)
        await checkButtonAndClickWithText(`2000`)



        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * TabContent
       */
      it(BUNDLE + 'TabContentFunction_001', 0, async function () {
        let testName = 'TabContentFunction';
        Logger.info(BUNDLE + testName + ' begin ------------------------------');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.tab_content_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.navigation')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);

        await checkButtonAndClickWithID(`tabcontent_001`)
        await checkButtonAndClickWithID(`tabcontent_002`)

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * StepperItem
       */
      it(BUNDLE + 'StepperFunction_001', 0, async function () {
        let testName = 'StepperFunction';
        Logger.info(BUNDLE + testName + ' begin ------------------------------');
        await driver.delayMs(DELAY_TIME);
        let list = await driver.findComponent(ON.id('list_001'));
        let on = ON.text(await manager.getStringValue($r('app.string.navigation')));
        await list.scrollSearch(on);
        let atom = await manager.getStringValue($r('app.string.stepper_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.navigation')));
          if (!await driver.findComponent(ON.text(atom))) {
            await driver.drag(200,400,200,100,800);
          }
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);

        await checkButtonAndClickWithText(`Next`);
        // await checkButtonAndClickWithText(`Next`);
        // await checkButtonAndClickWithText(`下一步`);
        // await checkButtonAndClickWithText(`开始`);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        await driver.drag(200,100,200,500,800);
        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       *TextArea 多行文本输入框
       */
      it(BUNDLE + 'TextareaFunction_001', 0 ,async function(){
        let testName = 'TextareaFunction';
        Logger.info(BUNDLE + testName + ' begin');
        await driver.delayMs(DELAY_TIME);
        let list = await driver.findComponent(ON.id('list_001'));
        let on = ON.text(await manager.getStringValue($r('app.string.text_and_input')));
        await list.scrollSearch(on);
        let atom = await manager.getStringValue($r('app.string.textarea_title'));
        let button = await driver.findComponent(ON.text(atom));
        await driver.delayMs(DELAY_TIME);
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.text_and_input')));
          if (!await driver.findComponent(ON.text(atom))) {
            await driver.drag(200,200,200,100,800);
          }
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);
        // 输入文本
        let input = await driver.findComponent(ON.id('textarea_001'));
        await input.inputText('test');
        await checkButtonAndClickWithID('textarea_select_001');
        await checkButtonAndClickWithText('End')
        await checkButtonAndClickWithID('textarea_select_002');
        await checkButtonAndClickWithText('In App')
        await checkButtonAndClickWithID('textarea_color_001');
        await checkButtonAndClickWithText('Pink')
        await checkButtonAndClickWithID('textarea_color_002');
        await checkButtonAndClickWithText('Blue')
        await driver.delayMs(DELAY_TIME);
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })
      /**
       *PatternLock 图案密码锁
       */
      it(BUNDLE + 'PatternLockFunction_001', 0 ,async function(){
        let testName = 'PatternLockFunction';
        Logger.info(BUNDLE + testName + ' begin');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.patternLock_title'));
        let button = await driver.findComponent(ON.text(atom));
        await driver.delayMs(DELAY_TIME);
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.text_and_input')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);
        await drawSliderWithId('patternLock_slider_001')
        await drawSliderWithId('patternLock_slider_002')
        await drawSliderWithId('patternLock_slider_003')
        await checkButtonAndClickWithID('patternLock_color_001');
        await checkButtonAndClickWithText('Pink')
        await checkButtonAndClickWithID('patternLock_color_002');
        await checkButtonAndClickWithText('Blue')
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })
      /**
       *Search 搜索框
       */
      it(BUNDLE + 'SearchFunction_001', 0 ,async function(){
        let testName = 'SearchFunction';
        Logger.info(BUNDLE + testName + ' begin');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.search_title'));
        let button = await driver.findComponent(ON.text(atom));
        await driver.delayMs(DELAY_TIME);
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.text_and_input')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);
        let input = await driver.findComponent(ON.id('search_001'));
        await input.inputText('test');
        await checkButtonAndClickWithID('search_select_001');
        await checkButtonAndClickWithText('End')
        await checkButtonAndClickWithID('search_select_002');
        await checkButtonAndClickWithText('In App')
        await checkButtonAndClickWithID('search_color_001');
        await checkButtonAndClickWithText('Pink')
        await driver.delayMs(DELAY_TIME);
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })
      /**
       *Image 图片
       */
      it(BUNDLE + 'ImageFunction_001', 0 ,async function(){
        let testName = 'ImageFunction';
        Logger.info(BUNDLE + testName + ' begin');
        await driver.delayMs(DELAY_TIME);
        let list = await driver.findComponent(ON.id('list_001'));
        let on = ON.text(await manager.getStringValue($r('app.string.image_video_and_media')));
        let scroll = await list.scrollSearch(on);
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.image_title'));
        let button = await driver.findComponent(ON.text(atom));
        await driver.delayMs(DELAY_TIME);
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.image_video_and_media')));
          if (!await driver.findComponent(ON.text(atom))) {
            await driver.drag(200,200,200,100,800);
          }
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);
        await checkButtonAndClickWithID('image_001')
        await checkButtonAndClickWithText('ScaleDown')
        await drawSliderWithId('image_slider_001')
        await drawSliderWithId('image_slider_002')
        await checkButtonAndClickWithID('image_select_002')
        await checkButtonAndClickWithText('Template')
        await checkButtonAndClickWithID('image_select_003')
        await checkButtonAndClickWithText('XY')
        await driver.drag(200,200,200,100,800);
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        await driver.drag(200, 500, 200, 200, 800)
        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       *ImageAnimator 逐帧播放图片
       */
      it(BUNDLE + 'ImageAnimatorFunction_001', 0 ,async function(){
        let testName = 'ImageAnimatorFunction';
        Logger.info(BUNDLE + testName + ' begin');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.image_animator_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.image_video_and_media')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);
        await checkButtonAndClickWithID('start')
        await checkButtonAndClickWithID('pause')
        await checkButtonAndClickWithID('end')
        await checkButtonAndClickWithID('reserve')
        await checkButtonAndClickWithID('single')
        await checkButtonAndClickWithID('circulate')
        await driver.delayMs(DELAY_TIME);
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        await driver.drag(200, 500, 200, 200, 800)
        Logger.info(BUNDLE + testName + ' end');
      })
      /**
       *Video 视频
       */
      it(BUNDLE + 'VideoFunction_001', 0 ,async function(){
        let testName = 'VideoFunction';
        Logger.info(BUNDLE + testName + ' begin');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.video_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.image_video_and_media')));
          await driver.drag(200, 500, 200, 200, 800)
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);
        await checkButtonAndClickWithID('video_switch_001')
        await checkButtonAndClickWithID('video_switch_002')
        await checkButtonAndClickWithID('video_switch_003')
        await driver.drag(200, 500, 200, 200, 800)
        await checkButtonAndClickWithID('video_switch_004')
        await checkButtonAndClickWithID('video_select_001')
        await checkButtonAndClickWithText('Auto')
        await checkButtonAndClickWithID('video_select_002')
        await checkButtonAndClickWithText('1.25X')
        await driver.delayMs(DELAY_TIME);
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })
      /**
       *XComponent 画布
       */
      it(BUNDLE + 'XComponentFunction_001', 0 ,async function(){
        let testName = 'XComponentFunction';
        Logger.info(BUNDLE + testName + ' begin');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.xcomponent_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.image_video_and_media')));
        }
        await checkButtonAndClickWithText(atom);
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })
      /**
       *PluginComponent 嵌入式显示
       */
      it(BUNDLE + 'PluginComponent_001', 0 ,async function(){
        let testName = 'PluginComponentFunction';
        Logger.info(BUNDLE + testName + ' begin');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.plugin_component_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.image_video_and_media')));
        }
        await checkButtonAndClickWithText(atom);
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })
      /**
       * ImageSpan 行内图像
       */
      it(BUNDLE + 'CanvasFunction_001', 0, async function () {
        let testName = 'CanvasFunction';
        Logger.info(BUNDLE + testName + ' begin');
        await driver.delayMs(DELAY_TIME);
        await driver.drag(200, 500, 200, 200, 800)
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.canvas_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.canvas_and_graphic_drawing')));
        }
        await checkButtonAndClickWithText(atom);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })
      /*
       * CircleDialog 圆形
      */
      it(BUNDLE + 'CircleFunction_001', 0, async function () {
        let testName = 'CircleFunction';
        Logger.info(BUNDLE + testName + ' begin');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.circle_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.canvas_and_graphic_drawing')));
        }
        await checkButtonAndClickWithText(atom);
        // 展开装饰线颜色
        await checkButtonAndClickWithID('circle_color_001');
        // 选择一个Pink
        await checkButtonAndClickWithText('Pink');
        await checkButtonAndClickWithID('circle_color_002');
        await checkButtonAndClickWithText('Blue');
        await driver.delayMs(DELAY_TIME);
        await drawSliderWithId('circle_slider_001')
        await drawSliderWithId('circle_slider_002')
        await drawSliderWithId('circle_slider_003')
        await drawSliderWithId('circle_slider_004')
        await drawSliderWithId('circle_slider_005')
        await driver.delayMs(DELAY_TIME);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })
      /**
       *line 直线
       */
      it(BUNDLE + 'LineFunction_001', 0 ,async function(){
        let testName = 'LineFunction';
        Logger.info(BUNDLE + testName + ' begin');
        let atom = await manager.getStringValue($r('app.string.line_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.canvas_and_graphic_drawing')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);
        // 展开装饰线颜色
        await checkButtonAndClickWithID('line_color_001');
        // 选择一个Pink
        await checkButtonAndClickWithText('Pink')
        await driver.delayMs(DELAY_TIME);
        await drawSliderWithId('line_slider_001')
        await drawSliderWithId('line_slider_002')
        await drawSliderWithId('line_slider_003')
        await drawSliderWithId('line_slider_004')
        await drawSliderWithId('line_slider_005')
        await drawSliderWithId('line_slider_006')
        await drawSliderWithId('line_slider_006')
        await driver.delayMs(DELAY_TIME);


        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        await driver.drag(200, 500, 200, 200, 800)
        Logger.info(BUNDLE + testName + ' end');
      })
      /**
       *Path 路径
       */
      it(BUNDLE + 'PathFunction_001', 0 ,async function(){
        let testName = 'PathFunction';
        Logger.info(BUNDLE + testName + ' begin');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.path_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.canvas_and_graphic_drawing')));
        }
        await checkButtonAndClickWithText(atom);

        await driver.delayMs(DELAY_TIME);
        await checkButtonAndClickWithID('path_select_001')
        await checkButtonAndClickWithText('M0 150 C0 100 140 0 200 150 L100 300 Z')
        // 展开装饰线颜色
        await checkButtonAndClickWithID('path_color_001');
        // 选择一个Pink
        await checkButtonAndClickWithText('Pink')
        await checkButtonAndClickWithID('path_color_002');
        await checkButtonAndClickWithText('Blue')
        await driver.delayMs(DELAY_TIME);
        await drawSliderWithId('path_slider_001')
        await drawSliderWithId('path_slider_002')
        await drawSliderWithId('path_slider_003')
        await drawSliderWithId('path_slider_004')
        await driver.delayMs(DELAY_TIME);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })
      /**
       *ellipse 椭圆
       */
      it(BUNDLE + 'EllipseFunction_001', 0 ,async function(){
        let testName = 'EllipseFunction';
        Logger.info(BUNDLE + testName + ' begin');
        let atom = await manager.getStringValue($r('app.string.ellipse_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.canvas_and_graphic_drawing')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);
        // 展开装饰线颜色
        await checkButtonAndClickWithID('ellipse_color_001');
        // 选择一个Pink
        await checkButtonAndClickWithText('Pink')
        // 展开装饰线颜色
        await checkButtonAndClickWithID('ellipse_color_002');
        // 选择一个Pink
        await checkButtonAndClickWithText('Blue');
        await driver.delayMs(DELAY_TIME);
        await drawSliderWithId('ellipse_slider_001')
        await drawSliderWithId('ellipse_slider_002')
        await drawSliderWithId('ellipse_slider_003')
        await drawSliderWithId('ellipse_slider_004')
        await drawSliderWithId('ellipse_slider_005')
        await drawSliderWithId('ellipse_slider_006')
        await driver.delayMs(DELAY_TIME);


        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })
      /**
       *polygon 多边形
       */
      it(BUNDLE + 'PolygonFunction_001', 0 ,async function(){
        let testName = 'PolygonFunction';
        Logger.info(BUNDLE + testName + ' begin');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.polygon_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.canvas_and_graphic_drawing')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);
        await checkButtonAndClickWithID('polygon_color_001');
        // 选择一个Pink
        await checkButtonAndClickWithText('Pink')
        await checkButtonAndClickWithID('polygon_color_002');
        await checkButtonAndClickWithText('Blue')
        await driver.delayMs(DELAY_TIME);
        await drawSliderWithId('polygon_slider_001')
        await drawSliderWithId('polygon_slider_002')
        await drawSliderWithId('polygon_slider_003')
        await drawSliderWithId('polygon_slider_004')
        await driver.delayMs(DELAY_TIME);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })
      /**
       *polyline 折线
       */
      it(BUNDLE + 'PloylineFunction_001', 0 ,async function(){
        let testName = 'PloylineFunction';
        Logger.info(BUNDLE + testName + ' begin');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.polyline_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.canvas_and_graphic_drawing')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);
        await checkButtonAndClickWithID('polyline_color_001');
        // 选择一个Pink
        await checkButtonAndClickWithText('Pink')
        await driver.delayMs(DELAY_TIME);
        await drawSliderWithId('polyline_slider_001')
        await drawSliderWithId('polyline_slider_002')
        await drawSliderWithId('polyline_slider_003')
        await drawSliderWithId('polyline_slider_004')
        await drawSliderWithId('polyline_slider_005')
        await drawSliderWithId('polyline_slider_006')
        await drawSliderWithId('polyline_slider_007')
        await drawSliderWithId('polyline_slider_008')
        await drawSliderWithId('polyline_slider_009')
        await driver.delayMs(DELAY_TIME);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })
      /**
       *rect 矩形
       */
      it(BUNDLE + 'RectFunction_001', 0 ,async function(){
        let testName = 'RectFunction';
        Logger.info(BUNDLE + testName + ' begin');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.rect_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.canvas_and_graphic_drawing')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);
        await checkButtonAndClickWithID('rect_color_001');
        // 选择一个Pink
        await checkButtonAndClickWithText('Pink')
        await checkButtonAndClickWithID('rect_color_002');
        await checkButtonAndClickWithText('Blue')
        await driver.delayMs(DELAY_TIME);
        await drawSliderWithId('rect_slider_001')
        await drawSliderWithId('rect_slider_002')
        await drawSliderWithId('rect_slider_003')
        await drawSliderWithId('rect_slider_004')
        await drawSliderWithId('rect_slider_005')
        await drawSliderWithId('rect_slider_006')
        await drawSliderWithId('rect_slider_007')
        await drawSliderWithId('rect_slider_008')
        await driver.delayMs(DELAY_TIME);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })
      /**
       *shape 指定图形
       */
      it(BUNDLE + 'ShapeFunction_001', 0 ,async function(){
        let testName = 'ShapeFunction';
        Logger.info(BUNDLE + testName + ' begin');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.shape_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.canvas_and_graphic_drawing')));
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);
        await checkButtonAndClickWithID('shape_color_001');
        // 选择一个Pink
        await checkButtonAndClickWithText('Pink')
        await checkButtonAndClickWithID('shape_color_002');
        await checkButtonAndClickWithText('Blue')
        await driver.delayMs(DELAY_TIME);
        await drawSliderWithId('shape_slider_001')
        await drawSliderWithId('shape_slider_002')
        await drawSliderWithId('shape_slider_003')
        await drawSliderWithId('shape_slider_004')
        await driver.delayMs(DELAY_TIME);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        await driver.drag(200, 500, 200, 200, 800);
        Logger.info(BUNDLE + testName + ' end');
      })
      /**
       *Web 网页
       */
      it(BUNDLE + 'WebFunction_001', 0 ,async function(){
        let testName = 'VideoFunction';
        Logger.info(BUNDLE + testName + ' begin');
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.web_title'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.web')));
          await driver.drag(200, 500, 200, 200, 800)
        }
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * Canvas_Sample
       */
      it(BUNDLE + 'CanvasFunction_001', 0, async function () {
        let testName = 'CanvasFunction';
        // 进入Canvas画布
        await driver.swipe(100, 1000, 100, 400, 5000);
        await driver.delayMs(DELAY_TIME);
        let atom = await manager.getStringValue($r('app.string.canvas_component_attributes'));
        let button = await driver.findComponent(ON.text(atom));
        if (!button) {
          // 如果没展开 就展开
          // 自动判断是否展开可以方便单元测试 只有第一次需要展开 再点一次会关上
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.canvas_components')));
        }
        await driver.swipe(100, 1000, 100, 400, 5000);
        await driver.delayMs(DELAY_TIME);
        await checkButtonAndClickWithText(atom);
        await driver.delayMs(DELAY_TIME);
        {
          // 属性
          Logger.info("Start Test canvas_component_attributes!", "CanvasFunction_001");
          let keys = ['fillStyle', 'lineWidth', 'strokeStyle', 'lineCap',
            'lineJoin', 'miterLimit', 'font', 'textAlign', 'textBaseline',
            'globalAlpha', 'lineDashOffset', 'globalCompositeOperation',
            'imageSmoothingEnabled', 'clearRect'];
          for (let i = 0; i < keys.length; i++) {
            { // 点击按钮
              if (i === 8) {
                Logger.info("Swipe for bottom button!", "CanvasFunction_001");
                await driver.swipe(300, 900, 300, 700, 2000);
                await driver.delayMs(DELAY_TIME);
              }
              let atom = keys[i];
              await checkButtonAndClickWithText(atom);
            }
            { // 验证点击有无响应
              let atom = keys[i];
              await driver.assertComponentExist(ON.text(atom));
            }
          }
          // 返回
          let backBtn = await driver.findComponent(ON.id('backBtn'));
          await backBtn.click();
          await driver.delayMs(500);
        }
        {
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.canvas_component_method')));
          await driver.delayMs(DELAY_TIME);
          // 方法
          Logger.info("Start Test canvas_component_method!", "CanvasFunction_001");
          let keys = ['fillRect', 'strokeRect', 'fillText', 'strokeText',
            'measureText', 'stroke', 'createPattern', 'fill', 'clip',
            'scale', 'drawImage', 'setLineDash',
            'getLineDash', 'clearRect'];
          for (let i = 0; i < keys.length; i++) {
            { // 点击按钮
              if (i === 8) {
                Logger.info("Swipe for bottom button!", "CanvasFunction_001");
                await driver.swipe(300, 900, 300, 700, 2000);
                await driver.delayMs(DELAY_TIME);
              }
              let atom = keys[i];
              await checkButtonAndClickWithText(atom);
            }
            { // 验证点击有无响应
              let atom = keys[i];
              await driver.assertComponentExist(ON.text(atom));
            }
          }
          // 返回
          let backBtn = await driver.findComponent(ON.id('backBtn'));
          await backBtn.click();
          await driver.delayMs(500);
        }
        {
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.canvas_component_shadow')));
          await driver.delayMs(DELAY_TIME);
          // 阴影
          Logger.info("Start Test canvas_component_shadow!", "CanvasFunction_001");
          let keys = ['shadowBlur', 'shadowColor', 'shadowOffsetX', 'shadowOffsetY', 'clearRect'];
          for (let i = 0; i < keys.length; i++) {
            { // 点击按钮
              let atom = keys[i];
              await checkButtonAndClickWithText(atom);
            }
            { // 验证点击有无响应
              let atom = keys[i];
              await driver.assertComponentExist(ON.text(atom));
            }
          }
          // 返回
          let backBtn = await driver.findComponent(ON.id('backBtn'));
          await backBtn.click();
          await driver.delayMs(500);
        }
        {
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.canvas_component_transform')));
          await driver.delayMs(DELAY_TIME);
          // transform
          Logger.info("Start Test canvas_component_transform!", "CanvasFunction_001");
          let keys = ['translate', 'transform', 'setTransform', 'rotate', 'clearRect'];
          for (let i = 0; i < keys.length; i++) {
            { // 点击按钮
              let atom = keys[i];
              await checkButtonAndClickWithText(atom);
            }
            { // 验证点击有无响应
              let atom = keys[i];
              await driver.assertComponentExist(ON.text(atom));
            }
          }
          // 返回
          let backBtn = await driver.findComponent(ON.id('backBtn'));
          await backBtn.click();
          await driver.delayMs(500);
        }
        {
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.canvas_component_gradient')));
          await driver.delayMs(DELAY_TIME);
          // CanvasGradient
          Logger.info("Start Test canvas_component_gradient!", "CanvasFunction_001");
          let keys = ['addColorStop', 'createLinearGradient', 'createRadialGradient', 'clearRect'];
          for (let i = 0; i < keys.length; i++) {
            { // 点击按钮
              let atom = keys[i];
              await checkButtonAndClickWithText(atom);
            }
            { // 验证点击有无响应
              let atom = keys[i];
              await driver.assertComponentExist(ON.text(atom));
            }
          }
          // 返回
          let backBtn = await driver.findComponent(ON.id('backBtn'));
          await backBtn.click();
          await driver.delayMs(500);
        }
        {
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.canvas_component_path_2d')));
          await driver.delayMs(DELAY_TIME);
          // path_2d
          Logger.info("Start Test canvas_component_path_2d!", "CanvasFunction_001");
          let keys = ['beginPath', 'moveTo', 'lineTo',
            'closePath', 'bezierCurveTo', 'quadraticCurveTo',
            'arc', 'arcTo', 'ellipse', 'rect', 'clearRect'];
          for (let i = 0; i < keys.length; i++) {
            { // 点击按钮
              let atom = keys[i];
              await checkButtonAndClickWithText(atom);
            }
            { // 验证点击有无响应
              let atom = keys[i];
              await driver.assertComponentExist(ON.text(atom));
            }
          }
          // 返回
          let backBtn = await driver.findComponent(ON.id('backBtn'));
          await backBtn.click();
          await driver.delayMs(500);
        }
        {
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.canvas_component_image_bitmap')));
          await driver.delayMs(DELAY_TIME);
          // image_bitmap
          Logger.info("Start Test canvas_component_image_bitmap!", "CanvasFunction_001");
          let keys = ['getImageData', 'putImageData', 'imageSmoothingQuality',
            'toDataURL', 'clearRect'];
          for (let i = 0; i < keys.length; i++) {
            { // 点击按钮
              let atom = keys[i];
              await checkButtonAndClickWithText(atom);
            }
            { // 验证点击有无响应
              let atom = keys[i];
              await driver.assertComponentExist(ON.text(atom));
            }
          }
          // 返回
          let backBtn = await driver.findComponent(ON.id('backBtn'));
          await backBtn.click();
          await driver.delayMs(500);
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.canvas_components')));
          await driver.delayMs(500);
        }
        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * TarBar 进入通用
       */
      it(BUNDLE + 'TarBarGeneralFunction_001', 0, async function () {
        let testName = 'TarBarGeneralFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        let testAtomName = await manager.getStringValue($r('app.string.universal'))
        await driver.assertComponentExist(ON.id('tabBar1'));
        let bar = await driver.findComponent(ON.id('tabBar1'));
        await bar.click();
        await driver.delayMs(DELAY_TIME);
        Logger.info(BUNDLE + testName + testAtomName);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * onClick 点击事件
       */
      it(BUNDLE + 'OnClickFunction_001', 0, async function () {
        let testName = 'OnClickFunction';
        Logger.info(BUNDLE + testName + ' begin');

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.click_event')));
        // 点击区域
        await driver.delayMs(DELAY_TIME);
        await driver.click(200, 300);
        await driver.delayMs(DELAY_TIME);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * 触摸事件
       */
      it(BUNDLE + 'TouchFunction_001', 0, async function () {
        let testName = 'TouchFunction';
        Logger.info(BUNDLE + testName + ' begin');

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.touch_event')));
        // 拖动区域
        await driver.delayMs(DELAY_TIME);
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(100, 300, 300, 280);
        await driver.delayMs(DELAY_TIME);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * 拖拽事件
       */
      it(BUNDLE + 'DragFunction_001', 0, async function () {
        let testName = 'DragFunction';
        Logger.info(BUNDLE + testName + ' begin');

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.drag_drop_event')));
        // 拖拽图标到不可接收区域
        await driver.assertComponentExist(ON.id('rightArea'));
        let rightArea = await driver.findComponent(ON.id('rightArea'));
        await checkButtonAndDragToTargetWithID('icon', rightArea);
        // 拖拽图标到可接收区域
        await driver.assertComponentExist(ON.id('leftArea'));
        let leftArea = await driver.findComponent(ON.id('leftArea'));
        await checkButtonAndDragToTargetWithID('icon', leftArea);
        // 查看不同组件的拖拽效果
        await driver.assertComponentExist(ON.id('column'));
        let column = await driver.findComponent(ON.id('column'));
        await checkButtonAndDragToTargetWithID('gridItem0', column);

        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(660, 600, 660, 0);

        await checkButtonAndDragToTargetWithID('listItem0', column);
        await checkButtonAndDragToTargetWithID('hyperlink', column);
        await checkButtonAndDragToTargetWithID('text', column);
        await checkButtonAndDragToTargetWithID('image', column);

        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(660, 600, 660, 200);

        await checkButtonAndDragToTargetWithID('video', column);
        await checkButtonAndDragToTargetWithID('formComponent', column);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * 组件区域变化事件
       */
      it(BUNDLE + 'AreaChangeFunction_001', 0, async function () {
        let testName = 'AreaChangeFunction';
        Logger.info(BUNDLE + testName + ' begin');

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.component_area_change_event')));
        // 调整区域宽度
        await driver.delayMs(DELAY_TIME);
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(110, 235, 354, 235, 800)
        await driver.delayMs(DELAY_TIME);
        // 调整区域高度
        await driver.delayMs(DELAY_TIME);
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(110, 315, 354, 315, 800)
        await driver.delayMs(DELAY_TIME);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * 挂载卸载事件
       */
      it(BUNDLE + 'MountUnmountEventFunction_001', 0, async function () {
        let testName = 'MountUnmountEventFunction';
        Logger.info(BUNDLE + testName + ' begin');

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.general_mount')));
        // 挂载
        let mount = await driver.findComponent(ON.id('mount'));
        await mount.click();
        await driver.delayMs(500);
        // 卸载
        let unmount = await driver.findComponent(ON.id('unmount'));
        await unmount.click();
        await driver.delayMs(500);
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * 组件可见区域变化事件
       */
      it(BUNDLE + 'ScrollEventFunction_001', 0, async function () {
        let testName = 'ScrollEventFunction';
        Logger.info(BUNDLE + testName + ' begin');
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.scroll_event')));
        await driver.delayMs(DELAY_TIME);
        // 从下往上滑动列表
        await driver.drag(200, 500, 200, 200, 800)
        await driver.delayMs(DELAY_TIME);
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * foreground 前景
       */
      it(BUNDLE + 'ForegroundFunction_001', 0, async function () {
        let testName = 'ForegroundFunction';
        Logger.info(BUNDLE + testName + ' begin');

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.prop_foreground')));

        // 正常显示
        await driver.delayMs(DELAY_TIME);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * background 背景
       */
      it(BUNDLE + 'BackgroundFunction_001', 0, async function () {
        let testName = 'BackgroundFunction';
        Logger.info(BUNDLE + testName + ' begin');
        // 从下往上滑动列表
        await driver.drag(200, 700, 200, 200, 800)
        await driver.delayMs(DELAY_TIME);
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.prop_background')));
        // 正常显示
        await driver.delayMs(DELAY_TIME);

        // 向下滑动 固定坐标只支持RK3568，其他设备需要调整
        let scrollBar = await driver.findComponent(ON.type('Scroll'));
        await scrollBar.scrollToBottom();
        await driver.delayMs(500);

        // 展开设置背景图片大小类型
        await checkButtonAndClickWithID("test_select1");

        // 选择一个 Contain
        await checkButtonAndClickWithText('Contain');
        await driver.delayMs(DELAY_TIME);

        // 展开设置背景图片位置
        await checkButtonAndClickWithID("test_select2");

        // 选择一个 Center
        await checkButtonAndClickWithText('Center');
        await driver.delayMs(DELAY_TIME);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * border 边框
       */
      it(BUNDLE + 'BorderFunction_001', 0, async function () {
        let testName = 'BorderFunction';
        Logger.info(BUNDLE + testName + ' begin');
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.prop_border')))
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * font 字体
       */
      it(BUNDLE + 'FontFunction_001', 0, async function () {
        let testName = 'FontFunction';
        Logger.info(BUNDLE + testName + ' begin');

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.prop_font')));
        // 正常显示

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * size 尺寸
       */
      it(BUNDLE + 'SizeFunction_001', 0, async function () {
        let testName = 'SizeFunction';
        Logger.info(BUNDLE + testName + ' begin');

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.prop_size')));
        // 正常显示

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * rotate 旋转
       */
      it(BUNDLE + 'RotateFunction_001', 0, async function () {
        let testName = 'RotateFunction'
        Logger.info(BUNDLE + testName + ' begin')

        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.graphic_transformation_rotate'))));
        if (!button) {
          //如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.graphic_transformation')));
        }
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.graphic_transformation_rotate')));
        // 正常显示

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * translate 平移
       */
      it(BUNDLE + 'TranslateFunction_001', 0, async function () {
        let testName = 'TranslateFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.graphic_transformation_translate'))));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.graphic_transformation')));
        }

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.graphic_transformation_translate')));

        // 正常显示
        // 调整图片平移slider X轴
        await driver.delayMs(DELAY_TIME)
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(110, 531, 354, 531, 800);
        await driver.delayMs(DELAY_TIME);
        // 调整图片平移slider Y轴
        await driver.drag(110, 603, 354, 603, 800);
        await driver.delayMs(DELAY_TIME);
        // 调整容器平移slider X轴
        await driver.drag(110, 983, 354, 983, 800);
        await driver.delayMs(DELAY_TIME);
        // 调整容器平移slider Y轴
        await driver.drag(110, 1055, 354, 1055, 800);
        await driver.delayMs(DELAY_TIME);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        // 关闭展开
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.graphic_transformation')));

        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * scale 缩放
       */
      it(BUNDLE + 'ScaleFunction_001', 0, async function () {
        let testName = 'ScaleFunction';
        Logger.info(BUNDLE + testName + ' begin');
        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.scale'))));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.graphic_transformation')));
        }

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.scale')));

        // 正常显示
        // 调整图片平移slider X轴
        await driver.delayMs(DELAY_TIME)
        // 滑动滑块
        await driver.assertComponentExist(ON.id('scale_x'));
        let sliderX = await driver.findComponent(ON.id('scale_x'));
        let pointX = await sliderX.getBoundsCenter();
        await driver.drag(pointX.x - 50, pointX.y, pointX.x + 50, pointX.y, 800);
        await driver.delayMs(DELAY_TIME);
        // Y轴
        await driver.assertComponentExist(ON.id('scale_y'));
        let sliderY = await driver.findComponent(ON.id('scale_y'));
        let point = await sliderY.getBoundsCenter();
        await driver.drag(point.x - 50, point.y, point.x + 50, point.y, 800);
        await driver.delayMs(DELAY_TIME);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * transform 变换矩阵
       */
      it(BUNDLE + 'TransformFunction_001', 0, async function () {
        let testName = 'TransformFunction'
        Logger.info(BUNDLE + testName + ' begin')

        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.transform'))));
        if (!button) {
          //如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.graphic_transformation')));
        }
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.transform')));
        // 正常显示

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        // 关闭展开
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.graphic_transformation')));

        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * 显示
       */
      it(BUNDLE + 'DisplayFunction_001', 0, async function () {
        let testName = 'DisplayFunction';
        Logger.info(BUNDLE + testName + ' begin');

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.components_display')));
        // 打开红色 选择1
        await clickSelectIDAndSelectText('test_select1', '1');
        // 打开蓝色 选择2
        await clickSelectIDAndSelectText('test_select2', '2');
        // 打开黄色 选择3
        await clickSelectIDAndSelectText('test_select3', '3');

        // 点击浮层
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.overlay')));
        // 位置调整 选择bottom end
        await clickSelectIDAndSelectText('test_selectPosition', 'bottom end');
        // 偏移调整 X偏移调整
        await driver.delayMs(DELAY_TIME);
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(110, 957, 354, 957, 800)
        await driver.delayMs(DELAY_TIME);
        // 偏移调整 Y偏移调整
        await driver.drag(110, 1017, 354, 1017, 800)
        await driver.delayMs(DELAY_TIME);

        // 点击显隐
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.visibility')));
        // 可见性调整 选择Hidden
        await clickSelectIDAndSelectText('test_selectVisible', 'Hidden');
        // 可见性调整 选择None
        await clickSelectIDAndSelectText('test_selectVisible', 'None');

        // 点击透明
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.opacity')));
        // 透明度调整
        await driver.delayMs(DELAY_TIME);
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(110, 741, 354, 741, 800);
        await driver.delayMs(DELAY_TIME);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * 互动
       */
      it(BUNDLE + 'InteractionFunction_001', 0, async function () {
        let testName = 'InteractionFunction';
        Logger.info(BUNDLE + testName + ' begin');
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.components_interaction')));
        // 按钮禁用
        await checkButtonAndClickWithID('test_checkbox1');
        // 列表禁用
        await checkButtonAndClickWithID('test_checkbox2');

        // 进入弹窗
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.popup_window')));
        // 显示单按键弹窗
        await checkButtonAndClickWithID('test_oneButton');
        await checkButtonAndClickWithText('OK');
        // 显示双按键弹窗
        await checkButtonAndClickWithID('test_twoButton');
        await checkButtonAndClickWithText('OK');
        // 显示弹窗
        await checkButtonAndClickWithID('test_popButton');
        await checkButtonAndClickWithText('OK');

        // 进入点击
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.touch_test')));
        await checkButtonAndLongClickWithID('test_forgroundChild');

        // 进入热区
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.touch_region')));
        await checkButtonAndLongClickWithID('test_rect');

        // 进入悬停
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.hovereffect')));

        // 进入菜单
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.menu')));

        // 进入多态
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.multiState')));
        // 组件禁用
        await checkButtonAndLongClickWithID('test_checkbox');

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * location 位置设置
       */
      it(BUNDLE + 'LocationFunction_001', 0, async function () {
        let testName = 'LocationFunction';
        Logger.info(BUNDLE + testName + ' begin');
        // 从下往上滑动列表
        await driver.drag(200, 750, 200, 150, 800);
        await driver.delayMs(DELAY_TIME);
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.location_settings')));
        // 正常显示
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * 布局约束
       */
      it(BUNDLE + 'LayoutConstraintFunction_001', 0, async function () {
        let testName = 'LayoutConstraintFunction';
        Logger.info(BUNDLE + testName + ' begin');
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.layout_constrain')));
        // 点击按钮
        await checkButtonAndClickWithID('layout_btn');
        // 点击按钮
        await checkButtonAndClickWithID('layout_btn');
        // 点击按钮
        await checkButtonAndClickWithID('layout_btn');
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * flex布局
       */
      it(BUNDLE + 'FlexFunction_001', 0, async function () {
        let testName = 'FlexFunction';
        Logger.info(BUNDLE + testName + 'begin');
        // 从下往上滑动列表
        await driver.drag(200, 1000, 200, 100, 800);
        await driver.delayMs(DELAY_TIME);
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.flex')));
        // 正常显示
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        Logger.info(BUNDLE + testName + 'end');
      });

      /**
       * 图片边框设置
       */
      it(BUNDLE + 'PictureBorderFunction_001', 0, async function () {
        let testName = 'PictureBorderFunction';
        Logger.info(BUNDLE + testName + 'begin');
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.picture_border')));
        // 正常显示
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        Logger.info(BUNDLE + testName + 'end');
      });

      /**
       * 形状裁剪
       */
      it(BUNDLE + 'ShapeCropFunction_001', 0, async function () {
        let testName = 'ShapeCropFunction'
        Logger.info(BUNDLE + testName + 'begin')
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.shape_crop')));
        // 正常显示
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        Logger.info(BUNDLE + testName + 'end');
      });

      /**
       * 栅格设置
       */
      it(BUNDLE + 'GridSettingsFunction_001', 0, async function () {
        let testName = 'GridSettingsFunction'
        Logger.info(BUNDLE + testName + 'begin')
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.grid_settings')));
        // 正常显示
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        Logger.info(BUNDLE + testName + 'end');
      });

      /**
       * 焦点控制
       */
      it(BUNDLE + 'FocusControlFunction_001', 0, async function () {
        let testName = 'FocusControlFunction'
        Logger.info(BUNDLE + testName + 'begin')
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.focus_control')));
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        Logger.info(BUNDLE + testName + 'end');
      });

      /**
       * 组件背景模糊
       */
      it(BUNDLE + 'ComponentBlurredFunction_001', 0, async function () {
        let testName = 'ComponentBlurredFunction'
        Logger.info(BUNDLE + testName + ' begin')
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.component_blurred')));
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        Logger.info(BUNDLE + testName + 'end');
      });

      /**
       * 分布式迁移标识
       */
      it(BUNDLE + 'RestoreIdFunction_001', 0, async function () {
        let testName = 'RestoreIdFunction'
        Logger.info(BUNDLE + testName + 'begin')
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.restore_id')));
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        Logger.info(BUNDLE + testName + 'end');
      });

      /**
       * 绑定手势方法
       */
      it(BUNDLE + 'BindFunction_001', 0, async function () {
        // 从下往上滑动列表
        await driver.drag(200, 1000, 200, 100, 800);
        await driver.delayMs(DELAY_TIME);
        let testName = 'BindFunction';
        Logger.info(BUNDLE + testName + 'begin');
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.bind_gesture_methods')));
        // 点击按钮
        await checkButtonAndClickWithID('bind_one');
        await checkButtonAndClickWithID('bind_two');
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        Logger.info(BUNDLE + testName + 'end');
      });

      /**
       * TabGesture
       */
      it(BUNDLE + 'TabGestureFunction_001', 0, async function () {
        let testName = 'TabGestureFunction';
        Logger.info(BUNDLE + testName + 'begin');
        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.tap_gesture'))));
        if (!button) {
          //如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.basic_gestures')));
          // 从下往上滑动列表
          await driver.drag(200, 800, 200, 100, 800);
          await driver.delayMs(DELAY_TIME);
        }
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.tap_gesture')));
        // 单指双击触发
        let click_btn = await driver.findComponent(ON.id('tap_click'))
        await click_btn.doubleClick();
        await driver.delayMs(500);
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        Logger.info(BUNDLE + testName + 'end');
      });

      /**
       * LongPressGesture
       */
      it(BUNDLE + 'LongPressFunction_001', 0, async function () {
        let testName = 'LongPressFunction';
        Logger.info(BUNDLE + testName + ' begin');
        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.long_press_gesture'))));
        if (!button) {
          //如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.basic_gestures')));
        }
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.long_press_gesture')));
        // 单指长按触发
        let click_btn = await driver.findComponent(ON.id('long_press'))
        await click_btn.longClick();
        await driver.delayMs(500);
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * PanGesture
       */
      it(BUNDLE + 'PanGestureFunction_001', 0, async function () {
        let testName = 'PanGestureFunction';
        Logger.info(BUNDLE + testName + ' begin');
        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.pan_gesture'))));
        if (!button) {
          //如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.basic_gestures')));
        }
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.pan_gesture')));
        // 单指左右滑动
        let text = await driver.findComponent(ON.id('pan_column'));
        let point = await text.getBoundsCenter();
        await driver.drag(point.x - 50, point.y, point.x + 50, point.y, 8000);
        await driver.delayMs(500);
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * SwipeGesture
       */
      it(BUNDLE + 'SwipeGestureFunction_001', 0, async function () {
        let testName = 'SwipeGestureFunction';
        Logger.info(BUNDLE + testName + ' begin');
        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.swipe_gesture'))));
        if (!button) {
          //如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.basic_gestures')));
        }
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.swipe_gesture')));
        // 单指左右滑动
        let text = await driver.findComponent(ON.id('swipe_column'));
        let point = await text.getBoundsCenter();
        await driver.drag(point.x - 50, point.y - 50, point.x + 50, point.y + 50, 8000);
        await driver.delayMs(500);
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * 图像效果
       */
      it(BUNDLE + 'EffectsFunction_001', 0, async function () {
        let testName = 'EffectsFunction';
        Logger.info(BUNDLE + testName + ' begin');

        // 滑动一段距离
        await driver.drag(110, 752, 110, 500, 800);
        await driver.delayMs(DELAY_TIME);

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.components_effects')));

        // 向下滑动 固定坐标只支持RK3568，其他设备需要调整
        let scrollBar = await driver.findComponent(ON.type('Scroll'));
        await scrollBar.scrollToBottom();
        await driver.delayMs(500);

        // 展开纹理效果调整
        await checkButtonAndClickWithID("test_select1");

        // 选择一个 Dark
        await checkButtonAndClickWithText('Dark');
        await driver.delayMs(DELAY_TIME);

        // 展开纹理效果调整
        await checkButtonAndClickWithID("test_select2");

        // 选择一个 Dark
        await checkButtonAndClickWithText('Average');
        await driver.delayMs(DELAY_TIME);

        // 点击阴影
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.shadow')));

        // 滑动半径调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(200, 500, 300, 500, 800);
        await driver.delayMs(DELAY_TIME);

        // 展开阴影效果类型
        await checkButtonAndClickWithID("test_select1");

        // 选择一个 BLUR
        await checkButtonAndClickWithText('BLUR');
        await driver.delayMs(DELAY_TIME);

        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(200, 957, 300, 957, 800)
        await driver.delayMs(DELAY_TIME);

        // 点击特效
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.effects')));

        // 滑到底端
        await driver.drag(110, 752, 110, 500, 800);
        await driver.delayMs(DELAY_TIME);
        await driver.delayMs(DELAY_TIME);

        // 滑动亮起效果调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(450, 885, 350, 885, 800);
        await driver.delayMs(DELAY_TIME);

        // 滑动球面化程度调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(450, 925, 350, 925, 800);
        await driver.delayMs(DELAY_TIME);

        // 滑动边缘像素扩展调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(450, 1025, 350, 1025, 800);
        await driver.delayMs(DELAY_TIME);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      });

      /**
       * TarBar 进入动画
       */
      it(BUNDLE + 'TarBarAnimateFunction_001', 0, async function () {
        let testName = 'TarBarAnimateFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        let testAtomName = 'switch animation'
        await driver.assertComponentExist(ON.id('tabBar2'));
        let bar = await driver.findComponent(ON.id('tabBar2'));
        await bar.click();
        await driver.delayMs(DELAY_TIME);
        Logger.info(BUNDLE + testName + testAtomName);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * pageTransition 页面间转场
       */
      it(BUNDLE + 'PageTransitionFunction_001', 0, async function () {
        let testName = 'PageTransitionFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.page_transition'))));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.transition_animation')));
        }

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.page_transition')));
        // 顶部进场/底部退场
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.page_transition_top')));
        // 返回页面间转场页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.page_transition_back')));
        // 底部进场/顶部退场
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.page_transition_bottom')));
        // 返回页面间转场页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.page_transition_back')));

        // 左侧进场/右侧退场
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.page_transition_left')));
        // 返回页面间转场页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.page_transition_back')));
        // 右侧进场/左侧退场
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.page_transition_right')));
        // 返回页面间转场页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.page_transition_back')));

        // 缩放进场/退场
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.page_transition_scale')));
        // 返回页面间转场页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.page_transition_back')));
        // 旋转进场/退场
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.page_transition_rotate')));
        // 返回页面间转场页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.page_transition_back')));

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');

      })

      /**
       * sharedTransition 共享元素转场
       */
      it(BUNDLE + 'SharedTransitionFunction_001', 0, async function () {
        let testName = 'SharedTransitionFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.share_element_transition'))));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.transition_animation')));
        }

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.share_element_transition')));

        // 点击grid的图片
        await checkButtonAndClickWithID('test_grid0');
        await driver.delayMs(DELAY_TIME);
        // 点击图片关闭
        await checkButtonAndClickWithID('test_back');
        await driver.delayMs(DELAY_TIME);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');

      })

      /**
       * 多任务
       */
      it(BUNDLE + 'MultiplexFunction_001', 0, async function () {
        let testName = 'MultiplexFunction';
        Logger.info(BUNDLE + testName + ' begin');
        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.Multiplex_interface'))));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.transition_animation')));
        }

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.Multiplex_interface')));

        // 上滑删除卡片
        await checkAndDragById('1', 'target');

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');

      })

      /**
       * 悬浮窗
       */
      it(BUNDLE + 'FloatingFunction_001', 0, async function () {
        let testName = 'FloatingFunction';
        Logger.info(BUNDLE + testName + ' begin');
        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.Floating_window'))));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.transition_animation')));
        }

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.Floating_window')));

        // 拖动悬浮窗
        await checkAndDragById('floatingWindowComponent', 'target');

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * 文件夹展开
       */
      it(BUNDLE + 'FolderFunction_001', 0, async function () {
        let testName = 'FolderFunction';
        Logger.info(BUNDLE + testName + ' begin');
        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.Folder_expansion'))));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.transition_animation')));
        }

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.Folder_expansion')));

        // 点击文件夹展开
        await checkButtonAndClickWithID('folderComponent');

        // 点击文件夹内应用
        await checkButtonAndClickWithID('folderComponent');

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * 系统图标
       */
      it(BUNDLE + 'SystemIcons', 0, async function () {
        let testName = 'SystemIcons';
        Logger.info(BUNDLE + testName + ' begin');
        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.System_icon'))));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.System_icon')));
        }

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.System_icon')));
        await driver.delayMs(1000);
        // 滑动滑块
        await driver.assertComponentExist(ON.id('systemIcons_slider'));
        let sliderX = await driver.findComponent(ON.id('systemIcons_slider'));
        let pointX = await sliderX.getBoundsCenter();
        Logger.info(BUNDLE + testName +  `SystemIcons pointX ${pointX.x} ${pointX.y}`);
        await driver.drag(pointX.x, pointX.y, pointX.x, pointX.y - 100, 800);
        await driver.delayMs(3000);
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        Logger.info(BUNDLE + testName +  'SystemIcons end');
      })

      /**
       * 商店卡片展开
       */
      it(BUNDLE + 'ShopCardFunction_001', 0, async function () {
        let testName = 'ShopCardFunction';
        Logger.info(BUNDLE + testName + ' begin');
        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.Shop_card_expansion'))));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.transition_animation')));
        }

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.Shop_card_expansion')));

        // 点击展开商店卡片
        await checkButtonAndClickWithID('shopCardUnexpanded');

        // 点击还原
        await checkButtonAndClickWithID('shopCardExpanded');

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * 图片卡片展开
       */
      it(BUNDLE + 'GalleryCardFunction_001', 0, async function () {
        let testName = 'GalleryCardFunction';
        Logger.info(BUNDLE + testName + ' begin');
        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.Gallery_card_expansion'))));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.transition_animation')));
        }

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.Gallery_card_expansion')));

        // 点击展开图库卡片
        await checkButtonAndClickWithID('galleryUnexpanded');

        // 点击还原
        await checkButtonAndClickWithID('galleryExpanded');

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * ComponentTransition 组件内转场
       */
      it(BUNDLE + 'ComponentTransitionSampleFunction_001', 0, async function () {
        let testName = 'ComponentTransitionSampleFunction';
        Logger.info(BUNDLE + testName + ' begin');
        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.component_transition'))));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.transition_animation')));
        }
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.component_transition')));
        // 点击显示
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.component_transition_show')));
        await driver.delayMs(DELAY_TIME);
        // 点击隐藏
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.component_transition_hide')));
        await driver.delayMs(DELAY_TIME);
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(DELAY_TIME);
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.transition_animation')));
        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * 布局动效
       */
      it(BUNDLE + 'LayoutAnimationFunction_001', 0, async function () {
        let testName = 'LayoutAnimationFunction';
        Logger.info(BUNDLE + testName + ' begin');
        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.layout_animation_expansion'))));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.transition_animation')));
        }

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.layout_animation_expansion')));

        // 等待动画显示完毕
        await driver.delayMs(5000);
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * 尺寸变换动效
       */
      it(BUNDLE + 'LayoutAnimationFunction_001', 0, async function () {
        let testName = 'LayoutAnimationFunction';
        Logger.info(BUNDLE + testName + ' begin');
        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.size_transition_expansion'))));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.transition_animation')));
        }

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.size_transition_expansion')));

        // 等待动画显示完毕
        await driver.delayMs(5000);
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * 侧边栏动效
       */
      it(BUNDLE + 'LayoutAnimationFunction_001', 0, async function () {
        let testName = 'LayoutAnimationFunction';
        Logger.info(BUNDLE + testName + ' begin');
        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.side_bar_effects_title'))));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.transition_animation')));
        }

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.side_bar_effects_title')));

        // 展开侧边栏的显示类型
        await checkButtonAndClickWithID('test_itemSelect');

        // 选择一个 Overlay
        await checkButtonAndClickWithText('Embed');

        // 点击展开侧边栏并等待查看效果
        await checkButtonAndClickWithID('hide_or_show_sideBar');
        await driver.delayMs(2000);

        //点击隐藏侧边栏并等待查看效果
        await checkButtonAndClickWithID('hide_or_show_sideBar');
        await driver.delayMs(2000);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');
      })

    })

    /**
     * Interpolation Calculation 插值计算
     */
    it(BUNDLE + 'InterpolationFunction_001', 0, async function () {
      let testName = 'InterpolationFunction';
      Logger.info(BUNDLE + testName + ' begin');

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.interpolation_calculation')));

        // 点击Go!
        await checkButtonAndClickWithID('test_goButton');
        await driver.delayMs(DELAY_TIME);

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');

      })

      /**
       * AnimateTo 显示动画
       */
      it(BUNDLE + 'AnimateToFunction_001', 0, async function () {
        let testName = 'AnimateToFunction';
        Logger.info(BUNDLE + testName + ' begin');
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.animate_to')));
        // 改变大小
        await checkButtonAndClickWithID('animate_btn_delay');
        await driver.delayMs(DELAY_TIME);
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * Animation 属性动画
       */
      it(BUNDLE + 'AnimationFunction_001', 0, async function () {
        let testName = 'AnimationFunction';
        Logger.info(BUNDLE + testName + ' begin');
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.attribute_animation')));
        // 改变大小
        await checkButtonAndClickWithID('animation_btn_delay');
        await driver.delayMs(DELAY_TIME);
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        Logger.info(BUNDLE + testName + 'end');
      })

      /**
       * TarBar 全局方法
       */
      it(BUNDLE + 'TarBarGlobalFunction_001', 0, async function () {
        let testName = 'TarBarGlobalFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let driver: Driver = Driver.create();
        await driver.delayMs(DELAY_TIME);

        // 切换到全局
        let testAtomName = 'switch to global'
        await driver.assertComponentExist(ON.id('tabBar3'));
        let bar = await driver.findComponent(ON.id('tabBar3'));
        await bar.click();
        await driver.delayMs(DELAY_TIME);
        Logger.info(BUNDLE + testName + testAtomName);

        Logger.info(BUNDLE + testName + ' end');
      })

      /**
       * AlertDialog 警告弹窗
       */
      it(BUNDLE + 'AlertDialogFunction_001', 0, async function () {
        let testName = 'AlertDialogFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.alert_dialog'))));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.popup_window')));
        }

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.alert_dialog')));

        // 点击单按钮弹窗并确认
        await checkButtonAndClickWithID('test_oneButton');
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.alert_dialog_confirm')));
        // 点击双按钮弹窗并确认
        await checkButtonAndClickWithID('test_twoButton');
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.alert_dialog_confirm')));

        // 点击垂直顶部弹窗并确认
        await checkButtonAndClickWithID('test_topButton');
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.alert_dialog_confirm')));
        // 点击垂直居中弹窗并确认
        await checkButtonAndClickWithID('test_centerButton');
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.alert_dialog_confirm')));
        // 点击垂直底部弹窗并确认
        await checkButtonAndClickWithID('test_bottomButton');
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.alert_dialog_confirm')));

        // 点击可关闭弹窗并确认
        await checkButtonAndClickWithID('test_closeableButton');
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.alert_dialog_confirm')));
        // 点击不可关闭弹窗并确认
        await checkButtonAndClickWithID('test_noCloseButton');
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.alert_dialog_confirm')));

        // 点击左上偏移弹窗并确认
        await checkButtonAndClickWithID('test_upperLeftButton');
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.alert_dialog_confirm')));
        // 点击右下偏移弹窗并确认
        await checkButtonAndClickWithID('test_lowRightButton');
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.alert_dialog_confirm')));

        // 点击2栅格弹窗并确认
        await checkButtonAndClickWithID('test_2GridButton');
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.alert_dialog_confirm')));
        // 点击3栅格弹窗并确认
        await checkButtonAndClickWithID('test_3GridButton');
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.alert_dialog_confirm')));
        // 点击4栅格弹窗并确认
        await checkButtonAndClickWithID('test_4GridButton');
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.alert_dialog_confirm')));

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');

      })

      /**
       * CustomDialog 自定义弹窗
       */
      it(BUNDLE + 'CustomDialogFunction_001', 0, async function () {
        let testName = 'CustomDialogFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.custom_dialog'))));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.dialog')));
        }

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.custom_dialog')));

        // 点击单按钮弹窗并确认
        await checkButtonAndClickWithID('test_dialogButton');
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.custom_dialog_start')));

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');

      })

      /**
       * DatePickerDialog 日期选择弹窗
       */
      it(BUNDLE + 'DatePickerDialogFunction_001', 0, async function () {
        let testName = 'DatePickerDialogFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.date_picker_dialog'))));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.dialog')));
        }

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.date_picker_dialog')));

        // 展开农历日期
        await checkButtonAndClickWithID('test_lunar');
        // 滚动日期 可能是年-2020
        await driver.delayMs(DELAY_TIME);
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(100, 1017, 100, 1117, 800);
        await driver.delayMs(DELAY_TIME);
        //确定
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.button_confirm')));

        // 展开公历日期
        await checkButtonAndClickWithID('test_gregorian');
        // 滚动日期 可能是年-2024
        await driver.delayMs(DELAY_TIME);
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(100, 1087, 100, 1017, 800);
        await driver.delayMs(DELAY_TIME);
        // 确定
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.button_confirm')));

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');

      })

      /**
       * TimePickerDialog 时间选择弹窗
       */
      it(BUNDLE + 'TimePickerDialogFunction_001', 0, async function () {
        let testName = 'TimePickerDialogFunction';
        Logger.info(BUNDLE + testName + ' begin');

        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.time_picker_dialog'))));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.dialog')));
        }

        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.time_picker_dialog')));

        // 展开24小时
        await checkButtonAndClickWithID('test_24hour');
        // 滚动小时
        await driver.delayMs(DELAY_TIME);
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(200, 1017, 200, 1117, 800);
        await driver.delayMs(DELAY_TIME);
        // 确定
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.button_confirm')));

        // 展开12小时
        await checkButtonAndClickWithID('test_12hour');
        // 滚动小时
        await driver.delayMs(DELAY_TIME);
        // 滑动slider调整 固定坐标只支持RK3568，其他设备需要调整
        await driver.drag(200, 1117, 200, 1017, 800);
        await driver.delayMs(DELAY_TIME);
        // 确定
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.button_confirm')));

        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);

        Logger.info(BUNDLE + testName + ' end');

      })
      /**
       * ActionSheetDialogSample 列表选择弹窗
       */
      it(BUNDLE + 'ActionSheetDialogSampleFunction_001', 0, async function () {
        let testName = 'ActionSheetDialogSampleFunction';
        Logger.info(BUNDLE + testName + 'begin');

        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.action_sheet_dialog'))));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.dialog')));
        }
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.action_sheet_dialog')));
        // 点击垂直顶部弹窗并确认
        await checkButtonAndClickWithID('sheet_topButton');
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.alert_dialog_confirm')));
        // 点击垂直居中弹窗并确认
        await checkButtonAndClickWithID('sheet_centerButton');
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.alert_dialog_confirm')));
        // 点击垂直底部弹窗并确认
        await checkButtonAndClickWithID('sheet_bottomButton');
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.alert_dialog_confirm')));
        // 点击可关闭弹窗并确认
        await checkButtonAndClickWithID('sheet_closeableButton');
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.alert_dialog_confirm')));
        // 点击不可关闭弹窗并确认
        await checkButtonAndClickWithID('sheet_noCloseButton');
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.alert_dialog_confirm')));
        // 点击左上偏移弹窗并确认
        await checkButtonAndClickWithID('sheet_upperLeftButton');
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.alert_dialog_confirm')));
        // 点击右下偏移弹窗并确认
        await checkButtonAndClickWithID('sheet_lowRightButton');
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.alert_dialog_confirm')));
        // 点击内容并确认
        await checkButtonAndClickWithID('sheet_click_contentButton');
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.alert_dialog_confirm')));
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        Logger.info(BUNDLE + testName + 'end');
      })

      /**
       * TextPickerDialog 文本滑动选择弹窗
       */
      it(BUNDLE + 'TextPickerDialogFunction_001', 0, async function () {
        let testName = 'TextPickerDialogFunction';
        Logger.info(BUNDLE + testName + 'begin');
        await driver.delayMs(DELAY_TIME);
        let button = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.text_picker_dialog'))));
        if (!button) {
          // 如果没展开 就展开
          await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.dialog')));
        }
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.text_picker_dialog')));
        // 点击文字
        await checkButtonAndClickWithID('text_pickerButton');
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.alert_dialog_cancel')));
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(500);
        Logger.info(BUNDLE + testName + 'end');
      })

      /**
       * BindContextMenuDialog 菜单弹窗
       */
      it(BUNDLE + 'BindContextMenuDialogFunction_001', 0, async function () {
        let testName = 'BindContextMenuDialogFunction';
        Logger.info(BUNDLE + testName + 'begin');
        await driver.delayMs(DELAY_TIME);
        await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.global_menu'))));
        // 进入页面
        await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.global_menu')));
        // 长按
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('long_pressButton'));
        let longPress = await driver.findComponent(ON.id('long_pressButton'));
        await longPress.longClick()
        await driver.delayMs(1000);
        // 点击屏幕
        await driver.click(200, 300);
        // 返回
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
        await driver.delayMs(1000);
        Logger.info(BUNDLE + testName + 'end');
      })
      Logger.info("Sample_ComponentCollection test end");
    })
}
