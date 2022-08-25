/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

const BUNDLE = 'Notification'
const TAG = '[Sample_Notification]'
const DOMAIN = 0xF811

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + '_startAbility', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + "_startAbility start")
      let parameter = {
        "want": {
          bundleName: "ohos.samples.etsnotification",
          abilityName: "ohos.samples.etsnotification.MainAbility"
        }
      }
      await featureAbility.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + "_startAbility get err " + JSON.stringify(err))
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + "_startAbility end")
      })
    })
    /**
     * 创建通道
     */
    it(BUNDLE + '_IndexPage_CreateSlot', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_CreateSlot start")
      let driver = await UiDriver.create()
      await driver.delayMs(200)
      await driver.assertComponentExist(BY.key('createSlot'))
      let slotComp = await driver.findComponent(BY.key('createSlot'))
      await slotComp.click()
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_CreateSlot end")
    })
    /**
     * 发布通知
     */
    it(BUNDLE + '_IndexPage_PublishNotice', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_PublishNotice start")
      let driver = await UiDriver.create()
      await driver.delayMs(200)
      // 选择长文本类型
      await driver.assertComponentExist(BY.key('longText'))
      let longTextComp =  await driver.findComponent(BY.key('longText'))
      await longTextComp.click()
      await driver.delayMs(1000)
      await driver.assertComponentExist(BY.key('publishNotice'))
      let PublishComp = await driver.findComponent(BY.key('publishNotice'))
      await PublishComp.click()
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_PublishNotice end")
    })
    /**
     * 取消最近通知以及全部通知
     */
    it(BUNDLE + '_IndexPage_CancelNotice', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_CancelNotice start")
      let driver = await UiDriver.create()
      await driver.delayMs(200)
      // 取消最近通知
      await driver.assertComponentExist(BY.key('longText'))
      let cancelLastComp =  await driver.findComponent(BY.key('cancelLast'))
      await cancelLastComp.click()
      await driver.delayMs(1000)
      // 取消全部通知
      await driver.assertComponentExist(BY.key('cancelAll'))
      let PublishComp = await driver.findComponent(BY.key('cancelAll'))
      await PublishComp.click()
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_CancelNotice end")
    })
    /**
     * 删除通道
     */
    it(BUNDLE + '_IndexPage_DeleteSlot', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_DeleteSlot start")
      let driver = await UiDriver.create()
      await driver.delayMs(200)
      await driver.assertComponentExist(BY.key('deleteSlot'))
      let slotComp = await driver.findComponent(BY.key('deleteSlot'))
      await slotComp.click()
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_DeleteSlot end")
    })
  })
}
