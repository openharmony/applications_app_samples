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
// [Start by_reference_parameter_passing]
class Tmp {
  public paramA1: string = '';
}

@Builder
function overBuilderByReference(params: Tmp) { // 不同名ets文件定义同名不导出的function编译报错，故修改
  Row() {
    Text(`UseStateVarByReference: ${params.paramA1} `)
  }
}
// [StartExclude by_reference_parameter_passing]
// [Start by_value_parameter_passing]
@Builder
function overBuilderByValue(paramA1: string) { // 不同名ets文件定义同名不导出的function编译报错，故修改
  Row() {
    Text(`UseStateVarByValue: ${paramA1} `)
  }
}
// [EndExclude by_reference_parameter_passing]

@Entry
@Component
struct Parent {
  @State label: string = 'Hello';

  build() {
    Column() {
      // [StartExclude by_value_parameter_passing]
      // 在父组件中调用overBuilderByReference组件时，
      // 把this.label通过引用传递的方式传给overBuilderByReference组件。
      overBuilderByReference({ paramA1: this.label })
      // [StartExclude by_reference_parameter_passing]
      // [EndExclude by_value_parameter_passing]
      overBuilderByValue(this.label)
      // [StartExclude by_value_parameter_passing]
      // [EndExclude by_reference_parameter_passing]
      Button('Click me').onClick(() => {
        // 单击Click me后，UI文本从Hello更改为ArkUI。
        this.label = 'ArkUI';
      })
      // [EndExclude by_value_parameter_passing]
    }
  }
}
// [End by_reference_parameter_passing]
// [End by_value_parameter_passing]