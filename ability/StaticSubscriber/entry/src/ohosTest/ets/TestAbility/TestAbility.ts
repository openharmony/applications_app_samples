/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import Ability from '@ohos.application.Ability'
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry'
import { Hypium } from 'hypium/index'
import testsuite from '../test/List.test'
import Logger from '../../../main/ets/model/Logger'

export default class TestAbility extends Ability {
  onCreate(want, launchParam) {
    Logger.info('TestAbility onCreate')
    var abilityDelegator: any
    abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
    var abilityDelegatorArguments: any
    abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments()
    Logger.info('start run testcase!!!')
    Hypium.hypiumTest(abilityDelegator, abilityDelegatorArguments, testsuite)
  }

  onDestroy() {
    Logger.info('TestAbility onDestroy')
  }

  onWindowStageCreate(windowStage) {
    Logger.info('TestAbility onWindowStageCreate')
    windowStage.setUIContent(this.context, 'TestAbility/pages/Index', null)

    globalThis.abilityContext = this.context
  }

  onWindowStageDestroy() {
    Logger.info('TestAbility onWindowStageDestroy')
  }

  onForeground() {
    Logger.info('TestAbility onForeground')
  }

  onBackground() {
    Logger.info('TestAbility onBackground')
  }
}