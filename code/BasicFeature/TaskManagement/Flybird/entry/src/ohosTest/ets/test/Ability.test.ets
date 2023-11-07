/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { UiDriver, BY, UiComponent, MatchPattern, Driver, ON } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import hilog from '@ohos.hilog'
import Logger from '../utils/Logger';
import resourceManager from '@ohos.resourceManager'
import inputMethod from '@ohos.inputMethod'

const TAG = '[Sample_Flybird]'
const DOMAIN = 0xF811
const BUNDLE = 'Flybird_'

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

export default function appTest() {
  describe('appTest', function () {

    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      Logger.info(TAG, BUNDLE + 'StartAbility_001 begin')
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.flybird',
          abilityName: 'EntryAbility'
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
     * input输入 flyBird
     */
    it(BUNDLE + 'InputFlyBirdFunction_001', 0, async function () {
      let testName = 'InputFlyBird'
      Logger.info(TAG, BUNDLE + testName + ' begin')

      let driver: Driver = Driver.create()
      await driver.delayMs(DELAY_TIME)

      // input输入
      hilog.info(DOMAIN, TAG, BUNDLE + 'FlyBirdFunction_001 flyInput')
      await driver.assertComponentExist(ON.id('textArea'))
      let flyInput = await driver.findComponent(ON.id('textArea'))
      await flyInput.inputText('flybird')
      let inputMethodController = inputMethod.getController()
      inputMethodController.stopInputSession()
      Logger.info(TAG, BUNDLE + testName + ' end')
    })

    /**
     * Connect service
     */
    it(BUNDLE + 'ConnectServiceFunction_001', 0, async function () {
      let testName = 'ConnectService'
      Logger.info(TAG, BUNDLE + testName + ' begin')

      let driver: Driver = Driver.create()
      await driver.delayMs(DELAY_TIME)

      // ConnectService
      await checkButtonAndClickWithText('Connect service')

      Logger.info(TAG, BUNDLE + testName + ' end')
    })

    /**
     * SetGameAlarm
     */
    it(BUNDLE + 'SetGameAlarmFunction_001', 0, async function () {
      let testName = 'SetGameAlarm'
      Logger.info(TAG, BUNDLE + testName + ' begin')

      let driver: Driver = Driver.create()
      await driver.delayMs(DELAY_TIME)

      // SetGameAlarm
      await checkButtonAndClickWithText('set game alarm')

      Logger.info(TAG, BUNDLE + testName + ' end')
    })

    /**
     * SetGameCalendar
     */
    it(BUNDLE + 'SetGameCalendarFunction_001', 0, async function () {
      let testName = 'SetGameCalendar'
      Logger.info(TAG, BUNDLE + testName + ' begin')

      let driver: Driver = Driver.create()
      await driver.delayMs(DELAY_TIME)

      // SetGameCalendar
      await checkButtonAndClickWithText('set game calendar')

      Logger.info(TAG, BUNDLE + testName + ' end')
    })

    /**
     * StartGame
     */
    it(BUNDLE + 'StartGameFunction_001', 0, async function () {
      let testName = 'StartGameCalendar'
      Logger.info(TAG, BUNDLE + testName + ' begin')

      let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator()
      // 获取ability
      let ability = await abilityDelegatorRegistry.getCurrentTopAbility()
      //获取manager
      let manager = ability.context.resourceManager

      let driver: Driver = Driver.create()
      await driver.delayMs(DELAY_TIME)

      // startGame
      await checkButtonAndClickWithText('start game')

      // 关卡1
      await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.level_one')))
      // 等待小鸟降落
      await driver.delayMs(DELAY_TIME * 10)
      // 返回上一页
      await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.back')))

      // 返回首页
      await checkButtonAndClickWithText(await manager.getStringValue($r('app.string.back')))

      // DisconnectService
      await checkButtonAndClickWithText('Disconnect service')

      Logger.info(TAG, BUNDLE + testName + ' end')
    })
  })
}