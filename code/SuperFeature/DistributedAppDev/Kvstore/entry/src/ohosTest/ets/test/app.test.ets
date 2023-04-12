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
import { UiDriver, BY, UiComponent, MatchPattern } from '@ohos.uitest'
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry'
import hilog from '@ohos.hilog'

const TAG = '[Sample_Kvstore]'
const DOMAIN = 0xF811
const BUNDLE = 'Kvstore_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001')
      let parameter = {
        bundleName: "ohos.samples.kvstore",
        abilityName: "EntryAbility"
      }
      let abilityDelegator: AbilityDelegatorRegistry.AbilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      abilityDelegator.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end')
      })
    })
    /**
     * 点击允许授权
     */
    it(BUNDLE + 'ClickAcceptFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAcceptFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAcceptFunction_001 clickAccept')
      // 点击允许
      await driver.assertComponentExist(BY.text('允许'))
      let btnAccept = await driver.findComponent(BY.text('允许'))
      await btnAccept.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAcceptFunction_001 end')
    })
    /**
     * 点击右上角按钮拉起对端设备
     */
    it(BUNDLE + 'ClickRightBtnFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickRightBtnFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickRightBtnFunction_001 clickRightBtn')
      // 点击右上角按钮
      await driver.assertComponentExist(BY.key('rightBtn'))
      let rightBtn = await driver.findComponent(BY.key('rightBtn'))
      await rightBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickRightBtnFunction_001 clickCancel')
      // 点击取消
      await driver.assertComponentExist(BY.key('cancel'))
      let cancelBtn = await driver.findComponent(BY.key('cancel'))
      await driver.delayMs(3000)
      await cancelBtn.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickRightBtnFunction_001 end')
    })
    /**
     * 点击添加和删除卡片
     */
    it(BUNDLE + 'HandleCardFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'HandleCardFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'HandleCardFunction_001 clickAddBtn')
      // 点击添加
      await driver.assertComponentExist(BY.key('add'))
      let addBtn = await driver.findComponent(BY.key('add'))
      await driver.delayMs(3000)
      await addBtn.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'HandleCardFunction_001 delCard')
      // 删除卡片
      await driver.assertComponentExist(BY.key('del笔记1'))
      let delBtn = await driver.findComponent(BY.key('del笔记1'))
      await delBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'HandleCardFunction_001 clickAddBtn')
      // 点击添加
      await driver.assertComponentExist(BY.key('add'))
      let addBtn2 = await driver.findComponent(BY.key('add'))
      await driver.delayMs(3000)
      await addBtn2.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'HandleCardFunction_001 end')
    })
  })
}