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
import UIAbility from '@ohos.app.ability.UIAbility';

import display from '@ohos.display';
import { AbilityConstant } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';

const TAG = '[Dialog_MainAbility]';

export default class MainAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    console.log(TAG + 'MainAbility onCreate, ability name is ' + want.abilityName + '.');
    globalThis.context = this.context;
    globalThis.abilityWant = want;

    globalThis.screenWidth = display.getDefaultDisplaySync().width;
    globalThis.screenHeight = display.getDefaultDisplaySync().height;
    console.info(TAG,
      `onCreate globalThis.screenWidth: ${JSON.stringify(globalThis.screenWidth)} globalThis.screenHeight: ${JSON.stringify(globalThis.screenHeight)}`);
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    console.info(TAG,
      `onWindowStageCreate globalThis.screenWidth: ${JSON.stringify(globalThis.screenWidth)} globalThis.screenHeight: ${JSON.stringify(globalThis.screenHeight)}`);
    windowStage.loadContent('pages/powerDialog', (err, data) => {
      if (err.code) {
        console.error('testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      console.info('testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onForeground() {
    // Ability has brought to foreground
    console.log(TAG + 'MainAbility onForeground.');
  }

  onBackground() {
    // Ability has back to background
    console.log(TAG + 'MainAbility onBackground.');
    this.context.terminateSelf();
  }

  onDestroy() {
    console.log(TAG + 'MainAbility onDestroy.');
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    console.log(TAG + 'MainAbility onWindowStageDestroy.');
  }
};
