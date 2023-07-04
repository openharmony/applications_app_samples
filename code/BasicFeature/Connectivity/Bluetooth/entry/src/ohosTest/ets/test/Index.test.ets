/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { Component, Driver, MatchPattern, ON, UiWindow } from '@ohos.UiTest';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Want from '@ohos.app.ability.Want';
import hilog from '@ohos.hilog';

const TAG = '[Sample_Bluetooth]';
const BUNDLE = 'HeartRate_';
const delegator = AbilityDelegatorRegistry.getAbilityDelegator();

// 资源本地化
async function getResourceString(resource: Resource): Promise<string> {
  let manage = delegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

export default function IndexTest() {
  describe('indexTest', function () {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async function () {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      try {
        let want: Want = {
          bundleName: 'ohos.samples.heartrate',
          abilityName: 'EntryAbility'
        }
        let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator()
        await abilityDelegator.startAbility(want)
      } catch (err) {
        hilog.error(0x0000, TAG, '%{public}s', 'Ability startAbility fail')
        expect().assertFail()
      }
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
    it('assertEqual', 0, function () {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'test'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })
    /**
     * 点击允许
     */
    it(BUNDLE + 'Allow_001', 0, async function () {
      try {
        let driver = Driver.create()
        await driver.delayMs(2000)
        // 点击允许
        await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.allow'))))
        let btn = await driver.findComponent(ON.text(await getResourceString($r('app.string.allow'))))
        await btn.click()
        await driver.delayMs(2000)
      } catch (err) {
        hilog.error(0x0000, TAG, '%{public}s', 'Allow_001 fail')
        expect().assertFail()
      }
    })
    /**
     * 点击搜索设备
     */
    it(BUNDLE + 'StartBLEScan_001', 0, async function () {
      try {
        let driver: Driver = Driver.create()
        await driver.delayMs(2000)
        await driver.assertComponentExist(ON.id('btn_start_scan'))
        let btn: Component = await driver.findComponent(ON.id('btn_start_scan'))
        await btn.click()
        await driver.delayMs(30000)
      } catch (err) {
        hilog.error(0x0000, TAG, '%{public}s', 'StartBLEScan_001 fail')
        expect().assertFail()
      }
    })
    /**
     * 点击连接
     */
    it(BUNDLE + 'Connect_001', 0, async function () {
      try {
        let driver: Driver = Driver.create()
        await driver.delayMs(2000)
        await driver.assertComponentExist(ON.id(`btn_connect0`))
        let btn: Component = await driver.findComponent(ON.id(`btn_connect0`))
        await btn.click()
        await driver.delayMs(15000)
      } catch (err) {
        hilog.error(0x0000, TAG, '%{public}s', 'Connect_001 fail')
        expect().assertFail()
      }
    })
    /**
     * 点击列表Item查看心率
     */
    it(BUNDLE + 'HeartRate_001', 0, async function () {
      try {
        let driver: Driver = Driver.create()
        await driver.delayMs(2000)
        await driver.assertComponentExist(ON.id(`list_item0`))
        let btn: Component = await driver.findComponent(ON.id('list_item0'))
        await btn.click()
        await driver.delayMs(2000)
      } catch (err) {
        hilog.error(0x0000, TAG, '%{public}s', 'HeartRate_001 fail')
        expect().assertFail()
      }
    })
    /**
     * 点击返回到上一页
     */
    it(BUNDLE + 'Back_001', 0, async function () {
      try {
        let driver: Driver = Driver.create()
        await driver.delayMs(2000)
        await driver.assertComponentExist(ON.id('iv_back'))
        let btn: Component = await driver.findComponent(ON.id('iv_back'))
        await btn.click()
        await driver.delayMs(2000)
      } catch (err) {
        hilog.error(0x0000, TAG, '%{public}s', 'Back_001 fail')
        expect().assertFail()
      }
    })
    /**
     * 再次点击列表Item查看心率
     */
    it(BUNDLE + 'HeartRate_001', 0, async function () {
      try {
        let driver: Driver = Driver.create()
        await driver.delayMs(2000)
        await driver.assertComponentExist(ON.id(`list_item0`))
        let btn: Component = await driver.findComponent(ON.id('list_item0'))
        await btn.click()
        await driver.delayMs(2000)
      } catch (err) {
        hilog.error(0x0000, TAG, '%{public}s', 'HeartRate_001 fail')
        expect().assertFail()
      }
    })
    /**
     * 点击断开连接
     */
    it(BUNDLE + 'Disconnect_001', 0, async function () {
      try {
        let driver: Driver = Driver.create()
        await driver.delayMs(2000)
        await driver.assertComponentExist(ON.id('btn_disconnect'))
        let btn: Component = await driver.findComponent(ON.id('btn_disconnect'))
        await btn.click()
        await driver.delayMs(10000)
      } catch (err) {
        hilog.error(0x0000, TAG, '%{public}s', 'Disconnect_001 fail')
        expect().assertFail()
      }
    })
  })
}