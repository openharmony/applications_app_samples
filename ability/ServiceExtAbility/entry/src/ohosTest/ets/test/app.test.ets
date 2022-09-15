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
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry'
import { UiDriver, BY, UiComponent, MatchPattern } from '@ohos.uitest'
import hilog from '@ohos.hilog'

const TAG = '[Sample_ServiceExtAbility]'
const DOMAIN = 0xF811
const BUNDLE = 'ServiceExtAbility_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let want = {
        bundleName: "ohos.samples.eTSServiceExtAbility",
        abilityName: "MainAbility"
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
    /**
     * 启动服务
     */
    it(BUNDLE + 'StartServiceFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartServiceFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartServiceFunction_001 clickStartService')
      // 点击启动服务
      await driver.assertComponentExist(BY.key('startService'))
      let startService = await driver.findComponent(BY.key('startService'))
      await startService.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartServiceFunction_001 getConnectState')
      // 连接状态变为已启动服务
      await driver.assertComponentExist(BY.key('connectState'))
      let connectState = await driver.findComponent(BY.key('connectState'))
      let state = await connectState.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartServiceFunction_001 state')
      expect('已启动服务').assertEqual(state)
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartServiceFunction_001 end')
    })
    /**
     * 输入两个数字
     */
    it(BUNDLE + 'InputTwoNumFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputTwoNumFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputTwoNumFunction_001 inputFirstNum')
      // 输入第一个数字
      await driver.assertComponentExist(BY.key('inputFirstNum'))
      let inputFirstNum = await driver.findComponent(BY.key('inputFirstNum'))
      await inputFirstNum.inputText('5')
      let firstNumValue = await inputFirstNum.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputTwoNumFunction_001 firstNumValue')
      expect('5').assertEqual(firstNumValue)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputTwoNumFunction_001 inputSecondNum')
      // 输入第二个数字
      await driver.assertComponentExist(BY.key('inputSecondNum'))
      let inputSecondNum = await driver.findComponent(BY.key('inputSecondNum'))
      await inputSecondNum.inputText('7')
      let secondNumValue = await inputSecondNum.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputTwoNumFunction_001 secondNumValue')
      expect('7').assertEqual(secondNumValue)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputTwoNumFunction_001 end')
    })
    /**
     * 连接服务
     */
    it(BUNDLE + 'ConnectServiceFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ConnectServiceFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ConnectServiceFunction_001 clickConnectService')
      // 点击连接服务
      await driver.assertComponentExist(BY.key('connectService'))
      let connectService = await driver.findComponent(BY.key('connectService'))
      await connectService.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ConnectServiceFunction_001 getConnectState')
      // 连接状态变为已连接服务
      await driver.assertComponentExist(BY.key('connectState'))
      let connectState = await driver.findComponent(BY.key('connectState'))
      let state = await connectState.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'ConnectServiceFunction_001 state')
      expect('已连接服务').assertEqual(state)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ConnectServiceFunction_001 end')
    })
    /**
     * 断开服务
     */
    it(BUNDLE + 'DisconnectServiceFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DisconnectServiceFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'DisconnectServiceFunction_001 click DisconnectService')
      // 断开服务
      await driver.assertComponentExist(BY.key('disconnectService'))
      let disconnectService = await driver.findComponent(BY.key('disconnectService'))
      await disconnectService.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'DisconnectServiceFunction_001 getConnectState')
      // 连接状态变为已断开服务
      await driver.assertComponentExist(BY.key('connectState'))
      let connectState = await driver.findComponent(BY.key('connectState'))
      let state = await connectState.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'DisconnectServiceFunction_001 state')
      expect('已断开服务').assertEqual(state)
      hilog.info(DOMAIN, TAG, BUNDLE + 'DisconnectServiceFunction_001 end')
    })
  })
}