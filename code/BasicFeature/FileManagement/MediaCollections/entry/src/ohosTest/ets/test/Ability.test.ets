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
import { Driver, ON } from '@ohos.UiTest'
import Logger from '../utils/Logger'

const BUNDLE = 'MediaCollectionTest_'
const TAG = '[Sample_MediaCollection_Test]'

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    /**
     * 拉起一个ability
     */
    it(BUNDLE + 'startAbility_001', 0, async (done) => {
      Logger.info(TAG, 'StartAbility start')
      let driver = await Driver.create()
      let want = {
        bundleName: 'com.example.sampledemo',
        abilityName: 'MainAbility'
      }
      let abilityDelegator = await AbilityDelegatorRegistry.getAbilityDelegator()
      await driver.delayMs(1000)
      await abilityDelegator.startAbility(want, (err, data) => {
        expect(err).assertNull()
        Logger.info(TAG, 'StartAbility get err ' + JSON.stringify(err))
      })
      await driver.delayMs(1000)
      Logger.info(TAG, 'StartAbility end')
      done()
    })

    /**
     * 获取权限
     */
    it(BUNDLE + 'getPermission_001', 1, async (done) => {
      Logger.info(TAG, 'getPermission_001 start')
      let driver = await Driver.create()
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.allow'))))
      let agree = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.allow'))))
      await agree.click()
      await driver.delayMs(1000)
      agree = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.allow'))))
      await expect(agree).assertNull()
      Logger.info(TAG, 'getPermission_001 end')
      done()
    })

    /**
     * 检查界面是否正常显示
     */
    it(BUNDLE + 'getPermission_001', 2, async (done) => {
      Logger.info(TAG, 'getPermission_001 start')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.id('search'))
      await driver.delayMs(200)
      await driver.assertComponentExist(ON.id('music'))
      await driver.delayMs(200)
      await driver.assertComponentExist(ON.id('video'))
      await driver.delayMs(200)
      await driver.assertComponentExist(ON.id('favorite'))
      await driver.delayMs(200)
      await driver.assertComponentExist(ON.id('me'))
      await driver.delayMs(200)
      await driver.assertComponentExist(ON.id('search'))
      await driver.delayMs(1000)
      Logger.info(TAG, 'getPermission_001 end')
      done()
    })
  })
}