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
import hilog from '@ohos.hilog'

const TAG = '[Sample_FormExtAbility]'
const DOMAIN = 0xF811
const BUNDLE = 'FormExtAbility_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let want = {
        bundleName: "ohos.samples.FormApplication",
        abilityName: "ohos.samples.FormApplication.MainAbility"
      }
      globalThis.abilityContext.startAbility(want, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end')
      })
    })
    /**
     * 添加卡片
     */
    it(BUNDLE + 'AddCardFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddCardFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 退出应用
      await driver.pressHome()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddCardFunction_001 longClickApp')
      // 长按应用
      await driver.assertComponentExist(BY.text('eTSFormExtAbility', MatchPattern.CONTAINS))
      let eTSFormExtAbility = await driver.findComponent(BY.text('eTSFormExtAbility', MatchPattern.CONTAINS))
      await eTSFormExtAbility.longClick()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddCardFunction_001 clickServiceCard')
      // 点击服务卡片
      await driver.assertComponentExist(BY.text('服务卡片', MatchPattern.CONTAINS))
      let serviceCard = await driver.findComponent(BY.text('服务卡片', MatchPattern.CONTAINS))
      await serviceCard.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddCardFunction_001 clickAddToDesktop')
      // 点击添加到桌面
      await driver.assertComponentExist(BY.text('添加到桌面', MatchPattern.CONTAINS))
      let addToDesktop = await driver.findComponent(BY.text('添加到桌面', MatchPattern.CONTAINS))
      await addToDesktop.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddCardFunction_001 end')
    })
  })
}