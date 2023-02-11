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
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry'
import { UiDriver, BY, UiComponent, MatchPattern } from '@ohos.uitest'
import hilog from '@ohos.hilog';

const BUNDLE = 'DistributedDataGobang'
const TAG = '[Sample_DistributedDataGobang]'
const DOMAIN = 0xF811

export default function appTest() {
  describe('appTest', function () {
    /**
     * 拉起Ability
     */
    it(BUNDLE + '_startAbility', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + '_startAbility start')
      let want = {
        bundleName: 'ohos.samples.distributeddatagobang',
        abilityName: 'MainAbility'
      }
      var abilityDelegator: any
      abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      await abilityDelegator.startAbility(want, (err) => {
        hilog.info(DOMAIN, TAG, BUNDLE + '_startAbility get err ' + JSON.stringify(err))
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + '_startAbility end')
      })
    })
    /**
     * 授权
     */
    it(BUNDLE + '_IndexPage_btnAgree', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_btnAgree start")
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 相机权限点击允许
      await driver.assertComponentExist(BY.text('允许', MatchPattern.CONTAINS))
      let btnCameraAgree = await driver.findComponent(BY.text('允许', MatchPattern.CONTAINS))
      await btnCameraAgree.click()
      await driver.delayMs(5000)
      hilog.info(DOMAIN, TAG, BUNDLE + "_IndexPage_btnAgree end")
    })
  })
}
