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

const TAG = '[Sample_BringApp]'
const DOMAIN = 0xF811
const BUNDLE = 'BringApp_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.etsbringapp",
          abilityName: "ohos.samples.etsbringapp.MainAbility"
        }
      }
      await featureAbility.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
      })
    })

    /**
     * 拉起短信
     */
    it(BUNDLE + 'MessageFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'MessageFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 拉起短信
      hilog.info(DOMAIN, TAG, BUNDLE + 'MessageFunction_001 message')
      await driver.assertComponentExist(BY.key('app3'))
      let appBtn4 = await driver.findComponent(BY.key('app3'))
      await appBtn4.click()
      await driver.delayMs(5000)
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'MessageFunction_001 pressBack')
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MessageFunction_001 end')
    })
  })
}