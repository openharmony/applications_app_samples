/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import Logger from '../utils/Logger';

const CASE: string = 'KeyboardAvoid'; // sample名称
const BUNDLE = 'keyboardavoid_';
const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    let driver = Driver.create();

    /**
     * 打开应用
     */
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      const driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      await driver.delayMs(1000);
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * 关联用例: 访问案例，软键盘自动拉起，上抬避让页面组件实现上抬避让
     * 执行步骤:
     * 1. 滑动页面，查看上抬避让效果
     * 2. 通过判断键盘是否拉起和是否展示全部数据(共12条)进行验证
     */
    it(CASE + '上抬避让模式', 0, async (done: Function) => {
      Logger.info(CASE, BUNDLE + '上抬避让模式 begin');
      let KeyboardAvoidTextInput = await driver.findComponent(ON.type('TextInput'));
      let KeyboardAvoidLiftUpComponents = await driver.findComponent(ON.id('KeyboardAvoidLiftUpComponents'));
      let isFocused = await KeyboardAvoidTextInput.isFocused();
      if (isFocused) {
        await KeyboardAvoidLiftUpComponents.scrollToBottom(4000);
        await driver.assertComponentExist(ON.text('第十二条数据'));
      } else {
        expect(isFocused).assertEqual(true);
      }
      Logger.info(CASE, BUNDLE + '上抬避让模式 end');
      done();
    })

    /**
     * 关联用例: 点击页面空白位置，软键盘收起，点击输入框，软键盘拉起
     * 执行步骤:
     * 1. 点击页面空白位置，收起软键盘
     * 2. 点击'弹出键盘'按钮，拉起软键盘
     * 3. 通过判断键盘高度是否从拉起状态变化为收起状态再变化为拉起状态进行验证
     */
    it(CASE + '键盘收起与拉起', 0, async (done: Function) => {
      Logger.info(CASE, BUNDLE + '键盘收起与拉起 begin');
      let KeyboardAvoidBlank = await driver.findComponent(ON.id('KeyboardAvoidBlank'));
      let KeyboardAvoidButtonPopUpKeyboard = await driver.findComponent(ON.id('KeyboardAvoidButtonPopUpKeyboard'));
      let KeyboardAvoidTextInput = await driver.findComponent(ON.type('TextInput'));

      let beforeIsFocused = await KeyboardAvoidTextInput.isFocused();
      await KeyboardAvoidBlank.click();
      await driver.delayMs(2000);
      let middleIsFocused = await KeyboardAvoidTextInput.isFocused();
      await KeyboardAvoidButtonPopUpKeyboard.click();
      await driver.delayMs(2000);
      let finalIsFocused = await KeyboardAvoidTextInput.isFocused();
      const finalCheck = beforeIsFocused && !middleIsFocused && finalIsFocused;
      expect(finalCheck).assertEqual(true);
      Logger.info(CASE, BUNDLE + '键盘收起与拉起 end');
      done();
    })

    /**
     * 关联用例: 点击“缩小避让”按钮，页面切换，点击输入框拉起软键盘，实现组件上抬避让让同时实现缩小
     * 执行步骤:
     * 1. 点击'缩小避让'按钮，切换页面至grid
     * 2. 点击'弹出键盘'按钮，拉起软键盘
     * 3. 滑动页面，查看上抬避让效果
     * 4. 通过判断键盘是否拉起和是否展示全部数据(共12条)进行验证
     */
    it(CASE + '缩小避让模式', 0, async (done: Function) => {
      Logger.info(CASE, BUNDLE + '缩小避让模式 begin');
      let KeyboardAvoidButtonScaling = await driver.findComponent(ON.id('KeyboardAvoidButtonScaling'));
      let KeyboardAvoidButtonPopUpKeyboard = await driver.findComponent(ON.id('KeyboardAvoidButtonPopUpKeyboard'));
      let KeyboardAvoidTextInput = await driver.findComponent(ON.type('TextInput'));
      await KeyboardAvoidButtonScaling.click();
      await KeyboardAvoidButtonPopUpKeyboard.click();
      let isFocused = await KeyboardAvoidTextInput.isFocused();
      if (isFocused) {
        await driver.fling({
          x: 100, y: 800
        }, {
          x: 100, y: 50
        }, 5, 600);
        await driver.assertComponentExist(ON.text('第十二条数据'));

      } else {
        expect(isFocused).assertEqual(true);
      }
      // 退出输入法
      await driver.pressBack();
      await driver.delayMs(1000);
      Logger.info(CASE, BUNDLE + '缩小避让模式 end');
      done();
    })
  })
}