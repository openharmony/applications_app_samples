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

// [Start ndk_implement_entry_ability]
import { BusinessError } from '@kit.BasicServicesKit';
import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { PipManager } from '../nodefree/PipManager';
import { Logger } from '../util/LogUtil';

// [Start typenode_free_implement_part]
// [Start typenode_other_three_implement_part]
export default class EntryAbility extends UIAbility {
// [End typenode_other_three_implement_part]
// [End typenode_free_implement_part]
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
      AppStorage.setOrCreate('UIAbilityContext', this.context);
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
  }

  onDestroy(): void {
    Logger.info('testTag', '%{public}s', 'Ability onDestroy');
  }

  // [Start typenode_free_implement_part]
  // [Start typenode_other_three_implement_part]
  onWindowStageCreate(windowStage: window.WindowStage): void {
  // [End typenode_other_three_implement_part]
  // [End typenode_free_implement_part]
    // Main window is created, set main page for this ability
    Logger.info('testTag', '%{public}s', 'Ability onWindowStageCreate');
    let windowClass: window.Window | undefined = undefined;
    let windowClassId: number = -1;

    // [Start typenode_free_implement_part]
    windowStage.getMainWindow().then((window) => {
      // [StartExclude typenode_free_implement_part]
      if (window == null) {
        Logger.error('Failed to obtaining the window. Cause: The data is empty');
        return;
      }
      windowClass = window;
      windowClass.setUIContent('pages/Index');
      windowClassId = windowClass.getWindowProperties().id;
      AppStorage.setOrCreate('windowId', windowClassId);
      Logger.info('Succeeded in obtaining the window')
      // [EndExclude typenode_free_implement_part]

      // [StartExclude ndk_implement_entry_ability]
      let ctx = window.getUIContext();
      AppStorage.setOrCreate('UIContext', ctx);
      // 通过主窗口UIContext创建typeNode节点
      PipManager.getInstance().makeTypeNode(ctx);
      // [EndExclude ndk_implement_entry_ability]
    }).catch((err: BusinessError) => {
      Logger.error(`Failed to obtaining the window. Cause code: ${err.code}, message: ${err.message}`);
    });

    // [Start typenode_other_three_implement_part]
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        Logger.error('testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      Logger.info('testTag', 'Succeeded in loading the content.');
    });
  }
  // [End typenode_other_three_implement_part]
  // [End Start typenode_free_implement_part]

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Logger.info('testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info('testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info('testTag', '%{public}s', 'Ability onBackground');
  }
// [Start typenode_other_three_implement_part]
// [Start typenode_free_implement_part]
}
// [End typenode_other_three_implement_part]
// [End typenode_free_implement_part]
// [End ndk_implement_entry_ability]