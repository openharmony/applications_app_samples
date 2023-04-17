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

const TAG = '[Sample_Runninglock]'
const DOMAIN = 0xF811
const BUNDLE = 'Runninglock_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      await abilityDelegator.startAbility({
        bundleName: "ohos.samples.runninglock",
        abilityName: "EntryAbility"
      }, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
      })
    })

    /**
     * 查询系统是否支持休眠锁按钮
     */
    it(BUNDLE + 'SearchSupportFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SearchSupportFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 点击查询系统是否支持休眠锁按钮
      hilog.info(DOMAIN, TAG, BUNDLE + 'SearchSupportFunction_001 searchSupport')
      await driver.assertComponentExist(BY.key('searchSupport'))
      let searchSupport = await driver.findComponent(BY.key('searchSupport'))
      await searchSupport.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SearchSupportFunction_001 end')
    })

    /**
     * 5s后定时息屏按钮
     */
    it(BUNDLE + 'TimingOutFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TimingOutFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(2000)
      // 点击5s后定时息屏按钮
      hilog.info(DOMAIN, TAG, BUNDLE + 'TimingOutFunction_001 timingOut')
      await driver.assertComponentExist(BY.key('timingOut'))
      let timingOut = await driver.findComponent(BY.key('timingOut'))
      await timingOut.click()
      await driver.delayMs(8000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'TimingOutFunction_001 end')
    })

    /**
     * 打开锁开关
     */
    it(BUNDLE + 'OpenFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'OpenFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 打开锁开关
      hilog.info(DOMAIN, TAG, BUNDLE + 'OpenFunction_001 lockSwitch')
      await driver.assertComponentExist(BY.type('Toggle'))
      let lockSwitch = await driver.findComponent(BY.type('Toggle'))
      await lockSwitch.click()
      await driver.delayMs(1000)
      // 点击5s后定时息屏按钮
      hilog.info(DOMAIN, TAG, BUNDLE + 'OpenFunction_001 timingOut')
      await driver.assertComponentExist(BY.key('timingOut'))
      let timingOut = await driver.findComponent(BY.key('timingOut'))
      await timingOut.click()
      await driver.delayMs(8000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'OpenFunction_001 end')
    })

    /**
     * 关闭锁开关
     */
    it(BUNDLE + 'CloseFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CloseFunction_001 end')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 关闭锁开关
      hilog.info(DOMAIN, TAG, BUNDLE + 'CloseFunction_001 lockSwitch')
      await driver.assertComponentExist(BY.type('Toggle'))
      let lockSwitch = await driver.findComponent(BY.type('Toggle'))
      await lockSwitch.click()
      await driver.delayMs(1000)
      // 点击5s后定时息屏按钮
      hilog.info(DOMAIN, TAG, BUNDLE + 'CloseFunction_001 timingOut')
      await driver.assertComponentExist(BY.key('timingOut'))
      let timingOut = await driver.findComponent(BY.key('timingOut'))
      await timingOut.click()
      await driver.delayMs(8000)
      await driver.click(1281, 975)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CloseFunction_001 end')
    })
  })
}