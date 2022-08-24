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

const TAG = '[Sample_CommonEvent]'
const DOMAIN = 0xF811
const BUNDLE = 'CommonEvent_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.etscommonevent",
          abilityName: "ohos.samples.etscommonevent.MainAbility"
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
     * 订阅公共事件
     */
    it(BUNDLE + 'SubscribeFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SubscribeFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SubscribeFunction_001 createSubscriber')
      // 创建订阅者
      await driver.assertComponentExist(BY.text('创建订阅者', MatchPattern.CONTAINS))
      let createBtn = await driver.findComponent(BY.text('创建订阅者', MatchPattern.CONTAINS))
      await createBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SubscribeFunction_001 subscribeCommonEvent')
      // 订阅公共事件
      await driver.assertComponentExist(BY.text('订阅公共事件', MatchPattern.CONTAINS))
      let subBtn = await driver.findComponent(BY.text('订阅公共事件', MatchPattern.CONTAINS))
      await subBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SubscribeFunction_001 end')
    })
    /**
     * 发布公共事件
     */
    it(BUNDLE + 'PublishFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 clickPublishCommonEventBtn')
      // 发布公共事件
      await driver.assertComponentExist(BY.text('发布公共事件', MatchPattern.CONTAINS))
      let pubBtn = await driver.findComponent(BY.text('发布公共事件', MatchPattern.CONTAINS))
      await pubBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 clickPublishInformationBtn')
      // 发布公共事件指定发布信息
      await driver.assertComponentExist(BY.text('发布公共事件指定发布信息', MatchPattern.CONTAINS))
      let pubInfoBtn = await driver.findComponent(BY.text('发布公共事件指定发布信息', MatchPattern.CONTAINS))
      await pubInfoBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 end')
    })
    /**
     * 取消订阅
     */
    it(BUNDLE + 'CancelSubscribeFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CancelSubscribeFunction_001　begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CancelSubscribeFunction_001　ClickCancelSubscribe')
      // 取消订阅
      await driver.assertComponentExist(BY.text('取消订阅', MatchPattern.CONTAINS))
      let cancelBtn = await driver.findComponent(BY.text('取消订阅', MatchPattern.CONTAINS))
      await cancelBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CancelSubscribeFunction_001　end')
    })
  })
}