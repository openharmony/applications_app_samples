/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { fileIo } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'EntryAbility';

export default class EntryAbility extends UIAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'Failed to get application context. Cause: %{public}s', JSON.stringify(err));
      }
    }
    hilog.info(0x0000, TAG, 'testTag', '%{public}s', 'Ability onCreate');
    // Writes raw file content to local storage.
    try {
      let value = await this.context.resourceManager.getRawFileContent('kv-popup.mp4');
      let myBuffer: ArrayBufferLike = value.buffer;
      let filePath = this.context.filesDir + '/kv-popup.mp4';
      let file = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
      fileIo.writeSync(file.fd, myBuffer);
      fileIo.closeSync(file);
    } catch (err) {
      hilog.info(0x0000, TAG, `fileIO error ${err}`);
    }
  }

  onDestroy(): void {
    hilog.info(0x0000, TAG, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, TAG, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/Index', (err) => {
      try {
        AppStorage.setOrCreate('uiContext', windowStage.getMainWindowSync().getUIContext());
      } catch (error) {
        let err = error as BusinessError
        if (err.code) {
          hilog.error(0x0000, TAG, 'testTag', 'Failed to set UI context. Cause: %{public}s', JSON.stringify(err));
        }
      }
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(0x0000, TAG, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, TAG, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, TAG, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, TAG, 'testTag', '%{public}s', 'Ability onBackground');
  }
}