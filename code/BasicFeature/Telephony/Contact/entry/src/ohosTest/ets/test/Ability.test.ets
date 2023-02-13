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
import hilog from '@ohos.hilog';

const BUNDLE = 'Contact'
const TAG = '[Sample_Contact]'
const DOMAIN = 0xF811

export default function appTest() {
  describe('appTest', function () {
    /**
     * 启动一个Ability
     */
    it(BUNDLE + '_startAbility', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + '_startAbility start')
      let parameter = {
        bundleName: "ohos.samples.contact",
        abilityName: "EntryAbility"
      }
      let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator()
      await abilityDelegatorRegistry.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + '_startAbility get err ' + JSON.stringify(err))
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + '_startAbility end')
      })
    })
    /**
     * 允许授予权限
     */
    it(BUNDLE + '_IndexPage_AgreeBtn', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + '_IndexPage_AgreeBtn start')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 授权
      await driver.assertComponentExist(BY.text('允许'))
      let agreeBtn = await driver.findComponent(BY.text('允许'))
      await agreeBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + '_IndexPage_AgreeBtn end')
    })
    /**
     * 点击首页Tabs
     */
    it(BUNDLE + '_IndexPage_TabBtn', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + '_IndexPage_TabBtn start')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 电话tab
      await driver.assertComponentExist(BY.key('tab0'))
      let tabPhone = await driver.findComponent(BY.key('tab0'))
      await tabPhone.click()
      await driver.delayMs(1000)
      // 收藏tab
      await driver.assertComponentExist(BY.key('tab2'))
      let tabCollect = await driver.findComponent(BY.key('tab2'))
      await tabCollect.click()
      await driver.delayMs(1000)
      // 联系人tab
      await driver.assertComponentExist(BY.key('tab1'))
      let tabContact = await driver.findComponent(BY.key('tab1'))
      await tabContact.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + '_IndexPage_TabBtn end')
    })
    /**
     * 添加联系人，readme中约束限制讲述add接口有问题，这个功能存在不确定性,暂时点击返回
     */
    it(BUNDLE + '_AddContactPage_ContactAdd', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + '_AddContactPage_ContactAdd start')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 点击进入添加联系人页面
      await driver.assertComponentExist(BY.key('add'))
      let addBtn = await driver.findComponent(BY.key('add'))
      await addBtn.click()
      await driver.delayMs(1000)
      // 点击返回首页，readme中约束限制讲述add接口有问题，这个功能存在不确定性,暂时点击返回
      await driver.assertComponentExist(BY.key('backIndex'))
      let backBtn = await driver.findComponent(BY.key('backIndex'))
      await backBtn.click()
      hilog.info(DOMAIN, TAG, BUNDLE + '_AddContactPage_ContactAdd end')
    })
    /**
     * 进入设置界面新建联系人
     */
    it(BUNDLE + '_SettingPage_Setting', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + '_SettingPage_Setting start')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 进入设置界面
      await driver.assertComponentExist(BY.key('setting'))
      let agreeBtn = await driver.findComponent(BY.key('setting'))
      await agreeBtn.click()
      await driver.delayMs(1000)
      // 新建联系人
      await driver.assertComponentExist(BY.key('newAddContact'))
      let addBtn = await driver.findComponent(BY.key('newAddContact'))
      await addBtn.click()
      await driver.delayMs(1000)
      // 点击返回设置界面
      await driver.assertComponentExist(BY.key('backIndex'))
      let backSetting = await driver.findComponent(BY.key('backIndex'))
      await backSetting.click()
      await driver.delayMs(1000)
      // 点击从设置页返回首页
      await driver.assertComponentExist(BY.key('back'))
      let backBtn = await driver.findComponent(BY.key('back'))
      await backBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + '_SettingPage_Setting end')
    })
  })
}
