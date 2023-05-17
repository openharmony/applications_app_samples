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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { Driver, ON, Component, MatchPattern } from '@ohos.UiTest'
import Logger from '../util/Logger'

const BUNDLE = 'Game2048'
const TAG = '[Sample_Game2048]'

export default function appTest() {
  describe('ActsAbilityTest', function () {
    /**
     * 拉起一个Ability
     */
    it(BUNDLE + '_startAbility', 0, async function (done) {
      Logger.info(TAG, BUNDLE + '_startAbility start')
      let parameter = {
        bundleName: "ohos.samples.game2048",
        abilityName: "EntryAbility"
      }
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      abilityDelegator.startAbility(parameter, (err, data) => {
        Logger.info(TAG, BUNDLE + '_startAbility get err ' + JSON.stringify(err))
        expect(err).assertNull()
      })
      Logger.info(TAG, BUNDLE + '_startAbility end')
      done()
    })

    /**
     * 点击开始游戏
     */
    it(BUNDLE + '_IndexPage_StartGame', 0, async () => {
      Logger.info(TAG, BUNDLE + "_IndexPage_StartGame start")
      let driver = Driver.create()
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.id('startGame'))
      let startBtn = await driver.findComponent(ON.id('startGame'))
      await startBtn.click()
      Logger.info(TAG, BUNDLE + "_IndexPage_StartGame end")
    })
  })
}