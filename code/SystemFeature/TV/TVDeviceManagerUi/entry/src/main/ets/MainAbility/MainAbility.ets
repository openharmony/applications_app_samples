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

import { UIAbility, Want, AbilityConstant } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'DeviceManagerUI_MainAbility:';

export default class MainAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    console.log(TAG + 'MainAbility onCreate, ability name is ' + want.abilityName + '.');
    globalThis.context = this.context;
    globalThis.allBundleInfo = [];
    globalThis.allUserPermissions = [];
    globalThis.allGroups = [];
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    console.log(TAG + 'MainAbility onWindowStageCreate.');
    windowStage.loadContent('pages/ConfirmDialog', (err: BusinessError) => {
      if (err.code) {
        console.error(TAG + 'Failed to load the content. Cause: ' + JSON.stringify(err));
      }
    });
  }

  onForeground(): void {
    console.log(TAG + 'MainAbility onForeground.');
  }

  onBackground(): void {
    console.log(TAG + 'MainAbility onBackground.');
  }

  onDestroy(): void {
    console.log(TAG + 'MainAbility onDestroy.');
  }

  onWindowStageDestroy(): void {
    console.log(TAG + 'MainAbility onWindowStageDestroy.');
  }
}
