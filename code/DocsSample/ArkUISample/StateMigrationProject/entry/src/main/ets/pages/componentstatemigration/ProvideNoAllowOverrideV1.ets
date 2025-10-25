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
// [Start GrandParent1_start]
@Entry
@Component
struct GrandParent1 {
  @Provide('reviewVotes') reviewVotes: number = 40;

  build() {
    Column() {
      Parent23();
    }
  }
}

@Component
struct Parent23 {
  // @Provide默认不支持重载，支持重载需设置allowOverride函数
  @Provide({ allowOverride: 'reviewVotes' }) reviewVotes: number = 20;

  build() {
    Child23();
  }
}

@Component
struct Child23 {
  @Consume('reviewVotes') reviewVotes: number;

  build() {
    Text(this.reviewVotes.toString()); // Text显示20
  }
}
// [End GrandParent1_start]