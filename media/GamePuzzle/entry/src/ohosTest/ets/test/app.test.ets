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
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry'
import { UiDriver, BY, UiComponent, MatchPattern } from '@ohos.uitest'
import featureAbility from '@ohos.ability.featureAbility'
import hilog from '@ohos.hilog'

const TAG = '[Sample_GamePuzzle]'
const DOMAIN = 0xF811
const BUNDLE = 'GamePuzzle_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      let want = {
        bundleName: "ohos.samples.gamepuzzle",
        abilityName: "MainAbility"
      }
      var abilityDelegator: any
      abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      abilityDelegator.startAbility(want, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
      })
    })

    /**
     * 进入页面
     */
    it(BUNDLE + 'CreateFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 点击允许进入
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_001 enter')
      await driver.assertComponentExist(BY.text('允许'))
      let btnCreate = await driver.findComponent(BY.text('允许'))
      await btnCreate.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_001 end')
    })
  })
}