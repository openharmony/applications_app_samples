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

const TAG = '[Sample_Shopping]'
const DOMAIN = 0xF811
const BUNDLE = 'Shopping_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.sample.shopping",
          abilityName: "ohos.sample.shopping.MainAbility"
        }
      }
      featureAbility.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end')
      })
    })
    /**
     * 点击切换模块内容
     */
    it(BUNDLE + 'ClickSwitchModuleFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSwitchModuleFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSwitchModuleFunction_001 clickMessage')
      // 点击消息
      await driver.assertComponentExist(BY.text('消息'))
      let message = await driver.findComponent(BY.text('消息'))
      await driver.delayMs(1000)
      await message.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSwitchModuleFunction_001 clickCart')
      // 点击购物车
      await driver.assertComponentExist(BY.text('购物车'))
      let cart = await driver.findComponent(BY.text('购物车'))
      await driver.delayMs(1000)
      await cart.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSwitchModuleFunction_001 clickMine')
      // 点击我的
      await driver.assertComponentExist(BY.text('我的'))
      let mine = await driver.findComponent(BY.text('我的'))
      await driver.delayMs(1000)
      await mine.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSwitchModuleFunction_001 clickHomePage')
      // 点击首页
      await driver.assertComponentExist(BY.text('首页'))
      let homePage = await driver.findComponent(BY.text('首页'))
      await driver.delayMs(1000)
      await homePage.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSwitchModuleFunction_001 end')
    })
  })
}