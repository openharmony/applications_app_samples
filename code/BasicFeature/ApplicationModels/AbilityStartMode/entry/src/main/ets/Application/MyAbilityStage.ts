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

import AbilityStage from '@ohos.app.ability.AbilityStage'
import Want from '@ohos.application.Want'
import Logger from '../common/Logger'

const TAG = '[Sample_StartMode]'

export default class MyAbilityStage extends AbilityStage {
  onCreate() {
    Logger.info(TAG, 'MyAbilityStage onCreate')
  }

  onAcceptWant(want: Want) {
    Logger.info(TAG, 'MyAbilityStage onAcceptWant start')
    if (want && want.abilityName === 'SpecifiedAbility') {
      if (want.parameters) {
        return `SpecifiedAbility${want.parameters.foodItemId}`
      }
    }
    return ''
  }
}