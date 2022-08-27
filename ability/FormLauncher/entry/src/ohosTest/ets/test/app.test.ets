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

const TAG = '[Sample_FormLauncher]'
const DOMAIN = 0xF811
const BUNDLE = 'FormLauncher_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.MyLauncher",
          abilityName: "ohos.samples.MyLauncher.MainAbility"
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
     * 点击转换、更新、删除卡片
     */
    it(BUNDLE + 'ClickFormBtnFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickFormBtnFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickFormBtnFunction_001 clickCastTempFormBtn')
      // 点击castTempForm
      await driver.assertComponentExist(BY.key('castTempFormBtn'))
      let castTempForm = await driver.findComponent(BY.key('castTempFormBtn'))
      await castTempForm.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickFormBtnFunction_001 clickUpdateFormBtn')
      // 点击updateForm
      await driver.assertComponentExist(BY.key('updateFormBtn'))
      let updateForm = await driver.findComponent(BY.key('updateFormBtn'))
      await updateForm.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickFormBtnFunction_001 clickDeleteFormBtn')
      // 点击deleteForm
      await driver.assertComponentExist(BY.key('deleteFormBtn'))
      let deleteForm = await driver.findComponent(BY.key('deleteFormBtn'))
      await deleteForm.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickFormBtnFunction_001 end')
    })
  })
}