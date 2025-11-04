/*
 * Copyright (c) 2023-2025 Huawei Device Co., Ltd.
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

import { AbilityConstant, ConfigurationConstant, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import UIAbility from '@ohos.app.ability.UIAbility'
import Window from '@ohos.window'
import Logger from '../util/Logger'
import quickFixManager from '@ohos.app.ability.quickFixManager'
import { BusinessError } from '@kit.BasicServicesKit';

const DOMAIN = 0x0000;
const TAG: string = 'MainAbility'


async function applyQuickFix() {
  let hapModuleQuickFixFiles = ['/data/storage/el2/base/haps/entry-signed-release.hqf'];
  try {
    quickFixManager.applyQuickFix(hapModuleQuickFixFiles).then(() => {
      Logger.info(`applyQuickFix success`);
    }).catch((error: BusinessError) => {
      Logger.error(`applyQuickFix err: ${error}`);
    });
  } catch (paramError) {
    Logger.error(`error: ${(paramError as BusinessError).code}, ${(paramError as BusinessError).message}`);
  }
}

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    Logger.info(TAG, `onCreate`)
    let status = want.parameters
    AppStorage.SetOrCreate('status', status)
    AppStorage.SetOrCreate('filePath', this.context.filesDir)
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy() {
    Logger.info(TAG, `onDestroy`)
  }

  onWindowStageCreate(windowStage: Window.WindowStage) {
    // Main window is created, set main page for this ability
    Logger.info(TAG, `onWindowStageCreate`)
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.info(TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`)
        return
      }
      Logger.info(TAG, `Succeeded in loading the content. Data:  ${JSON.stringify(data)}`)
    })
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, `onWindowStageDestroy`)
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info(TAG, `onForeground`)
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info(TAG, `onBackground`)
  }
}