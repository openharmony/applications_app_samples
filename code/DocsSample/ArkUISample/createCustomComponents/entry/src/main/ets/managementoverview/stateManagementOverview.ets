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
// [ Start state_management_overview ]
@Component
struct MyComponentOverview {
  @State count: number = 0;
  increaseBy: number = 1;

  build() {
    // [StartExclude management_overview]
    Column(){
      Text(`Count: ${this.count}`)
      Text(`increaseBy: ${this.increaseBy}`)
    }
    // [EndExclude management_overview]
  }
}

@Entry
@Component
struct Parent {
  build() {

      Column() {
        // 从父组件初始化，覆盖本地定义的默认值
        MyComponentOverview({ count: 1, increaseBy: 2 })
      }

  }
}
// [ End state_management_overview ]
