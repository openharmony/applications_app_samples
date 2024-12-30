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

import { common, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct Index {
  build() {
    Column() {
      Button($r('app.string.return_entryability'))
        .onClick(() => {
          let context = getContext(this) as common.UIAbilityContext;
          let want: Want = {
            'deviceId': '',
            'bundleName': 'com.samples.requestuserauthorization',
            'abilityName': 'EntryAbility',
            'moduleName': 'entry',
          };
          context.startAbility(want).then(() => {
            console.info(`start entry ability index page succeed with ${JSON.stringify(want)}`);
          }).catch((error: Error) => {
            console.error(`start entry ability index page failedwith ${error}`);
          });
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.SpaceEvenly)
  }
}