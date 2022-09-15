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
import {UiDriver,BY,UiComponent,MatchPattern} from '@ohos.uitest'
import featureAbility from '@ohos.ability.featureAbility'
import hilog from '@ohos.hilog'

const TAG = '[Sample_FileIo]'
const DOMAIN = 0xF811
const BUNDLE = 'FileIo_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.etsfileio",
          abilityName: "ohos.samples.etsfileio.MainAbility"
        }
      }
      featureAbility.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
      })
    })

    /**
     * 创建文件
     */
    it(BUNDLE + 'CreateFunction_001', 0, async function () {
      // 进入页面
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(3000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_001 clickCreate')
      // 点击创建文件
      await driver.assertComponentExist(BY.text('创建文件', MatchPattern.CONTAINS))
      let btnCreate = await driver.findComponent(BY.text('创建文件', MatchPattern.CONTAINS))
      await btnCreate.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateFunction_001 end')
    })

    /**
     * 修改文件名
     */
    it(BUNDLE + 'RenameFunction_001', 0, async function () {
      // 进入页面
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenameFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(3000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenameFunction_001 clickRename')
      // 点击修改文件名
      await driver.assertComponentExist(BY.text('修改文件名', MatchPattern.CONTAINS))
      let btnRename = await driver.findComponent(BY.text('修改文件名', MatchPattern.CONTAINS))
      await btnRename.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenameFunction_001 end')
    })

    /**
     * 写入文件
     */
    it(BUNDLE + 'WriteFunction_001', 0, async function () {
      // 进入页面
      hilog.info(DOMAIN, TAG, BUNDLE + 'WriteFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(3000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'WriteFunction_001 clickWrite')
      // 点击写入文件
      await driver.assertComponentExist(BY.text('写入文件', MatchPattern.CONTAINS))
      let btnWrite = await driver.findComponent(BY.text('写入文件', MatchPattern.CONTAINS))
      await btnWrite.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'WriteFunction_001 end')
    })

    /**
     * 读取文件
     */
    it(BUNDLE + 'ReadFunction_001', 0, async function () {
      // 进入页面
      hilog.info(DOMAIN, TAG, BUNDLE + 'ReadFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(3000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ReadFunction_001 clickRead')
      // 点击读取文件
      await driver.assertComponentExist(BY.text('读取文件', MatchPattern.CONTAINS))
      let btnRead = await driver.findComponent(BY.text('读取文件', MatchPattern.CONTAINS))
      await btnRead.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ReadFunction_001 end')
    })

    /**
     * 删除文件
     */
    it(BUNDLE + 'DeleteFunction_001', 0, async function () {
      // 进入页面
      hilog.info(DOMAIN, TAG, BUNDLE + 'DeleteFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(3000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'DeleteFunction_001 clickDelete')
      // 点击删除文件
      await driver.assertComponentExist(BY.text('删除文件', MatchPattern.CONTAINS))
      let btnDelete = await driver.findComponent(BY.text('删除文件', MatchPattern.CONTAINS))
      await btnDelete.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'DeleteFunction_001 end')
    })
  })
}
