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
import { abilityDelegatorRegistry, Driver, ON, Component } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import Logger from '../utils/Logger';

const CASE: string = 'PullToRefresh'; // sample名称
const TAG: string = '[pulltorefresh_Test]';
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
     * 执行步骤：
     * 1、上滑列表。
     * 2、通过验证滑动后列表是否增加新列表项判断列表加载成功。
     **/
    it(CASE + '上滑列表', 0, async (done: Function) => {
      Logger.info(TAG, `${CASE}_Page_Scroll_Up begin`);
      await driver.assertComponentExist(ON.id('pageList'));
      const pageList: Component = await driver.findComponent(ON.id('pageList'));
      // 加载第二页
      await pageList.scrollToBottom(2000);
      await driver.delayMs(3000);
      await driver.assertComponentExist(ON.text('入春来，百花香'));
      // 加载第三页
      await pageList.scrollToBottom(2000);
      await driver.delayMs(3000);
      await driver.assertComponentExist(ON.text('入春来，百花香'));
      // 加载第四页
      await pageList.scrollToBottom(2000);
      await driver.delayMs(3000);
      await driver.assertComponentExist(ON.text('入春来，百花香'));
      // 上滑到底后不再加载
      await pageList.scrollToBottom(2000);
      await driver.delayMs(3000);
      await driver.assertComponentExist(ON.text('《将进酒 君不见》'));
      done();
    })

    /**
     * 执行步骤：
     * 1、下拉列表。
     * 2、通过验证下拉后列表是否刷新判断列表刷新成功。
     **/
    it(CASE + '下拉列表', 0, async (done: Function) => {
      Logger.info(TAG, `${CASE}_Page_Scroll_Down begin`);
      await driver.assertComponentExist(ON.id('pageList'));
      const pageList: Component = await driver.findComponent(ON.id('pageList'));
      // 下拉到列表顶部，更新数据
      await pageList.scrollToTop(2000);
      await driver.delayMs(3000);
      await driver.assertComponentExist(ON.text('好物推荐'));
      done();
    })
  })
}