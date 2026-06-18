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
// [Start Parameter_specification]
@Component
struct MyComponent {
  countDownFrom: number = 0;
  color: Color = Color.Blue;

  build() {
    Column() {
      Text(`${this.countDownFrom}`)
        .fontSize(20)
        .margin(10)
        .backgroundColor(this.color)
    }
    .width('100%')
  }
}

@Entry
@Component
struct ParentComponent {
  private someColor: Color = Color.Pink;

  build() {
    Column() {
      // 创建MyComponent实例，并将创建MyComponent成员变量countDownFrom初始化为10，将成员变量color初始化为this.someColor
      MyComponent({ countDownFrom: 10, color: this.someColor })
    }
    .width('100%')
  }
}

// [End Parameter_specification]
const parentComponentParameter = ParentComponent;
export default parentComponentParameter;
