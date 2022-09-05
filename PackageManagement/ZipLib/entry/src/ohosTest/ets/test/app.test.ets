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

const TAG = '[Sample_ZipLib]'
const DOMAIN = 0xF811
const BUNDLE = 'ZipLib_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.ziplib",
          abilityName: "ohos.samples.ziplib.MainAbility"
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
     * 添加文件
     */
    it(BUNDLE + 'AddFileFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFileFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFileFunction_001 clickAddBtn')
      // 点击添加
      await driver.assertComponentExist(BY.key('addFileBtn'))
      let btnAdd = await driver.findComponent(BY.key('addFileBtn'))
      await btnAdd.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFileFunction_001 inputFileName')
      // 输入文件名称
      await driver.assertComponentExist(BY.key('inputFileName'))
      let fileName = await driver.findComponent(BY.key('inputFileName'))
      await fileName.inputText('js')
      let fileNameVal = await fileName.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFileFunction_001 fileNameVal')
      expect('js').assertEqual(fileNameVal)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFileFunction_001 inputFileContent')
      // 输入文件内容
      await driver.assertComponentExist(BY.key('inputFileContent'))
      let fileContent = await driver.findComponent(BY.key('inputFileContent'))
      await fileContent.inputText('nodejs')
      let fileContentVal = await fileContent.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFileFunction_001 fileContentVal')
      expect('nodejs').assertEqual(fileContentVal)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFileFunction_001 clickConfirmBtn')
      // 点击确认
      await driver.assertComponentExist(BY.key('confirmBtn'))
      let confirmBtn = await driver.findComponent(BY.key('confirmBtn'))
      await confirmBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFileFunction_001 end')
    })
    /**
     * 压缩和解压文件
     */
    it(BUNDLE + 'CompressedFileFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CompressedFileFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CompressedFileFunction_001 clickZipBtn')
      // 点击压缩
      await driver.assertComponentExist(BY.text('压缩', MatchPattern.CONTAINS))
      let zip = await driver.findComponent(BY.text('压缩', MatchPattern.CONTAINS))
      await zip.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CompressedFileFunction_001 clickUnZipBtn')
      // 点击解压
      await driver.assertComponentExist(BY.text('解压', MatchPattern.CONTAINS))
      let unzip = await driver.findComponent(BY.text('解压', MatchPattern.CONTAINS))
      await unzip.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CompressedFileFunction_001 end')
    })
  })
}