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

// [Start Ability_FuncAbilityA]
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
// [StartExclude Ability_FuncAbilityA]
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

const DOMAIN = 0x0000;
// [EndExclude Ability_FuncAbilityA]

export default class FuncAbilityA extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // 接收调用方UIAbility传过来的参数
    let funcAbilityWant = want;
    let info = funcAbilityWant?.parameters?.info;
    // [StartExclude Ability_FuncAbilityA]
    hilog.info(DOMAIN, 'FuncAbilityA', '%{public}s', info);
    // [EndExclude Ability_FuncAbilityA]
  }

  // [StartExclude Ability_FuncAbilityA]
  onDestroy(): void {
    hilog.info(DOMAIN, 'FuncAbilityA', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'FuncAbilityA', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('innerability/FuncAbilityAPage', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'FuncAbilityA', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'FuncAbilityA', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'FuncAbilityA', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'FuncAbilityA', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'FuncAbilityA', '%{public}s', 'Ability onBackground');
  }
  // [EndExclude Ability_FuncAbilityA]
}
// [End Ability_FuncAbilityA]