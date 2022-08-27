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

const TAG = '[Sample_UtilLruBuffer]'
const DOMAIN = 0xF811
const BUNDLE = 'UtilLruBuffer_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'testClick_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'testClick_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.utillrubuffer",
          abilityName: "ohos.samples.utillrubuffer.MainAbility"
        }
      }
      featureAbility.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'testClick_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'testClick_001 end')
      })
    })
    /**
     * 点击按钮分别执行对应操作
     */
    it(BUNDLE + 'ClickBtnFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBtnFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBtnFunction_001 clickInitBufferBtn')
      // 点击初始化缓冲区
      await driver.assertComponentExist(BY.text('初始化缓冲区', MatchPattern.CONTAINS))
      let initBufferBtn = await driver.findComponent(BY.text('初始化缓冲区', MatchPattern.CONTAINS))
      await initBufferBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBtnFunction_001 clickGetBufferCapacityBtn')
      // 点击获取缓冲区容量
      await driver.assertComponentExist(BY.text('获取缓冲区容量', MatchPattern.CONTAINS))
      let getBufferCapacityBtn = await driver.findComponent(BY.text('获取缓冲区容量', MatchPattern.CONTAINS))
      await getBufferCapacityBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBtnFunction_001 clickUpdateBufferCapacityBtn')
      // 点击更新缓冲区容量
      await driver.assertComponentExist(BY.text('更新缓冲区容量', MatchPattern.CONTAINS))
      let updateBufferCapacityBtn = await driver.findComponent(BY.text('更新缓冲区容量', MatchPattern.CONTAINS))
      await updateBufferCapacityBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBtnFunction_001 clickGetBufferStringBtn')
      // 点击获取缓冲区字符串
      await driver.assertComponentExist(BY.text('获取缓冲区字符串', MatchPattern.CONTAINS))
      let getBufStrBtn = await driver.findComponent(BY.text('获取缓冲区字符串', MatchPattern.CONTAINS))
      await getBufStrBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBtnFunction_001 clickAddKeyValuePairBtn')
      // 点击添加键值对
      let addKeyValuePairBtn = await driver.findComponent(BY.text('添加键值对', MatchPattern.CONTAINS))
      await addKeyValuePairBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBtnFunction_001 clickGetValueWithKeyBtn')
      // 点击获取键对应的值
      await driver.assertComponentExist(BY.text('获取键对应的值', MatchPattern.CONTAINS))
      let getValueWithKeyBtn = await driver.findComponent(BY.text('获取键对应的值', MatchPattern.CONTAINS))
      await getValueWithKeyBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBtnFunction_001 clickGetValueOfTheKey')
      // 点击key对应的值
      await driver.assertComponentExist(BY.key('getValueOfTheKey'))
      let getValueOfTheKey = await driver.findComponent(BY.key('getValueOfTheKey'))
      await getValueOfTheKey.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBtnFunction_001 clickGetAllKeyValuePairBtn')
      // 点击获取所有键值对
      await driver.assertComponentExist(BY.text('获取所有键值对', MatchPattern.CONTAINS))
      let getAllKeyValuePairBtn = await driver.findComponent(BY.text('获取所有键值对', MatchPattern.CONTAINS))
      await getAllKeyValuePairBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBtnFunction_001 clickDeleteBtn')
      // 点击删除指定键及关联值
      await driver.assertComponentExist(BY.text('删除指定键及关联值', MatchPattern.CONTAINS))
      let delBtn = await driver.findComponent(BY.text('删除指定键及关联值', MatchPattern.CONTAINS))
      await delBtn.click()
      await driver.delayMs(1000)
      // 点击key对应的值
      await getValueOfTheKey.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBtnFunction_001 clickClearAllKeyValuePairBtn')
      // 点击清除所有键值对
      await driver.assertComponentExist(BY.text('清除所有键值对', MatchPattern.CONTAINS))
      let clearAllKeyValuePairBtn = await driver.findComponent(BY.text('清除所有键值对', MatchPattern.CONTAINS))
      await clearAllKeyValuePairBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBtnFunction_001 clickViewRecordBtn')
      // 点击查看操作记录
      await driver.assertComponentExist(BY.text('查看操作记录', MatchPattern.CONTAINS))
      let viewRecordBtn = await driver.findComponent(BY.text('查看操作记录', MatchPattern.CONTAINS))
      await viewRecordBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBtnFunction_001 end')
    })
  })
}