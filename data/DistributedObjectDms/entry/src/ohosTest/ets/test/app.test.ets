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
import hilog from '@ohos.hilog'

const TAG = '[Sample_DistributedObjectDms]'
const DOMAIN = 0xF811
const BUNDLE = 'DistributedObjectDms_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let want = {
        bundleName: "ohos.samples.distributedobjectdms",
        abilityName: "MainAbility"
      }
      globalThis.abilityContext.startAbility(want, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end')
      })
    })
    /**
     * 点击允许
     */
    it(BUNDLE + 'ClickAcceptFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAcceptFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAcceptFunction_001 clickAcceptBtn')
      // 点击允许
      await driver.assertComponentExist(BY.text('允许', MatchPattern.CONTAINS))
      let btnAccept = await driver.findComponent(BY.text('允许', MatchPattern.CONTAINS))
      await btnAccept.click()
      await driver.delayMs(3000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAcceptFunction_001 end')
    })
    /**
     * 退出应用
     */
    it(BUNDLE + 'ExitAppFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ExitAppFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      await driver.pressHome()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ExitAppFunction_001 end')
    })
    /**
     * 再次进入应用
     */
    it(BUNDLE + 'RestartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'RestartAbilityFunction_001 begin')
      let want = {
        bundleName: "ohos.samples.distributedobjectdms",
        abilityName: "MainAbility"
      }
      globalThis.abilityContext.startAbility(want, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'RestartAbilityFunction_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'RestartAbilityFunction_001 end')
      })
    })
    /**
     * 点击右上角流转按钮，选择设备
     */
    it(BUNDLE + 'ClickBtnFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ExitAppFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ExitAppFunction_001 clickFlowBtn')
      // 点击右上角流转按钮
      await driver.assertComponentExist(BY.key('flowBtn'))
      let flowBtn = await driver.findComponent(BY.key('flowBtn'))
      await flowBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ExitAppFunction_001 clickCancelBtn')
      // 点击取消
      await driver.assertComponentExist(BY.key('cancelBtn'))
      let cancelBtn = await driver.findComponent(BY.key('cancelBtn'))
      await cancelBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ExitAppFunction_001 end')
    })
    /**
     * 点击开始按钮，认证设备播放动画
     */
    it(BUNDLE + 'ClickStartFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ExitAppFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ExitAppFunction_001 clickStartBtn')
      await driver.assertComponentExist(BY.key('startBtn'))
      let startBtn = await driver.findComponent(BY.key('startBtn'))
      await startBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ExitAppFunction_001 end')
    })
  })
}