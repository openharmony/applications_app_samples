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
import Want from '@ohos.app.ability.Want'

const BUNDLE = 'Setting'
const TAG = '[Sample_Setting]'

export default function appTest() {
  describe('appTest',  () => {
    /**
     * 拉起Ability
     */
    it(BUNDLE + '_startAbility', 0, async (done:Function) => {
      Logger.info(TAG, BUNDLE + '_startAbility start')
      let driver :Driver= await Driver.create()
      let want :Want= {
        bundleName: 'ohos.samples.settings',
        abilityName: 'MainAbility'
      }
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      let resourceManager = (await abilityDelegator.getCurrentTopAbility()).context.resourceManager
      await abilityDelegator.startAbility(want, (err, data) => {
        Logger.info(TAG, 'StartAbility get err ' + JSON.stringify(err))
        expect(err).assertNull()
      })
      await driver.delayMs(1000)
      let setting = await resourceManager.getStringValue($r('app.string.settings'))
      await driver.assertComponentExist(ON.text(setting))
      Logger.info(TAG, BUNDLE + '_startAbility end')
      done()
    })

    /**
     * 检查滑动窗口是否正常
     */
    it(BUNDLE + '_DragList', 1, async () => {
      Logger.info(TAG, BUNDLE + "_DragList start")
      let driver = await Driver.create()
      await driver.drag(100, 900, 100, 100, 100)
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      let resourceManager = (await abilityDelegator.getCurrentTopAbility()).context.resourceManager
      await driver.delayMs(1000)
      let systemTab = await resourceManager.getStringValue($r('app.string.systemTab'))
      await driver.assertComponentExist(ON.text(systemTab))
      let aboutTab = await resourceManager.getStringValue($r('app.string.aboutTab'))
      await driver.assertComponentExist(ON.text(aboutTab))
      await driver.delayMs(1000)
      await driver.drag(100, 300, 100, 900, 100)
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + "_DragList end")
    })

    /**
     * 检查WLAN模块
     */
    it(BUNDLE + '_WLAN', 2, async () => {
      Logger.info(TAG, BUNDLE + "_WLAN start")
      let driver = await Driver.create()
      await driver.assertComponentExist(ON.text('WLAN'))
      let wlanItem = await driver.findComponent(ON.text('WLAN'))
      await wlanItem.click()
      await driver.delayMs(1000)
      // 检查Switch开关是否正常
      await driver.assertComponentExist(ON.id('ToggleSwitch'))
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      let resourceManager = (await abilityDelegator.getCurrentTopAbility()).context.resourceManager
      let wifiTipConnectedWLAN = await resourceManager.getStringValue($r('app.string.wifiTipConnectedWLAN'))
      await driver.assertComponentExist(ON.text(wifiTipConnectedWLAN))
      let wifiTipValidWLAN = await resourceManager.getStringValue($r('app.string.wifiTipValidWLAN'))
      await driver.assertComponentExist(ON.text(wifiTipValidWLAN))
      let moreWlanSettings  = await resourceManager.getStringValue($r('app.string.moreWlanSettings'))
      await driver.assertComponentExist(ON.text(moreWlanSettings))
      let wlanSetting = await driver.findComponent(ON.text(moreWlanSettings))
      await wlanSetting.click()
      await driver.delayMs(1000)
      let wlanPlus = await resourceManager.getStringValue($r('app.string.wlanPlus'))
      await driver.assertComponentExist(ON.text(wlanPlus))
      let wlanDirect = await resourceManager.getStringValue($r('app.string.wlanDirect'))
      await driver.assertComponentExist(ON.text(wlanDirect))
      await driver.delayMs(1000)
      // 退回首页
      await driver.pressBack()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + "_WLAN end")
    })

    /**
     * 检查更多链接模块
     */
    it(BUNDLE + '_MoreConnection', 3, async () => {
      Logger.info(TAG, BUNDLE + "_MoreConnection start")
      let driver = await Driver.create()
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      let resourceManager = (await abilityDelegator.getCurrentTopAbility()).context.resourceManager
      let moreConnectionsTab = await resourceManager.getStringValue($r('app.string.moreConnectionsTab'))
      await driver.assertComponentExist(ON.text(moreConnectionsTab))
      let connection = await driver.findComponent(ON.text(moreConnectionsTab))
      await connection.click()
      await driver.delayMs(1000)
      let NFC = await resourceManager.getStringValue($r('app.string.NFC'))
      await driver.assertComponentExist(ON.text(NFC))
      let nfc = await driver.findComponent(ON.text(NFC))
      await nfc.click()
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.id('ToggleSwitch'))
      let toggleSwitch = await driver.findComponent(ON.id('ToggleSwitch'))
      await toggleSwitch.click()
      await driver.delayMs(1000)
      // 退回首页
      await driver.pressBack()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + "_MoreConnection end")
    })

    /**
     * 窗口分屏
     */
    it(BUNDLE + '_WindowSplit', 4, async () => {
      Logger.info(TAG, BUNDLE + "_WindowSplit start")
      let driver = await Driver.create()
      let window = await driver.findWindow({
        bundleName: 'ohos.samples.settings'
      })
      let boundsBefore = await window.getBounds()
      Logger.info(TAG, BUNDLE + JSON.stringify(boundsBefore))
      await window.split()
      await driver.delayMs(1000)
      let boundsAfter = await window.getBounds()
      Logger.info(TAG, BUNDLE + JSON.stringify(boundsAfter))
      expect(boundsBefore.bottom).assertLarger(boundsAfter.bottom)
      await driver.click(500, 500)
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + "_WindowSplit end")
    })

    /**
     * 窗口化
     */
    it(BUNDLE + '_WindowResume', 5, async (done:Function) => {
      Logger.info(TAG, BUNDLE + '_WindowResume start')
      let driver = await Driver.create()
      let window = await driver.findWindow({
        bundleName: 'ohos.samples.settings'
      })
      let boundsBefore = await window.getBounds()
      Logger.info(TAG, BUNDLE + JSON.stringify(boundsBefore))
      // 检查窗口化
      await window.resume()
      await driver.delayMs(1000)
      let boundsAfter = await window.getBounds()
      expect(boundsBefore.bottom - boundsBefore.top).assertLarger(boundsAfter.bottom - boundsAfter.top)
      expect(boundsBefore.right - boundsBefore.left).assertLarger(boundsAfter.right - boundsAfter.left)
      // 检查窗口拖动
      await driver.drag(boundsAfter.left + 30, boundsAfter.top + 15, 100, 100, 100)
      await driver.delayMs(1000)
      let boundsMove = await window.getBounds()
      expect(boundsAfter.top).assertLarger(boundsMove.top)
      expect(boundsAfter.right).assertLarger(boundsMove.right)
      await driver.delayMs(1000)
      await window.resume()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + '_WindowResume end')
      done()
    })

    /**
     * 窗口最小化
     */
    it(BUNDLE + '_WindowMiniSize', 6, async () => {
      Logger.info(TAG, BUNDLE + "_WindowMiniSize start")
      let driver = await Driver.create()
      let window = await driver.findWindow({
        bundleName: 'ohos.samples.settings'
      })
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      let resourceManager = (await abilityDelegator.getCurrentTopAbility()).context.resourceManager
      let moreConnectionsTab = await resourceManager.getStringValue($r('app.string.moreConnectionsTab'))
      await driver.assertComponentExist(ON.text(moreConnectionsTab))
      await window.minimize()
      await driver.delayMs(1000)
      let connection = await driver.findComponent(ON.text(moreConnectionsTab))
      await expect(connection).assertNull()
      let settings = await resourceManager.getStringValue($r('app.string.settings'))
      await driver.assertComponentExist(ON.text(settings))
      let setting = await driver.findComponent(ON.text(settings))
      await setting.click()
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.text(moreConnectionsTab))
      Logger.info(TAG, BUNDLE + "_WindowMiniSize end")
    })

    /**
     * 关闭窗口
     */
    it(BUNDLE + '_WindowClose', 7, async () => {
      Logger.info(TAG, BUNDLE + "_WindowClose start")
      let driver = await Driver.create()
      let window = await driver.findWindow({
        bundleName: 'ohos.samples.settings'
      })
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      let resourceManager = (await abilityDelegator.getCurrentTopAbility()).context.resourceManager
      let moreConnectionsTab = await resourceManager.getStringValue($r('app.string.moreConnectionsTab'))
      await driver.assertComponentExist(ON.text(moreConnectionsTab))
      await window.close()
      await driver.delayMs(1000)
      let connection = await driver.findComponent(ON.text(moreConnectionsTab))
      await expect(connection).assertNull()
      let settings = await resourceManager.getStringValue($r('app.string.settings'))
      await driver.assertComponentExist(ON.text(settings))
      let setting = await driver.findComponent(ON.text(settings))
      await setting.click()
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.text(moreConnectionsTab))
      Logger.info(TAG, BUNDLE + "_WindowClose end")
    })
  })
}
