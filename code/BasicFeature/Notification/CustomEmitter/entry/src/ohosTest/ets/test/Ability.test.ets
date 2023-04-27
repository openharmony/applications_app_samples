/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import { Driver, ON, MatchPattern } from '@ohos.UiTest'
import Logger from '../util/Logger'

const BUNDLE = 'CustomEmitter'
const TAG = '[Sample_CustomEmitter]'

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    /**
     * 拉起一个ability
     */
    it(BUNDLE + 'StartAbility', 0, async () => {
      Logger.info(TAG, 'StartAbility start')
      let driver = await Driver.create()
      let want = {
        bundleName: 'ohos.samples.customemitter',
        abilityName: 'MainAbility'
      }
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      await abilityDelegator.startAbility(want, (err, data) => {
        Logger.info(TAG, 'StartAbility get err ' + JSON.stringify(err))
        expect(err).assertNull()
      })
      await driver.delayMs(1000)
      Logger.info(TAG, 'StartAbility end')
    })

    /**
     * 检查Dialog是否显示，是否能正常关闭
     */
    it(BUNDLE + 'OpenDialog', 1, async (done) => {
      Logger.info(TAG, 'OpenDialog start')
      let driver = await Driver.create()
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager
      // 检查Dialog是否显示
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.shopping'))))
      let closeBtn = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.close_icon'))))
      await closeBtn.click()
      await driver.delayMs(500)
      // 检查Dialog是否关闭
      let title = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.shopping'))))
      await expect(title).assertNull()
      await driver.delayMs(500)
      Logger.info(TAG, 'OpenDialog end')
      done()
    })

    /**
     * 点击某商品，检查是否跳转
     * 本示例运行时间较长，请将Time Out调整为120s，确保用例正常执行
     */
    it(BUNDLE + 'OpenDetail', 2, async (done) => {
      Logger.info(TAG, 'OpenDetail start')
      let driver = await Driver.create()
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager

      let idList = ['0', '1', '2']  // 商品id列表
      for (let i in idList) {
        let goods = await driver.findComponent(ON.id(idList[i]))
        // 点击商品
        await goods.click()
        await driver.delayMs(500)
        // 检查跳转后商品是否一致
        await driver.assertComponentExist(
          ON.text(await resourceManager.getStringValue($r('app.string.evaluate')), MatchPattern.CONTAINS))
        await driver.assertComponentExist(ON.id(idList[i]))
        await driver.pressBack()
        await driver.delayMs(500)
      }
      Logger.info(TAG, 'OpenDetail end')
      done()
    })

    /**
     * 添加某商品到购物车界面
     * 本示例运行时间较长，请将Time Out调整为120s，确保用例正常执行
     */
    it(BUNDLE + 'AddGoodsToCart', 3, async (done) => {
      Logger.info(TAG, 'AddGoodsToCart start')
      let driver = await Driver.create()
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager
      let cartTag = 'cart'
      let idList = ['0', '1', '2']  // 商品id列表
      for (let i in idList) {
        let goods = await driver.findComponent(ON.id(idList[i]))
        // 点击商品
        await goods.click()
        await driver.delayMs(500)
        // 检查跳转后商品是否一致
        await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.add_to_cart'))))
        await driver.assertComponentExist(ON.id(idList[i]))
        await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.shop_cart'))))
        // 点击添加商品到购物车当中
        let addBtn = await driver.findComponent(
          ON.text(await resourceManager.getStringValue($r('app.string.add_to_cart'))))
        await addBtn.click()
        await driver.delayMs(500)
        // 跳转到购物车页面
        let cartBtn = await driver.findComponent(
          ON.text(await resourceManager.getStringValue($r('app.string.shop_cart'))))
        await cartBtn.click()
        await driver.delayMs(500)
        // 检查商品是否已经添加
        await driver.assertComponentExist(ON.id(cartTag + idList[i]))
        // 退回首页
        await driver.pressBack()
        await driver.delayMs(500)
        await driver.pressBack()
        await driver.delayMs(500)
      }
      Logger.info(TAG, 'AddGoodsToCart end')
      done()
    })
  })
}