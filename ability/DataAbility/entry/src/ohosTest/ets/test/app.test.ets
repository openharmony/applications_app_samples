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

const TAG = '[Sample_DataAbility]'
const DOMAIN = 0xF811
const BUNDLE = 'DataAbility_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.etsdataability",
          abilityName: "ohos.samples.etsdataability.MainAbility"
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
    * 添加数据
    */
    it(BUNDLE + 'AddFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(500)
      // add
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 clickInsert')
      await driver.assertComponentExist(BY.key('batchInsert'))
      let btnInsert = await driver.findComponent(BY.key('batchInsert'))
      await btnInsert.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 clickAdd')
      await driver.assertComponentExist(BY.key('add'))
      let btnAdd = await driver.findComponent(BY.key('add'))
      await btnAdd.click()
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 end')
    })

    /**
    * 编辑数据
    */
    it(BUNDLE + 'EditFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(500)
      // edit
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFunction_001 edit')
      await driver.assertComponentExist(BY.type('ListItem'))
      let btnEdit = await driver.findComponent(BY.type('ListItem'))
      await btnEdit.click()
      await driver.delayMs(500)
      // edit detail input name
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFunction_001 editName')
      await driver.assertComponentExist(BY.key('input name'))
      let text1 = await driver.findComponent(BY.key('input name'))
      await text1.inputText('hhh')
      let val1 = await text1.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFunction_001 nameValue')
      expect('hhh').assertEqual(val1)
      // edit detail input introduction
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFunction_001 editIntroduction')
      await driver.assertComponentExist(BY.key('input introduction'))
      let text2 = await driver.findComponent(BY.key('input introduction'))
      await text2.inputText('yyy')
      let val2 = await text2.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFunction_001 introductionValue')
      expect('yyy').assertEqual(val2)
      await driver.delayMs(500)
      // save edits
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFunction_001 save')
      await driver.assertComponentExist(BY.key('submit'))
      let btnSave = await driver.findComponent(BY.key('submit'))
      await btnSave.click()
      await driver.delayMs(500)
      // do not save edits
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFunction_001 notSave')
      await btnEdit.click()
      await driver.delayMs(500)
      await driver.pressBack()
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFunction_001 end')
    })

    /**
    * 查找数据
    */
    it(BUNDLE + 'SearchFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'SearchFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(500)
      // enter the search page
      hilog.info(DOMAIN, TAG, BUNDLE + 'SearchFunction_001 enterSearchPage')
      await driver.assertComponentExist(BY.key('searchTip'))
      let btnEnterSearch = await driver.findComponent(BY.key('searchTip'))
      await btnEnterSearch.click()
      await driver.delayMs(500)
      // search detail
      hilog.info(DOMAIN, TAG, BUNDLE + 'SearchFunction_001 search')
      await driver.assertComponentExist(BY.key('search'))
      let textSearch = await driver.findComponent(BY.key('search'))
      await textSearch.inputText('oo')
      await textSearch.inputText('name1')
      await textSearch.inputText('yy')
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SearchFunction_001 pressBack')
      await driver.pressBack()
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SearchFunction_001 end')
    })

    /**
    * 删除数据
    */
    it(BUNDLE + 'DeleteFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'DeleteFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(500)
      // delete
      hilog.info(DOMAIN, TAG, BUNDLE + 'DeleteFunction_001 delete')
      await driver.assertComponentExist(BY.key('delete'))
      let btnDelete = await driver.findComponent(BY.key('delete'))
      await btnDelete.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'DeleteFunction_001 enterSearch')
      await driver.assertComponentExist(BY.key('searchTip'))
      let btnEnterSearch = await driver.findComponent(BY.key('searchTip'))
      await btnEnterSearch.click()
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + 'DeleteFunction_001 afterSearch')
      await driver.assertComponentExist(BY.key('search'))
      let textSearch = await driver.findComponent(BY.key('search'))
      await textSearch.inputText('name2')
      await driver.pressBack()
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + 'DeleteFunction_001 end')
    })
  })
}