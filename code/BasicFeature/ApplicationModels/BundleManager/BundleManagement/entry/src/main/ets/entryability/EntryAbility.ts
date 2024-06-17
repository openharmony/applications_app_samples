/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = 'entryAbility';
const DOMAIN_NUMBER: number = 0xFF00;

export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Ability onCreate');
  }

  onDestroy() {
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(DOMAIN_NUMBER, TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });

    windowStage.getMainWindow((err, data) => {
      if (err.code) {
        hilog.error(DOMAIN_NUMBER, TAG, 'Failed to obtain the main window. Cause: ' + JSON.stringify(err));
        return;
      }
      let windowClass = data;
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in obtaining the main window. Data: ' + JSON.stringify(data));

      let SystemBarProperties = {
        statusBarColor: "#f1f3f5",
        navigationBarColor: "#f1f3f5"
      };
      windowClass.setWindowSystemBarProperties(SystemBarProperties, (err) => {
        if (err) {
          hilog.error(DOMAIN_NUMBER, TAG, 'Failed to set the system bar properties. Cause: ' + JSON.stringify(err));
          return;
        }
        hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in setting the system bar properties.');
      });
    })
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Ability onBackground');
  }
}