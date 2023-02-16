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

const TAG = '[Sample_DistributedRdb]'
const DOMAIN = 0xF811
const BUNDLE = 'DistributedRdb_'

export default function abilityTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let parameter = {
          bundleName: "ohos.samples.distributedrdb",
          abilityName: "EntryAbility"
      }
      var abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      await abilityDelegator.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end')
      })
    })
    /**
     * 点击允许授权
     */
    it(BUNDLE + 'ClickAcceptFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAcceptFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAcceptFunction_001 clickAccept')
      // 点击允许
      await driver.assertComponentExist(BY.text('允许'))
      let btnAccept = await driver.findComponent(BY.text('允许'))
      await btnAccept.click()
      await driver.delayMs(3000)
    })
    /**
     * 点击添加按钮添加联系人
     */
    it(BUNDLE + 'AddContactFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddContactFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddContactFunction_001 clickAddBtn')
      // 点击添加按钮
      await driver.assertComponentExist(BY.key('btnAdd'))
      let btnAdd = await driver.findComponent(BY.key('btnAdd'))
      await driver.delayMs(3000)
      await btnAdd.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddContactFunction_001 end')
    })
  })
}