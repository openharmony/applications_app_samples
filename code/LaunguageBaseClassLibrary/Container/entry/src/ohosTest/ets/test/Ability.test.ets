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
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry';
import hilog from '@ohos.hilog'

const TAG = '[Sample_Container]'
const DOMAIN = 0xF811
const BUNDLE = 'Container_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let parameter = {
        bundleName: "ohos.samples.container",
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
     * 点击添加
     */
    it(BUNDLE + 'ClickAddFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAddFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAddFunction_001 clickAddBtn')
      // 点击添加按钮
      await driver.assertComponentExist(BY.key('addBtn'))
      let btnAdd = await driver.findComponent(BY.key('addBtn'))
      await btnAdd.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAddFunction_001 end')
    })
    /**
     * 联系人信息弹窗中输入姓名、年龄、电话
     */
    it(BUNDLE + 'InputContactInformationFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputContactInformationFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputContactInformationFunction_001 inputName')
      // 输入姓名
      await driver.assertComponentExist(BY.key('inputName'))
      let nameInput = await driver.findComponent(BY.key('inputName'))
      await nameInput.inputText('zhangsan')
      let nameVal = await nameInput.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputContactInformationFunction_001 nameVal')
      expect('zhangsan').assertEqual(nameVal)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputContactInformationFunction_001 inputAge')
      // 输入年龄
      await driver.assertComponentExist(BY.key('inputAge'))
      let ageInput = await driver.findComponent(BY.key('inputAge'))
      await ageInput.inputText('18')
      let ageVal = await ageInput.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputContactInformationFunction_001 ageVal')
      expect('18').assertEqual(ageVal)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputContactInformationFunction_001 inputPhone')
      // 输入电话
      await driver.assertComponentExist(BY.key('inputPhone'))
      let phoneInput = await driver.findComponent(BY.key('inputPhone'))
      await phoneInput.inputText('18156349865')
      let phoneVal = await phoneInput.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputContactInformationFunction_001 phoneVal')
      expect('18156349865').assertEqual(phoneVal)
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputContactInformationFunction_001 clickConfirm')
      // 点击确认
      await driver.assertComponentExist(BY.key('confirm'))
      let btnConfirm = await driver.findComponent(BY.key('confirm'))
      await btnConfirm.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputContactInformationFunction_001 end')
    })
    /**
     * 删除联系人信息
     */
    it(BUNDLE + 'DelContactInformationFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DelContactInformationFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'DelContactInformationFunction_001 clickDelContact')
      // 点击删除
      await driver.assertComponentExist(BY.key('delContact'))
      let btnDel = await driver.findComponent(BY.key('delContact'))
      await btnDel.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'DelContactInformationFunction_001 end')
    })
  })
}