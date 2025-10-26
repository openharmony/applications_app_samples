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
// [Start Parent22_start]
@Entry
@ComponentV2
struct Parent22 {
  @Local parentValue: number = 42;

  build() {
    Column() {
      // @Provider禁止从父组件初始化，替代方案为先用@Param接受，再赋值给@Provider
      Child22({ initialValue: this.parentValue });
    }
  }
}

@ComponentV2
struct Child22 {
  @Param @Once initialValue: number = 0;
  @Provider() childValue: number = this.initialValue;

  build() {
    Column() {
      Text(this.childValue.toString());
    }
  }
}
// [End Parent22_start]