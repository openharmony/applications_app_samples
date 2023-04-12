/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

const TAG = '[Sample_UtilRationalNumber]'
const DOMAIN = 0xF811
const BUNDLE = 'UtilRationalNumber_'

export default function abilityTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      await abilityDelegator.startAbility({
        bundleName: "ohos.samples.utilrationalnumber",
        abilityName: "EntryAbility"
      }, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end')
      })
    })
    /**
     * 点击对应的有理数按钮，文本框显示对应操作结果
     */
    it(BUNDLE + 'ClickRationalNumberBtnFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickRationalNumberBtnFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickRationalNumberBtnFunction_001 clickCompareBtn')
      // 点击有理数比较
      await driver.assertComponentExist(BY.text('有理数比较', MatchPattern.CONTAINS))
      let compareBtn = await driver.findComponent(BY.text('有理数比较', MatchPattern.CONTAINS))
      await compareBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickRationalNumberBtnFunction_001 clickGetValueOfRationalNumberBtn')
      // 点击获取有理数的值
      await driver.assertComponentExist(BY.text('获取有理数的值', MatchPattern.CONTAINS))
      let getValueOfRationalNum = await driver.findComponent(BY.text('获取有理数的值', MatchPattern.CONTAINS))
      await getValueOfRationalNum.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickRationalNumberBtnFunction_001 clickGetDenominatorBtn')
      // 点击获取有理数分子分母
      await driver.assertComponentExist(BY.text('获取有理数分子分母', MatchPattern.CONTAINS))
      let getDenominator = await driver.findComponent(BY.text('获取有理数分子分母', MatchPattern.CONTAINS))
      await getDenominator.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickRationalNumberBtnFunction_001 clickCheckIsZeroBtn')
      // 点击检查是否为0
      await driver.assertComponentExist(BY.text('检查是否为0', MatchPattern.CONTAINS))
      let isZero = await driver.findComponent(BY.text('检查是否为0', MatchPattern.CONTAINS))
      await isZero.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickRationalNumberBtnFunction_001 clickCheckIsNaNBtn')
      // 点击检查是否表示NaN
      await driver.assertComponentExist(BY.text('检查是否表示NaN', MatchPattern.CONTAINS))
      let isNaN = await driver.findComponent(BY.text('检查是否表示NaN', MatchPattern.CONTAINS))
      await isNaN.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickRationalNumberBtnFunction_001 clickCheckIsFiniteBtn')
      // 点击检查是否为有限值
      await driver.assertComponentExist(BY.text('检查是否为有限值', MatchPattern.CONTAINS))
      let isFinite = await driver.findComponent(BY.text('检查是否为有限值', MatchPattern.CONTAINS))
      await isFinite.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickRationalNumberBtnFunction_001 end')
    })
  })
}