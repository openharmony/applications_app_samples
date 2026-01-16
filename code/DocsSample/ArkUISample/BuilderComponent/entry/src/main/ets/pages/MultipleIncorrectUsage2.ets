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
// [Start multiple_parameters_in_builder_incorrect_usage_2]
class GlobalTmp2 {
  public strValue: string = 'Hello';
}

class SecondTmp {
  public numValue: number = 0;
}

@Builder
function overBuilder2(param: GlobalTmp2, num: SecondTmp) {
  Column() {
    Text(`strValue: ${param.strValue}`)
    Text(`num: ${num.numValue}`)
  }
}

@Entry
@Component
struct Parent2 {
  @State strParam: GlobalTmp2 = new GlobalTmp2();
  @State numParam: SecondTmp = new SecondTmp();

  build() {
    Column() {
      Text('UI Rendered via @Builder')
        .fontSize(20)
      // 使用了两个参数，用法错误。
      overBuilder2({ strValue: this.strParam.strValue }, { numValue: this.numParam.numValue })
      Line()
        .width('100%')
        .height(10)
        .backgroundColor('#000000').margin(10)
      Button('Update Values').onClick(() => {
        this.strParam.strValue = 'Hello World';
        this.numParam.numValue = 1;
      })
    }
  }
}
// [End multiple_parameters_in_builder_incorrect_usage_2]