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

const TAG = '[Sample_Screen]'
const DOMAIN = 0xF811
const BUNDLE = 'Screen_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let want = {
        bundleName: "ohos.samples.screen",
        abilityName: "MainAbility"
      }
      await globalThis.abilityContext.startAbility(want, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
      })
    })

    /**
     * DeviceInfo
     */
    it(BUNDLE + 'DeviceInfoFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'DeviceInfoFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // clickBigRect
      hilog.info(DOMAIN, TAG, BUNDLE + 'DeviceInfoFunction_001 clickBigRect')
      await driver.assertComponentExist(BY.key('bigRect'))
      let bigRect = await driver.findComponent(BY.key('bigRect'))
      await bigRect.click()
      await driver.delayMs(1000)
      // deviceInfo
      hilog.info(DOMAIN, TAG, BUNDLE + 'DeviceInfoFunction_001 deviceInfo')
      await driver.assertComponentExist(BY.key('deviceInfo'))
      let deviceInfo = await driver.findComponent(BY.key('deviceInfo'))
      await deviceInfo.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'DeviceInfoFunction_001 end')
    })

    /**
     * AddScreen
     */
    it(BUNDLE + 'AddScreenFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddScreenFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // addScreen1
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddScreenFunction_001 addScreen1')
      await driver.assertComponentExist(BY.key('addScreen'))
      let addScreenBtn = await driver.findComponent(BY.key('addScreen'))
      await addScreenBtn.click()
      await driver.delayMs(1000)
      // addScreen2
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddScreenFunction_001 addScreen2')
      await addScreenBtn.click()
      await driver.delayMs(1000)
      // addScreen3
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddScreenFunction_001 addScreen3')
      await addScreenBtn.click()
      await driver.delayMs(1000)
      // clickSmallRect1
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddScreenFunction_001 clickSmallRect1')
      await driver.assertComponentExist(BY.key('smallRect1'))
      let smallRect1 = await driver.findComponent(BY.key('smallRect1'))
      await smallRect1.click()
      await driver.delayMs(1000)
      // deviceInfo
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddScreenFunction_001 deviceInfo')
      await driver.assertComponentExist(BY.key('deviceInfo'))
      let deviceInfo = await driver.findComponent(BY.key('deviceInfo'))
      await deviceInfo.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddScreenFunction_001 end')
    })

    /**
     * RemoveScreen
     */
    it(BUNDLE + 'RemoveScreenFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'RemoveScreenFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // removeScreen
      hilog.info(DOMAIN, TAG, BUNDLE + 'RemoveScreenFunction_001 removeScreen')
      await driver.assertComponentExist(BY.key('removeScreen'))
      let removeScreenBtn = await driver.findComponent(BY.key('removeScreen'))
      await removeScreenBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'RemoveScreenFunction_001 end')
    })
  })
}