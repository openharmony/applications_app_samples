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

// [Start input_case_module_import_InputMethodExtensionAbility]

import { Want } from '@kit.AbilityKit';
import { keyboardController } from './model/KeyboardController';
import { InputMethodExtensionAbility } from '@kit.IMEKit';

export default class InputMethodService extends InputMethodExtensionAbility {
  onCreate(want: Want): void {
    keyboardController.onCreate(this.context); // 初始化窗口并注册对输入法框架的事件监听
  }

  onDestroy(): void {
    console.log(`InputMethodExtAbility onDestroy.`);
    keyboardController.onDestroy(); // 销毁窗口并去注册事件监听
  }
}
// [End input_case_module_import_InputMethodExtensionAbility]