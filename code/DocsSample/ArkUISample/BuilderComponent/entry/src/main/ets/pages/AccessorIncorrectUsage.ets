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
// [Start not_passed_set_accessor_builder_incorrect_usage]
import { UIUtils, Binding, MutableBinding } from '@kit.ArkUI';
@ObservedV2
class GlobalTmp1 {
  @Trace public strValue: string = 'Hello';
}

@Builder
function builderWithTwoParams1(param1: Binding<GlobalTmp1>, param2: MutableBinding<number>) {
  Column() {
    Text(`strValue: ${param1.value.strValue}`)
    Button(`num: ${param2.value}`)
      .onClick(()=>{
        param2.value += 1; // 点击Button触发set访问器会造成运行时错误
      })
  }.borderWidth(1)
}

@Entry
@ComponentV2
struct MakeBindingTest1 {
  @Local GlobalTmp1: GlobalTmp1 = new GlobalTmp1();
  @Local num: number = 0;

  build() {
    Column() {
      Text(`${this.GlobalTmp1.strValue}`)
      builderWithTwoParams1(UIUtils.makeBinding(() => this.GlobalTmp1),
        UIUtils.makeBinding<number>(() => this.num)) // 构造MutableBinding类型参数时没有传SetterCallback
      Button('Update Values').onClick(() => {
        this.GlobalTmp1.strValue = 'Hello World 2025';
        this.num = 1;
      })
    }
  }
}
// [End not_passed_set_accessor_builder_incorrect_usage]