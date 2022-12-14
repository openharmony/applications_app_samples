/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import Ability from '@ohos.application.Ability'
import hilog from '@ohos.hilog'

export default class MainAbility extends Ability {
  onCreate(want, launchParam) {
    hilog.info(0x0000, 'Sample', '%{public}s', 'onCreate');
  }

  onDestroy() {
    hilog.info(0x0000, 'Sample', '%{public}s', 'onDestroy');
  }

  onWindowStageCreate(windowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'Sample', '%{public}s', 'onWindowStageCreate');

    windowStage.loadContent("pages/Index", (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'Sample', '%{public}s', 'Failed to load the content. Cause:' + JSON.stringify(err));
        return;
      }
      hilog.info(0x0000, 'Sample', '%{public}s', 'Succeeded in loading the content. Data: ' + JSON.stringify(data))
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'Sample', '%{public}s', "MainAbility onWindowStageDestroy")
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'Sample', '%{public}s', "MainAbility onForeground")
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'Sample', '%{public}s', "MainAbility onBackground")
  }
}
