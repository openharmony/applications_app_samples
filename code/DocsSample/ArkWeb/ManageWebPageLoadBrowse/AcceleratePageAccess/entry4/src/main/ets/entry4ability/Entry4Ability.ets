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

// [Start save_uiContext_to_localstorage_in_entry_ability]
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
// [StartExclude save_uiContext_to_localstorage_in_entry_ability]
import { hilog } from '@kit.PerformanceAnalysisKit';
// [EndExclude save_uiContext_to_localstorage_in_entry_ability]

const localStorage: LocalStorage = new LocalStorage('uiContext');

export default class Entry4Ability extends UIAbility {
  public storage: LocalStorage = localStorage;
  // [StartExclude save_uiContext_to_localstorage_in_entry_ability]
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }
  // [EndExclude save_uiContext_to_localstorage_in_entry_ability]

  // [StartExclude save_uiContext_to_localstorage_in_entry_ability]
  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }
  // [EndExclude save_uiContext_to_localstorage_in_entry_ability]
  onWindowStageCreate(windowStage: window.WindowStage) {
    windowStage.loadContent('pages/Index', this.storage, (err, data) => {
      if (err.code) {
        return;
      }

      this.storage.setOrCreate<UIContext>('uiContext', windowStage.getMainWindowSync().getUIContext());
    });
  }
  // [StartExclude save_uiContext_to_localstorage_in_entry_ability]
  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }
  // [EndExclude save_uiContext_to_localstorage_in_entry_ability]
  // [StartExclude save_uiContext_to_localstorage_in_entry_ability]
  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }
  // [EndExclude save_uiContext_to_localstorage_in_entry_ability]
  // [StartExclude save_uiContext_to_localstorage_in_entry_ability]
  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
  // [EndExclude save_uiContext_to_localstorage_in_entry_ability]
}
// [End save_uiContext_to_localstorage_in_entry_ability]
