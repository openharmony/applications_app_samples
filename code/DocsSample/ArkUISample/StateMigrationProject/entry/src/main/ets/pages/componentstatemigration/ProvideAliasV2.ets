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
// [Start Parent18_start]
@ComponentV2
struct Child18 {
  // alias是唯一匹配的key，有alias情况下无法通过属性名匹配
  @Consumer('text') childMessage: string = 'default';
  @Consumer() message: string = 'default';

  build() {
    Column() {
      Text(this.childMessage)
      Text(this.message) // Text是default
    }
  }
}

@Entry
@ComponentV2
struct Parent18 {
  @Provider('text') message: string = 'Hello World';

  build() {
    Column() {
      Child18()
    }
  }
}
// [End Parent18_start]