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
import { Driver, ON, MatchPattern } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import hilog from '@ohos.hilog'

const TAG: string = '[Sample_UtilScope]'
const DOMAIN = 0xF811
const BUNDLE = 'UtilScope_'

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.utilscope',
            abilityName: 'EntryAbility'
        })
        done()
      } catch (expection) {
        expect(0).assertEqual(expection.code)
        hilog.info(DOMAIN, TAG, 'StartAbility end err:' + JSON.stringify(expection))
        done()
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
    })

    /**
     * 输入年龄，判断年龄是否符合工作年龄限制
     */
    it(BUNDLE + 'CheckAgeFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckAgeFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      // 输入年龄
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckAgeFunction_001 inputAge')
      await driver.assertComponentExist(ON.id('inputAge'))
      let ageInput = await driver.findComponent(ON.id('inputAge'))
      await ageInput.inputText('18')
      let valAge = await ageInput.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckAgeFunction_001 valAge=' + valAge)
      expect('18').assertEqual(valAge)
      // 点击年龄分析
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckAgeFunction_001 clickAgeAnalysis')
      await driver.assertComponentExist(ON.id('ageAnalysis'))
      let ageAnalysisBtn = await driver.findComponent(ON.id('ageAnalysis'))
      await ageAnalysisBtn.click()
      // 点击确定
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckAgeFunction_001 clickConfirm')
      await driver.assertComponentExist(ON.text('确定'))
      let ageConfirmBtn = await driver.findComponent(ON.text('确定'))
      await ageConfirmBtn.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckAgeFunction_001 end')
    })

    /**
     * 输入早、午、晚体温，判断体温是否在正常范围
     */
    it(BUNDLE + 'CheckTemperatureFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckTemperatureFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      // 输入早上体温
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckTemperatureFunction_001 inputMorningTemperature')
      await driver.assertComponentExist(ON.id('morningTemperature'))
      let morningTemperature = await driver.findComponent(ON.id('morningTemperature'))
      await morningTemperature.inputText('36')
      let valMorning = await morningTemperature.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckTemperatureFunction_001 valMorning=' + valMorning)
      expect('36').assertEqual(valMorning)
      // 输入中午体温
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckTemperatureFunction_001 inputNoonTemperature')
      await driver.assertComponentExist(ON.id('noonTemperature'))
      let noonTemperature = await driver.findComponent(ON.id('noonTemperature'))
      await noonTemperature.inputText('36')
      let valNoon = await morningTemperature.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckTemperatureFunction_001 valNoon=' + valNoon)
      expect('36').assertEqual(valNoon)
      // 输入晚上体温
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckTemperatureFunction_001 inputNightTemperature')
      await driver.assertComponentExist(ON.id('nightTemperature'))
      let nightTemperature = await driver.findComponent(ON.id('nightTemperature'))
      await nightTemperature.inputText('36')
      let valNight = await morningTemperature.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckTemperatureFunction_001 valNight=' + valNight)
      expect('36').assertEqual(valNight)
      // 点击体温分析
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckTemperatureFunction_001 clickTemperatureAnalysis')
      await driver.assertComponentExist(ON.id('temperatureAnalysis'))
      let temperatureAnalysisBtn = await driver.findComponent(ON.id('temperatureAnalysis'))
      await temperatureAnalysisBtn.click()
      // 点击确定
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckTemperatureFunction_001 clickConfirm')
      await driver.assertComponentExist(ON.text('确定'))
      let temperatureConfirmBtn = await driver.findComponent(ON.text('确定'))
      await temperatureConfirmBtn.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckTemperatureFunction_001 end')
    })

    /**
     * 输入最长睡眠时间、最短睡眠时间，判断睡眠是否充足
     */
    it(BUNDLE + 'CheckSleepFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckSleepFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      // 输入最短睡眠时间
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckSleepFunction_001 inputShortestSleepTime')
      await driver.assertComponentExist(ON.id('shortestSleepTime'))
      let shortestSleepTime = await driver.findComponent(ON.id('shortestSleepTime'))
      await shortestSleepTime.inputText('6')
      let valShortestTime = await shortestSleepTime.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckSleepFunction_001 valShortestTime=' + valShortestTime)
      expect('6').assertEqual(valShortestTime)
      // 输入最长睡眠时间
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckSleepFunction_001 inputLongestSleepTime')
      await driver.assertComponentExist(ON.id('longestSleepTime'))
      let longestSleepTime = await driver.findComponent(ON.id('longestSleepTime'))
      await longestSleepTime.inputText('8')
      let valLongestTime = await longestSleepTime.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckSleepFunction_001 valLongestTime=' + valLongestTime)
      expect('8').assertEqual(valLongestTime)
      // 点击睡眠分析
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckSleepFunction_001 clickSleepAnalysis')
      await driver.assertComponentExist(ON.id('sleepAnalysis'))
      let sleepAnalysisBtn = await driver.findComponent(ON.id('sleepAnalysis'))
      await sleepAnalysisBtn.click()
      // 点击确定
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckSleepFunction_001 clickConfirm')
      let sleepTimeConfirmBtn = await driver.findComponent(ON.text('确定'))
      await sleepTimeConfirmBtn.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckSleepFunction_001 end')
    })
  })
}