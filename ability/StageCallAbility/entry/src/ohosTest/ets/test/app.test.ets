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

const TAG = '[Sample_StageCallAbility]'
const DOMAIN = 0xF811
const BUNDLE = 'StageCallAbility_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let want = {
        bundleName: "ohos.samples.CallApplication",
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
      await driver.assertComponentExist(BY.text('允许'))
      let btnAccept = await driver.findComponent(BY.text('允许'))
      await btnAccept.click()
      await driver.delayMs(3000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAcceptFunction_001 end')
    })
    /**
     * 点击启动启动Callee Ability页面
     */
    it(BUNDLE + 'ClickStartCalleeAbilityFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickStartCalleeAbilityFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickStartCalleeAbilityFunction_001 clickStartCalleeAbilityBtn')
      // 点击启动Callee Ability按钮
      await driver.assertComponentExist(BY.text('启动Callee Ability'))
      let btnStart = await driver.findComponent(BY.text('启动Callee Ability'))
      await btnStart.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickStartCalleeAbilityFunction_001 end')
    })
    /**
     * 切换到MainAbility页面
     */
    it(BUNDLE + 'StartMainAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartMainAbilityFunction_001 begin')
      let want = {
        bundleName: "ohos.samples.CallApplication",
        abilityName: "MainAbility"
      }
      await globalThis.abilityContext.startAbility(want, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartMainAbilityFunction_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartMainAbilityFunction_001 end')
      })
    })
    /**
     * 点击获取Caller通信接口
     */
    it(BUNDLE + 'ClickObtainCallerFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickObtainCallerFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickObtainCallerFunction_001 clickObtainCallerBtn')
      // 点击获取Caller
      await driver.assertComponentExist(BY.text('获取Caller'))
      let btnCaller = await driver.findComponent(BY.text('获取Caller'))
      await btnCaller.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickObtainCallerFunction_001 end')
    })
    /**
     * 输入待发送消息
     */
    it(BUNDLE + 'InputSendMessageFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputSendMessageFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputSendMessageFunction_001 inputWaitingSendMessage')
      // 输入待发送消息
      await driver.assertComponentExist(BY.key('inputMessage'))
      let sendMessage = await driver.findComponent(BY.key('inputMessage'))
      await sendMessage.inputText('playmusic')
      let message = await sendMessage.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputContactInformationFunction_001 message')
      expect('playmusic').assertEqual(message)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputSendMessageFunction_001 clickSendMessageBtn')
      // 点击通过Call调用发送消息
      await driver.assertComponentExist(BY.text('通过Call调用发送消息'))
      let btnSendMessage = await driver.findComponent(BY.text('通过Call调用发送消息'))
      await btnSendMessage.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputSendMessageFunction_001 end')
    })
    /**
     * 点击启动Callee Ability
     */
    it(BUNDLE + 'StartCalleeAbilityFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartCalleeAbilityFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartCalleeAbilityFunction_001 clickStartCalleeAbilityBtn')
      // 点击启动Callee Ability
      await driver.assertComponentExist(BY.text('启动Callee Ability'))
      let btnStart = await driver.findComponent(BY.text('启动Callee Ability'))
      await btnStart.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartCalleeAbilityFunction_001 end')
    })
    /**
     * 切换到MainAbility页面
     */
    it(BUNDLE + 'StartMainAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartMainAbilityFunction_001 begin')
      let want = {
        bundleName: "ohos.samples.CallApplication",
        abilityName: "MainAbility"
      }
      globalThis.abilityContext.startAbility(want, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartMainAbilityFunction_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartMainAbilityFunction_001 end')
      })
    })
    /**
     * 点击释放Caller通信接口
     */
    it(BUNDLE + 'ClickCallerReleaseFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCallerReleaseFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCallerReleaseFunction_001 cliclkCallerReleaseBtn')
      // 点击释放Caller
      await driver.assertComponentExist(BY.text('释放Caller'))
      let btnCallerRelease = await driver.findComponent(BY.text('释放Caller'))
      await btnCallerRelease.click()
      await driver.delayMs(1000)
      // 再次输入待发送消息
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCallerReleaseFunction_001 sendMessage')
      await driver.assertComponentExist(BY.key('inputMessage'))
      let sendMessage = await driver.findComponent(BY.key('inputMessage'))
      await sendMessage.inputText('playball')
      let secondMessage = await sendMessage.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCallerReleaseFunction_001 secondMessage')
      expect('playball').assertEqual(secondMessage)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCallerReleaseFunction_001 clickSendMessageBtn')
      // 点击通过Call调用发送消息
      await driver.assertComponentExist(BY.text('通过Call调用发送消息'))
      let btnSendMessage = await driver.findComponent(BY.text('通过Call调用发送消息'))
      await btnSendMessage.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCallerReleaseFunction_001 end')
    })
  })
}