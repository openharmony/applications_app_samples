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

const TAG = '[Sample_ArkUIAnimation]'
const DOMAIN = 0xF811
const BUNDLE = 'ArkUIAnimation_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.etsarkuianimation",
          abilityName: "ohos.samples.etsarkuianimation.MainAbility"
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
     * 启动动画
     */
    it(BUNDLE + 'StartAnimation_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAnimation_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 点击主图标 开启动画
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAnimation_001 start')
      await driver.assertComponentExist(BY.key('mainImg'))
      let mainImg = await driver.findComponent(BY.key('mainImg'))
      await mainImg.click()
      await driver.delayMs(1000)
      // 再次点击主图标 结束动画
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAnimation_001 finish')
      await mainImg.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAnimation_001 end')
    })

    /**
     * 启动小动画
     */
    it(BUNDLE + 'SmallAnimation_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'SmallAnimation_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 点击主图标 出现小动画
      hilog.info(DOMAIN, TAG, BUNDLE + 'SmallAnimation_001 mainImg')
      await driver.assertComponentExist(BY.key('mainImg'))
      let mainImg = await driver.findComponent(BY.key('mainImg'))
      await mainImg.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SmallAnimation_001 end')
    })

    /**
     * 增加、减少小动画
     */
    it(BUNDLE + 'AddSmallAnimation_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddSmallAnimation_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 增加小动画
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddSmallAnimation_001 add')
      await driver.assertComponentExist(BY.key('add'))
      let addBtn = await driver.findComponent(BY.key('add'))
      await addBtn.click()
      await driver.delayMs(1000)
      await addBtn.click()
      await driver.delayMs(1000)
      await addBtn.click()
      await driver.delayMs(1000)
      // 减少小动画
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddSmallAnimation_001 reduce')
      await driver.assertComponentExist(BY.key('reduce'))
      let reduceBtn = await driver.findComponent(BY.key('reduce'))
      await reduceBtn.click()
      await driver.delayMs(1000)
      // 关闭动画
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddSmallAnimation_001 mainImg')
      await driver.assertComponentExist(BY.key('mainImg'))
      let mainImg = await driver.findComponent(BY.key('mainImg'))
      await mainImg.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddSmallAnimation_001 end')
    })
  })
}