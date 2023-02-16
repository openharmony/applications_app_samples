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
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry'
import hilog from '@ohos.hilog'

const TAG = '[Sample_RPC]'
const DOMAIN = 0xF811
const BUNDLE = 'RPC_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let parameter = {
        bundleName: "ohos.samples.rpc",
        abilityName: "EntryAbility"
      }
      let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator()
      abilityDelegatorRegistry.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end')
      })
    })
    /**
     * 选择商品及对应数量
     */
    it(BUNDLE + 'SelectGoodsFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectGoodsFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectGoodsFunction_001 clickSelectVeggie')
      // 点击蔬菜类空白框
      let VegGoods = await driver.findComponent(BY.text('').isAfter(BY.text('Veggie')))
      await VegGoods.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectGoodsFunction_001 selectPotato')
      // 选择potato
      await driver.assertComponentExist(BY.text('potato', MatchPattern.CONTAINS))
      let VegSubCate = await driver.findComponent(BY.text('potato', MatchPattern.CONTAINS))
      await VegSubCate.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectGoodsFunction_001 clickVeggieAddBtn')
      // 点击添加
      let btnVegAdd = await driver.findComponent(BY.text('+').isAfter(BY.text('Veggie')))
      await btnVegAdd.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectGoodsFunction_001 clickSelectFruit')
      // 点击水果类空白框
      let FruitGoods = await driver.findComponent(BY.text('').isAfter(BY.text('Fruit')))
      await FruitGoods.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectGoodsFunction_001 selectApple')
      // 选择apple
      await driver.assertComponentExist(BY.text('apple', MatchPattern.CONTAINS))
      let FruitSubCate = await driver.findComponent(BY.text('apple', MatchPattern.CONTAINS))
      await FruitSubCate.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectGoodsFunction_001 clickFruitAddBtn')
      // 点击添加
      let btnFruitAdd = await driver.findComponent(BY.text('+').isAfter(BY.text('Fruit')))
      await btnFruitAdd.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectGoodsFunction_001 clickSelectMeat')
      // 点击肉类空白框
      let MeatGoods = await driver.findComponent(BY.text('').isAfter(BY.text('Meat')))
      await MeatGoods.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectGoodsFunction_001 selectBeef')
      // 选择beef
      await driver.assertComponentExist(BY.text('beef', MatchPattern.CONTAINS))
      let MeatSubCate = await driver.findComponent(BY.text('beef', MatchPattern.CONTAINS))
      await MeatSubCate.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectGoodsFunction_001 clickMeatAddBtn')
      // 点击添加
      let btnMeatAdd = await driver.findComponent(BY.text('+').isAfter(BY.text('Meat')))
      await btnMeatAdd.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectGoodsFunction_001 clickSelectSnacks')
      // 选择零食类空白框
      let SnacksGoods = await driver.findComponent(BY.text('').isAfter(BY.text('Snacks')))
      await SnacksGoods.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectGoodsFunction_001 selectCandy')
      // 选择candy
      await driver.assertComponentExist(BY.text('candy', MatchPattern.CONTAINS))
      let textSnacksSubCate = await driver.findComponent(BY.text('candy', MatchPattern.CONTAINS))
      await textSnacksSubCate.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectGoodsFunction_001 clickSnacksAddBtn')
      // 点击添加
      let btnSnacksAdd = await driver.findComponent(BY.text('+').isAfter(BY.text('Snacks')))
      await btnSnacksAdd.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectGoodsFunction_001 end')
    })
    /**
     * 点击确认订单
     */
    it(BUNDLE + 'ClickConfirmOrderFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickConfirmOrderFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickConfirmOrderFunction_001 clickConfirmOrderBtn')
      // 点击确认订单
      await driver.assertComponentExist(BY.key('confirmOrderBtn'))
      let btnConfirm = await driver.findComponent(BY.key('confirmOrderBtn'))
      await btnConfirm.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickConfirmOrderFunction_001 begin end')
    })
  })
}