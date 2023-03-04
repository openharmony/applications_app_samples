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

import UIAbility from '@ohos.app.ability.UIAbility';
import deviceInfo from'@ohos.deviceInfo'
import display from '@ohos.display';
import Window from '@ohos.window'
import { Logger } from '@ohos/common'

const TAG: string = 'MainAbility'

export default class MainAbility extends UIAbility {
  storage: LocalStorage

  onCreate(want, launchParam) {
    Logger.info(TAG, 'MainAbility onCreate')
    this.storage = new LocalStorage()
    this.storage.setOrCreate('selectedLabel', '')
    this.storage.setOrCreate('isSplitMode', deviceInfo.deviceType === 'tablet')
  }

  onDestroy() {
    Logger.info(TAG, 'MainAbility onDestroy');
  }

  updateBreakpoint(windowWidth: number) {
    let windowWidthVp: number = windowWidth / (display.getDefaultDisplaySync().densityDPI / 160)
    let curBp: string
    if (windowWidthVp < 520) {
      curBp = 'sm'
    } else if (windowWidthVp < 840) {
      curBp = 'md'
    } else {
      curBp = 'lg'
    }
    Logger.info(TAG, 'window width: ' + windowWidth +', window width vp: ' + windowWidthVp + ', breakpoint: ' + curBp)
    this.storage.setOrCreate('currentBreakpoint', curBp)
    this.storage.setOrCreate('windowWidth', windowWidthVp)
  }

  onWindowStageCreate(windowStage: Window.WindowStage) {
    // Main window is created, set main page for this ability
    Logger.info(TAG, 'MainAbility onWindowStageCreate')

    windowStage.getMainWindow().then((windowObj) => {
      this.updateBreakpoint(windowObj.getWindowProperties().windowRect.width)
      windowObj.on('windowSizeChange', (newSize)=>{
        this.updateBreakpoint(newSize.width)

        if (windowObj.getWindowProperties().isFullScreen) {
          Logger.info(TAG, 'isFullScreen')
        }
        if (windowObj.getWindowProperties().isLayoutFullScreen) {
          Logger.info(TAG, 'isLayoutFullScreen')
        }
      })
    });

    windowStage.loadContent('pages/Index', this.storage, (err, data) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`)
        return;
      }
      Logger.info(TAG, `Succeeded in loading the content. Data:  ${JSON.stringify(data)}`)
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, `MainAbility onWindowStageDestroy`)
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info(TAG, `MainAbility onForeground`)
  }

  onBackground() {
    // Ability has back to background
    Logger.info(TAG, `MainAbility onBackground`)
  }
}
