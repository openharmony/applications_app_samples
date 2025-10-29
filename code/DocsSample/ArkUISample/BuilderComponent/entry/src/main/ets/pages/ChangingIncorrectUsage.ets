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
// [Start changing_input_parameters_builder_incorrect_usage]
@Builder
function myGlobalBuilder(value: string) {
  Column() {
    Text(`myGlobalBuilder: ${value} `)
      .fontSize(16)
      .onClick(() => {
        // 简单类型按值传递的@Builder函数中修改参数，不闪退但UI不刷新
        value = 'value change';
      })
  }.borderWidth(1)
}

interface TempMod1 {
  paramA: string;
}

@Builder
function overBuilderMod1(param: TempMod1) {
  Row() {
    Column() {
      Button(`overBuilderMod1 === ${param.paramA}`)
        .onClick(() => {
          // 错误写法，不允许在@Builder装饰的函数内部修改对象类型参数的属性，闪退且UI不刷新
          param.paramA = 'Yes';
        })
      Button('change')
        .onClick(() => {
          // 错误写法，不允许在@Builder装饰的函数内部修改对象类型参数的引用，不闪退但UI不刷新
          param = { paramA: 'change trial' };
        })
    }
  }
}

@Entry
@Component
struct ParentMod1 {
  @State label: string = 'Hello';
  @State message1: string = 'Value Passing';

  @Builder
  extendBlank() {
    Row() {
      Blank()
    }
    .height(20)
  }

  build() {
    Column() {
      // 按引用传递能实现参数变化时的UI刷新，但不能在@Builder函数内部修改参数
      overBuilderMod1({ paramA: this.label });
      this.extendBlank();
      Button('click me')
        .onClick(() => {
          this.label = 'ArkUI';
        })
      this.extendBlank();
      myGlobalBuilder(this.message1);
    }
  }
}
// [End changing_input_parameters_builder_incorrect_usage]