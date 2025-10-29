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
// [Start by_makebinding_parameter_passing]
import { Binding, MutableBinding, UIUtils } from '@kit.ArkUI';

@Builder
function customButton(num1: Binding<number>, num2: MutableBinding<number>) {
  Row() {
    Column() {
      Text(`number1: ${num1.value}, number2: ${num2.value}`)
      Button(`only change number2`)
        .onClick(() => {
          // 赋值MutableBinding类型传递该修改到父组件中。
          num2.value += 1;
        })
    }
  }
}

@Entry
@ComponentV2
struct ParameterMakeBinding {
  @Local number1: number = 5;
  @Local number2: number = 12;

  build() {
    Column() {
      customButton(
        // 使用makeBinding传入参数，需要传入读回调，返回Binding类型，支持@Builder内组件UI刷新。
        UIUtils.makeBinding<number>(() => this.number1),
        // makeBinding额外传入写回调时返回MutableBinding类型，支持@Builder内组件UI刷新并且同步属性修改。
        UIUtils.makeBinding<number>(
          () => this.number2,
          (val: number) => {
            this.number2 = val;
          })
      )
    }
  }
}
// [End by_makebinding_parameter_passing]