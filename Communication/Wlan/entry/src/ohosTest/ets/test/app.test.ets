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

const TAG = '[Sample_Wlan]'
const DOMAIN = 0xF811
const BUNDLE = 'Wlan_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.etswlan",
          abilityName: "ohos.samples.etswlan.MainAbility"
        }
      }
      await featureAbility.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
      })
    })

    /**
     * 进入页面
     */
    it(BUNDLE + 'EnterFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(500)
      // enter
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFunction_001 clickEnter')
      await driver.assertComponentExist(BY.text('允许'))
      let btnEnter = await driver.findComponent(BY.text('允许'))
      await btnEnter.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFunction_001 end')
    })

    /**
     * 连接wifi
     */
    it(BUNDLE + 'WifiFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'WifiFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'WifiFunction_001 checkBox')
      await driver.assertComponentExist(BY.type('Toggle'))
      let checkBox = await driver.findComponent(BY.type('Toggle'))
      hilog.info(DOMAIN, TAG, BUNDLE + 'WifiFunction_001 isChecked')
      await driver.delayMs(3000)
      if (await checkBox.isChecked()) {
        // connect Wlan
        hilog.info(DOMAIN, TAG, BUNDLE + 'WifiFunction_001 clickWifi1')
        await driver.assertComponentExist(BY.key('Wifi1'))
        let btnList = await driver.findComponent(BY.key('Wifi1'))
        await btnList.click()
        await driver.delayMs(1000)
        // input password
        hilog.info(DOMAIN, TAG, BUNDLE + 'WifiFunction_001 inputPassword')
        await driver.assertComponentExist(BY.key('input'))
        let input1 = await driver.findComponent(BY.key('input'))
        await input1.inputText('123')
        await driver.delayMs(1000)
        hilog.info(DOMAIN, TAG, BUNDLE + 'WifiFunction_001 clickSure')
        await driver.assertComponentExist(BY.text('确定', MatchPattern.CONTAINS))
        let btnSure = await driver.findComponent(BY.text('确定', MatchPattern.CONTAINS))
        await btnSure.click()
        await driver.delayMs(1000)
        // not input
        hilog.info(DOMAIN, TAG, BUNDLE + 'WifiFunction_001 clickWifi4')
        await driver.assertComponentExist(BY.key('Wifi4'))
        let btnList4 = await driver.findComponent(BY.key('Wifi4'))
        await btnList4.click()
        await driver.delayMs(1000)
        hilog.info(DOMAIN, TAG, BUNDLE + 'WifiFunction_001 end')
      }
      else {
        // Wlan on
        hilog.info(DOMAIN, TAG, BUNDLE + 'WifiFunction_001 clickToggle')
        await driver.assertComponentExist(BY.type('Toggle'))
        let btnCheck = await driver.findComponent(BY.type('Toggle'))
        await btnCheck.click()
        await driver.delayMs(3000)
        // connect Wlan
        hilog.info(DOMAIN, TAG, BUNDLE + 'WifiFunction_001 clickWifi1')
        await driver.assertComponentExist(BY.key('Wifi1'))
        let btnList = await driver.findComponent(BY.key('Wifi1'))
        await btnList.click()
        await driver.delayMs(1000)
        // input password
        hilog.info(DOMAIN, TAG, BUNDLE + 'WifiFunction_001 inputPassword')
        await driver.assertComponentExist(BY.key('input'))
        let input1 = await driver.findComponent(BY.key('input'))
        await input1.inputText('123')
        await driver.delayMs(1000)
        hilog.info(DOMAIN, TAG, BUNDLE + 'WifiFunction_001 clickSure')
        await driver.assertComponentExist(BY.text('确定', MatchPattern.CONTAINS))
        let btnSure = await driver.findComponent(BY.text('确定', MatchPattern.CONTAINS))
        await btnSure.click()
        await driver.delayMs(1000)
        // not input
        hilog.info(DOMAIN, TAG, BUNDLE + 'WifiFunction_001 clickWifi4')
        await driver.assertComponentExist(BY.key('Wifi4'))
        let btnList4 = await driver.findComponent(BY.key('Wifi4'))
        await btnList4.click()
        await driver.delayMs(1000)
        hilog.info(DOMAIN, TAG, BUNDLE + 'WifiFunction_001 end')
      }
    })

    /**
     * 查看wifi详细信息
     */
    it(BUNDLE + 'DetailFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'DetailFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(500)
      // about Wlan details
      hilog.info(DOMAIN, TAG, BUNDLE + 'DetailFunction_001 clickDetails')
      await driver.assertComponentExist(BY.key('about'))
      let btnAbout = await driver.findComponent(BY.key('about'))
      await btnAbout.click()
      await driver.pressBack()
      await driver.delayMs(100)
      hilog.info(DOMAIN, TAG, BUNDLE + 'DetailFunction_001 end')
    })

    /**
     * 关闭wifi
     */
    it(BUNDLE + 'WlanOffFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'WlanOffFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(500)
      // Wlan off
      hilog.info(DOMAIN, TAG, BUNDLE + 'WlanOffFunction_001 clickToggle')
      await driver.assertComponentExist(BY.type('Toggle'))
      let btnCheck = await driver.findComponent(BY.type('Toggle'))
      await btnCheck.click()
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + 'WlanOffFunction_001 end')
    })
  })
}