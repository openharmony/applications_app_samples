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
import { ReusableV2Component } from '../common/ReusableV2Component1'
//[Start Interface Description]
@Entry
@ComponentV2
struct Page1 {

  build() {
    Column() {
      ReusableV2Component()
        .reuse({reuseId: () => 'reuseComponent'}) // 使用'reuseComponent'作为reuseId
      ReusableV2Component()
        .reuse({reuseId: () => ''}) // 使用空字符串将默认使用组件名'ReusableV2Component'作为reuseId
      ReusableV2Component() // 未指定reuseId将默认使用组件名'ReusableV2Component'作为reuseId
    }
  }
}
//[End Interface Description]