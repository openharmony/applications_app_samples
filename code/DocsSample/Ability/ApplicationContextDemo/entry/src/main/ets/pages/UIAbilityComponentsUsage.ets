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

// [Start ui_ability_usage_start]
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[UIAbilityComponentsUsage]';
const DOMAIN = 0xF811;
@Entry
@Component
struct UIAbilityComponentsUsage {
  // 页面展示
  build() {
    Column() {
      // [StartExclude  ui_ability_usage_start]
      Text('usage start')
        .width('50vp')
      // [EndExclude  ui_ability_usage_start]
      Button('FuncAbilityB')
        .onClick(() => {
          let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
          try {
            context.terminateSelf((err: BusinessError) => {
              if (err.code) {
                // 处理业务逻辑错误
                hilog.error(DOMAIN, TAG, `terminateSelf failed, code is ${err.code}, message is ${err.message}.`);
                return;
              }
              // 执行正常业务
              hilog.info(DOMAIN, TAG, `terminateSelf succeed.`);
            });
          } catch (err) {
            // 捕获同步的参数错误
            let code = (err as BusinessError).code;
            let message = (err as BusinessError).message;
            hilog.error(DOMAIN, TAG, `terminateSelf failed, code is ${code}, message is ${message}.`);
          }
        })
    }
  }
}
// [End ui_ability_usage_start]