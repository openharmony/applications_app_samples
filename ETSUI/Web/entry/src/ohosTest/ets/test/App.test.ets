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
import featureAbility from '@ohos.ability.featureAbility';
import hilog from '@ohos.hilog';

const BUNDLE = 'Web'
const TAG = '[Sample_Web]'
const DOMAIN = 0xF811

export default function appTest() {
  describe('appTest', function () {
    /**
     * 拉起一个Ability
     */
    it(BUNDLE + '_startAbility', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + '_startAbility start')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.etsweb",
          abilityName: "ohos.samples.etsweb.MainAbility"
        }
      }
      await featureAbility.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + '_startAbility get err ' + JSON.stringify(err))
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + '_startAbility end')
      })
    })
    /**
     * 点击相应图标进入相应网页
     */
    it(BUNDLE + '_IndexPage_BtnIcon', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_BtnIcon start")
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 点击应用图标进入对应网页
      await driver.assertComponentExist(BY.key('homeWeb0'))
      let webBtn = await driver.findComponent(BY.key('homeWeb0'))
      await webBtn.click()
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage__BtnIcon end")
    })
    /**
     * 在浏览多级网页后，可以通过点击**底部导航条**可实现进入上一级网页、下一级网页、进入主页面等操作。
     */
    it(BUNDLE + '_IndexPage_BottomBar', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_BottomBar start")
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 点击返回主页
      await driver.assertComponentExist(BY.key('option1'))
      let backBtn = await driver.findComponent(BY.key('option1'))
      await backBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_BottomBar end")
    })
    /**
     * 点击停止加载页面
     */
    it(BUNDLE + '_IndexPage_UpdatePage', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_UpdatePage start")
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 首页进入应用页
      await driver.assertComponentExist(BY.key('homeWeb0'))
      let webBtn = await driver.findComponent(BY.key('homeWeb0'))
      await webBtn.click()
      await driver.delayMs(1000)
      // 点击刷新按钮按钮
      await driver.assertComponentExist(BY.key('refresh'))
      let refreshPage = await driver.findComponent(BY.key('refresh'))
      await refreshPage.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_UpdatePage end")
      // 点击返回主页
      await driver.assertComponentExist(BY.key('option1'))
      let backBtn = await driver.findComponent(BY.key('option1'))
      await backBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_UpdatePage end")
    })
  })
}
