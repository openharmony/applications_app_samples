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

import hilog from '@ohos.hilog'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { Driver, ON, Component, MatchPattern } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry'

const TAG = '[Sample_EnterpriseExtAbility]'
const DOMAIN = 0xF811
const BUNDLE = 'EnterpriseExtAbility_'

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let want = {
        bundleName: "ohos.samples.enterprise_admin_ext_ability",
        abilityName: "EntryAbility"
      }
      var abilityDelegator: any
      abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      abilityDelegator.startAbility(want, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end')
      })
    })

    it(BUNDLE + 'onAdminEnabled_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'onAdminEnabled_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(100)
      // 点击激活激活设备管理器
      hilog.info(DOMAIN, TAG, BUNDLE + 'onAdminEnabled_001 clickEnableAdmin')
      await driver.assertComponentExist(ON.id('enableAdmin'))
      let enableAdmin = await driver.findComponent(ON.id('enableAdmin'))
      await enableAdmin.click()
      await driver.delayMs(100)
      // 获取激活状态
      await driver.assertComponentExist(ON.id('enableAdminMsg'))
      let connectState = await driver.findComponent(ON.id('enableAdminMsg'))
      let state = await connectState.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'onAdminEnabled_001 state')
      expect('enableAdmin success').assertEqual(state)
      hilog.info(DOMAIN, TAG, BUNDLE + 'onAdminEnabled_001 end')
    })

    it(BUNDLE + 'onSubscribeManagedEvent_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'onSubscribeManagedEvent_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(100)
      // 点击订阅应用安装卸载事件
      hilog.info(DOMAIN, TAG, BUNDLE + 'onSubscribeManagedEvent_001 clickDisableAdmin')
      await driver.assertComponentExist(ON.id('subscribeManagedEvent'))
      let subscribeManagedEvent = await driver.findComponent(ON.id('subscribeManagedEvent'))
      await subscribeManagedEvent.click()
      await driver.delayMs(100)
      // 获取订阅状态
      await driver.assertComponentExist(ON.id('subscribeManagedEventMsg'))
      let connectState = await driver.findComponent(ON.id('subscribeManagedEventMsg'))
      let state = await connectState.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'onSubscribeManagedEvent_001 state')
      expect('subscribeManagedEvent success').assertEqual(state)
      hilog.info(DOMAIN, TAG, BUNDLE + 'onSubscribeManagedEvent_001 end')
    })

    it(BUNDLE + 'onUnsubscribeManagedEvent_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'onUnsubscribeManagedEvent_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(100)
      // 点击取消订阅应用安装卸载事件
      hilog.info(DOMAIN, TAG, BUNDLE + 'onUnsubscribeManagedEvent_001 clickDisableAdmin')
      await driver.assertComponentExist(ON.id('unsubscribeManagedEvent'))
      let unsubscribeManagedEvent = await driver.findComponent(ON.id('unsubscribeManagedEvent'))
      await unsubscribeManagedEvent.click()
      await driver.delayMs(100)
      // 获取取消订阅状态
      await driver.assertComponentExist(ON.id('unsubscribeManagedEventMsg'))
      let connectState = await driver.findComponent(ON.id('unsubscribeManagedEventMsg'))
      let state = await connectState.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'onUnsubscribeManagedEvent_001 state')
      expect('unsubscribeManagedEvent success').assertEqual(state)
      hilog.info(DOMAIN, TAG, BUNDLE + 'onUnsubscribeManagedEvent_001 end')
    })

    it(BUNDLE + 'onAdminDisabled_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'onAdminDisabled_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(100)
      // 点击去激活设备管理器
      hilog.info(DOMAIN, TAG, BUNDLE + 'onAdminDisabled_001 clickDisableAdmin')
      await driver.assertComponentExist(ON.id('disableAdmin'))
      let disableAdmin = await driver.findComponent(ON.id('disableAdmin'))
      await disableAdmin.click()
      await driver.delayMs(100)
      // 获取激活状态
      await driver.assertComponentExist(ON.id('disableAdminMsg'))
      let connectState = await driver.findComponent(ON.id('disableAdminMsg'))
      let state = await connectState.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'onAdminDisabled_001 state')
      expect('disableSuperAdmin success').assertEqual(state)
      hilog.info(DOMAIN, TAG, BUNDLE + 'onAdminDisabled_001 end')
    })
  })
}