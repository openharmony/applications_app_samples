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

import { describe, it, expect } from '@ohos/hypium'
import { Driver, ON } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import hilog from '@ohos.hilog'

const TAG = '[Sample_MediaQuery]'
const DOMAIN = 0xFF00
const BUNDLE = 'MediaQuery_'

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.mediaquery',
          abilityName: 'EntryAbility'
        })
        done()
      } catch (exception) {
        hilog.info(DOMAIN, TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail()
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
    })

    /**
     * 进入应用
     */
    it(BUNDLE + 'EnterFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      // 点击冬日养猫日常
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFunction_001 newTitle1')
      await driver.assertComponentExist(ON.id('item0'))
      let newTitle1 = await driver.findComponent(ON.id('item0'))
      await newTitle1.click()
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.id('currentNewImg'))
      await driver.pressBack()
      await driver.delayMs(2000)
      // 点击冬奥美食记
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFunction_001 newTitle2')
      await driver.assertComponentExist(ON.id('item1'))
      let newTitle2 = await driver.findComponent(ON.id('item1'))
      await newTitle2.click()
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.id('currentNewImg'))
      await driver.pressBack()
      await driver.delayMs(2000)
      // 点击疫情期间你在干什么
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFunction_001 newTitle3')
      await driver.assertComponentExist(ON.id('item2'))
      let newTitle3 = await driver.findComponent(ON.id('item2'))
      await newTitle3.click()
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.id('currentNewImg'))
      await driver.pressBack()
      await driver.delayMs(2000)
      // 点击精致女人穿搭技巧
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFunction_001 newTitle4')
      await driver.assertComponentExist(ON.id('item3'))
      let newTitle4 = await driver.findComponent(ON.id('item3'))
      await newTitle4.click()
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.id('currentNewImg'))
      await driver.pressBack()
      await driver.delayMs(2000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFunction_001 end')
    })
  })
}