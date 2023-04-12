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

const TAG = '[Sample_Call]'
const DOMAIN = 0xF811
const BUNDLE = 'Call_'

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let want = {
        bundleName: "ohos.samples.call",
        abilityName: "EntryAbility"
      }
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      await abilityDelegator.startAbility(want, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin, err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
      })
    })

    /**
     * 输入电话号码并拨打
     */
    it(BUNDLE + 'CallFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'CallFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 输入电话号码
      hilog.info(DOMAIN, TAG, BUNDLE + 'CallFunction_001 input')
      await driver.assertComponentExist(BY.key('telInput'))
      let telInput = await driver.findComponent(BY.key('telInput'))
      await telInput.inputText('13566254180')
      let telVal = await telInput.getText()
      expect('13566254180').assertEqual(telVal)
      await driver.delayMs(1000)
      // 点击图标拨号
      hilog.info(DOMAIN, TAG, BUNDLE + 'CallFunction_001 call')
      await driver.assertComponentExist(BY.key('callImg'))
      let callBtn = await driver.findComponent(BY.key('callImg'))
      await callBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CallFunction_001 end')
    })
  })
}