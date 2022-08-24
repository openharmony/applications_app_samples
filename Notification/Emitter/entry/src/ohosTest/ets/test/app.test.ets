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

const TAG = '[Sample_Emitter]'
const DOMAIN = 0xF811
const BUNDLE = 'Emitter_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.etsemitter",
          abilityName: "ohos.samples.etsemitter.MainAbility"
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
     * 点击进入商城列表
     */
    it(BUNDLE + 'ClickEnterMallFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickEnterMallFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickEnterMallFunction_001 clickMallBtn')
      // 进入商城
      await driver.assertComponentExist(BY.key('enterMall'))
      let mallBtn = await driver.findComponent(BY.key('enterMall'))
      await mallBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickEnterMallFunction_001 end')
    })
    /**
     * 点击选择商品并提交
     */
    it(BUNDLE + 'SelectGoodsFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectGoodsFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectGoodsFunction_001 clickDesktopToggle')
      // 选择第一个商品
      await driver.assertComponentExist(BY.key('DesktopToggle'))
      let DesktopToggle = await driver.findComponent(BY.key('DesktopToggle'))
      await DesktopToggle.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectGoodsFunction_001 clickDisplayToggle')
      // 选择第二个商品
      await driver.assertComponentExist(BY.key('DisplayToggle'))
      let DisplayToggle = await driver.findComponent(BY.key('DisplayToggle'))
      await DisplayToggle.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectGoodsFunction_001 clickNoteBookToggle')
      // 选择第三个商品
      await driver.assertComponentExist(BY.key('NoteBookToggle'))
      let NoteBookToggle = await driver.findComponent(BY.key('NoteBookToggle'))
      await NoteBookToggle.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectGoodsFunction_001 clickSubmitBtn')
      // 点击提交按钮
      await driver.assertComponentExist(BY.key('submitBtn'))
      let submitBtn = await driver.findComponent(BY.key('submitBtn'))
      await submitBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectGoodsFunction_001 end')
    })
    /**
     * 首页商品列表展示所选商品
     */
    it(BUNDLE + 'ShowSelectGoodsFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShowSelectGoodsFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShowSelectGoodsFunction_001 returnHomePage')
      // 跳转至首页
      await driver.assertComponentExist(BY.key('enterMall'))
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShowSelectGoodsFunction_001 end')
    })
  })
}