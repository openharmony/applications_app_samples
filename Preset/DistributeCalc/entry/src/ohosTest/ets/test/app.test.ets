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

const TAG = '[Sample_DistributeCalc]'
const DOMAIN = 0xF811
const BUNDLE = 'DistributeCalc_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.etsdistributecalc",
          abilityName: "ohos.samples.etsdistributecalc.MainAbility"
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
     * 进入页面
     */
    it(BUNDLE + 'EnterFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(2000)
      console.log("Sample_DistributeCalc 21")
      // enter
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFunction_001 enter')
      await driver.assertComponentExist(BY.text('允许', MatchPattern.CONTAINS))
      let btnEnter = await driver.findComponent(BY.text('允许', MatchPattern.CONTAINS))
      await btnEnter.click()
      await driver.delayMs(1000)
      // ic_hop click  tabBar
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFunction_001 dialogClick')
      await driver.assertComponentExist(BY.key('hop'))
      let showDialog = await driver.findComponent(BY.key('hop'))
      await showDialog.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFunction_001 end')
    })

    /**
     * 计算7+8的结果
     */
    it(BUNDLE + 'AddFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 7
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 number7')
      await driver.assertComponentExist(BY.key('7'))
      let Number7 = await driver.findComponent(BY.key('7'))
      await Number7.click()
      await driver.delayMs(1000)
      // +
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 add')
      await driver.assertComponentExist(BY.key('+'))
      let obtainImgLAdd = await driver.findComponent(BY.key('+'))
      await obtainImgLAdd.click()
      await driver.delayMs(1000)
      // 8
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 number8')
      await driver.assertComponentExist(BY.key('8'))
      let Number8 = await driver.findComponent(BY.key('8'))
      await Number8.click()
      await driver.delayMs(1000)
      // =
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 equal')
      await driver.assertComponentExist(BY.key('='))
      let obtainImgEqual = await driver.findComponent(BY.key('='))
      await obtainImgEqual.click()
      await driver.delayMs(1000)
      // C  clear
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 clear')
      await driver.assertComponentExist(BY.key('C'))
      let obtainImgClear = await driver.findComponent(BY.key('C'))
      await obtainImgClear.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 end')
    })

    /**
     * 计算9/3的结果
     */
    it(BUNDLE + 'DivisionFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DivisionFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 9
      hilog.info(DOMAIN, TAG, BUNDLE + 'DivisionFunction_001 number9')
      await driver.assertComponentExist(BY.key('9'))
      let Number9 = await driver.findComponent(BY.key('9'))
      await Number9.click()
      await driver.delayMs(1000)
      // /
      hilog.info(DOMAIN, TAG, BUNDLE + 'DivisionFunction_001 division')
      await driver.assertComponentExist(BY.key('/'))
      let obtainImgLevelDivision = await driver.findComponent(BY.key('/'))
      await obtainImgLevelDivision.click()
      await driver.delayMs(1000)
      // 3
      hilog.info(DOMAIN, TAG, BUNDLE + 'DivisionFunction_001 number3')
      await driver.assertComponentExist(BY.key('3'))
      let Number3 = await driver.findComponent(BY.key('3'))
      await Number3.click()
      await driver.delayMs(1000)
      // =
      hilog.info(DOMAIN, TAG, BUNDLE + 'DivisionFunction_001 equal')
      await driver.assertComponentExist(BY.key('='))
      let obtainImgEqual = await driver.findComponent(BY.key('='))
      await obtainImgEqual.click()
      await driver.delayMs(1000)
      // C
      hilog.info(DOMAIN, TAG, BUNDLE + 'DivisionFunction_001 clear')
      await driver.assertComponentExist(BY.key('C'))
      let obtainImgClear = await driver.findComponent(BY.key('C'))
      await obtainImgClear.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'DivisionFunction_001 end')
    })
  })
}