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
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry'

const BUNDLE = 'Npm'
const TAG = '[Sample_Npm]'
const DOMAIN = 0xF811

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + '_startAbility', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + '_startAbility start')
      let want = {
        bundleName: "ohos.samples.npm",
        abilityName: "MainAbility"
      }
      var abilityDelegator: any
      abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      await abilityDelegator.startAbility(want, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + '_startAbility get err ' + JSON.stringify(err))
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + '_startAbility end')
      })
    })
    /**
     * 点击获取验证码
     */
    it(BUNDLE + '_IndexPage_getCode', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + '_IndexPage_getCode start')
      let driver = await UiDriver.create()
      await driver.delayMs(2000)
      // 点击获取验证码
      await driver.assertComponentExist(BY.key('getCode'))
      let btnGetCode = await driver.findComponent(BY.key('getCode'))
      await btnGetCode.click()
      await driver.delayMs(1000)
      // 点击下一页
      await driver.assertComponentExist(BY.key('indexNextPage'))
      let indexNextPage = await driver.findComponent(BY.key('indexNextPage'))
      await indexNextPage.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + '_IndexPage_getCode end')
    })
    /**
     * 输入相关日期
     */
    it(BUNDLE + '_DatePage_InputDate', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + '_DatePage_InputDate start')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 点击输入需要计算的日期
      await driver.assertComponentExist(BY.key('inputText0'))
      let computeDate = await driver.findComponent(BY.key('inputText0'))
      await computeDate.inputText('2000-01-01')
      await driver.delayMs(1000)
      // 点击向前推多少天
      await driver.assertComponentExist(BY.key('inputText1'))
      let beforeDays = await driver.findComponent(BY.key('inputText1'))
      await beforeDays.inputText('3')
      await driver.delayMs(1000)
      // 点击向后推多少天
      await driver.assertComponentExist(BY.key('inputText2'))
      let afterDays = await driver.findComponent(BY.key('inputText2'))
      await afterDays.inputText('3')
      await driver.delayMs(1000)
      // 点击确认
      await driver.assertComponentExist(BY.key('confirm'))
      let comfirmBtn = await driver.findComponent(BY.key('confirm'))
      await comfirmBtn.click()
      await driver.delayMs(1000)
      //点击下一页
      await driver.assertComponentExist(BY.key('dateNextPage'))
      let nextPage = await driver.findComponent(BY.key('dateNextPage'))
      await nextPage.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + '_DatePage_InputDate end')
    })
    /**
     * 拼接字符串
     */
    it(BUNDLE + '_LocalLibrarry_InputString', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + '_LocalLibrarry_InputString start')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 点击输入第一个字符串
      await driver.assertComponentExist(BY.key('inputText3'))
      let computeDate = await driver.findComponent(BY.key('inputText3'))
      await computeDate.inputText('hello')
      await driver.delayMs(1000)
      // 点击向前推多少天
      await driver.assertComponentExist(BY.key('inputText4'))
      let beforeDays = await driver.findComponent(BY.key('inputText4'))
      await beforeDays.inputText('world')
      await driver.delayMs(1000)
      // 点击确认
      await driver.assertComponentExist(BY.key('confirmBtn'))
      let comfirmBtn = await driver.findComponent(BY.key('confirmBtn'))
      await comfirmBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + '_LocalLibrarry_InputString end')
    })
  })
}
