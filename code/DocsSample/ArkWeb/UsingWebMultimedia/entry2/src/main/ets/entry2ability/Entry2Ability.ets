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
import { hilog } from '@kit.PerformanceAnalysisKit';

import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
// [Start allow_subsequent_rendering_to_use_ui]
import { window } from '@kit.ArkUI';

export default class Entry2Ability extends UIAbility {
  // [StartExclude allow_subsequent_rendering_to_use_ui]
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }
  // [EndExclude allow_subsequent_rendering_to_use_ui]
  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        return;
      }
      // 保存 UIContext， 在后续的同层渲染绘制中会用到。
      AppStorage.setOrCreate<UIContext>('UIContext', windowStage.getMainWindowSync().getUIContext());
    });
  }
  // [StartExclude allow_subsequent_rendering_to_use_ui]
  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
  // [EndExclude allow_subsequent_rendering_to_use_ui]
}
// [End allow_subsequent_rendering_to_use_ui]