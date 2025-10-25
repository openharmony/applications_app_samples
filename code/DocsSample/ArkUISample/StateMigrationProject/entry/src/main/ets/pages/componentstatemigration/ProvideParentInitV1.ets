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
// [Start Parent21_start]
@Entry
@Component
struct Parent21 {
  @State parentValue: number = 42;

  build() {
    Column() {
      // @Provide可以从父组件初始化
      Child21({ childValue: this.parentValue });
    }
  }
}

@Component
struct Child21 {
  @Provide childValue: number = 0;

  build() {
    Column() {
      Text(this.childValue.toString());
    }
  }
}
// [End Parent21_start]