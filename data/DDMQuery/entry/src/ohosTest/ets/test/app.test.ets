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

const TAG = '[Sample_DDMQuery]'
const DOMAIN = -0xF811
const BUNDLE = 'DDMQuery_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.etsddmquery",
          abilityName: "ohos.samples.etsddmquery.MainAbility"
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
     * 添加数据并按指定结果查询
     */
    it(BUNDLE + 'AddDataAndQueryFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddDataAndQueryFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddDataAndQueryFunction_001 addData')
      // 点击添加数据
      await driver.assertComponentExist(BY.text('添加数据', MatchPattern.CONTAINS))
      let btnAddData = await driver.findComponent(BY.text('添加数据', MatchPattern.CONTAINS))
      await btnAddData.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddDataAndQueryFunction_001 queryResult')
      // 点击查询指定字段结果集
      await driver.assertComponentExist(BY.text('查询指定字段结果集', MatchPattern.CONTAINS))
      let btnQueryResult = await driver.findComponent(BY.text('查询指定字段结果集', MatchPattern.CONTAINS))
      await btnQueryResult.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddDataAndQueryFunction_001 querySpecifiedValue')
      // 点击查询指定值条目
      await driver.assertComponentExist(BY.text('查询指定值条目', MatchPattern.CONTAINS))
      let btnQuerySpecifiedValue = await driver.findComponent(BY.text('查询指定值条目', MatchPattern.CONTAINS))
      await btnQuerySpecifiedValue.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddDataAndQueryFunction_001 queryResDescOrder')
      // 点击查询结果降序
      await driver.assertComponentExist(BY.text('查询結果降序', MatchPattern.CONTAINS))
      let btnQueryResDescOrder = await driver.findComponent(BY.text('查询結果降序', MatchPattern.CONTAINS))
      await btnQueryResDescOrder.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddDataAndQueryFunction_001 queryConditional')
      // 点击与条件查询
      await driver.assertComponentExist(BY.text('与条件查询', MatchPattern.CONTAINS))
      let btnQueryConditional = await driver.findComponent(BY.text('与条件查询', MatchPattern.CONTAINS))
      await btnQueryConditional.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddDataAndQueryFunction_001 querySmallerValue')
      // 点击查询小于指定值
      await driver.assertComponentExist(BY.text('查询小于指定值', MatchPattern.CONTAINS))
      let btnQuerySmallerValue = await driver.findComponent(BY.text('查询小于指定值', MatchPattern.CONTAINS))
      await btnQuerySmallerValue.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddDataAndQueryFunction_001 end')
    })
  })
}