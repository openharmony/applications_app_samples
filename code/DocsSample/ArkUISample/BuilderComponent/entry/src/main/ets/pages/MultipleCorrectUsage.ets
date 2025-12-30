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
// [Start multiple_parameters_in_builder_correct_usage]
class GlobalTmp3 {
  public strValue: string = 'Hello';
  public numValue: number = 0;
}

@Builder
function overBuilder3(param: GlobalTmp3) {
  Column() {
    Text(`strValue: ${param.strValue}`)
    Text(`num: ${param.numValue}`)
  }
}

@Entry
@Component
struct Parent3 {
  @State objParam: GlobalTmp3 = new GlobalTmp3();

  build() {
    Column() {
      Text('UI Rendered via @Builder')
        .fontSize(20)
      // 传入一个参数，正确用法
      overBuilder3({ strValue: this.objParam.strValue, numValue: this.objParam.numValue })
      Line()
        .width('100%')
        .height(10)
        .backgroundColor('#000000').margin(10)
      Button('Update Values').onClick(() => {
        this.objParam.strValue = 'Hello World';
        this.objParam.numValue = 1;
      })
    }
  }
}
// [End multiple_parameters_in_builder_correct_usage]