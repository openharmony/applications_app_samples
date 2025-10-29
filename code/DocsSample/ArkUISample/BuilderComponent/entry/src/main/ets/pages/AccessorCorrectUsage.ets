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
// [Start not_passed_set_accessor_builder_correct_usage]
import { UIUtils, Binding, MutableBinding } from '@kit.ArkUI';

@ObservedV2
class GlobalTmp2 {
  @Trace public strValue: string = 'Hello';
}

@Builder
function builderWithTwoParams2(param1: Binding<GlobalTmp2>, param2: MutableBinding<number>) {
  Column() {
    Text(`strValue: ${param1.value.strValue}`)
    Button(`num: ${param2.value}`)
      .onClick(() => {
        param2.value += 1; // 修改了MutableBinding类型参数的value属性
      })
  }.borderWidth(1)
}

@Entry
@ComponentV2
struct MakeBindingTest2 {
  @Local GlobalTmp2: GlobalTmp2 = new GlobalTmp2();
  @Local num: number = 0;

  build() {
    Column() {
      Text(`${this.GlobalTmp2.strValue}`)
      builderWithTwoParams2(UIUtils.makeBinding(() => this.GlobalTmp2),
        UIUtils.makeBinding<number>(() => this.num,
          val => {
            this.num = val;
          }))
      Button('Update Values').onClick(() => {
        this.GlobalTmp2.strValue = 'Hello World 2025';
        this.num = 1;
      })
    }
  }
}
// [End not_passed_set_accessor_builder_correct_usage]