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

import Ability from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import { BusinessError } from '@ohos.base';
import window from '@ohos.window';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import Want from '@ohos.app.ability.Want';
import common from '@ohos.app.ability.common';

let myContext: common.UIAbilityContext | null = null ;
export default class MainAbility extends Ability {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    AppStorage.SetOrCreate('context', this.context);
    hilog.info(0x0000, 'Sample', '%{public}s', 'onCreate');
  }

  onDestroy() {
    hilog.info(0x0000, 'Sample', '%{public}s', 'onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'Sample', '%{public}s', 'onWindowStageCreate');

    let filesDir = this.context.filesDir;
    console.info('sanBoxFileDir = ' + filesDir);
    AppStorage.SetOrCreate('sanBoxFileDir', filesDir);
    myContext = this.context;

    this.getResourceStr();

    windowStage.loadContent('pages/Index', (err: BusinessError, data: void) => {
      if (err.code) {
        hilog.error(0x0000, 'Sample', '%{public}s', 'Failed to load the content. Cause:' + JSON.stringify(err));
        return;
      }
      hilog.info(0x0000, 'Sample', '%{public}s', 'Succeeded in loading the content. Data: ' + JSON.stringify(data));
    })
  }

  getResourceStr(): void {
    try {
      myContext?.resourceManager.getStringValue($r('app.string.isDelFile').id)
        .then((value: Object) => {
          AppStorage.SetOrCreate('isDelFile', value);
          hilog.info(0x0000, 'testTag', '%{public}s', 'getStringValue value' + value);
        })
        .catch((error: BusinessError) => {
          hilog.error(0x0000, 'testTag', 'Failed to getStringValue. Cause: %{public}s', error ?? '');
        });

      myContext?.resourceManager.getStringValue($r('app.string.fileContent1').id)
        .then((value: Object) => {
          AppStorage.SetOrCreate('fileContent1', value);
          hilog.info(0x0000, 'testTag', '%{public}s', 'getStringValue value' + value);
        })
        .catch((error: BusinessError) => {
          hilog.error(0x0000, 'testTag', 'Failed to getStringValue. Cause: %{public}s', error ?? '');
        });

      myContext?.resourceManager.getStringValue($r('app.string.fileContent2').id)
        .then((value: Object) => {
          AppStorage.SetOrCreate('fileContent2', value);
          hilog.info(0x0000, 'testTag', '%{public}s', 'getStringValue value' + value);
        })
        .catch((error: BusinessError) => {
          hilog.error(0x0000, 'testTag', 'Failed to getStringValue. Cause: %{public}s', error ?? '');
        });

      myContext?.resourceManager.getStringValue($r('app.string.fileContent3').id)
        .then((value: Object) => {
          AppStorage.SetOrCreate('fileContent3', value);
          hilog.info(0x0000, 'testTag', '%{public}s', 'getStringValue value' + value);
        })
        .catch((error: BusinessError) => {
          hilog.error(0x0000, 'testTag', 'Failed to getStringValue. Cause: %{public}s', error ?? '');
        });

      myContext?.resourceManager.getStringValue($r('app.string.fileContent4').id)
        .then((value: Object) => {
          AppStorage.SetOrCreate('fileContent4', value);
          hilog.info(0x0000, 'testTag', '%{public}s', 'getStringValue value' + value);
        })
        .catch((error: BusinessError) => {
          hilog.error(0x0000, 'testTag', 'Failed to getStringValue. Cause: %{public}s', error ?? '');
        });
    } catch (error) {
      hilog.error(0x0000, 'testTag', 'callback getStringValue failed. Cause: %{public}s', error.message ?? '');
    }
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'Sample', '%{public}s', 'MainAbility onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'Sample', '%{public}s', 'MainAbility onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'Sample', '%{public}s', 'MainAbility onBackground');
  }
}
