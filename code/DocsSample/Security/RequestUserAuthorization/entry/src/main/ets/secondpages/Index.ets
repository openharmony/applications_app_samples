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

import { Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
// [Start second_request_permission]
import { abilityAccessCtrl, Context, common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

// [StartExclude second_request_permission]
@Entry
@Component
struct Index {
  build() {
    Column() {
      Button('再次授权')
        .margin(20)
        .onClick(() => {
          // [EndExclude second_request_permission]
          let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
          let context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;
          atManager.requestPermissionOnSetting(context, ['ohos.permission.APPROXIMATELY_LOCATION']).then((data: Array<abilityAccessCtrl.GrantStatus>) => {
            console.info(`requestPermissionOnSetting success, result: ${data}`);
          }).catch((err: BusinessError) => {
            console.error(`requestPermissionOnSetting fail, code: ${err.code}, message: ${err.message}`);
          });
          // [End second_request_permission]
        })

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
    .justifyContent(FlexAlign.Center)
  }
}