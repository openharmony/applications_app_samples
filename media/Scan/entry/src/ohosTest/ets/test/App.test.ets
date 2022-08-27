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
import hilog from '@ohos.hilog';

const BUNDLE = "Scan"
const TAG = '[Sample_Scan]'
const DOMAIN = 0xF811

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + '_startAbility', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + "_startAbility start")
      let want = {
        bundleName: "com.example.scan",
        abilityName: "MainAbility"
      }
      await globalThis.abilityContext.startAbility(want, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + "_startAbility get err " + JSON.stringify(err))
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + "_startAbility end")
      })
    })
    // 点击允许权限
    it(BUNDLE + '_IndexPage_btnAgree', 0, async function () {
      // hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_btnAgree start")
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 相机权限点击允许
      await driver.assertComponentExist(BY.text('允许', MatchPattern.CONTAINS))
      let btnCameraAgree = await driver.findComponent(BY.text('允许', MatchPattern.CONTAINS))
      await btnCameraAgree.click()
      await driver.delayMs(1000)
      // 麦克风权限点击允许
      await driver.assertComponentExist(BY.text('允许', MatchPattern.CONTAINS))
      let btnMicrophoneAgree = await driver.findComponent(BY.text('允许', MatchPattern.CONTAINS))
      await btnMicrophoneAgree.click()
      await driver.delayMs(1000)
      // 媒体和文件权限点击允许
      await driver.assertComponentExist(BY.text('允许', MatchPattern.CONTAINS))
      let btnMediaAgree = await driver.findComponent(BY.text('允许', MatchPattern.CONTAINS))
      await btnMediaAgree.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_btnAgree end")
    })
    /**
     * 点击扫一扫
     */
    it(BUNDLE + '_IndexPage_ScanBtn', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_ScanBtn start")
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      await driver.assertComponentExist(BY.key('btnScan'))
      let scanBtn = await driver.findComponent(BY.key('btnScan'))
      await scanBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_ScanBtn end")
    })
    /**
     * 获取二维码图片
     */
    it(BUNDLE + '_ScanPage_getScanPicture', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + "_ScanPage_getScanPicture start")
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      await driver.assertComponentExist(BY.key('getScanPicture'))
      // 点击右上角图片，进入文件页
      let pictureBtn = await driver.findComponent(BY.key('getScanPicture'))
      await pictureBtn.click()
      await driver.delayMs(3000)
      await driver.assertComponentExist(BY.text('图片', MatchPattern.CONTAINS))
      let ImageComp = await driver.findComponent(BY.text('图片', MatchPattern.CONTAINS))
      await ImageComp.click()
      await driver.delayMs(1000)
      await driver.assertComponentExist(BY.text('取消', MatchPattern.CONTAINS))
      let cancelBtn = await driver.findComponent(BY.text('取消', MatchPattern.CONTAINS))
      await cancelBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + "_ScanPage_getScanPicture end")
    })
    /**
     * 点击轻触效果
     */
    it(BUNDLE + '_ScanPage_TouchLight', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + "_ScanPage_ScanPage start")
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      await driver.assertComponentExist(BY.key('touchLight'))
      let touchLightBtn = await driver.findComponent(BY.key('touchLight'))
      await touchLightBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + "_ScanPage_ScanPage end")
    })
  })
}
