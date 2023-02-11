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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { UiDriver, BY, UiComponent, MatchPattern } from '@ohos.uitest'
import featureAbility from '@ohos.ability.featureAbility'
import hilog from '@ohos.hilog'

const TAG = '[Sample_Flybird]'
const DOMAIN = 0xF811
const BUNDLE = 'Flybird'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let parameter = {
        "want": {
          bundleName: "com.samples.flybird",
          abilityName: "com.samples.flybird.MainAbility"
        }
      }
      await featureAbility.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin, err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
      })
    })
    /**
      * flyBird
      */
    it(BUNDLE + 'FlyBirdFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FlyBirdFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // input输入
      hilog.info(DOMAIN, TAG, BUNDLE + 'FlyBirdFunction_001 flyInput')
      await driver.assertComponentExist(BY.key('textArea'))
      let flyInput = await driver.findComponent(BY.key('textArea'))
      await flyInput.inputText('flybird')
      let flyVal = await flyInput.getText()
      expect('flybird').assertEqual(flyVal)
      await driver.delayMs(1000)
      // ConnectService
      hilog.info(DOMAIN, TAG, BUNDLE + 'FlyBirdFunction_001 ConnectService')
      await driver.assertComponentExist(BY.text('Connect service', MatchPattern.CONTAINS))
      let btnConnect = await driver.findComponent(BY.text('Connect service', MatchPattern.CONTAINS))
      await btnConnect.click()
      await driver.delayMs(1000)
      // setGameAlarm
      hilog.info(DOMAIN, TAG, BUNDLE + 'FlyBirdFunction_001 setGameAlarm')
      await driver.assertComponentExist(BY.text('set game alarm', MatchPattern.CONTAINS))
      let btnSetAlarm = await driver.findComponent(BY.text('set game alarm', MatchPattern.CONTAINS))
      await btnSetAlarm.click()
      await driver.delayMs(1000)
      // setGameCalendar
      hilog.info(DOMAIN, TAG, BUNDLE + 'FlyBirdFunction_001 setGameCalendar')
      await driver.assertComponentExist(BY.text('set game calendar', MatchPattern.CONTAINS))
      let btnSetCalendar = await driver.findComponent(BY.text('set game calendar', MatchPattern.CONTAINS))
      await btnSetCalendar.click()
      await driver.delayMs(1000)
      // startGame
      hilog.info(DOMAIN, TAG, BUNDLE + 'FlyBirdFunction_001 startGame')
      await driver.assertComponentExist(BY.text('start game', MatchPattern.CONTAINS))
      let btnStartGame = await driver.findComponent(BY.text('start game', MatchPattern.CONTAINS))
      await btnStartGame.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'FlyBirdFunction_001 end')
      // 返回首页
      hilog.info(DOMAIN, TAG, BUNDLE + 'FlyBirdFunction_001 IndexBack')
      await driver.assertComponentExist(BY.text('返回', MatchPattern.CONTAINS))
      let backBtn = await driver.findComponent(BY.text('返回', MatchPattern.CONTAINS))
      await backBtn.click()
      await driver.delayMs(1000)
      // DisconnectService
      hilog.info(DOMAIN, TAG, BUNDLE + 'FlyBirdFunction_001 DisconnectService')
      await driver.assertComponentExist(BY.text('Disconnect service', MatchPattern.CONTAINS))
      let btnDisconnect = await driver.findComponent(BY.text('Disconnect service', MatchPattern.CONTAINS))
      await btnDisconnect.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'FlyBirdFunction_001 end')
    })
  })
}