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
//[Start Usage restrictions]
@Entry
@ComponentV2
struct Page13 {
  build() {
    Column() {
      ReusableV2Component() // 正确用法
      V1Component()
    }
  }
}
// @ReusableV2
@ComponentV2
struct ReusableV2Component {
  build() {
  }
}
@Builder
function V2ReusableBuilder() {
  ReusableV2Component()
}
@Component
struct V1Component {
  build() {
    Column() {
      ReusableV2Component() // 错误用法，编译报错
      V2ReusableBuilder() // 错误用法，较复杂场景，运行时报错
    }
  }
}
//[End Usage restrictions]