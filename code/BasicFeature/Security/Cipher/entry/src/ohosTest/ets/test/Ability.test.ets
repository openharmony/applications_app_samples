/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry'
import hilog from '@ohos.hilog'

const TAG = '[Sample_Cipher]'
const DOMAIN = 0xF811
const BUNDLE = 'Cipher_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      await abilityDelegator.startAbility({
        bundleName: "ohos.samples.cipher",
        abilityName: "EntryAbility"
      }, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001  end')
      })
    })

    /**
     * 加密
     */
    it(BUNDLE + 'EncryptionFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'EncryptionFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 加密
      hilog.info(DOMAIN, TAG, BUNDLE + 'EncryptionFunction_001 encryption')
      await driver.assertComponentExist(BY.key('encryption'))
      let encryption = await driver.findComponent(BY.key('encryption'))
      await encryption.click()
      await driver.delayMs(1000)
      // 点击加密/解密
      hilog.info(DOMAIN, TAG, BUNDLE + 'EncryptionFunction_001 encryptAndDecrypt')
      await driver.assertComponentExist(BY.key('encryptAndDecrypt'))
      let encryptAndDecrypt = await driver.findComponent(BY.key('encryptAndDecrypt'))
      await encryptAndDecrypt.click()
      await driver.delayMs(1000)
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'EncryptionFunction_001 back')
      await driver.assertComponentExist(BY.key('back'))
      let btnBack = await driver.findComponent(BY.key('back'))
      await btnBack.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'EncryptionFunction_001 end')
    })

    /**
     * 解密
     */
    it(BUNDLE + 'DecryptFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecryptFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 解密
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecryptFunction_001 decrypt')
      await driver.assertComponentExist(BY.key('decrypt'))
      let decrypt = await driver.findComponent(BY.key('decrypt'))
      await decrypt.click()
      await driver.delayMs(1000)
      // 点击加密/解密
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecryptFunction_001 Decrypt')
      await driver.assertComponentExist(BY.key('encryptAndDecrypt'))
      let encryptAndDecrypt = await driver.findComponent(BY.key('encryptAndDecrypt'))
      await encryptAndDecrypt.click()
      await driver.delayMs(1000)
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecryptFunction_001 back')
      await driver.assertComponentExist(BY.key('back'))
      let btnBack = await driver.findComponent(BY.key('back'))
      await btnBack.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecryptFunction_001 end')
    })
  })
}