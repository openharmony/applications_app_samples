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

// [Start once_init_sync_noMore]
@ComponentV2
struct ChildComponent {
  @Param @Once onceParam: string = '';

  build() {
    Column() {
      Text(`onceParam: ${this.onceParam}`);
    }
  }
}

@Entry
// [Start once_param_componentV2_pair]
// [Start once_param_order_irrelevant]
@ComponentV2
struct MyComponent {
  // [StartExclude once_init_sync_noMore]
  // [StartExclude once_param_order_irrelevant]
  @Param @Once onceParam: string = 'onceParam'; // 正确用法
  // [EndExclude once_param_order_irrelevant]
  // [StartExclude once_param_componentV2_pair]
  @Param @Once param1: number = 0;
  @Once @Param param2: number = 0;
  // [StartExclude once_param_order_irrelevant]
  // [EndExclude once_init_sync_noMore]
  @Local message: string = 'Hello World';

  build() {
    Column() {
      Text(`Parent message: ${this.message}`);
      Button('change message')
        .onClick(() => {
          this.message = 'Hello Tomorrow';
        });
      ChildComponent({ onceParam: this.message });
    }
  }
  // [EndExclude once_param_componentV2_pair]
  // [EndExclude once_param_order_irrelevant]
}
//[End once_param_componentV2_pair]
// [End once_param_order_irrelevant]
// [End once_init_sync_noMore]