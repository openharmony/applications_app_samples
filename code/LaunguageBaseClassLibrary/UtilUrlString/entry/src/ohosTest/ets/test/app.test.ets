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

const TAG = '[Sample_UtilUrlString]'
const DOMAIN = 0xF811
const BUNDLE = 'UtilUrlString_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.etsurlstring",
          abilityName: "ohos.samples.etsurlstring.MainAbility"
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
     * 点击按钮显示对应操作结果
     */
    it(BUNDLE + 'ClickUrlStringBtnFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBtnFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBtnFunction_001 clickInsertKeyValuePairsBtn')
      // 点击插入键值对到查询字符串
      await driver.assertComponentExist(BY.text('插入键值对到查询字符串', MatchPattern.CONTAINS))
      let insertKeyValuePairs = await driver.findComponent(BY.text('插入键值对到查询字符串', MatchPattern.CONTAINS))
      await insertKeyValuePairs.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBtnFunction_001 clickDeleteKeyValuePairsBtn')
      // 点击删除键值对
      await driver.assertComponentExist(BY.text('删除键值对', MatchPattern.CONTAINS))
      let deleteKeyValuePairs = await driver.findComponent(BY.text('删除键值对', MatchPattern.CONTAINS))
      await deleteKeyValuePairs.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBtnFunction_001 clickGetFirstValueBtn')
      // 点击获取指定名称对应的第一个值
      await driver.assertComponentExist(BY.text('获取指定名称对应的第一个值', MatchPattern.CONTAINS))
      let getFirstValue = await driver.findComponent(BY.text('获取指定名称对应的第一个值', MatchPattern.CONTAINS))
      await getFirstValue.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBtnFunction_001 clickSetNewValue')
      // 点击设置键的新值
      await driver.assertComponentExist(BY.text('设置键的新值', MatchPattern.CONTAINS))
      let setNewValue = await driver.findComponent(BY.text('设置键的新值', MatchPattern.CONTAINS))
      await setNewValue.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBtnFunction_001 end')
    })
  })
}