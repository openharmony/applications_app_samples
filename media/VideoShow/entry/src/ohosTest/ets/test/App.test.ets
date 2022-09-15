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
import hilog from '@ohos.hilog'

const BUNDLE = 'VideoShow'
const TAG = '[Sample_VideoShow]'
const DOMAIN = 0xF811

export default function appTest() {
  describe('appTest', function () {
    /**
     * 拉起一个ability
     */
    it(BUNDLE + '_startAbility', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + '_startAbility start')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      let want = {
        bundleName: 'com.example.videoshow',
        abilityName: 'MainAbility'
      }
      var abilityDelegator: any
      abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      await abilityDelegator.startAbility(want, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + '_startAbility get err ' + JSON.stringify(err))
        expect(0).assertEqual(err.code)
        done()
        driver.delayMs(1000)
        hilog.info(DOMAIN, TAG, BUNDLE + '_startAbility end')
      })
    })
    /**
     * 进入直播间，并进行向上滑动以及向下滑动
     */
    it(BUNDLE + '_IndexPage_LiveVideo', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + '_IndexPage_LiveVideo start')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 点击进入直播间
      await driver.assertComponentExist(BY.key('directVideo'))
      let enterVideoComp = await driver.findComponent(BY.key('directVideo'))
      await enterVideoComp.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + '_IndexPage_LiveVideo end')
    })
  })
}
