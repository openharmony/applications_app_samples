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

// [Start ui_ability_basic_usage_start]
import { common, Want } from '@kit.AbilityKit';

@Entry
@Component
struct Page_UIAbilityComponentsBasicUsage {
  startAbilityTest(): void {
    let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let want: Want = {
      // Want参数信息
    };
    context.startAbility(want);
  }

  // 页面展示
  build() {
    // [StartExclude  ui_ability_basic_usage_start]
    Column(){
      Text('basic usage start')
        .width('50vp')
    }
    .width('100%')
    // [EndExclude  ui_ability_basic_usage_start]
  }
}
// [End ui_ability_basic_usage_start]