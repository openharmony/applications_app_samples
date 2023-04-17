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
import window from '@ohos.window'
import Logger from '../../../../../WindowComponent/src/main/ets/components/util/Logger'
import WindowManger from "../../../../../WindowComponent/src/main/ets/components/feature/WindowManger"

export default class MainAbility extends UIAbility {
  private TAG: string = 'WindowManger'
  private subWindow: window.WindowStage

  onCreate(want) {
    const that = this
    this.context.eventHub.on("createWindow", (data) => {
      data.context = that.context
      data.launchWant = want
      data.subWindow = that.subWindow
    })
  }

  onDestroy() {
    Logger.info(this.TAG, 'MainAbility onDestroy')
  }

  onWindowStageCreate(windowStage) {
    this.subWindow = windowStage
    WindowManger.initMainWindow(windowStage)
    windowStage.loadContent("pages/Index")
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info(this.TAG, 'MainAbility onWindowStageDestroy')
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info(this.TAG, 'MainAbility onForeground')
  }

  onBackground() {
    // Ability has back to background
    Logger.info(this.TAG, 'MainAbility onBackground')
  }
}
