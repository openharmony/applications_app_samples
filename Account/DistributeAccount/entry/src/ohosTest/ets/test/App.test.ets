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
import featureAbility from '@ohos.ability.featureAbility';
import hilog from '@ohos.hilog';

const BUNDLE = 'DistributeAccount'
const TAG = '[Sample_DistributeAccount]'
const DOMAIN = 0xF811

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + '_startAbility', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + '_startAbility start')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.etsdistributeaccount",
          abilityName: "ohos.samples.etsdistributeaccount.MainAbility"
        }
      }
      await featureAbility.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + '_startAbility get err ' + JSON.stringify(err))
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + '_startAbility end')
      })
    })

    it(BUNDLE + '_IndexPage_Login', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + '_IndexPage_Login start')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 输入用户名
      await driver.assertComponentExist(BY.key('inputUserName'))
      let inputUser = await driver.findComponent(BY.key('inputUserName'))
      await inputUser.inputText('mst')
      let userName = await inputUser.getText()
      await expect('mst').assertEqual(userName)
      // 输入密码
      await driver.delayMs(1000)
      await driver.assertComponentExist(BY.key('inputPassword'))
      let inputPassword = await driver.findComponent(BY.key('inputPassword'))
      await inputPassword.inputText('188')
      let password = await inputPassword.getText()
      await expect('188').assertEqual(password)
      await driver.delayMs(1000)
      await driver.assertComponentExist(BY.text('登录'))
      let loginBtn = await driver.findComponent(BY.text('登录'))
      await loginBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + '_IndexPage_Login end')
    })
  })
}
