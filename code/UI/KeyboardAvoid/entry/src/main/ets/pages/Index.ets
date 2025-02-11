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

import { KeyboardAvoid } from 'keyboardavoid';

@Entry
@Component
struct Index {
  build() {
    Column() {
      /**
       * 功能描述：本示例介绍使用TextInput组件和LazyForEach实现组件随软键盘弹出避让场景。该场景多用于需要用户手动输入文字类应用。
       * 参数介绍：无
       */
      KeyboardAvoid()
    }
    .height('100%')
    .width('100%')
  }
}