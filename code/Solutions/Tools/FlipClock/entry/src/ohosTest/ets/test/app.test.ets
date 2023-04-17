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
import { UiDriver, BY, UiComponent, MatchPattern } from '@ohos.uitest'
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry'
import hilog from '@ohos.hilog'

const TAG = '[Sample_FlipClock]'
const DOMAIN = 0xF811
const BUNDLE = 'FlipClock_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let parameter = {
        bundleName: "ohos.samples.flipclock",
        abilityName: "EntryAbility"
      }
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      await abilityDelegator.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
      })
    })

    /**
     * 时钟
     */
    it(BUNDLE + 'CreateFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(2000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_001 end')
    })

    /**
     * 闹钟
     */
    it(BUNDLE + 'ClockFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClockFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClockFunction_001 clockClick')
      await driver.assertComponentExist(BY.text('闹钟', MatchPattern.CONTAINS))
      let btnClock = await driver.findComponent(BY.text('闹钟', MatchPattern.CONTAINS))
      await btnClock.click()
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClockFunction_001 end')
    })

    /**
     * 倒计时
     */
    it(BUNDLE + 'CountdownFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CountdownFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CountdownFunction_001 timerClick')
      await driver.assertComponentExist(BY.text('倒计时', MatchPattern.CONTAINS))
      let btnTimer = await driver.findComponent(BY.text('倒计时', MatchPattern.CONTAINS))
      await btnTimer.click()
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CountdownFunction_001 end')
    })

    /**
     * 设置
     */
    it(BUNDLE + 'SetFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SetFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SetFunction_001 setting')
      await driver.assertComponentExist(BY.text('设置', MatchPattern.CONTAINS))
      let btnSettings = await driver.findComponent(BY.text('设置', MatchPattern.CONTAINS))
      await btnSettings.click()
      await driver.delayMs(1000)
      // 全屏
      hilog.info(DOMAIN, TAG, BUNDLE + 'SetFunction_001 fullScreen')
      await driver.assertComponentExist(BY.type('Toggle'))
      let btnFullScreen = await driver.findComponent(BY.type('Toggle'))
      await btnFullScreen.click()
      await driver.delayMs(1000)
      // 屏幕常量
      hilog.info(DOMAIN, TAG, BUNDLE + 'SetFunction_001 screenLight')
      await driver.assertComponentExist(BY.key('screenLight'))
      let btnScreenLight = await driver.findComponent(BY.key('screenLight'))
      await btnScreenLight.click()
      await driver.delayMs(1000)
      // 亮度调节
      hilog.info(DOMAIN, TAG, BUNDLE + 'SetFunction_001 brightness')
      await driver.assertComponentExist(BY.key('brightness'))
      let btnBrightness = await driver.findComponent(BY.key('brightness'))
      await btnBrightness.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SetFunction_001 end')
    })
  })
}