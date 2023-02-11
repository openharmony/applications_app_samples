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
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry'
import { UiDriver, BY, UiComponent, MatchPattern } from '@ohos.uitest'
import hilog from '@ohos.hilog'

const TAG = '[Sample_DistributedNote]'
const DOMAIN = 0xF811
const BUNDLE = 'DistributedNote_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let want = {
        bundleName: "ohos.samples.distributednote",
        abilityName: "MainAbility"
      }
      var abilityDelegator: any
      abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      abilityDelegator.startAbility(want, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end')
      })
    })
    /**
     * 点击允许进行授权
     */
    it(BUNDLE + 'ClickAcceptFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAcceptFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(3000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAcceptFunction_001 clickAccept')
      // 点击允许
      await driver.assertComponentExist(BY.text('允许'))
      let btnAccept = await driver.findComponent(BY.text('允许'))
      await btnAccept.click()
      await driver.delayMs(3000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAcceptFunction_001 end')
    })
    /**
     * 点击添加按钮进入添加界面
     */
    it(BUNDLE + 'AddFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 clickAddNote')
      // 点击添加按钮
      await driver.assertComponentExist(BY.key('addNote'))
      let btnAdd = await driver.findComponent(BY.key('addNote'))
      await driver.delayMs(1000)
      await btnAdd.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 end')
    })
    /**
     * 编辑标题、内容、标记颜色，点击提交按钮添加备忘录
     */
    it(BUNDLE + 'EditFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFunction_001 inputTitle')
      // 输入标题
      await driver.assertComponentExist(BY.key('titleInput'))
      let title = await driver.findComponent(BY.key('titleInput'))
      await driver.delayMs(1000)
      await title.inputText('music')
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFunction_001 inputContent')
      // 输入内容
      await driver.assertComponentExist(BY.key('contentInput'))
      let content = await driver.findComponent(BY.key('contentInput'))
      await driver.delayMs(1000)
      await content.inputText('this is a folk music')
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFunction_001 clickSaveNote')
      // 点击保存
      await driver.assertComponentExist(BY.key('saveNote'))
      let btnSave = await driver.findComponent(BY.key('saveNote'))
      await driver.delayMs(1000)
      await btnSave.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFunction_001 end')
    })
    /**
     * 点击清除可以清除备忘录
     */
    it(BUNDLE + 'ClearNoteFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClearNoteFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClearNoteFunction_001 clickClearNote')
      // 点击清除
      await driver.assertComponentExist(BY.key('clearNote'))
      let btnClear = await driver.findComponent(BY.key('clearNote'))
      await driver.delayMs(1000)
      await btnClear.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClearNoteFunction_001 end')
    })
    /**
     * 再次点击添加按钮，进入添加界面
     */
    it(BUNDLE + 'AddNoteFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddNoteFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddNoteFunction_001 clickAddNote')
      // 再次点击添加
      await driver.assertComponentExist(BY.key('addNote'))
      let btnAdd = await driver.findComponent(BY.key('addNote'))
      await driver.delayMs(1000)
      await btnAdd.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddNoteFunction_001 end')
    })
    /**
     * 编辑标题内容，点击提交保存备忘录
     */
    it(BUNDLE + 'SaveNoteFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SaveNoteFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SaveNoteFunction_001 inputTitle')
      // 输入标题
      await driver.assertComponentExist(BY.key('titleInput'))
      let title = await driver.findComponent(BY.key('titleInput'))
      await driver.delayMs(1000)
      await title.inputText('book')
      hilog.info(DOMAIN, TAG, BUNDLE + 'SaveNoteFunction_001 inputContent')
      // 输入内容
      await driver.assertComponentExist(BY.key('contentInput'))
      let content = await driver.findComponent(BY.key('contentInput'))
      await driver.delayMs(1000)
      await content.inputText('this is a history book')
      hilog.info(DOMAIN, TAG, BUNDLE + 'SaveNoteFunction_001 clickSaveNote')
      // 点击保存
      await driver.assertComponentExist(BY.key('saveNote'))
      let btnSave = await driver.findComponent(BY.key('saveNote'))
      await driver.delayMs(1000)
      await btnSave.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'SaveNoteFunction_001 end')
    })
  })
}