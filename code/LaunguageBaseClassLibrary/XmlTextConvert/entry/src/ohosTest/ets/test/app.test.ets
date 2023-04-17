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

const TAG = '[Sample_XmlTextConvert]'
const DOMAIN = 0xF811
const BUNDLE = 'XmlTextConvert_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.etsxmltextconvert",
          abilityName: "ohos.samples.etsxmltextconvert.MainAbility"
        }
      }
      await featureAbility.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end')
      })
    })
    /**
     * 点击生成、解析、转换Xml
     */
    it(BUNDLE + 'ClickXmlFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickXmlFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickXmlFunction_001 clickSerializerXml')
      // 点击Xml生成
      await driver.assertComponentExist(BY.text('Xml 生成', MatchPattern.CONTAINS))
      let serializer = await driver.findComponent(BY.text('Xml 生成', MatchPattern.CONTAINS))
      await serializer.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickXmlFunction_001 clickParserXml')
      // 点击Xml解析
      await driver.assertComponentExist(BY.text('Xml 解析', MatchPattern.CONTAINS))
      let parser = await driver.findComponent(BY.text('Xml 解析', MatchPattern.CONTAINS))
      await parser.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickXmlFunction_001 clickConvertXml')
      // 点击Xml转换
      let convert = await driver.findComponent(BY.text('Xml 转换', MatchPattern.CONTAINS))
      await convert.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickXmlFunction_001 end')
    })
  })
}