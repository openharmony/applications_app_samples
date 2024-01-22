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

import { describe, it, expect } from '@ohos/hypium'
import Logger from '../../../../../position/src/main/ets/components/util/Logger'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import { Driver, ON } from '@ohos.UiTest'
import UIAbility from '@ohos.app.ability.UIAbility';

const TAG = '[Sample_Location]'
const BUNDLE = 'Location_'
const delegator = AbilityDelegatorRegistry.getAbilityDelegator()

// 本地化资源
async function getResourceString(resource: Resource): Promise<string> {
  let manage = delegator.getAppContext().resourceManager
  let text = await manage.getStringValue(resource)
  return text
}

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    /**
     * open the application
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      Logger.info(TAG, BUNDLE + 'StartAbility_001 begin')
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.location',
          abilityName: 'MainAbility'
        })
        done()
      } catch (exception) {
        Logger.info(TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail()
      }
      Logger.info(TAG, BUNDLE + 'StartAbility_001 end')
    })

    /**
     * 获取权限
     */
    it(BUNDLE + 'RequestPermissionFunction_001', 0, async () => {
      Logger.info(TAG, BUNDLE + 'RequestPermissionFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(2000);
      // 获取访问位置
      Logger.info(TAG, BUNDLE + 'RequestPermissionFunction_001 requestPermission');
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.only_accept_during_use'))));
      let btnAccept = await driver.findComponent(ON.text(await getResourceString($r('app.string.only_accept_during_use'))));
      await btnAccept.click();
      Logger.info(TAG, BUNDLE + 'RequestPermissionFunction_001 end');
    })

    /**
     * 选择所在的城市
     */
    it(BUNDLE + 'SelectCityFunction_001', 0, async () => {
      Logger.info(TAG, BUNDLE + 'SelectCityFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(2000)
      // 点击热门城市
      Logger.info(TAG, BUNDLE + 'SelectCityFunction_001 clickHeatCity')
      await driver.assertComponentExist(ON.id('city1'))
      let heatCity = await driver.findComponent(ON.id('city1'))
      await heatCity.click()
      // 已经选择城市
      await driver.assertComponentExist(ON.id('currentLoc'))
      let currentCity = await driver.findComponent(ON.id('currentLoc'))
      let currentValue = await currentCity.getText()
      expect(currentValue).assertEqual(await getResourceString($r('app.string.beijing')))
      // 点击索引来选择城市
      Logger.info(TAG, BUNDLE + 'SelectAlphaCityFunction_001 clickCityByAlpha')
      await driver.assertComponentExist(ON.text('A'))
      let alpha = await driver.findComponents(ON.text('A'))
      await alpha[0].click()
      await driver.assertComponentExist(ON.id('cityFirst1'))
      let cityFirst = await driver.findComponent(ON.id('cityFirst1'))
      await cityFirst.click()
      await driver.assertComponentExist(ON.id('region2'))
      let region = await driver.findComponent(ON.id('region2'))
      await region.click()
      // 现在所选择的城市
      await driver.assertComponentExist(ON.id('currentLoc'))
      let currentSelectCity = await driver.findComponent(ON.id('currentLoc'))
      let currentCityValue = await currentSelectCity.getText()
      expect(currentCityValue).assertEqual(await getResourceString($r('app.string.anhui')))
      Logger.info(TAG, BUNDLE + 'SelectCityFunction_001 end')
    })
  })
}