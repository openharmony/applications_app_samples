/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import { Driver, ON, Component, MatchPattern, DisplayRotation } from '@ohos.UiTest'
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import hilog from '@ohos.hilog'

const TAG = '[Sample_Sensor]'
const DOMAIN = 0xF811
const BUNDLE = 'Sensor_'

// 检查页面是否正常显示
async function checkPage(driver: Driver) {
  hilog.info(DOMAIN, TAG, 'checkPage begin')
  let resourceManager = abilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager
  await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.directionNorth'))))
  await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.angle'))))
  await driver.assertComponentExist(ON.type('Image'))
  hilog.info(DOMAIN, TAG, 'checkPage end')
}

export default function appTest() {
  describe('ActsAbilityTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let parameter = {
        bundleName: "ohos.samples.sensor",
        abilityName: "EntryAbility"
      }
      abilityDelegatorRegistry.getAbilityDelegator().startAbility(parameter, (err, data) => {
        if (err !== null) {
          hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err.code:' + err.code)
          expect(0).assertEqual(err.code)
        }
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
      })
    })

    /**
     * 拉起Sensor
     */
    it(BUNDLE + 'BringSensorFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'BringSensorFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'BringSensorFunction_001 end')
    })

    /**
     * 检查页面控件是否正常显示
     */
    it(BUNDLE + 'CheckSensorFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckSensorFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(500)
      await checkPage(driver)
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckSensorFunction_001 end')
    })

    /**
     * 切换到横屏(转动90°)
     */
    it(BUNDLE + 'RotateScreenLandscapeFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'RotateScreenLandscapeFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      await driver.setDisplayRotation(DisplayRotation.ROTATION_90)
      await driver.delayMs(1000)
      await checkPage(driver)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'RotateScreenLandscapeFunction_001 end')
    })

    /**
     * 切换回竖屏
     */
    it(BUNDLE + 'RotateScreenPortraitFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'RotateScreenPortraitFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      await driver.setDisplayRotation(DisplayRotation.ROTATION_0)
      await driver.delayMs(1000)
      await checkPage(driver)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'RotateScreenPortraitFunction_001 end')
    })
  })
}