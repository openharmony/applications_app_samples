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
import { Driver, ON } from '@ohos.UiTest'
import featureAbility from '@ohos.ability.featureAbility'
import hilog from '@ohos.hilog'

const TAG = '[Sample_DefiningPageLayoutAndConnection]'
const DOMAIN = 0xF811
const BUNDLE = 'DefiningPageLayoutAndConnection_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.etsdefiningpagelayoutandconnection",
          abilityName: "ohos.samples.etsdefiningpagelayoutandconnection.MainAbility"
        }
      }
      await featureAbility.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
      })
    })

    /**
     * Grid布局 查看详情
     */
    it(BUNDLE + 'FoodGridFunction_001', 0, async function () {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_001 foodDetail')
      await driver.assertComponentExist(ON.id('foodGridItem1'))
      let foodGridItem1 = await driver.findComponent(ON.id('foodGridItem1'))
      await foodGridItem1.click()
      await driver.delayMs(1000)
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_001 back')
      await driver.assertComponentExist(ON.id('back'))
      let backBtn = await driver.findComponent(ON.id('back'))
      await backBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_001 end')
    })

    /**
     * 切换布局
     */
    it(BUNDLE + 'SwitchLayoutFunction_001', 0, async function () {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'SwitchLayoutFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      // switchLayout
      hilog.info(DOMAIN, TAG, BUNDLE + 'SwitchLayoutFunction_001 switchLayout')
      await driver.assertComponentExist(ON.id('switch'))
      let switchBtn = await driver.findComponent(ON.id('switch'))
      await switchBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SwitchLayoutFunction_001 end')
    })

    /**
     * List布局 查看详情
     */
    it(BUNDLE + 'FoodListFunction_001', 0, async function () {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_001 foodDetail')
      await driver.assertComponentExist(ON.id('foodListItem1'))
      let foodListItem1 = await driver.findComponent(ON.id('foodListItem1'))
      await foodListItem1.click()
      await driver.delayMs(1000)
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_001 back')
      await driver.assertComponentExist(ON.id('back'))
      let backBtn = await driver.findComponent(ON.id('back'))
      await backBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_001 end')
    })
  })
}