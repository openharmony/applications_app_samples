/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required ON applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import hilog from '@ohos.hilog';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { Component, Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const TAG = '[Sample_distributedcalc]'
const DOMAIN = 0xF811
const BUNDLE = 'distributedcalc_'

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
    /**
     * 拉起应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(DOMAIN, TAG, 'StartAbility_001 begin')
      let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator()
      try {
        await abilityDelegatorRegistry.startAbility({
          bundleName: 'ohos.samples.mydistributedcalc',
          abilityName: 'ohos.samples.mydistributedcalc.MainAbility'
        })
      } catch (err) {
        expect(0).assertEqual(err.code)
      }
      hilog.info(DOMAIN, TAG, 'StartAbility_001 end')
    })
    /**
     * 获取权限
     */
    it(BUNDLE + 'RequestPermissionFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'RequestPermissionFunction begin')
      let driver = Driver.create()
      await driver.delayMs(2000)
      // 获取文件读写权限
      hilog.info(DOMAIN, TAG, 'RequestPermissionFunction requestPermission')
      await driver.assertComponentExist(ON.text('允许'))
      let btnStart = await driver.findComponent(ON.text('允许'))
      await btnStart.click()
      hilog.info(DOMAIN, TAG, 'RequestPermissionFunction end')
    })
    /**
     * 分布式功能
     */
    it(BUNDLE + 'hopFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'hopFunction begin')
      let driver = Driver.create()
      await driver.delayMs(2000)
      // 点击按钮
      hilog.info(DOMAIN, TAG, 'hopFunction click hop botton')
      await driver.assertComponentExist(ON.id('btn_hop'))
      let btnHop = await driver.findComponent(ON.id('btn_hop'))
      await btnHop.click()
      await driver.delayMs(2000)
      // 取消弹窗
      hilog.info(DOMAIN, TAG, 'hopFunction unpopup')
      await driver.assertComponentExist(ON.text('取消'))
      let btnCancel = await driver.findComponent(ON.text('取消'))
      await btnCancel.click()
      hilog.info(DOMAIN, TAG, 'hopFunction end')
    })
    /**
     * 计算
     */
    it(BUNDLE + 'computeFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'computeFunction begin')
      let driver = Driver.create()
      await driver.delayMs(2000)
      await driver.assertComponentExist(ON.id('btn_nine'))
      let btnNine = await driver.findComponent(ON.id('btn_nine'))
      await btnNine.click()

      await driver.delayMs(500)
      await driver.assertComponentExist(ON.id('btn_four'))
      let btnFour = await driver.findComponent(ON.id('btn_four'))
      await btnFour.click()

      await driver.delayMs(500)
      await driver.assertComponentExist(ON.id('btn_divide'))
      let btnDivide = await driver.findComponent(ON.id('btn_divide'))
      await btnDivide.click()

      await driver.delayMs(500)
      await driver.assertComponentExist(ON.id('btn_two'))
      let btnTwo = await driver.findComponent(ON.id('btn_two'))
      await btnTwo.click()

      await driver.delayMs(500)
      await driver.assertComponentExist(ON.id('text_expression'))
      let textExpression = await driver.findComponent(ON.id('text_expression'))
      let expression = await textExpression.getText()

      await driver.delayMs(500)
      await driver.assertComponentExist(ON.id('text_result'))
      let textResult = await driver.findComponent(ON.id('text_result'))
      let result = await textResult.getText()

      await driver.delayMs(500)
      expect('94/2').assertEqual(expression)
      expect('47.000').assertEqual(result)

      await driver.delayMs(500)
      await driver.assertComponentExist(ON.id('btn_eq'))
      let btnEq = await driver.findComponent(ON.id('btn_eq'))
      await btnEq.click()

      await driver.delayMs(500)
      expression = await textExpression.getText()
      result = await textResult.getText()

      await driver.delayMs(500)
      expect('47.000').assertEqual(expression)
      expect('').assertEqual(result)

      await driver.delayMs(500)
      await driver.assertComponentExist(ON.id('btn_c'))
      let btnC = await driver.findComponent(ON.id('btn_c'))
      await btnC.click()

      await driver.delayMs(500)
      expression = await textExpression.getText()
      expect('').assertEqual(expression)

      hilog.info(DOMAIN, TAG, 'computeFunction end')
    })
  })
}