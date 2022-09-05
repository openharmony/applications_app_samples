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

const TAG = '[Sample_UtilScope]'
const DOMAIN = 0xF811
const BUNDLE = 'UtilScope_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.etsutilscope",
          abilityName: "ohos.samples.etsutilscope.MainAbility"
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
     * 输入年龄，判断年龄是否符合工作年龄限制
     */
    it(BUNDLE + 'CheckAgeFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckAgeFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckAgeFunction_001 inputAge')
      // 输入年龄
      await driver.assertComponentExist(BY.key('inputAge'))
      let ageInput = await driver.findComponent(BY.key('inputAge'))
      await ageInput.inputText('18')
      let valAge = await ageInput.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckAgeFunction_001 valAge')
      expect('18').assertEqual(valAge)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckAgeFunction_001 clickAgeAnalysis')
      // 点击年龄分析
      await driver.assertComponentExist(BY.key('ageAnalysis'))
      let ageAnalysisBtn = await driver.findComponent(BY.key('ageAnalysis'))
      await ageAnalysisBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckAgeFunction_001 clickConfirm')
      // 点击确定
      await driver.assertComponentExist(BY.text('确定'))
      let ageConfirmBtn = await driver.findComponent(BY.text('确定'))
      await ageConfirmBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckAgeFunction_001 end')
    })
    /**
     * 输入早、午、晚体温，判断体温是否在正常范围
     */
    it(BUNDLE + 'CheckTemperatureFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckTemperatureFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckTemperatureFunction_001 inputMorningTemperature')
      // 输入早上体温
      await driver.assertComponentExist(BY.key('morningTemperature'))
      let morningTemperature = await driver.findComponent(BY.key('morningTemperature'))
      await morningTemperature.inputText('36')
      let valMorning = await morningTemperature.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckTemperatureFunction_001 valMorning')
      expect('36').assertEqual(valMorning)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckTemperatureFunction_001 inputNoonTemperature')
      // 输入中午体温
      await driver.assertComponentExist(BY.key('noonTemperature'))
      let noonTemperature = await driver.findComponent(BY.key('noonTemperature'))
      await noonTemperature.inputText('36')
      let valNoon = await morningTemperature.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckTemperatureFunction_001 valNoon')
      expect('36').assertEqual(valNoon)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckTemperatureFunction_001 inputNightTemperature')
      // 输入晚上体温
      await driver.assertComponentExist(BY.key('nightTemperature'))
      let nightTemperature = await driver.findComponent(BY.key('nightTemperature'))
      await nightTemperature.inputText('36')
      let valNight = await morningTemperature.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckTemperatureFunction_001 valNight')
      expect('36').assertEqual(valNight)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckTemperatureFunction_001 clickTemperatureAnalysis')
      // 点击体温分析
      await driver.assertComponentExist(BY.key('temperatureAnalysis'))
      let temperatureAnalysisBtn = await driver.findComponent(BY.key('temperatureAnalysis'))
      await temperatureAnalysisBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckTemperatureFunction_001 clickConfirm')
      // 点击确定
      await driver.assertComponentExist(BY.text('确定'))
      let temperatureConfirmBtn = await driver.findComponent(BY.text('确定'))
      await temperatureConfirmBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckTemperatureFunction_001 end')
    })
    /**
     * 输入最长睡眠时间、最短睡眠时间，判断睡眠是否充足
     */
    it(BUNDLE + 'CheckSleepFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckSleepFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckSleepFunction_001 inputShortestSleepTime')
      // 输入最短睡眠时间
      await driver.assertComponentExist(BY.key('shortestSleepTime'))
      let shortestSleepTime = await driver.findComponent(BY.key('shortestSleepTime'))
      await shortestSleepTime.inputText('6')
      let valShortestTime = await shortestSleepTime.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckSleepFunction_001 valShortestTime')
      expect('6').assertEqual(valShortestTime)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckSleepFunction_001 inputLongestSleepTime')
      // 输入最长睡眠时间
      await driver.assertComponentExist(BY.key('longestSleepTime'))
      let longestSleepTime = await driver.findComponent(BY.key('longestSleepTime'))
      await longestSleepTime.inputText('8')
      let valLongestTime = await longestSleepTime.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckSleepFunction_001 valLongestTime')
      expect('8').assertEqual(valLongestTime)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckSleepFunction_001 clickSleepAnalysis')
      // 点击睡眠分析
      await driver.assertComponentExist(BY.key('sleepAnalysis'))
      let sleepAnalysisBtn = await driver.findComponent(BY.key('sleepAnalysis'))
      await sleepAnalysisBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckSleepFunction_001 clickConfirm')
      // 点击确定
      let sleepTimeConfirmBtn = await driver.findComponent(BY.text('确定'))
      await sleepTimeConfirmBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckSleepFunction_001 end')
    })
  })
}