/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import { Driver, ON } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry'
import hilog from '@ohos.hilog'

const TAG = '[Sample_CustomNotification]'
const DOMAIN = 0xF811
const BUNDLE = 'CustomNotification_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001 begin', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      await abilityDelegator.startAbility({
        bundleName: "ohos.samples.customnotification",
        abilityName: "MainAbility"
      }, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
      })
    })

    /**
     * BringPowerManager
     */
    it(BUNDLE + 'CreateCustomNotificationFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateCustomNotificationFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      // 点击允许
      await driver.assertComponentExist(ON.type('Button'))
      let buttonClick = await driver.findComponent(ON.text('允许'))
      await buttonClick.click()
      // 获取按钮
      let Button = await driver.findComponents(ON.type('Button').within(ON.type('Scroll')))
      // 点击基本类型通知
      await Button[0].click()
      // 下拉查看通知
      await driver.swipe(180, 0, 180, 50, 600)
      await driver.delayMs(1000)
      await driver.swipe(180, 50, 180, 0, 600)
      await driver.delayMs(1000)
      // 点击长文本类型通知
      await Button[1].click()
      // 下拉查看通知
      await driver.swipe(180, 0, 180, 50, 600)
      await driver.assertComponentExist(ON.text('CustomNotification'))
      let textButton = await driver.findComponent(ON.text('CustomNotification'))
      await textButton.click()
      await driver.delayMs(1000)
      await driver.swipe(180, 50, 180, 0, 600)
      await driver.delayMs(1000)
      // 点击多行文本类型通知
      await Button[2].click()
      // 下拉查看通知
      await driver.swipe(180, 0, 180, 50, 600)
      await driver.delayMs(1000)
      await driver.swipe(180, 50, 180, 0, 600)
      await driver.delayMs(1000)
      // 点击图片类型通知
      await Button[3].click()
      // 下拉查看通知
      await driver.swipe(180, 0, 180, 50, 600)
      await driver.delayMs(1000)
      await driver.swipe(180, 50, 180, 0, 600)
      await driver.delayMs(1000)
      // 点击带按钮的通知
      await Button[4].click()
      // 下拉查看通知
      await driver.swipe(180, 0, 180, 50, 600)
      await driver.delayMs(1000)
      await driver.swipe(180, 50, 180, 0, 600)
      await driver.delayMs(1000)
      // 点击可跳转的通知
      await Button[5].click()
      // 下拉查看通知
      await driver.swipe(180, 0, 180, 50, 600)
      await driver.delayMs(1000)
      await driver.swipe(180, 50, 180, 0, 600)
      await driver.delayMs(1000)
      // 点击取消所有通知
      await Button[6].click()
      // 下拉查看通知
      await driver.swipe(180, 0, 180, 50, 600)
      await driver.delayMs(1000)
      await driver.swipe(180, 50, 180, 0, 600)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateCustomNotificationFunction_001 end')
    })
  })
}

