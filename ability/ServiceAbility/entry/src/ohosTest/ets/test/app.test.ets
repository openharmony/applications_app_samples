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

const TAG = '[Sample_ServiceAbility]'
const DOMAIN = 0xF811
const BUNDLE = 'ServiceAbility_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.etsserviceability",
          abilityName: "ohos.samples.etsserviceability.MainAbility"
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
     * 连接服务
     */
    it(BUNDLE + 'ConnectServiceFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ConnectServiceFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ConnectServiceFunction_001 clickConnectServiceBtn')
      // 点击连接服务
      await driver.assertComponentExist(BY.text('连接服务'))
      let btnConnectService = await driver.findComponent(BY.text('连接服务'))
      await driver.delayMs(1000)
      await btnConnectService.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'ConnectServiceFunction_001 end')
    })
    /**
     * 输入字符串进行排序
     */
    it(BUNDLE + 'StringSortFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StringSortFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'StringSortFunction_001 inputString')
      // 输入字符串
      await driver.assertComponentExist(BY.key('textAreaInput'))
      let textArea = await driver.findComponent(BY.key('textAreaInput'))
      await driver.delayMs(1000)
      await textArea.inputText('anghjdek')
      let inputValue = await textArea.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'StringSortFunction_001 inputValue')
      expect('anghjdek').assertEqual(inputValue)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'StringSortFunction_001 clickStringSortBtn')
      // 点击字符串排序
      await driver.assertComponentExist(BY.text('字符串排序'))
      let btnStringSort = await driver.findComponent(BY.text('字符串排序'))
      await driver.delayMs(1000)
      await btnStringSort.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'StringSortFunction_001 end')
    })
    /**
     * 断开服务
     */
    it(BUNDLE + 'DisconnectServiceFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DisconnectServiceFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'DisconnectServiceFunction_001 clickDisconnectServiceBtn')
      // 点击断开服务
      await driver.assertComponentExist(BY.text('断开服务'))
      let btnDisconnectService = await driver.findComponent(BY.text('断开服务'))
      await driver.delayMs(1000)
      await btnDisconnectService.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'DisconnectServiceFunction_001 end')
    })
  })
}