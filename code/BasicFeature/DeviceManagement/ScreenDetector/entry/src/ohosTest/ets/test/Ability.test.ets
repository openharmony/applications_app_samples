/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { Driver, ON, MatchPattern } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import UIAbility from '@ohos.app.ability.UIAbility'
import Logger from '../utils/Logger';

const TAG = '[Sample_ScreenDetector]'
const BUNDLE = 'ScreenDetector_'

const DELAY_TIME = 1000
let driver: Driver = Driver.create()

//通过text验证有没有这个组件 有的话点击一下
async function checkButtonAndClickWithText(text: string) {
  let atom = text
  await driver.assertComponentExist(ON.text(atom))
  let button = await driver.findComponent(ON.text(atom))
  await button.click()
  await driver.delayMs(DELAY_TIME)
  Logger.info(TAG, BUNDLE + atom)
}

//通过id验证有没有这个组件 有的话点击一下
async function checkButtonAndClickWithID(text: string) {
  let atom = text
  await driver.assertComponentExist(ON.id(atom))
  let button = await driver.findComponent(ON.id(atom))
  await button.click()
  await driver.delayMs(DELAY_TIME)
  Logger.info(TAG, BUNDLE + atom)
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
      Logger.info("Sample_ScreenDetector test start")

      /**
       * 打开应用
       */
      it(BUNDLE + 'StartAbility_001', 0, async function (done) {
        Logger.info(TAG, BUNDLE + 'StartAbility_001 begin')
        let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
        try {
          await abilityDelegator.startAbility({
            bundleName: 'com.samples.screendetector',
            abilityName: 'MainAbility'
          })
          done()
        } catch (exception) {
          Logger.info(TAG, `StartAbility_001 end ${JSON.stringify(exception)}`)
          expect(0).assertEqual(exception.code)
          done()
        }
        Logger.info(TAG, BUNDLE + 'StartAbility_001' + ' end')
      })

      /**
       * 新增窗口
       */
      it(BUNDLE + 'AddScreenFunction_001', 0, async function () {
        let testName = 'AddScreen'
        Logger.info(TAG, BUNDLE + testName + ' begin')

        let driver: Driver = Driver.create()
        await driver.delayMs(DELAY_TIME)

        // 增加屏幕窗口
        for (let i = 0; i < 5; i++) {
          await checkButtonAndClickWithID('test_add')
        }

        Logger.info(TAG, BUNDLE + testName + ' end')
      });

      /**
       * 移除窗口
       */
      it(BUNDLE + 'AddScreenFunction_001', 0, async function () {
        let testName = 'AddScreen'
        Logger.info(TAG, BUNDLE + testName + ' begin')

        let driver: Driver = Driver.create()
        await driver.delayMs(DELAY_TIME)

        // 移除屏幕窗口
        for (let i = 0; i < 5; i++) {
          await checkButtonAndClickWithID('test_cut')
        }

        Logger.info(TAG, BUNDLE + testName + ' end')
      });

      /**
       * 验证R0屏幕信息
       */
      it(BUNDLE + 'DetectorScreenFunction_001', 0, async function () {
        let testName = 'DetectorScreen'
        Logger.info(TAG, BUNDLE + testName + ' begin')

        let driver: Driver = Driver.create()
        await driver.delayMs(DELAY_TIME)

        // 进入屏幕详情
        await checkButtonAndClickWithID('test_screen0')
        await driver.delayMs(DELAY_TIME)

        Logger.info(TAG, BUNDLE + testName + ' end')
      });

      Logger.info("Sample_ScreenDetector test end")
    })
  })
}
