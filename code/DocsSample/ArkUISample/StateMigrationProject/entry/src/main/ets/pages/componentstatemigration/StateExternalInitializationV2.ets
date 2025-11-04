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
@ComponentV2
struct Child6 {
  @Param @Once value: number = 0;

  build() {
    Text(this.value.toString())
  }
}

@Entry
@ComponentV2
struct Parent6 {
  build() {
    Column() {
      // @Local禁止从外部初始化，可以用@Param和@Once替代实现
      Child6({ value: 30 })
    }
  }
}
// [End Parent6_start]