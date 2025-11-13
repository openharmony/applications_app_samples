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
// [Start Parent6_start]
const VALUE_DEFAULT_INIT = 0;

@ComponentV2
struct Child {
  @Param @Once value: number = VALUE_DEFAULT_INIT;

  build() {
    Text(this.value.toString())
  }
}

@Entry
@ComponentV2
struct Parent {
  build() {
    Column() {
      // @Local禁止从外部初始化，可以用@Param和@Once替代实现
      Child({ value: 30 })
    }
  }
}
// [End Parent6_start]
const parent6 = Parent;
export default parent6;