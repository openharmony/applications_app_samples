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
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'

const TAG = '[Sample_EnterpriseExtAbility]'
const DOMAIN = 0xF811
const BUNDLE = 'EnterpriseExtAbility_'

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      try {
        await abilityDelegator.startAbility({
          bundleName: "ohos.samples.enterprise_admin_ext_ability",
          abilityName: "EntryAbility"
        });
        done();
      } catch (err) {
        expect(err.code).assertEqual(0);
        done();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end')
    })

    it(BUNDLE + 'onAdminEnabled_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'onAdminEnabled_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000);
      // 点击激活激活设备管理器
      hilog.info(DOMAIN, TAG, BUNDLE + 'onAdminEnabled_001 clickEnableAdmin')
      await driver.assertComponentExist(ON.id('enableAdmin'))
      let enableAdmin = await driver.findComponent(ON.id('enableAdmin'))
      await driver.delayMs(1000);
      await enableAdmin.click()
      await driver.delayMs(1000);
      // 获取激活状态
      await driver.assertComponentExist(ON.id('enableAdminMsg'))
      let connectState = await driver.findComponent(ON.id('enableAdminMsg'))
      await driver.delayMs(1000);
      let state = await connectState.getText()
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'onAdminEnabled_001 state')
      expect('enableAdmin success').assertEqual(state)
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'onAdminEnabled_001 end')
    })

    it(BUNDLE + 'onSubscribeManagedEvent_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'onSubscribeManagedEvent_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000);
      // 点击订阅应用安装卸载事件
      hilog.info(DOMAIN, TAG, BUNDLE + 'onSubscribeManagedEvent_001 clickDisableAdmin')
      await driver.assertComponentExist(ON.id('subscribeManagedEvent'))
      let subscribeManagedEvent = await driver.findComponent(ON.id('subscribeManagedEvent'))
      await driver.delayMs(1000);
      await subscribeManagedEvent.click()
      await driver.delayMs(1000);
      // 获取订阅状态
      await driver.assertComponentExist(ON.id('subscribeManagedEventMsg'))
      let connectState = await driver.findComponent(ON.id('subscribeManagedEventMsg'))
      await driver.delayMs(1000);
      let state = await connectState.getText()
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'onSubscribeManagedEvent_001 state')
      expect('subscribeManagedEvent success').assertEqual(state)
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'onSubscribeManagedEvent_001 end')
    })

    it(BUNDLE + 'onUnsubscribeManagedEvent_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'onUnsubscribeManagedEvent_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000);
      // 点击取消订阅应用安装卸载事件
      hilog.info(DOMAIN, TAG, BUNDLE + 'onUnsubscribeManagedEvent_001 clickDisableAdmin')
      await driver.assertComponentExist(ON.id('unsubscribeManagedEvent'))
      let unsubscribeManagedEvent = await driver.findComponent(ON.id('unsubscribeManagedEvent'))
      await driver.delayMs(1000);
      await unsubscribeManagedEvent.click()
      await driver.delayMs(1000);
      // 获取取消订阅状态
      await driver.assertComponentExist(ON.id('unsubscribeManagedEventMsg'))
      let connectState = await driver.findComponent(ON.id('unsubscribeManagedEventMsg'))
      await driver.delayMs(1000);
      let state = await connectState.getText()
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'onUnsubscribeManagedEvent_001 state')
      expect('unsubscribeManagedEvent success').assertEqual(state)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'onUnsubscribeManagedEvent_001 end')
    })

    it(BUNDLE + 'onAdminDisabled_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'onAdminDisabled_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000);
      // 点击去激活设备管理器
      hilog.info(DOMAIN, TAG, BUNDLE + 'onAdminDisabled_001 clickDisableAdmin')
      await driver.assertComponentExist(ON.id('disableAdmin'))
      let disableAdmin = await driver.findComponent(ON.id('disableAdmin'))
      await driver.delayMs(1000);
      await disableAdmin.click()
      await driver.delayMs(1000);
      // 获取激活状态
      await driver.assertComponentExist(ON.id('disableAdminMsg'))
      let connectState = await driver.findComponent(ON.id('disableAdminMsg'))
      await driver.delayMs(1000);
      let state = await connectState.getText()
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'onAdminDisabled_001 state')
      expect('disableSuperAdmin success').assertEqual(state)
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'onAdminDisabled_001 end')
    })
  })
}