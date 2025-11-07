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

@Component
export struct LocalUseCaseJoin {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.local_use_case_join'))
  }
}

// [Start Local_Use_Case_Join]
@Entry
@ComponentV2
struct Index {
  @Local count: number | undefined = 10; // 使用@Local装饰联合类型变量

  build() {
    Column() {
      Text(`count(${this.count})`)
      Button('change to undefined') // 按钮1：将count设置为undefined
        .onClick(() => {
          this.count = undefined;
        })
      Button('change to number') // 按钮2：将count更新为数字10
        .onClick(() => {
          this.count = 10;
        })
    }
  }
}
// [End Local_Use_Case_Join]