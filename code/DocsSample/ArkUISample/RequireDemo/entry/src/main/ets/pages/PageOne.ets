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

// [Start page_one_require_tart]
@Entry
@Component
struct PageOne {
  message: string = 'Hello World';

  build() {
    Column() {
      Child_V1({ message: this.message })
    }
  }
}

@Component
struct Child_V1 {
  @Require @State message: string;

  build() {
    Column() {
      Text(this.message) // 从API version 18开始，可以编译通过。
    }
  }
}
// [End page_one_require_tart]