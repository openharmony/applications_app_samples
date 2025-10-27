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
// [Start changing_input_parameters_builder_correct_usage]
import { UIUtils, MutableBinding } from '@kit.ArkUI';

// 使用MutableBinding在@Builder装饰的函数中修改参数值
@Builder
function myGlobalBuilderMod(str: MutableBinding<string>) {
  Column() {
    Text(`Mod--MyGlobalBuilder: ${str.value}`)
      .fontSize(16)
      .onClick(() => {
        str.value = 'value change mod';
      })
  }
}

interface TempMod2 {
  paramA: string;
}

// 使用MutableBinding在@Builder装饰的函数内部修改参数值
@Builder
function overBuilderMod2(param: MutableBinding<TempMod2>) {
  Column() {
    Button(`Mod--overBuilder === ${param.value.paramA}`)
      .onClick(() => {
        param.value.paramA = 'Yes';
      })
    Button(`change`)
      .onClick(() => {
        param.value = { paramA: 'trialOne' };
      })
  }
}

@Entry
@Component
struct ParentMod2 {
  @State label: string = 'Hello';
  @State message1: string = 'Value Passing';
  @State objectOne: TempMod2 = {
    paramA: this.label
  };

  @Builder
  extendBlank() {
    Row() {
      Blank()
    }
    .height(20)
  }

  build() {
    Column() {
      // 使用MutableBinding时无法传对象字面量，需要先将字面量对象抽出为状态变量
      overBuilderMod2(
        UIUtils.makeBinding<TempMod2>(
          () => this.objectOne,
          value => {
            this.objectOne = value; // 必须要传SetterCallback，否则触发时会造成运行时错误
          }
        )
      )
      this.extendBlank();
      Button('click me')
        .onClick(() => {
          this.objectOne.paramA = 'ArkUI';
        })
      this.extendBlank();
      myGlobalBuilderMod(
        UIUtils.makeBinding<string>(
          () => this.message1,
          value => {
            this.message1 = value; // 必须要传SetterCallback，否则触发时会造成运行时错误
          }
        )
      );
    }
  }
}
// [End changing_input_parameters_builder_correct_usage]