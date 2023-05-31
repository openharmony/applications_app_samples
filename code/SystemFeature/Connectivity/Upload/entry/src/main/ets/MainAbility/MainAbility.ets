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

import UIAbility from '@ohos.app.ability.UIAbility'
import Window from '@ohos.window'
import Logger from '../util/Logger'
import type { Permissions } from '@ohos.abilityAccessCtrl'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
import window from '@ohos.window'
import display from '@ohos.display'

const TAG: string = '[MainAbility]'
const PERMISSIONS: Array<Permissions> = ['ohos.permission.READ_MEDIA', 'ohos.permission.WRITE_MEDIA', 'ohos.permission.CAMERA', 'ohos.permission.INTERNET', 'ohos.permission.GET_NETWORK_INFO']

export default class MainAbility extends UIAbility {
  private windowObj: window.Window
  private curBp: string

  async onCreate(want, launchParam) {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager()
    try {
      atManager.requestPermissionsFromUser(this.context, PERMISSIONS).then((data) => {
        AppStorage.SetOrCreate('filePath', this.context.filesDir)
        AppStorage.SetOrCreate('context', this.context)
        Logger.info(TAG, 'MainAbility onCreate')
      }).catch((err) => {
        Logger.info(TAG, `err: ${JSON.stringify(err)}`)
      })
    } catch (err) {
      Logger.info(TAG, `catch err->${JSON.stringify(err)}`);
    }
  }

  // 根据当前窗口尺寸更新断点
  private updateBreakpoint(windowWidth) {
    const dpi = display.getDefaultDisplaySync().densityDPI;
    // 将长度的单位由px换算为vp
    let windowWidthVp = windowWidth / (dpi / 160)
    let newBp: string = ''
    if (windowWidthVp < 320) {
      newBp = 'xs'
    } else if (windowWidthVp < 520) {
      newBp = 'sm'
    } else if (windowWidthVp < 840) {
      newBp = 'md'
    } else {
      newBp = 'lg'
    }
    if (this.curBp !== newBp) {
      this.curBp = newBp
      // 使用状态变量记录当前断点值
      AppStorage.SetOrCreate('currentBreakpoint', this.curBp)
    }
    Logger.info("dpi为：" + dpi + "，窗口更新断点为：" + newBp)
  }

  onDestroy() {
    Logger.info(TAG, 'MainAbility onDestroy')
  }

  onWindowStageCreate(windowStage: Window.WindowStage) {
    // Main window is created, set main page for this ability
    Logger.info(TAG, 'MainAbility onWindowStageCreate')

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.info(TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`)
        return
      }
      Logger.info(TAG, `Succeeded in loading the content. Data:  ${JSON.stringify(data)}`)
    })

    windowStage.getMainWindow().then((windowObj) => {
      this.windowObj = windowObj
      // 获取应用启动时的窗口尺寸
      this.updateBreakpoint(windowObj.getWindowProperties().windowRect.width)
      // 注册回调函数，监听窗口尺寸变化
      windowObj.on('windowSizeChange', (windowSize) => {
        this.updateBreakpoint(windowSize.width)
      })
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, `MainAbility onWindowStageDestroy`)
    if (this.windowObj) {
      this.windowObj.off('windowSizeChange')
    }
  }

  onForeground() {
    // Ability has brought to foreground
    AppStorage.SetOrCreate('cameraStatus',!AppStorage.Get('cameraStatus'))
    Logger.info(TAG, `MainAbility onForeground`)
  }

  onBackground() {
    // Ability has back to background
    Logger.info(TAG, `MainAbility onBackground`)
  }
}
