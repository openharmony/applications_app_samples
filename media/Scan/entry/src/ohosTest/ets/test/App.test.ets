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
    // 证明拉起白屏
    it(BUNDLE + '_IndexPage_btnAgree', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_BtnAgree start")
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      await driver.assertComponentExist(BY.text('允许', MatchPattern.CONTAINS))
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_BtnAgree end")
    })
  })
}
