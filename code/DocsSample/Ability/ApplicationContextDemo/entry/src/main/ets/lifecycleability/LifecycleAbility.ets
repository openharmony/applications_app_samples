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
// [Start lifecycle_ability_start]
import { UIAbility, ApplicationStateChangeCallback } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
const TAG = '[LifecycleAbility]';
const DOMAIN = 0xF811;

export default class LifecycleAbility extends UIAbility {
  onCreate() {
    let applicationStateChangeCallback: ApplicationStateChangeCallback = {
      onApplicationForeground() {
        hilog.info(DOMAIN, TAG, 'applicationStateChangeCallback onApplicationForeground');
      },
      onApplicationBackground() {
        hilog.info(DOMAIN, TAG, 'applicationStateChangeCallback onApplicationBackground');
      }
    }

    // 1.获取applicationContext
    let applicationContext = this.context.getApplicationContext();
    try {
      // 2.通过applicationContext注册应用前后台状态监听
      applicationContext.on('applicationStateChange', applicationStateChangeCallback);
    } catch (paramError) {
      hilog.error(DOMAIN, TAG, `error: ${(paramError as BusinessError).code}, ${(paramError as BusinessError).message}`);
    }
    hilog.info(DOMAIN, TAG, 'Register applicationStateChangeCallback');
  }
}
// [End lifecycle_ability_start]