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

const CASE: string = 'SearchComponent'; // sample名称
const TAG: string = '[searchcomponent_Test]';
const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.

    // /**
    //  * 打开应用
    //  */
    // it(BUNDLE + '_startAbility', 0, async (done: Function) => {
    //   Logger.info(TAG, BUNDLE + '_startAbility start')
    //   let want: Want = {
    //     bundleName: bundleName,
    //     abilityName: 'EntryAbility'
    //   };
    //   delegator.startAbility(want, (err) => {
    //     Logger.info(TAG, 'StartAbility get err ' + JSON.stringify(err));
    //     expect(err).assertNull();
    //   })
    //   Logger.info(TAG, BUNDLE + '_startAbility end');
    //   let driver: Driver = Driver.create();
    //   await driver.delayMs(3000);
    //   done();
    // });

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

    it(CASE + '_Find', 0, async (done: Function) => {
      Logger.info(TAG, `${CASE} begin`);
      let driver = Driver.create();

      // 点击“搜索”框
      Logger.info(TAG, `${CASE}_Find begin`);
      let search = await driver.findComponent(ON.type('Search'));
      await search.click();
      await driver.delayMs(1000);

      // 在搜索框输入需查找的案例名
      let textInput = await driver.findComponent(ON.type('Search'));
      await textInput.inputText('发布图片评论');
      await driver.delayMs(1000);

      // 点击搜索按钮，查找案例
      let searchButton = await driver.findComponent(ON.text('搜索'));
      await searchButton.click();
      await driver.delayMs(2000);

      done()
    })
    
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
  })
}