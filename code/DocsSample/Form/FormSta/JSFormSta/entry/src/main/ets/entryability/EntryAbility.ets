'use static'

/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

// [Start JSForm_EntryAbilitySta]
// entry/src/main/ets/entryability/EntryAbility.ets
import UIAbility from '@ohos.app.ability.UIAbility';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import { BusinessError } from '@ohos.base'
import hilog from '@ohos.hilog'

const TAG: string = 'EntryAbility';
// [StartExclude JSForm_EntryAbilitySta]
const DOMAIN: int = 0x0000;

// [EndExclude JSForm_EntryAbilitySta]
class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, TAG, 'EntryAbility onCreate');
  }

  // [StartExclude JSForm_EntryAbilitySta]
  onDestroy(): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, TAG, 'EntryAbility onWindowStageCreate');
    try {
      windowStage.loadContent('pages/Index', (err: BusinessError<void> | null): void => {
        hilog.info(DOMAIN, TAG, 'loadContent entering');
        if (err && err.code) {
          hilog.error(DOMAIN, TAG, 'loadContent error: message: ' + err?.message + 'code: ' + err?.code);
          return;
        }
        hilog.info(DOMAIN, TAG, 'loadContent ok');
      });
    } catch (e) {
      hilog.error(DOMAIN, TAG, 'loadContent catch message: ' + e?.message + 'code: ' + e?.code);
    }
  }

  onWindowStageDestroy(): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onBackground');
  }

  // [EndExclude JSForm_EntryAbilitySta]
}

// [End JSForm_EntryAbilitySta]