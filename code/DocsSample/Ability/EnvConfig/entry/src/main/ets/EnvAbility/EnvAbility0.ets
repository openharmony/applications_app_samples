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
// [Start get_envconf]
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN_NUMBER = 0xF811;
const TAG = '[EnvAbility0]';

export default class EnvAbility0 extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      let value = this.context.resourceManager.getConfigurationSync();
      // 屏幕方向
      let direction = value.direction;
      // 语言文字国家地区
      let locale = value.locale;
    } catch (error) {
      hilog.error(DOMAIN_NUMBER, TAG, 'getConfigurationSync error is ' + error);
    }
  }
}
// [End get_envconf]