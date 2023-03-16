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

import UIAbility from '@ohos.app.ability.UIAbility'
import Logger from '../model/Logger'
import window from '@ohos.window'

export default class MainAbility extends UIAbility {
  onCreate(want, launchParam) {
    Logger.info('[Sample_AdaptiveCapabilities]', 'MainAbility onCreate')
  }

  onDestroy() {
    Logger.info('[Sample_AdaptiveCapabilities]', 'MainAbility onDestroy')
  }

  onWindowStageCreate(windowStage) {
    // Main window is created, set main page for this ability
    Logger.info('[Sample_AdaptiveCapabilities]', 'onWindowStageCreate')
    windowStage.setUIContent(this.context, "pages/Index", null)
    window.getTopWindow(this.context)
      .then(windowObj => {
        AppStorage.SetOrCreate('windowObj', windowObj)
      })
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info('[Sample_AdaptiveCapabilities]', 'onWindowStageDestroy')
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info('[Sample_AdaptiveCapabilities]', 'onForeground')
  }

  onBackground() {
    // Ability has back to background
    Logger.info('[Sample_AdaptiveCapabilities]', 'onBackground')
  }
}
