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
import { window } from '@kit.ArkUI';
import { UIAbility } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

export default class EntryAbility extends UIAbility {
  private windowClass: window.Window | undefined = undefined;

  onCreate(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      let uiContext: UIContext | undefined = windowStage.getMainWindowSync().getUIContext();
      AppStorage.setOrCreate('uiContext', uiContext);
      this.windowClass = windowStage.getMainWindowSync();
      this.windowClass.setWindowLayoutFullScreen(true).then(() => {
        hilog.info(0x0000, 'testTag', 'Success in setting the window layout to full-screen mode.');
      }).catch((err: BusinessError) => {
        hilog.info(0x0000, 'testTag',
          'Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err));
      });
      this.immersive();
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  private immersive(): void {
    let type: window.AvoidAreaType = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR;
    try {
      let avoidArea: window.AvoidArea = this.windowClass?.getWindowAvoidArea(type) as window.AvoidArea;
      let bottomRectHeight: number = avoidArea.bottomRect.height;
      AppStorage.setOrCreate('bottomRectHeight', bottomRectHeight);
      type = window.AvoidAreaType.TYPE_SYSTEM;
      avoidArea = this.windowClass?.getWindowAvoidArea(type) as window.AvoidArea;
      let topRectHeight: number = avoidArea.topRect.height;
      AppStorage.setOrCreate('topRectHeight', topRectHeight);
    } catch (e) {
      let err = e as BusinessError;
      hilog.error(0x0000, 'testTag', `failed code=${err.code}, message=${err.message}`);
    }
  }

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
}
