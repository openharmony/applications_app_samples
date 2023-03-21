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
import display from '@ohos.display';
import window from '@ohos.window';

const TAG: string = '[Sample_HealthyDiet]';
const DPI: number = 160;
const SM_SIZE: number = 320;
const MD_SIZE: number = 520;
const LG_SIZE: number = 840;


export default class MainAbility extends UIAbility {
  async onCreate(want, launchParam): Promise<void> {
    console.log(TAG, 'MainAbility onCreate');
    let windowDate = await window.getLastWindow(this.context);
    let data = windowDate.getWindowProperties().windowRect.width;
    let displayDate = display.getDefaultDisplaySync();
    let screenDpi = displayDate.densityDPI;
    AppStorage.SetOrCreate('dpi', screenDpi);
    let windowWidth = data / (screenDpi / DPI);
    if (windowWidth >= SM_SIZE && windowWidth < MD_SIZE || windowWidth < SM_SIZE) {
      AppStorage.SetOrCreate<string>('currentBreakpoint', 'sm');
    } else if (windowWidth >= MD_SIZE && windowWidth < LG_SIZE) {
      AppStorage.SetOrCreate<string>('currentBreakpoint', 'md');
    } else if (windowWidth >= LG_SIZE) {
      AppStorage.SetOrCreate<string>('currentBreakpoint', 'lg');
    }
  }

  onDestroy() {
    console.log(TAG, "MainAbility onDestroy")
  }

  onWindowStageCreate(windowStage) {
    console.log(TAG, "MainAbility onWindowStageCreate")
    windowStage.loadContent("pages/Logo", (err, data) => {
      if (err.code) {
        console.error('Failed to load the content. Cause:' + JSON.stringify(err))
        return
      }
      console.info('Succeeded in loading the content. Data: ' + JSON.stringify(data))
    })
  }

  onWindowStageDestroy() {
    console.log(TAG, "MainAbility onWindowStageDestroy")
  }

  onForeground() {
    console.log(TAG, "MainAbility onForeground")
  }

  onBackground() {
    console.log(TAG, "MainAbility onBackground")
  }
}
