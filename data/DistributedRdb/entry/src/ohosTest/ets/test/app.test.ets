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

const TAG = '[Sample_DistributedRdb]'
const DOMAIN = 0xF811
const BUNDLE = 'DistributedRdb_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.etsdistributedrdb",
          abilityName: "ohos.samples.etsdistributedrdb.MainAbility"
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
     * 点击允许授权
     */
    it(BUNDLE + 'ClickAcceptFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAcceptFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAcceptFunction_001 clickAccept')
      // 点击允许
      await driver.assertComponentExist(BY.text('允许', MatchPattern.CONTAINS))
      let btnAccept = await driver.findComponent(BY.text('允许', MatchPattern.CONTAINS))
      await btnAccept.click()
      await driver.delayMs(3000)
    })
    /**
     * 点击添加按钮添加联系人
     */
    it(BUNDLE + 'AddContactFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddContactFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddContactFunction_001 clickAddBtn')
      // 点击添加按钮
      await driver.assertComponentExist(BY.key('btnAdd'))
      let btnAdd = await driver.findComponent(BY.key('btnAdd'))
      await btnAdd.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddContactFunction_001 inputName')
      // 输入姓名
      await driver.assertComponentExist(BY.key('inputName'))
      let name = await driver.findComponent(BY.key('inputName'))
      await name.inputText('zhangsan')
      let valName = await name.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddContactFunction_001 valName')
      expect('zhangsan').assertEqual(valName)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddContactFunction_001 inputPhone')
      // 输入电话
      await driver.assertComponentExist(BY.key('inputPhone'))
      let phone = await driver.findComponent(BY.key('inputPhone'))
      await phone.inputText('15968794562')
      let valPhone = await name.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddContactFunction_001 valPhone')
      expect('15968794562').assertEqual(valPhone)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddContactFunction_001 inputRemark')
      // 输入备注
      await driver.assertComponentExist(BY.key('inputRemark'))
      let remark = await driver.findComponent(BY.key('inputRemark'))
      await remark.inputText('classmate')
      let valRemark = await name.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddContactFunction_001 valRemark')
      expect('classmate').assertEqual(valRemark)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddContactFunction_001 clickRightBtn')
      // 点击提交
      await driver.assertComponentExist(BY.key('rightBtn'))
      let btnSubmit = await driver.findComponent(BY.key('rightBtn'))
      await btnSubmit.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddContactFunction_001 end')
    })
    /**
     * 点击联系人进入编辑界面，编辑联系人信息
     */
    it(BUNDLE + 'EditContactFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditContactFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditContactFunction_001 clickContact')
      // 点击联系人列表
      await driver.assertComponentExist(BY.key('contact'))
      let contactItem = await driver.findComponent(BY.key('contact'))
      await contactItem.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditContactFunction_001 inputPhone')
      // 编辑电话
      await driver.assertComponentExist(BY.key('inputPhone'))
      let phone = await driver.findComponent(BY.key('inputPhone'))
      await phone.inputText('15968798862')
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditContactFunction_001 clickRightBtn')
      // 点击提交
      await driver.assertComponentExist(BY.key('rightBtn'))
      let btnSubmit = await driver.findComponent(BY.key('rightBtn'))
      await btnSubmit.click()
      await driver.delayMs(1000)
      // 长按联系人列表
      await contactItem.longClick()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditContactFunction_001 clickQuit')
      // 点击退出
      await driver.assertComponentExist(BY.text('退出', MatchPattern.CONTAINS))
      let btnQuit = await driver.findComponent(BY.text('退出', MatchPattern.CONTAINS))
      await btnQuit.click()
      await driver.delayMs(1000)
      console.log('Sample_DistributedRdb 10 end')
    })
    /**
     * 点击更多，分别选择连接设备和设置的数据同步方式
     */
    it(BUNDLE + 'ClickMoreFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickMoreFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(2000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickMoreFunction_001 clickRightBtn')
      // 点击更多
      await driver.assertComponentExist(BY.key('rightBtn'))
      let btnMore = await driver.findComponent(BY.key('rightBtn'))
      await btnMore.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickMoreFunction_001 clickConnectDevice')
      // 选择连接设备
      let connectDevice = await driver.findComponent(BY.text('连接设备', MatchPattern.CONTAINS))
      await connectDevice.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickMoreFunction_001 clickCancelBtn')
      // 点击取消
      await driver.assertComponentExist(BY.key('cancelBtn'))
      let cancelBtn = await driver.findComponent(BY.key('cancelBtn'))
      await cancelBtn.click()
      await driver.delayMs(1000)
      // 点击更多，选择设置
      await btnMore.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickMoreFunction_001 clickSetting')
      await driver.assertComponentExist(BY.text('设置', MatchPattern.CONTAINS))
      let setting = await driver.findComponent(BY.text('设置', MatchPattern.CONTAINS))
      await setting.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickMoreFunction_001 clickAutomaticToggle')
      // 点击自动同步开关
      await driver.assertComponentExist(BY.key('automaticToggle'))
      let automaticSync = await driver.findComponent(BY.key('automaticToggle'))
      await automaticSync.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickMoreFunction_001 clickManualToggle')
      // 点击手动同步开关
      await driver.assertComponentExist(BY.key('manualToggle'))
      let manualSync = await driver.findComponent(BY.key('manualToggle'))
      await manualSync.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickMoreFunction_001 end')
    })
  })
}