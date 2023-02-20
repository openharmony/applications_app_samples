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

const BUNDLE = 'Game2048'
const TAG = '[Sample_Game2048]'
const DOMAIN = 0xF811

export default function appTest() {
  describe('appTest', function () {
    /**
     * 拉起一个Ability
     */
    it(BUNDLE + '_startAbility', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + '_startAbility start')
      let parameter = {
        bundleName: "ohos.samples.game2048",
        abilityName: "EntryAbility"
      }
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      await abilityDelegator.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + '_startAbility get err ' + JSON.stringify(err))
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + '_startAbility end')
      })
    })
    /**
     * 点击开始游戏
     */
    it(BUNDLE + '_IndexPage_StartGame', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_StartGame start")
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      await driver.assertComponentExist(BY.key('startGame'))
      let startBtn = await driver.findComponent(BY.key('startGame'))
      await startBtn.click()
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_StartGame end")
    })
  })
}