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
import { Logger } from '../../../main/ets/common/Logger'

const TAG = '[Sample_RPC]'
const BUNDLE = 'RPC_'

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      Logger.info(TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.rpc',
          abilityName: 'EntryAbility'
        })
        done()
      }
      catch (expection) {
        Logger.info(TAG, `StartAbility end ${JSON.stringify(expection)}`)
        done()
      }
      Logger.info(TAG, BUNDLE + 'StartAbility_001 end')
    })
    /**
     * 选择商品及对应数量
     */

    it(BUNDLE + 'SelectGoodsFunction_001', 0, async function () {
      Logger.info(TAG, BUNDLE + 'SelectGoodsFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'SelectGoodsFunction_001 clickSelectVeggie')
      // 点击蔬菜类空白框
      let VegGoods = await driver.findComponent(ON.text('').isAfter(ON.text('Veggie')))
      await VegGoods.click()
      await driver.delayMs(1000)
      // 判断菜单弹窗是否弹出,蔬菜菜单子类是否正常显示
      await driver.assertComponentExist(ON.id('menu'))
      await driver.assertComponentExist(ON.text('potato'))
      await driver.assertComponentExist(ON.text('cabbage'))
      await driver.assertComponentExist(ON.text('eggplant'))
      Logger.info(TAG, BUNDLE + 'SelectGoodsFunction_001 selectPotato')
      // 选择potato
      let VegSubCate = await driver.findComponent(ON.text('potato', MatchPattern.CONTAINS))
      await VegSubCate.click()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'SelectGoodsFunction_001 clickVeggieAddBtn')
      // 点击添加
      let btnVegAdd = await driver.findComponent(ON.text('+').isAfter(ON.text('Veggie')))
      await btnVegAdd.click()
      await driver.delayMs(1000)
      // 判断是否添加成功
      await driver.assertComponentExist(ON.id('amount').isAfter(ON.text('Veggie')))
      let amountVeggie = await driver.findComponent(ON.id('amount').isAfter(ON.text('Veggie')))
      let amountVeggieValue = await amountVeggie.getText()
      expect('1').assertEqual(amountVeggieValue)
      Logger.info(TAG, BUNDLE + 'SelectGoodsFunction_001 clickSelectFruit')
      // 点击水果类空白框
      let FruitGoods = await driver.findComponent(ON.text('').isAfter(ON.text('Fruit')))
      await FruitGoods.click()
      await driver.delayMs(1000)
      // 判断菜单弹窗是否弹出,水果菜单子类是否正常显示
      await driver.assertComponentExist(ON.id('menu'))
      await driver.assertComponentExist(ON.text('apple'))
      await driver.assertComponentExist(ON.text('banana'))
      await driver.assertComponentExist(ON.text('peach'))
      Logger.info(TAG, BUNDLE + 'SelectGoodsFunction_001 selectApple')
      // 选择apple
      let FruitSubCate = await driver.findComponent(ON.text('apple', MatchPattern.CONTAINS))
      await FruitSubCate.click()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'SelectGoodsFunction_001 clickFruitAddBtn')
      // 点击添加
      let btnFruitAdd = await driver.findComponent(ON.text('+').isAfter(ON.text('Fruit')))
      await btnFruitAdd.click()
      await driver.delayMs(1000)
      // 判断是否添加成功
      await driver.assertComponentExist(ON.id('amount').isAfter(ON.text('Fruit')))
      let amountFruit = await driver.findComponent(ON.id('amount').isAfter(ON.text('Fruit')))
      let amountFruitValue = await amountFruit.getText()
      expect('1').assertEqual(amountFruitValue)
      Logger.info(TAG, BUNDLE + 'SelectGoodsFunction_001 clickSelectMeat')
      // 点击肉类空白框
      let MeatGoods = await driver.findComponent(ON.text('').isAfter(ON.text('Meat')))
      await MeatGoods.click()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'SelectGoodsFunction_001 selectBeef')
      // 判断菜单弹窗是否弹出,肉类菜单子类是否正常显示
      await driver.assertComponentExist(ON.id('menu'))
      await driver.assertComponentExist(ON.text('beef'))
      await driver.assertComponentExist(ON.text('pork'))
      await driver.assertComponentExist(ON.text('chicken'))
      // 选择beef
      let MeatSubCate = await driver.findComponent(ON.text('beef', MatchPattern.CONTAINS))
      await MeatSubCate.click()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'SelectGoodsFunction_001 clickMeatAddBtn')
      // 点击添加
      let btnMeatAdd = await driver.findComponent(ON.text('+').isAfter(ON.text('Meat')))
      await btnMeatAdd.click()
      await driver.delayMs(1000)
      // 判断是否添加成功
      await driver.assertComponentExist(ON.id('amount').isAfter(ON.text('Meat')))
      let amountMeat = await driver.findComponent(ON.id('amount').isAfter(ON.text('Meat')))
      let amountMeatValue = await amountMeat.getText()
      expect('1').assertEqual(amountMeatValue)
      Logger.info(TAG, BUNDLE + 'SelectGoodsFunction_001 clickSelectSnacks')
      // 选择零食类空白框
      let SnacksGoods = await driver.findComponent(ON.text('').isAfter(ON.text('Snacks')))
      await SnacksGoods.click()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'SelectGoodsFunction_001 selectCandy')
      // 判断菜单弹窗是否弹出,小吃菜单子类是否正常显示
      await driver.assertComponentExist(ON.id('menu'))
      await driver.assertComponentExist(ON.text('biscuits'))
      await driver.assertComponentExist(ON.text('chips'))
      await driver.assertComponentExist(ON.text('candy'))
      // 选择candy
      let textSnacksSubCate = await driver.findComponent(ON.text('candy', MatchPattern.CONTAINS))
      await textSnacksSubCate.click()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'SelectGoodsFunction_001 clickSnacksAddBtn')
      // 点击添加
      let btnSnacksAdd = await driver.findComponent(ON.text('+').isAfter(ON.text('Snacks')))
      await btnSnacksAdd.click()
      await driver.delayMs(1000)
      // 判断是否添加成功
      await driver.assertComponentExist(ON.id('amount').isAfter(ON.text('Snacks')))
      let amountSnacks = await driver.findComponent(ON.id('amount').isAfter(ON.text('Snacks')))
      let amountSnacksValue = await amountSnacks.getText()
      expect('1').assertEqual(amountSnacksValue)
      Logger.info(TAG, BUNDLE + 'SelectGoodsFunction_001 end')
    })
    /**
     * 点击确认订单
     */
    it(BUNDLE + 'ClickConfirmOrderFunction_001', 0, async function () {
      Logger.info(TAG, BUNDLE + 'ClickConfirmOrderFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'ClickConfirmOrderFunction_001 clickConfirmOrderBtn')
      // 点击确认订单
      await driver.assertComponentExist(ON.id('confirmOrderBtn'))
      let btnConfirm = await driver.findComponent(ON.id('confirmOrderBtn'))
      await btnConfirm.click()
      await driver.delayMs(1000)
      // 判断总价格是否有变化
      await driver.assertComponentExist(ON.id('totalPrice'))
      let totalPrice = await driver.findComponent(ON.id('totalPrice'))
      let price = await totalPrice.getText()
      expect('57').assertEqual(price)
      Logger.info(TAG, BUNDLE + 'ClickConfirmOrderFunction_001 begin end')
    })
  })
}