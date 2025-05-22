/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

// [Start AppRecovery_All]
import {
  AbilityConstant,
  UIAbility,
  Want,
  AbilityStage,
  appRecovery,
  errorManager,
  wantConstant
} from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

let abilityWant: Want;
let registerId = -1;
let callback: errorManager.ErrorObserver = {
  onUnhandledException(errMsg) {
    console.log(errMsg);
    appRecovery.saveAppState();
    appRecovery.restartApp();
  }
}

export default class EntryAbility extends UIAbility {
  storage: LocalStorage | undefined = undefined;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    appRecovery.enableAppRecovery(appRecovery.RestartFlag.ALWAYS_RESTART,
      appRecovery.SaveOccasionFlag.SAVE_WHEN_ERROR | appRecovery.SaveOccasionFlag.SAVE_WHEN_BACKGROUND,
      appRecovery.SaveModeFlag.SAVE_WITH_FILE);

    abilityWant = want;
    if (launchParam.launchReason == AbilityConstant.LaunchReason.APP_RECOVERY) {
      this.storage = new LocalStorage();
      if (want.parameters) {
        let recoveryData = want.parameters['myData'];
        this.storage.setOrCreate('myData', recoveryData);
        this.context.restoreWindowStage(this.storage);
      }
    }
    if (want.parameters === undefined) {
      return;
    }
    if (want.parameters[wantConstant.Params.ABILITY_RECOVERY_RESTART] != undefined &&
      want.parameters[wantConstant.Params.ABILITY_RECOVERY_RESTART] == true) {
      console.log('This ability need to recovery');
    }
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    registerId = errorManager.on('error', callback);

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');

    errorManager.off('error', registerId, (err) => {
      console.error('[Demo] err:', err);
    });
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

  onSaveState(state: AbilityConstant.StateType, wantParams: Record<string, Object>) {
    // Ability has called to save app data
    console.log('[Demo] EntryAbility onSaveState');
    wantParams['myData'] = 'my1234567';
    return AbilityConstant.OnSaveResult.ALL_AGREE;
  }
}
// [End AppRecovery_All]