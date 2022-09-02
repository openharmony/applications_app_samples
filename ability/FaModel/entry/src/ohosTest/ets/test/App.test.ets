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

import { UiDriver, BY } from '@ohos.uitest'
import { describe, it, expect } from '@ohos/hypium'
import featureAbility from '@ohos.ability.featureAbility'
import Logger from '../../../main/ets/MainAbility/util/Logger'

const TAG: string = 'AppTest'

export default function AppTest() {
  describe('appTest', function () {
    it('testClick_001', 0, async function (done) {
      Logger.info(TAG, 'testClick_001 begin')
      let parameter = {
        "want": {
          bundleName: 'ohos.samples.famodel',
          abilityName: 'ohos.samples.famodel.MainAbility'
        }
      }
      await featureAbility.startAbility(parameter, (err, data) => {
        expect(0).assertEqual(err.code)
        done()
      })
    })

    it('testClick_002', 0, async function () {
      Logger.info(TAG, 'testClick_002 begin')

      let driver = await UiDriver.create()
      await driver.delayMs(1000)

      Logger.info(TAG, 'testClick_002 end')
    })

    it('testClick_003', 0, async function () {
      Logger.info(TAG, 'testClick_003 begin')

      let driver = await UiDriver.create()
      await driver.assertComponentExist(BY.type('button'))
      let button = await driver.findComponent(BY.type('button'))
      await button.click()
      await driver.delayMs(1000)

      Logger.info(TAG, 'testClick_003 end')
    })
  })
}