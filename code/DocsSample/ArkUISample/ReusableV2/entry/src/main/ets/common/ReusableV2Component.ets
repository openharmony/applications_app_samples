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
// [Start ReusableV2Component]
@ComponentV2
export  struct ReusableV2Component {
  aboutToAppear() {
    console.info('ReusableV2Component aboutToAppear called'); // 组件创建时调用
  }
  aboutToDisappear() {
    console.info('ReusableV2Component aboutToDisappear called'); // 组件销毁时调用
  }
  aboutToRecycle() {
    console.info('ReusableV2Component aboutToRecycle called'); // 组件回收时调用
  }
  aboutToReuse() {
    console.info('ReusableV2Component aboutToReuse called'); // 组件复用时调用
  }
  build() {
    Column() {
      Text('ReusableV2Component')
    }
  }
}
// [End ReusableV2Component]