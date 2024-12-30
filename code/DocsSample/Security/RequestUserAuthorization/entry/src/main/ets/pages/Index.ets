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
import { checkPermissions } from '../utils/PermissionUtil';
import router from '@ohos.router';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct Index {
  toSecondAbilityIndex() {
    let context = getContext(this) as common.UIAbilityContext;
    let want: Want = {
      'deviceId': '',
      'bundleName': 'com.samples.requestuserauthorization',
      'abilityName': 'SecondAbility',
      'moduleName': 'entry',
    };
    context.startAbility(want).then(() => {
      console.info(`start second ability index page succeed with ${JSON.stringify(want)}`);
    }).catch((error: Error) => {
      console.error(`start second ability index page failedwith ${error}`);
    });
  }

  build() {
    Column() {
      Button($r('app.string.req_permission_page'))
        .onClick(() => {
          router.pushUrl({ url: 'reqpermissioninui/pages/Index' });
        })
      Button($r('app.string.req_permission_ability'))
        .onClick(() => {
          this.toSecondAbilityIndex();
        })
      Button($r('app.string.check_permission'))
        .onClick(() => {
          checkPermissions();
        })
        .type(ButtonType.Circle)
        .backgroundColor(Color.Gray)
        .height(100)
        .width(100)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.SpaceEvenly)
  }
}