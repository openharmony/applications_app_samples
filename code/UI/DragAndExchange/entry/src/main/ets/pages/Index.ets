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

import { Launcher } from 'dragandexchange';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column() {
      /**
       * 功能描述：本示例介绍Grid和List内拖拽交换子组件位置的使用：通过onItemDrop()和onDrop()回调，实现子组件在Grid和List中的子组件位置交换。
       * 参数介绍：无
       */
      Launcher()
    }
    .height('100%')
    .width('100%')
  }
}