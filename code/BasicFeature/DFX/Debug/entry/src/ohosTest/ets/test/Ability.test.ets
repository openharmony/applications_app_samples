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
import { Driver, ON, MatchPattern } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import Logger from '../../../main/ets/data/Logger'

const BUNDLE = "Debug"
const TAG: string = '[Sample_Debug]'

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 拉起应用
     */
    it('StartAbility_001', 0 , async (done : () => void) => {
      Logger.info(TAG, BUNDLE + 'StartAbility_001 begin')
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.debug',
          abilityName: 'MainAbility'
        })
        done()
      } catch (exception) {
        expect(0).assertEqual(exception.code)
        Logger.info(TAG, `StartAbility end ${JSON.stringify(exception)}`)
        done()
      }
      Logger.info(TAG, BUNDLE + 'StartAbility_001 end')
    })
    /**
     * debug信息界面显示
     */
    it('ShowInfoFunction_001', 0, async () => {
      Logger.info(TAG, BUNDLE + 'ShowInfoFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      // 点击Debug按钮
      await driver.assertComponentExist(ON.id('btnDebug'))
      let btnDebug = await driver.findComponent(ON.id('btnDebug'))
      await btnDebug.click()
      // 弹出Debug信息界面
      await driver.assertComponentExist(ON.id('debugInfo'))
      await driver.assertComponentExist(ON.id('title'))
      await driver.assertComponentExist(ON.id('storageSize'))
      Logger.info(TAG, BUNDLE + 'ShowInfoFunction_001 end')
    })
    /**
     * debug信息界面隐藏
     */
    it('ShowInfoFunction_002', 0, async () => {
      Logger.info(TAG, BUNDLE + 'ShowInfoFunction_002 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      // 点击Debug按钮，隐藏Debug信息界面
      await driver.assertComponentExist(ON.id('btnDebug'))
      let btnDebug = await driver.findComponent(ON.id('btnDebug'))
      await btnDebug.click()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'ShowInfoFunction_002 end')
    })
  })
}
