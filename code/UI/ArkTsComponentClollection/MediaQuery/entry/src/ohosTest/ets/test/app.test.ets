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
import { UiDriver, BY, UiComponent, MatchPattern } from '@ohos.uitest'
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry'
import hilog from '@ohos.hilog'

const TAG = '[Sample_MediaQuery]'
const DOMAIN = 0xF811
const BUNDLE = 'MediaQuery_'

export default function appTest() {
  describe('appTest', function () {
    it('testClick_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let parameter = {
        bundleName: 'ohos.samples.mediaquery',
        abilityName: 'EntryAbility'
      }
      let abilityDelegator: AbilityDelegatorRegistry.AbilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      await abilityDelegator.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
      })
    })

    /**
     * 进入应用
     */
    it(BUNDLE + 'CreateFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 点击冬日养猫日常
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_001 newTitle1')
      await driver.assertComponentExist(BY.text('冬日养猫日常', MatchPattern.CONTAINS))
      let newTitle1 = await driver.findComponent(BY.text('冬日养猫日常', MatchPattern.CONTAINS))
      await newTitle1.click()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(2000)
      // 点击冬奥美食记
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_001 newTitle2')
      await driver.assertComponentExist(BY.text('冬奥美食记', MatchPattern.CONTAINS))
      let newTitle2 = await driver.findComponent(BY.text('冬奥美食记', MatchPattern.CONTAINS))
      await newTitle2.click()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(2000)
      // 点击疫情期间你在干什么
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_001 newTitle3')
      await driver.assertComponentExist(BY.text('疫情期间你在干什么', MatchPattern.CONTAINS))
      let newTitle3 = await driver.findComponent(BY.text('疫情期间你在干什么', MatchPattern.CONTAINS))
      await newTitle3.click()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(2000)
      // 点击精致女人穿搭技巧
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_001 newTitle4')
      await driver.assertComponentExist(BY.text('精致女人穿搭技巧', MatchPattern.CONTAINS))
      let newTitle4 = await driver.findComponent(BY.text('精致女人穿搭技巧', MatchPattern.CONTAINS))
      await newTitle4.click()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(2000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_001 end')
    })
  })
}