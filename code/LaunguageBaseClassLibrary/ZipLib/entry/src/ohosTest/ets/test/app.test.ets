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

const TAG = '[Sample_ZipLib]'
const DOMAIN = 0xF811
const BUNDLE = 'ZipLib_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let parameter = {
        bundleName: "ohos.samples.ziplib",
        abilityName: "EntryAbility"
      }
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      abilityDelegator.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end')
      })
    })
    /**
     * 添加文件
     */
    it(BUNDLE + 'AddFileFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFileFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFileFunction_001 clickAddBtn')
      // 点击添加
      await driver.assertComponentExist(BY.key('addFileBtn'))
      let btnAdd = await driver.findComponent(BY.key('addFileBtn'))
      await driver.delayMs(3000)
      await btnAdd.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFileFunction_001 end')
    })
  })
}