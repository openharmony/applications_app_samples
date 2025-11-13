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
const PARENT_STATE_PARENT_VALUE_INITIAL = 42;
const CHILD_PROVIDE_CHILD_VALUE_INITIAL = 0;

@Entry
@Component
struct Parent {
  @State parentValue: number = PARENT_STATE_PARENT_VALUE_INITIAL;

  build() {
    Column() {
      // @Provide可以从父组件初始化
      Child({ childValue: this.parentValue })
    }
  }
}

@Component
struct Child {
  @Provide childValue: number = CHILD_PROVIDE_CHILD_VALUE_INITIAL;

  build() {
    Column() {
      Text(this.childValue.toString())
    }
  }
}
// [End Parent21_start]
const parent21 = Parent;
export default parent21;