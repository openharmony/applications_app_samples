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
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry'
import hilog from '@ohos.hilog'

const TAG = '[Sample_Http]'
const DOMAIN = 0xF811
const BUNDLE = 'Http_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let want = {
        bundleName: "ohos.samples.http",
        abilityName: "MainAbility"
      }
      var abilityDelegator: any
      abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      await abilityDelegator.startAbility(want, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
      })
    })

     /**
       * Get  https://www.baidu.com
       */
    it(BUNDLE + 'GetFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 输入 GET
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetFunction_001 GetInput')
      await driver.assertComponentExist(BY.key('GET'))
      let textGet = await driver.findComponent(BY.key('GET'))
      await textGet.inputText("www.baidu.com")
      await textGet.getText()
      await driver.delayMs(1000)
      // 设置参数
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetFunction_001 set')
      await driver.assertComponentExist(BY.key('Key1'))
      let btnSet = await driver.findComponent(BY.key('Key1'))
      await btnSet.inputText('revidx')
      let valGetTwo = await btnSet.getText()
      expect('revidx').assertEqual(valGetTwo)
      await driver.delayMs(1000)
      // 参数value1
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetFunction_001 valueInput1')
      await driver.assertComponentExist(BY.key('Value1'))
      let textValue1 = await driver.findComponent(BY.key('Value1'))
      await textValue1.inputText('2')
      let valValue1 = await textValue1.getText()
      expect('2').assertEqual(valValue1)
      await driver.delayMs(1000)
      // 增加参数
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetFunction_001 add')
      await driver.assertComponentExist(BY.key('add'))
      let btnAdd = await driver.findComponent(BY.key('add'))
      await btnAdd.click()
      await driver.delayMs(1000)
      // 参数key2
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetFunction_001 keyInput2')

      await driver.assertComponentExist(BY.key('Key2'))
      let textKey2 = await driver.findComponent(BY.key('Key2'))
      await textKey2.inputText('hisfilter')
      let valKey2 = await textKey2.getText()
      expect('hisfilter').assertEqual(valKey2)
      await driver.delayMs(1000)
      // 参数value2
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetFunction_001 valueInput2')
      await driver.assertComponentExist(BY.key('Value2'))
      let textValue2 = await driver.findComponent(BY.key('Value2'))
      await textValue2.inputText('1')
      let valValue2 = await textValue2.getText()
      expect('1').assertEqual(valValue2)
      await driver.delayMs(1000)
       // 减少参数
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetFunction_001 reduce')
      await driver.assertComponentExist(BY.key('reduce'))
      let btnReduce = await driver.findComponent(BY.key('reduce'))
      await btnReduce.click()
      await driver.delayMs(1000)
      // confirm
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetFunction_001 confirm')
      await driver.assertComponentExist(BY.key('submit'))
      let btnConfirm = await driver.findComponent(BY.key('submit'))
      await btnConfirm.click()
      await driver.delayMs(5000)
      // errorBack
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetFunction_001 errorBack')
      await driver.assertComponentExist(BY.key('errorBack'))
      let btnClear = await driver.findComponent(BY.key('errorBack'))
      await btnClear.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetFunction_001 end')
    })
  })
}