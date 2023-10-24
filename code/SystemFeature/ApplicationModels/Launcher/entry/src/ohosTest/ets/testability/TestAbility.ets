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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import UIAbility from '@ohos.app.ability.UIAbility'
import { Hypium } from '@ohos/hypium'
import testsuite from '../test/List.test'
import { Logger } from '@ohos/base'
import Want from '@ohos.app.ability.Want'
import AbilityConstant from '@ohos.app.ability.AbilityConstant'
import { BusinessError } from '@ohos.base'
import window from '@ohos.window'

const TAG: string = 'TestAbility'

export default class TestAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    // launcher需要通过拉起ServiceExtensionAbility的方式拉起
    Logger.info(TAG, 'TestAbility onCreate')
    let serviceWant: Want = {
      'deviceId': '',
      'bundleName': 'ohos.samples.launcher',
      'abilityName': 'MainAbility'
    }
    this.context.startServiceExtensionAbility(serviceWant).then(() => {
      Logger.info('startServiceExtensionAbility success')
    }).catch((error: BusinessError) => {
      Logger.info('startServiceExtensionAbility failed: ' + JSON.stringify(error))
    })
  }

  onDestroy() {
    Logger.info(TAG, 'TestAbility onDestroy')
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    Logger.info(TAG, 'TestAbility onWindowStageCreate')
    windowStage.loadContent("testability/pages/Index", (err, data) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`)
        return;
      }
      Logger.error(TAG, `Succeeded in loading the content. Data:: ${JSON.stringify(data)}`)
    })

    let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
    let abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments()
    Logger.info(TAG, 'start run testcase!!!')
    Hypium.hypiumTest(abilityDelegator, abilityDelegatorArguments, testsuite)
  }

  onWindowStageDestroy() {
    Logger.info(TAG, 'TestAbility onWindowStageDestroy')
  }

  onForeground() {
    Logger.info(TAG, 'TestAbility onForeground')
  }

  onBackground() {
    Logger.info(TAG, 'TestAbility onBackground')
  }
}