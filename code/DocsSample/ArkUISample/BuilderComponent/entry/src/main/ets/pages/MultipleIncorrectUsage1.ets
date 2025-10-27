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
// [Start multiple_parameters_in_builder_incorrect_usage_1]
class GlobalTmp1 {
  public strValue: string = 'Hello';
}

@Builder function overBuilder1(param: GlobalTmp1, num: number) {
  Column() {
    Text(`strValue: ${param.strValue}`)
    Text(`num: ${num}`)
  }
}

@Entry
@Component
struct Parent1 {
  @State objParam: GlobalTmp1 = new GlobalTmp1();
  @State num: number = 0;
  build() {
    Column() {
      Text('UI Rendered via @Builder')
        .fontSize(20)
      // 使用了两个参数，用法错误。
      overBuilder1({strValue: this.objParam.strValue}, this.num)
      Line()
        .width('100%')
        .height(10)
        .backgroundColor('#000000').margin(10)
      Button('Update Values').onClick(() => {
        this.objParam.strValue = 'Hello World';
        this.num = 1;
      })
    }
  }
}
// [End multiple_parameters_in_builder_incorrect_usage_1]