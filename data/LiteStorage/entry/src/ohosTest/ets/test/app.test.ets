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
import featureAbility from '@ohos.ability.featureAbility'
import hilog from '@ohos.hilog'

const TAG = '[Sample_LiteStorage]'
const DOMAIN = 0xF811
const BUNDLE = 'LiteStorage_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.etslitestorage",
          abilityName: "ohos.samples.etslitestorage.MainAbility"
        }
      }
      featureAbility.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end')
      })
    })
    /**
     * 添加商品
     */
    it(BUNDLE + 'AddGoodsFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddGoodsFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddGoodsFunction_001 addMate')
      // 添加MateX2
      await driver.assertComponentExist(BY.key('addMateX2'))
      let addMateX2 = await driver.findComponent(BY.key('addMateX2'))
      await addMateX2.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddGoodsFunction_001 addMate40')
      // 添加Mate40Pro+
      await driver.assertComponentExist(BY.key('addMate40Pro+'))
      let addMate40Pro = await driver.findComponent(BY.key('addMate40Pro+'))
      await addMate40Pro.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddGoodsFunction_001 addP50Pro')
      // 添加P50Pro
      await driver.assertComponentExist(BY.key('addP50Pro'))
      let addP50Pro = await driver.findComponent(BY.key('addP50Pro'))
      await addP50Pro.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddGoodsFunction_001 addMatePadPro')
      // 添加MatePadPro12.6
      await driver.assertComponentExist(BY.key('addMatePadPro12.6'))
      let addMatePadPro = await driver.findComponent(BY.key('addMatePadPro12.6'))
      await addMatePadPro.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddGoodsFunction_001 addMateBookXPro')
      // 添加MateBookXPro
      await driver.assertComponentExist(BY.key('addMateBookXPro'))
      let addMateBookXPro = await driver.findComponent(BY.key('addMateBookXPro'))
      await addMateBookXPro.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddGoodsFunction_001 end')
    })
    /**
     * 点击购物车，删除宝贝，商品总价和购物车图标发生变化
     */
    it(BUNDLE + 'ClickCartFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCartFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCartFunction_001 clickCart')
      // 点击购物车
      await driver.assertComponentExist(BY.key('cart'))
      let btnCart = await driver.findComponent(BY.key('cart'))
      await btnCart.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCartFunction_001 delGoods')
      // 点击删除宝贝
      await driver.assertComponentExist(BY.key('delGoods'))
      let delGoods = await driver.findComponent(BY.key('delGoods'))
      await delGoods.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCartFunction_001 delFirstGoods')
      // 删除第一个宝贝
      await driver.findComponent(BY.key('cartDel1'))
      let cartDel = await driver.findComponent(BY.key('cartDel1'))
      await cartDel.click()
      await driver.delayMs(1000)
      // 退出
      await driver.pressBack()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCartFunction_001 end')
    })
    /**
     * 重新启动主页
     */
    it(BUNDLE + 'RestartMainPageFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'RestartMainPageFunction_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.etslitestorage",
          abilityName: "ohos.samples.etslitestorage.MainAbility"
        }
      }
      featureAbility.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'RestartMainPageFunction_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'RestartMainPageFunction_001 end')
      })
    })
    /**
     * 点击购物车查看选择的宝贝是否保存
     */
    it(BUNDLE + 'ClickViewCartFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickViewCartFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickViewCartFunction_001 clickCart')
      // 点击购物车
      await driver.assertComponentExist(BY.key('cart'))
      let btnCart = await driver.findComponent(BY.key('cart'))
      await btnCart.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickViewCartFunction_001 end')
    })
  })
}