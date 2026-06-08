'use static'

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
 
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import { hilog } from '@kit.PerformanceAnalysisKit';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import { BusinessError } from '@ohos.base';

const DOMAIN_NUMBER: int = 0xFF00;
const TAG: string = 'EntryAbility';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err: BusinessError<void> | null): void => {
      if (err && err.code) {
        hilog.error(DOMAIN_NUMBER, TAG, `Failed to load the content. code: ${err?.code}, message: ${err?.message}`);
        return;
      }
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Ability onBackground');
  }
}
