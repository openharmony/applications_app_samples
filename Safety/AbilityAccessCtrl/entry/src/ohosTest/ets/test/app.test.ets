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

const TAG = '[Sample_AbilityAccessCtrl]'
const DOMAIN = 0xF811
const BUNDLE = 'AbilityAccessCtrl_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.abilityaccessctrl",
          abilityName: "ohos.samples.abilityaccessctrl.MainAbility"
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
     * 取消权限
     */
    it(BUNDLE + 'CancelPermission_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'CancelPermission_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 取消权限
      hilog.info(DOMAIN, TAG, BUNDLE + 'CancelPermission_001 cancel')
      await driver.assertComponentExist(BY.text('取消', MatchPattern.CONTAINS))
      let btnCancel = await driver.findComponent(BY.text('取消', MatchPattern.CONTAINS))
      await btnCancel.click()
      await driver.delayMs(1000)
      // 检查权限
      hilog.info(DOMAIN, TAG, BUNDLE + 'CancelPermission_001 checkPermission')
      await driver.assertComponentExist(BY.key('checkPermission'))
      let btnPermission = await driver.findComponent(BY.key('checkPermission'))
      await btnPermission.click()
      await driver.delayMs(1000)
      // 返回桌面
      hilog.info(DOMAIN, TAG, BUNDLE + 'CancelPermission_001 pressBack')
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CancelPermission_001 end')
    })

    /**
     * 权限确认
     */
    it(BUNDLE + 'ConfirmPermission_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'ConfirmPermission_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 进入AbilityAccessCtrl
      hilog.info(DOMAIN, TAG, BUNDLE + 'ConfirmPermission_001 enter')
      await driver.assertComponentExist(BY.text('AbilityAccessCtrl', MatchPattern.CONTAINS))
      let btnApp = await driver.findComponent(BY.text('AbilityAccessCtrl', MatchPattern.CONTAINS))
      await btnApp.click()
      await driver.delayMs(1000)
      // 权限确认
      hilog.info(DOMAIN, TAG, BUNDLE + 'ConfirmPermission_001 confirm')
      await driver.assertComponentExist(BY.text('确认', MatchPattern.CONTAINS))
      let btnCancel = await driver.findComponent(BY.text('确认', MatchPattern.CONTAINS))
      await btnCancel.click()
      await driver.delayMs(1000)
      // 检查权限
      hilog.info(DOMAIN, TAG, BUNDLE + 'ConfirmPermission_001 checkPermission')
      await driver.assertComponentExist(BY.key('checkPermission'))
      let btnPermission = await driver.findComponent(BY.key('checkPermission'))
      await btnPermission.click()
      await driver.delayMs(1000)
      // 返回桌面
      hilog.info(DOMAIN, TAG, BUNDLE + 'ConfirmPermission_001 pressBack')
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CancelPermission_001 end')
    })

    /**
     * 再次检查权限
     */
    it(BUNDLE + 'checkPermission_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'checkPermission_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 进入AbilityAccessCtrl
      hilog.info(DOMAIN, TAG, BUNDLE + 'checkPermission_001 enter')
      await driver.assertComponentExist(BY.text('AbilityAccessCtrl', MatchPattern.CONTAINS))
      let btnApp = await driver.findComponent(BY.text('AbilityAccessCtrl', MatchPattern.CONTAINS))
      await btnApp.click()
      await driver.delayMs(1000)
      // 检查权限
      hilog.info(DOMAIN, TAG, BUNDLE + 'checkPermission_001 checkPermission')
      await driver.assertComponentExist(BY.key('checkPermission'))
      let btnPermission = await driver.findComponent(BY.key('checkPermission'))
      await btnPermission.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'checkPermission_001 end')
    })
  })
}