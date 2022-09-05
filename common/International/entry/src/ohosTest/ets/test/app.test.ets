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

const TAG = '[Sample_International]'
const DOMAIN = 0xF811
const BUNDLE = 'International_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.international",
          abilityName: "ohos.samples.international.MainAbility"
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
     * 语言和地区
     */
    it(BUNDLE + 'LanguageRegionFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'LanguageRegionFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 点击语言和地区
      hilog.info(DOMAIN, TAG, BUNDLE + 'LanguageRegionFunction_001 enter')
      await driver.assertComponentExist(BY.text('语言和地区', MatchPattern.CONTAINS))
      let languageRegion = await driver.findComponent(BY.text('语言和地区', MatchPattern.CONTAINS))
      await languageRegion.click()
      await driver.delayMs(1000)
      // 添加语言
      hilog.info(DOMAIN, TAG, BUNDLE + 'LanguageRegionFunction_001 add')
      await driver.assertComponentExist(BY.text('添加语言', MatchPattern.CONTAINS))
      let btnAdd = await driver.findComponent(BY.text('添加语言', MatchPattern.CONTAINS))
      await btnAdd.click()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(2000)
      // 编辑
      hilog.info(DOMAIN, TAG, BUNDLE + 'LanguageRegionFunction_001 edit')
      await driver.assertComponentExist(BY.key('edit'))
      let btnEdit = await driver.findComponent(BY.key('edit'))
      await btnEdit.click()
      await driver.delayMs(1000)
      // 确认
      hilog.info(DOMAIN, TAG, BUNDLE + 'LanguageRegionFunction_001 check')
      await driver.assertComponentExist(BY.key('check'))
      let btnCheck = await driver.findComponent(BY.key('check'))
      await btnCheck.click()
      await driver.delayMs(2000)
      // 当前地区
      hilog.info(DOMAIN, TAG, BUNDLE + 'LanguageRegionFunction_001 currentRegion')
      await driver.assertComponentExist(BY.text('当前地区', MatchPattern.CONTAINS))
      let btnCurrentRegion = await driver.findComponent(BY.text('当前地区', MatchPattern.CONTAINS))
      await btnCurrentRegion.click()
      await driver.delayMs(1000)
      // 选择地区
      hilog.info(DOMAIN, TAG, BUNDLE + 'LanguageRegionFunction_001 selectRegion')
      await driver.assertComponentExist(BY.text('选择地区', MatchPattern.CONTAINS))
      let btnSelectRegion = await driver.findComponent(BY.text('选择地区', MatchPattern.CONTAINS))
      await btnSelectRegion.click()
      await driver.delayMs(1000)
      // 选择新加坡
      hilog.info(DOMAIN, TAG, BUNDLE + 'LanguageRegionFunction_001 selected')
      await driver.assertComponentExist(BY.text('新加坡', MatchPattern.CONTAINS))
      let btnSelected = await driver.findComponent(BY.text('新加坡', MatchPattern.CONTAINS))
      await btnSelected.click()
      await driver.delayMs(500)
      await driver.pressBack()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'LanguageRegionFunction_001 end')
    })

    /**
     * 日期和时间
     */
    it(BUNDLE + 'DateTimeFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DateTimeFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(2000)
      // 点击日期和时间
      hilog.info(DOMAIN, TAG, BUNDLE + 'DateTimeFunction_001 enter')
      await driver.assertComponentExist(BY.text('日期和时间', MatchPattern.CONTAINS))
      let dateTime = await driver.findComponent(BY.text('日期和时间', MatchPattern.CONTAINS))
      await dateTime.click()
      await driver.delayMs(1000)
      console.log("Sample_International 32")
      // 开启24小时制
      hilog.info(DOMAIN, TAG, BUNDLE + 'DateTimeFunction_001 toggleClick')
      await driver.assertComponentExist(BY.type('Toggle'))
      let btnHours24 = await driver.findComponent(BY.type('Toggle'))
      await btnHours24.click()
      await driver.delayMs(2000)
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'DateTimeFunction_001 end')
    })

    /**
     * 区域格式示例
     */
    it(BUNDLE + 'FormatExampleFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'FormatExampleFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 点击区域格式示例
      hilog.info(DOMAIN, TAG, BUNDLE + 'FormatExampleFunction_001 enter')
      await driver.assertComponentExist(BY.text('区域格式示例', MatchPattern.CONTAINS))
      let formatExample = await driver.findComponent(BY.text('区域格式示例', MatchPattern.CONTAINS))
      await formatExample.click()
      await driver.delayMs(2000)
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'FormatExampleFunction_001 end')
    })
  })
}