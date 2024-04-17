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
import { Driver, ON } from '@ohos.UiTest'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import Logger from '../utils/Logger'

const TAG = '[Sample_DeviceUsageStatistics]'
const BUNDLE = 'DeviceUsageStatistics_'

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      Logger.info( TAG, BUNDLE + 'StartAbility_001 begin')
      let driver = Driver.create()
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      await abilityDelegator.startAbility({
        bundleName: "ohos.samples.deviceusage",
        abilityName: "EntryAbility"
      }, (err, data) => {
        expect(err).assertNull()
        Logger.info(TAG, BUNDLE + 'StartAbility_001,err:' + JSON.stringify(err))
      })
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'StartAbility_001 end')
      done()
    })

    /**
     * 应用使用时长
     */
    it(BUNDLE + 'AppStatistics_001', 1, async () => {
      Logger.info(TAG, BUNDLE + 'AppStatistics_001 begin')
      let driver = await Driver.create()
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.application_duration'))))
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'AppStatistics_001 end')
    })

    /**
     * 不常用应用
     */
    it(BUNDLE + 'FreeApps_001', 2, async () => {
      Logger.info(TAG, BUNDLE + 'FreeApps_001 begin')
      let driver = await Driver.create()
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager
      await driver.fling({
        x: 500, y: 480
      }, {
        x: 500, y: 200
      }, 5, 1200)
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.free_apps'))))
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'FreeApps_001 end')
    })
  })
}