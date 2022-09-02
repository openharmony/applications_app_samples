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

const TAG = '[Sample_QRCode]'
const DOMAIN = 0xF811
const BUNDLE = 'QRCode_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let want = {
        bundleName: "ohos.samples.qrcode",
        abilityName: "MainAbility"
      }
      await globalThis.abilityContext.startAbility(want, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
      })
    })

    /**
     * 进入应用
     */
    it(BUNDLE + 'EnterFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(2000)
      // 进入应用
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFunction_001 enter')
      await driver.assertComponentExist(BY.text('允许', MatchPattern.CONTAINS))
      let btnEnter = await driver.findComponent(BY.text('允许', MatchPattern.CONTAINS))
      await btnEnter.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFunction_001 end')
    })

    /**
     * 生成并保存二维码
     */
    it(BUNDLE + 'CreateFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(2000)
      // 点击生成二维码
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_001 createClick')
      await driver.assertComponentExist(BY.text('生成二维码', MatchPattern.CONTAINS))
      let btnCreate = await driver.findComponent(BY.text('生成二维码', MatchPattern.CONTAINS))
      await btnCreate.click()
      await driver.delayMs(1000)
      // 输入二维码内容
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_001 createQRCodeInput')
      await driver.assertComponentExist(BY.key('createQRCodeInput'))
      let CreateQRCodeInput = await driver.findComponent(BY.key('createQRCodeInput'))
      await CreateQRCodeInput.inputText('helloWorld')
      let val = await CreateQRCodeInput.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_001 inputValue')
      expect('helloWorld').assertEqual(val)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_001 saveClick')
      await driver.assertComponentExist(BY.key('save'))
      let btnSave = await driver.findComponent(BY.key('save'))
      await btnSave.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_001 end')
    })
  })
}